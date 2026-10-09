"""Web interface for the DETECT v2 SysML v2 implementation.

Layout and interaction follow the v1 webapp: a landing page holding the
documentation, then a configuration page where each use case is submitted and its
results appear as a table with a CSV download.
"""

import csv
import html
import io
import os
from collections.abc import Sequence

import syside
from nicegui import ui

from detect import (
    CategoryName,
    Ecosystem,
    EntryKind,
    FlagName,
    Header,
    Profile,
    ProfileMapping,
    Question,
    Rows,
    UseCase,
    entry_rows,
    format_display_name,
    parse,
    parse_model,
    tool_rows,
)

FORM_TITLE = "DETECT"
WEBAPP_VERSION = "2.0"

# The NiceGUI default primary (#5898d4) gives white text only 3.06:1, below the 4.5:1
# that WCAG 2.0 AA requires for the navbar. This darker blue of the same family gives
# white text 5.42:1.
PRIMARY_COLOR = "#2b6cb0"

# Applied to headings that exist only to give the page an outline. Tailwind's sr-only
# keeps them out of the visual design while leaving them in the accessibility tree.
VISUALLY_HIDDEN = "sr-only"

PRIMARY_BUTTON = (
    "px-8 py-3 bg-indigo-600 text-white rounded-lg shadow-lg hover:bg-indigo-700 "
    "transition duration-300 w-full sm:w-auto"
)
DOWNLOAD_BUTTON = "px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700"

# The enumeration value the model gives its selection placeholders.
PLACEHOLDER_VALUE = 0

# Each page load parses the model afresh, because the sizing panel writes the visitor's
# answers into it. A profile mapping holds only names, not model elements, and depends
# only on the profile's definition, so it is built once per definition and shared.
_profile_mappings: dict[str, ProfileMapping] = {}


def cached_profile_mapping(profile: Profile) -> ProfileMapping:
    """Return the profile's mapping, building it on first use."""
    key = str(profile.definition.qualified_name)
    if key not in _profile_mappings:
        _profile_mappings[key] = profile.mapping()
    return _profile_mappings[key]


def question_label(question: Question) -> str:
    """The heading shown above a question's dropdown."""
    return f"{question.number}: {question.name.replace('_', ' ').title()}"


def csv_bytes(header: Header, rows: Rows) -> bytes:
    """Encode a header and rows as a CSV file in memory."""
    output = io.StringIO()
    writer = csv.writer(output)
    writer.writerow(header)
    writer.writerows(rows)
    return output.getvalue().encode("utf-8")


def create_table(
    header: Header, labels: Sequence[str], widths: Sequence[int], rows: Rows
) -> ui.table:
    """Create a table whose columns are the header fields, with the given labels and widths.

    Cells wrap, except in a column whose label is `Value`, which holds a number.
    """
    columns = [
        {
            "name": field,
            "label": label,
            "field": field,
            "required": True,
            "align": "center" if label == "Value" else "left",
            "style": f"width: {width}%;"
            + ("" if label == "Value" else " white-space: normal; word-wrap: break-word;"),
        }
        for field, label, width in zip(header, labels, widths, strict=True)
    ]
    return (
        ui.table(columns=columns, rows=[dict(zip(header, row, strict=True)) for row in rows])
        .classes("w-full")
        .props("wrap-cells")
    )


def show_banner(container: ui.element, variant: str, body: str) -> None:
    """Show a banner in a results container. `body` is HTML; escape any model text in it."""
    with container:
        ui.html(
            f"<div class='p-4 bg-{variant}-100 border-l-4 border-{variant}-500 rounded'>"
            f"{body}</div>",
            sanitize=False,
        ).classes("w-full")


def announce_results(container: ui.element, message: str) -> None:
    """Name a results container and move focus to it once its contents are replaced.

    Results are produced by a button click and inserted into a container elsewhere on
    the page, which a screen reader would otherwise not report. Focusing the container,
    which is a labelled region, makes the reader announce the label and the contents.
    """
    # Assign the property directly. props() parses a string, so a quote or a newline in
    # the message would corrupt the parse.
    container._props["aria-label"] = " ".join(message.split())
    container.update()
    ui.run_javascript(f"getHtmlElement({container.id})?.focus()")


def set_toggle_state(button: ui.button, pressed: bool) -> None:
    """Show, both visually and to assistive technology, whether a toggle is selected.

    The selected state is carried by the Quasar colour props rather than by Tailwind
    background classes. A `ui.button` already carries Quasar's `bg-primary`, which wins
    over a `bg-*` class, and `classes()` appends rather than replaces, so the earlier
    class-swapping approach could not change the appearance in either direction.
    """
    button.props(f"color={'primary' if pressed else 'grey-4'}")
    button.props(f"text-color={'white' if pressed else 'grey-9'}")
    button._props["aria-pressed"] = "true" if pressed else "false"
    button.update()


def create_results_container(extra_classes: str, label: str) -> ui.card:
    """Create a card that holds results and can be announced when it is filled."""
    container = ui.card().classes(f"w-full {extra_classes}")
    container.props("role=region tabindex=-1")
    container._props["aria-label"] = label
    return container


def create_heading(text: str, level: int, classes: str) -> ui.html:
    """Create a real heading element so that the page has a document outline."""
    # Heading text comes from the models, which are edited separately from this code.
    # Escaping keeps it text: without it the sanitiser would admit a link or an image
    # declared in a model label.
    return ui.html(html.escape(text), tag=f"h{level}").classes(classes)


def create_footer() -> None:
    """Create the footer shown on every page."""
    with ui.column().classes(
        "w-full items-center justify-center px-4 py-0.5 mt-6 border-t border-gray-200 gap-1"
    ):
        ui.markdown(f"\nWebapp version {WEBAPP_VERSION}").classes("text-sm text-gray-600")
        ui.markdown("\nCopyright © 2026 Sensmetry").classes("text-sm text-gray-600")
        ui.image("images/Sensmetry_logo-02.svg").classes("max-w-[200px]").props('alt="Sensmetry"')


def navbar() -> None:
    """Create the header shown on every page."""
    ui.colors(primary=PRIMARY_COLOR)
    ui.add_head_html(
        """
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Lexend:wght@400;700&display=swap" rel="stylesheet">
        """
    )

    with (
        ui.header().classes("items-center justify-center"),
        ui.row().classes("w-full max-w-5xl items-center justify-between px-4"),
    ):
        with ui.row().classes("items-center gap-4"):
            ui.label(FORM_TITLE).classes("text-h5 font-bold")
            ui.link("Home", "/").classes("text-white no-underline hover:underline font-bold")
            ui.link("Configuration", "/tool").classes(
                "text-white no-underline hover:underline font-bold"
            )

        with ui.row().classes("items-center gap-4 text-h6"):
            ui.html(
                """
                Powered by
                <a href="https://syside.sensmetry.com/" class="text-white no-underline hover:underline inline-flex items-center gap-1">
                    <span class="font-bold" style="font-family: 'Lexend', sans-serif;">Syside</span>
                    <i class="material-icons text-xs">open_in_new</i>
                </a>
            """,
                sanitize=False,
            )


@ui.page("/")
def landing_page() -> None:
    """Landing page holding the documentation."""
    navbar()

    ui.add_head_html("""
        <style>
            .prose h1 { font-size: 1.5rem !important; }
            .prose h2 { font-size: 1.25rem !important; }
            .prose h3 { font-size: 1.125rem !important; }
        </style>
    """)

    try:
        with open("README_web.md", encoding="utf-8") as f:
            doc_content = f.read()
    except FileNotFoundError:
        doc_content = (
            "# Documentation\n\nDocumentation file not found. Please create `README_web.md`."
        )

    with (
        ui.row().classes("w-full justify-center p-4 sm:p-8 bg-gray-50 min-h-screen"),
        ui.card().classes("w-full max-w-4xl shadow-xl rounded-2xl p-6 sm:p-10"),
    ):
        ui.markdown(doc_content).classes("prose max-w-none")

        ui.separator().classes("my-6")
        with ui.row().classes("w-full justify-center"):
            ui.button("Start Configuration", on_click=lambda: ui.navigate.to("/tool")).classes(
                PRIMARY_BUTTON
            )

        create_footer()


def use_case_heading(use_case: UseCase) -> str:
    """The heading naming a use case in tabs and in the document outline."""
    return f"{use_case.id}: {use_case.title}"


def _profile_panel(use_case: UseCase, profile: Profile) -> None:
    """Build the interface for a use case that maps boolean selections to tool types."""
    mapping = cached_profile_mapping(profile)
    selections: dict[FlagName, bool] = {flag.name: False for flag in mapping.flags}
    heading = use_case_heading(use_case)

    create_heading(heading, 2, VISUALLY_HIDDEN)
    ui.label(use_case.objective).classes("text-lg text-gray-500 mb-4")

    grouped: dict[CategoryName, list[FlagName]] = {}
    for flag in mapping.flags:
        grouped.setdefault(flag.category, []).append(flag.name)

    for category, flag_names in grouped.items():
        with ui.expansion(category, value=True).classes("w-full border rounded-lg mb-2"):
            for flag_name in flag_names:
                ui.checkbox(
                    format_display_name(flag_name),
                    value=False,
                    on_change=lambda e, name=flag_name: selections.update({name: e.value}),
                ).classes("ml-2")

    ui.separator().classes("my-6")

    results_container = create_results_container("mt-4", f"{heading} results")
    results_container.set_visibility(False)

    def evaluate() -> None:
        """Evaluate the profile against the current selections and show the result."""
        selected = [name for name, chosen in selections.items() if chosen]
        results_container.clear()
        results_container.set_visibility(True)

        if not selected:
            show_banner(
                results_container,
                "yellow",
                "<strong>Nothing selected.</strong> Choose at least one option above.",
            )
            announce_results(results_container, "Nothing selected")
            return

        try:
            header, rows = tool_rows(mapping, selected, separator=", ")
            download = csv_bytes(*tool_rows(mapping, selected))
            summary = f"{len(rows)} tool types required by {len(selected)} selections"

            with results_container:
                with ui.row().classes("w-full justify-between items-center mb-2"):
                    ui.html(
                        "<div class='p-2 bg-green-100 border-l-4 border-green-500 rounded'>"
                        f"<strong>✓ {summary}</strong></div>",
                        sanitize=False,
                    )
                    ui.button(
                        "Download CSV",
                        on_click=lambda: ui.download(
                            download, filename=use_case.tools_csv_filename
                        ),
                    ).classes(DOWNLOAD_BUTTON)
                create_table(header, ["Tool Type", "Required by"], [40, 60], rows)
            announce_results(results_container, summary)
        except Exception as error:
            show_banner(
                results_container,
                "red",
                f"<strong>✗ Error:</strong> {html.escape(str(error))}",
            )
            announce_results(results_container, "Evaluation failed")

    with ui.row().classes("w-full items-center justify-center gap-4"):
        ui.button(f"Evaluate {use_case.id}", on_click=evaluate).classes(PRIMARY_BUTTON)


@ui.page("/tool")
def main_page() -> None:
    """Configuration page carrying one tab per use case the model declares."""
    navbar()

    declared = parse(parse_model())

    with (
        ui.row().classes("w-full justify-center p-4 sm:p-8 bg-gray-50 min-h-screen"),
        ui.card().classes("w-full max-w-5xl shadow-xl rounded-2xl p-6 sm:p-10"),
    ):
        create_heading("DETECT Configuration", 1, VISUALLY_HIDDEN)

        with ui.tabs().classes("w-full") as tabs:
            tab_by_use_case = {
                use_case.id: ui.tab(use_case_heading(use_case)) for use_case in declared
            }

        # Quasar keeps a tab panel mounted once it has been shown, positioning the
        # inactive ones out of view rather than removing them. A screen reader still
        # reaches their headings and form controls, and Tab still moves through them, so
        # each panel's contents go inside a wrapper that can be made `inert`, which
        # removes a subtree from the accessibility tree and the focus order together.
        # The wrapper is a plain element because QTabPanel does not pass the attribute
        # through to the DOM.
        wrappers: dict[str, ui.element] = {}

        def hide_inactive_panels(active_tab: str) -> None:
            """Make every tab panel except the one on screen inert."""
            for name, wrapper in wrappers.items():
                if name == active_tab:
                    # `inert` is a boolean attribute, so inert="false" would still be
                    # inert. The attribute has to be removed rather than set.
                    wrapper._props.pop("inert", None)
                else:
                    wrapper._props["inert"] = True
                wrapper.update()

        first_tab = tab_by_use_case[declared[0].id]
        with ui.tab_panels(
            tabs,
            value=first_tab,
            on_change=lambda event: hide_inactive_panels(str(event.value)),
        ).classes("w-full"):
            for use_case in declared:
                tab = tab_by_use_case[use_case.id]
                with ui.tab_panel(tab), ui.element("div").classes("w-full") as wrapper:
                    if isinstance(use_case.subject, Ecosystem):
                        _sizing_panel(use_case, use_case.subject)
                    else:
                        _profile_panel(use_case, use_case.subject)
                wrappers[str(tab.props["name"])] = wrapper

        hide_inactive_panels(str(first_tab.props["name"]))

        create_footer()


def _sizing_panel(use_case: UseCase, ecosystem: Ecosystem) -> None:
    """Build the interface for the use case that sizes the ecosystem."""
    answers: dict[str, str] = {
        question.name: question.options[0] for question in ecosystem.questions
    }
    calculated_system_size: syside.EnumerationUsage | None = None

    create_heading(use_case_heading(use_case), 2, VISUALLY_HIDDEN)
    ui.label(
        f"{use_case.objective} Select your configuration options from the dropdowns "
        "below, submit them to calculate the system size, then generate the requirements "
        "and criteria that apply at that size."
    ).classes("text-lg text-gray-500 mb-6")

    with ui.grid().classes("grid-cols-1 gap-x-8 gap-y-6 w-full"):
        for question in ecosystem.questions:
            with ui.column().classes("w-full flex flex-col"):
                create_heading(
                    question_label(question), 3, "text-lg font-semibold text-gray-800 mb-1"
                )
                ui.markdown(question.description).classes("text-sm text-gray-600 mb-3")
                ui.select(
                    label=question.question,
                    options=question.options,
                    value=answers[question.name],
                    on_change=lambda e, name=question.name, opts=question.options: answers.update(
                        {name: e.value if e.value is not None else opts[0]}
                    ),
                ).classes("w-full").props("outlined icon=tune")

    ui.separator().classes("my-6")

    result_card_container = create_results_container("mb-4", "System size result")

    tableviews_container = create_results_container("mt-4", "Requirements and criteria")
    tableviews_container.set_visibility(False)

    def submit_form() -> None:
        """Write the answers into the model and report the calculated size."""
        nonlocal calculated_system_size
        result_card_container.clear()
        tableviews_container.set_visibility(False)

        try:
            ecosystem.answer(answers)
            if not ecosystem.all_answered():
                calculated_system_size = None
                second_button_container.set_visibility(False)
                unanswered = [
                    html.escape(question_label(question))
                    for question in ecosystem.questions
                    if question.values[answers[question.name]] == PLACEHOLDER_VALUE
                ]
                show_banner(
                    result_card_container,
                    "yellow",
                    "<strong>Error:</strong> The following fields are still set to 'TBD':<br>"
                    "<ul class='list-disc list-inside mt-2'>"
                    + "".join(f"<li>{field}</li>" for field in unanswered)
                    + "</ul>",
                )
                announce_results(result_card_container, "Error: some fields are still set to TBD")
                return

            calculated_system_size = ecosystem.size()
            show_banner(
                result_card_container,
                "green",
                f"<strong>✓ System Size:</strong> {html.escape(str(calculated_system_size.name))}",
            )
            announce_results(result_card_container, f"System size: {calculated_system_size.name}")
            second_button_container.set_visibility(True)
        except Exception as error:
            calculated_system_size = None
            second_button_container.set_visibility(False)
            show_banner(
                result_card_container,
                "red",
                f"<strong>✗ Error calculating system size:</strong> {html.escape(str(error))}",
            )
            announce_results(result_card_container, "System size calculation failed")

    def process_with_system_size() -> None:
        """Filter the requirements and criteria at the calculated size and show them."""
        if calculated_system_size is None:
            result_card_container.clear()
            show_banner(
                result_card_container,
                "yellow",
                "<strong>System size not available.</strong> "
                "Please submit the configuration first.",
            )
            announce_results(result_card_container, "System size not available")
            return

        try:
            requirements = entry_rows(
                EntryKind.REQUIREMENT, ecosystem.applicable(EntryKind.REQUIREMENT)
            )
            criteria = entry_rows(EntryKind.CRITERION, ecosystem.applicable(EntryKind.CRITERION))

            tableviews_container.clear()
            with tableviews_container, ui.column().classes("w-full"):
                with ui.row().classes("w-full justify-between items-center mb-2"):
                    with ui.row().classes("items-center gap-2"):
                        requirements_toggle = ui.button("Requirements").classes(
                            "px-4 py-2 rounded-lg"
                        )
                        criteria_toggle = ui.button("Criteria").classes("px-4 py-2 rounded-lg")
                    with ui.row().classes("items-center gap-2"):
                        ui.button(
                            "Download Requirements CSV",
                            on_click=lambda: ui.download(
                                csv_bytes(*requirements), filename=EntryKind.REQUIREMENT.filename
                            ),
                        ).classes(DOWNLOAD_BUTTON)
                        ui.button(
                            "Download Criteria CSV",
                            on_click=lambda: ui.download(
                                csv_bytes(*criteria), filename=EntryKind.CRITERION.filename
                            ),
                        ).classes(DOWNLOAD_BUTTON)

                requirements_table = create_table(
                    requirements[0], ["ID", "Value", "Description"], [15, 10, 75], requirements[1]
                )
                criteria_table = create_table(
                    criteria[0],
                    ["ID", "Value", "Criteria", "Context"],
                    [15, 10, 40, 35],
                    criteria[1],
                )
                criteria_table.set_visibility(False)

                def show_tableview(showing_requirements: bool) -> None:
                    """Toggle between the requirements and criteria tables."""
                    requirements_table.set_visibility(showing_requirements)
                    criteria_table.set_visibility(not showing_requirements)
                    set_toggle_state(requirements_toggle, showing_requirements)
                    set_toggle_state(criteria_toggle, not showing_requirements)

                show_tableview(True)
                requirements_toggle.on_click(lambda: show_tableview(True))
                criteria_toggle.on_click(lambda: show_tableview(False))

            tableviews_container.set_visibility(True)
            announce_results(
                tableviews_container,
                f"{len(requirements[1])} requirements and {len(criteria[1])} criteria generated",
            )
        except Exception as error:
            tableviews_container.clear()
            tableviews_container.set_visibility(True)
            show_banner(
                tableviews_container,
                "red",
                "<strong>✗ Error processing requirements and criteria:</strong> "
                f"{html.escape(str(error))}",
            )
            announce_results(tableviews_container, "Processing requirements and criteria failed")

    with ui.row().classes("w-full items-center justify-center gap-4"):
        ui.button("Submit Configuration", on_click=submit_form).classes(PRIMARY_BUTTON)
        with ui.row().classes("w-full sm:w-auto") as second_button_container:
            ui.button("Process with System Size", on_click=process_with_system_size).classes(
                PRIMARY_BUTTON.replace("indigo", "green")
            )
        second_button_container.set_visibility(False)


if __name__ in {"__main__", "__mp_main__"}:
    ui.run(
        host="0.0.0.0",
        port=int(os.environ.get("PORT", "8080")),
        title="DETECT v2 in SysML v2",
        language="en-US",
        favicon="images/Syside_only_logo_light_favicon.svg",
    )
