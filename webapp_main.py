from nicegui import ui
import syside
from detect import (
    parse_model,
    get_named_item,
    system_size_calculation,
    calculate_system_size,
    write_system_size,
    evaluate_requirements_and_criteria,
    get_named_documentation_comment,
    natural_sort_key,
    Requirement,
    Criteria,
)
import os
import io
import csv
from typing import Any


class FieldInput:
    field_name: str
    description: str
    dropdown_question: str
    data_selections: dict[str, int]

    def __init__(
        self,
        field_name: str,
        description: str,
        dropdown_question: str,
        data_selections: dict[str, int],
    ):
        self.field_name = field_name
        self.description = description
        self.dropdown_question = dropdown_question
        self.data_selections = data_selections


# --- Functions ---


def get_DE_Ecosystem_definition(model: syside.Model) -> syside.PartDefinition | None:
    part_definitions_sysml = model.nodes(syside.PartDefinition)
    DE_Ecosystem_definition: syside.PartDefinition | None = None
    for part_definition in part_definitions_sysml:
        if part_definition.name == "DE_Ecosystem":
            DE_Ecosystem_definition = part_definition
            break
    if DE_Ecosystem_definition is None:
        raise ValueError("DE_Ecosystem part definition not found")
    return DE_Ecosystem_definition


def get_available_inputs(model: syside.Model) -> list[FieldInput] | None:
    """
    Finds the available input fields, their enumeration names and numeric values.
    Used to populate the NiceGUI dropdowns.
    """
    DE_Ecosystem_definition = get_DE_Ecosystem_definition(model)
    if DE_Ecosystem_definition is None:
        raise ValueError("DE_Ecosystem part definition not found")
    inputs_element_sysml = get_named_item(DE_Ecosystem_definition, "DETECT_Inputs")
    input_list: list[FieldInput] = []
    if inputs_element_sysml is None:
        raise ValueError("inputs attribute not found")
    available_inputs = inputs_element_sysml.owned_elements.collect()
    for input_definition in available_inputs:
        if not isinstance(input_definition, syside.AttributeUsage):
            raise ValueError(
                f"Input element '{input_definition.name}' is not an attribute definition"
            )
        name = input_definition.name
        if name is None:
            raise ValueError(f"Input element '{input_definition.name}' has no name")

        input_type = input_definition.attribute_definitions[0]
        if not isinstance(input_type, syside.EnumerationDefinition):
            continue  # In the ported definitions there is an unfinished attribute definition. We skip it without raising an error.

        description = get_named_documentation_comment(input_definition, "Description")
        if description is None:
            raise ValueError(f"Description for input '{name}' not found")

        dropdown_question = get_named_documentation_comment(
            input_definition, "Question"
        )
        if dropdown_question is None:
            raise ValueError(f"Question for input '{name}' not found")

        available_input_dict: dict[str, int] = {}
        for available_input_sysml in input_type.enumerated_values.collect():
            input_name = available_input_sysml.declared_name
            if input_name is None:
                raise ValueError(
                    f"Available input '{available_input_sysml.name}' has no name"
                )

            for feature in available_input_sysml.owned_elements.collect():
                if feature.name == "value":
                    if not isinstance(feature, syside.Feature):
                        raise ValueError(f"Feature '{feature.name}' is not a feature")
                    expression = feature.feature_value_expression
                    if expression is None:
                        raise ValueError(
                            f"Available input '{available_input_sysml.name}' has no value expression"
                        )
                    evaluation, report = syside.Compiler().evaluate(expression)
                    if evaluation is None:
                        raise ValueError(
                            f"Failed to evaluate expression for '{available_input_sysml.name}'"
                        )
                    if report.fatal:
                        raise ValueError(
                            f"Failed to evaluate expression for '{available_input_sysml.name}': {report}"
                        )
                    if not isinstance(evaluation, int):
                        raise ValueError(
                            f"Expression for '{available_input_sysml.name}' did not evaluate to an integer value"
                        )
                    available_input_dict[input_name] = evaluation
                    break

        input_list.append(
            FieldInput(name, description, dropdown_question, available_input_dict)
        )

    return input_list


def augment_config_with_defaults(
    field_inputs: list[FieldInput],
) -> dict[str, dict[str, Any]]:
    """
    Takes FieldInput objects and adds necessary UI metadata (label, icon, full_width).

    It prepares a simple list of labels for ui.select where labels are used as both
    display and stored values. This simplifies the structure and avoids type mismatches.
    """
    full_config = {}

    for i, field_input in enumerate(field_inputs, 1):
        field_name = field_input.field_name
        options_dict = field_input.data_selections

        # 1. Prepare simple list of labels - labels will be used as both display and value
        # Sort by internal_id (value) in ascending order, then extract just the labels
        sorted_items = sorted(
            options_dict.items(), key=lambda x: x[1]
        )  # Sort by value (internal_id)
        options_list = [
            label for label, internal_id in sorted_items
        ]  # Extract sorted labels
        label_to_id_map = {label: internal_id for label, internal_id in sorted_items}

        # 2. Generate a clean label (field name)
        clean_label = f"{i}. " + field_name.replace("_", " ").title()

        # 3. Use description and dropdown_question from FieldInput
        description = field_input.description
        placeholder = field_input.dropdown_question

        # 4. Assemble the configuration
        full_config[field_name] = {
            "label": clean_label,
            "description": description,
            "placeholder": placeholder,
            "icon": "tune",  # Default generic icon
            "full_width": False,  # Default to half-width
            "options": options_list,  # Simple list of label strings
            "label_to_id_map": label_to_id_map,  # Keep mapping for reference if needed
        }

    # Custom adjustments for specific fields if needed
    if "project_status" in full_config:
        full_config["project_status"]["icon"] = "flag"
        full_config["project_status"]["full_width"] = (
            True  # Make the status field full width
        )

    return full_config


def generate_csv_content_requirements(requirements: list[Requirement]) -> bytes:
    """Generate CSV content for requirements in memory."""
    output = io.StringIO()
    writer = csv.writer(output)
    writer.writerow(["id", "value", "description"])
    # Sort requirements by ID using natural sort (same as save_requirements_to_csv)
    sorted_requirements = sorted(requirements, key=lambda req: natural_sort_key(req.id))
    for req in sorted_requirements:
        writer.writerow([req.id, req.value, req.description])
    return output.getvalue().encode("utf-8")


def generate_csv_content_criteria(criteria: list[Criteria]) -> bytes:
    """Generate CSV content for criteria in memory."""
    output = io.StringIO()
    writer = csv.writer(output)
    writer.writerow(["id", "value", "criteria", "context"])
    # Sort criteria by ID using natural sort (same as save_criteria_to_csv)
    sorted_criteria = sorted(criteria, key=lambda crit: natural_sort_key(crit.id))
    for crit in sorted_criteria:
        writer.writerow([crit.id, crit.value, crit.criteria, crit.context])
    return output.getvalue().encode("utf-8")


def create_requirements_tableview(requirements: list[Requirement]) -> ui.table:
    """Create a tableview for requirements with text wrapping."""
    sorted_requirements = sorted(requirements, key=lambda req: natural_sort_key(req.id))

    # Prepare rows data
    rows = [
        {"id": req.id, "value": req.value, "description": req.description}
        for req in sorted_requirements
    ]

    # Create table with text wrapping enabled
    table = (
        ui.table(
            columns=[
                {
                    "name": "id",
                    "label": "ID",
                    "field": "id",
                    "required": True,
                    "align": "left",
                    "style": "width: 15%; white-space: normal; word-wrap: break-word;",
                },
                {
                    "name": "value",
                    "label": "Value",
                    "field": "value",
                    "required": True,
                    "align": "center",
                    "style": "width: 10%;",
                },
                {
                    "name": "description",
                    "label": "Description",
                    "field": "description",
                    "required": True,
                    "align": "left",
                    "style": "width: 75%; white-space: normal; word-wrap: break-word;",
                },
            ],
            rows=rows,
        )
        .classes("w-full")
        .props("wrap-cells")
    )

    return table


def create_criteria_tableview(criteria: list[Criteria]) -> ui.table:
    """Create a tableview for criteria with text wrapping."""
    sorted_criteria = sorted(criteria, key=lambda crit: natural_sort_key(crit.id))

    # Prepare rows data
    rows = [
        {
            "id": crit.id,
            "value": crit.value,
            "criteria": crit.criteria,
            "context": crit.context,
        }
        for crit in sorted_criteria
    ]

    # Create table with text wrapping enabled
    table = (
        ui.table(
            columns=[
                {
                    "name": "id",
                    "label": "ID",
                    "field": "id",
                    "required": True,
                    "align": "left",
                    "style": "width: 15%; white-space: normal; word-wrap: break-word;",
                },
                {
                    "name": "value",
                    "label": "Value",
                    "field": "value",
                    "required": True,
                    "align": "center",
                    "style": "width: 10%;",
                },
                {
                    "name": "criteria",
                    "label": "Criteria",
                    "field": "criteria",
                    "required": True,
                    "align": "left",
                    "style": "width: 40%; white-space: normal; word-wrap: break-word;",
                },
                {
                    "name": "context",
                    "label": "Context",
                    "field": "context",
                    "required": True,
                    "align": "left",
                    "style": "width: 35%; white-space: normal; word-wrap: break-word;",
                },
            ],
            rows=rows,
        )
        .classes("w-full")
        .props("wrap-cells")
    )

    return table


# --- Configuration ---
FORM_TITLE = "DETECT"
FORM_SUBTITLE = "Select your configuration options from the dropdowns below. Based on your selection, the system size will be calculated appropriate requirements and criteria will be generated."

# --- NiceGUI Layout ---


def create_footer() -> None:
    """Create a consistent footer for all pages."""
    with ui.column().classes(
        "w-full items-center justify-center px-4 py-0.5 mt-6 border-t border-gray-200 gap-1"
    ):
        # Sensmetry logo - SVG version, fully visible
        ui.markdown("\nCopyright © 2025 Sensmetry").classes("text-sm text-gray-600")
        ui.image("images/Sensmetry_logo-02.svg").classes("max-w-[200px]")


def navbar() -> None:
    ui.add_head_html(
        """
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Lexend:wght@400;700&display=swap" rel="stylesheet">
        """
    )

    with (
        ui.header().classes("items-center justify-center"),
        ui.row().classes("w-full max-w-4xl items-center justify-between px-4"),
    ):
        # Left side container
        with ui.row().classes("items-center gap-4"):
            ui.label("DETECT").classes("text-h5 font-bold")
            ui.link("Home", "/").classes(
                "text-white no-underline hover:underline font-bold"
            )
            ui.link("Configuration", "/tool").classes(
                "text-white no-underline hover:underline font-bold"
            )

        # Right side container
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
    """Landing page with documentation."""
    # Persistent header
    navbar()

    # Add custom CSS for smaller heading sizes
    ui.add_head_html("""
        <style>
            .prose h1 { font-size: 1.5rem !important; }
            .prose h2 { font-size: 1.25rem !important; }
            .prose h3 { font-size: 1.125rem !important; }
        </style>
    """)

    # Read the documentation markdown file
    try:
        with open("README_web.md", "r", encoding="utf-8") as f:
            doc_content = f.read()
    except FileNotFoundError:
        doc_content = "# Documentation\n\nDocumentation file not found. Please create `README_web.md`."

    # Use a centered column for the entire page content
    with ui.row().classes("w-full justify-center p-4 sm:p-8 bg-gray-50 min-h-screen"):
        # Card container for the documentation
        with ui.card().classes("w-full max-w-4xl shadow-xl rounded-2xl p-6 sm:p-10"):
            # Documentation content
            ui.markdown(doc_content).classes("prose max-w-none")

            # Bottom button
            ui.separator().classes("my-6")
            with ui.row().classes("w-full justify-center"):
                ui.button(
                    "Start Configuration", on_click=lambda: ui.navigate.to("/tool")
                ).classes(
                    "px-8 py-3 bg-indigo-600 text-white rounded-lg shadow-lg hover:bg-indigo-700 transition duration-300 text-lg font-semibold"
                )

            # Footer
            create_footer()


@ui.page("/tool")
def main_page() -> None:
    # Persistent header
    navbar()

    ## User state
    # 1. Load and augment the options.
    model = parse_model()
    partial_options = get_available_inputs(model)
    if partial_options is None:
        raise ValueError("No available inputs found")
    dynamic_options = augment_config_with_defaults(partial_options)

    # Initialize data state. This dictionary will hold the selected labels (strings).
    data: dict[str, str] = {}
    for field_name, config in dynamic_options.items():
        # Initialize data with the first label from options
        # Options are now a simple list of label strings
        first_label = config["options"][0]
        data[field_name] = first_label

    state = {"calculated_system_size": None, "calculated_system_size_number": None}

    result_card_container = None
    second_button_container = None
    tableviews_container = None

    ## Local logic

    def submit_form() -> None:
        """Handles the form submission logic."""

        if result_card_container is None:
            return

        # Check for fields with value 0 (TBD) and build data dict for system_size_calculation
        fields_with_tbd = []
        inputs_data: dict[str, int] = {}

        for field_name, selected_label in data.items():
            config = dynamic_options[field_name]
            internal_id = config.get("label_to_id_map", {}).get(selected_label, None)
            if internal_id == 0:
                fields_with_tbd.append(field_name.replace("_", " ").title())
            # Build the inputs_data dict with field_name -> internal_id mapping
            if internal_id is not None:
                inputs_data[field_name] = internal_id

        # Clear previous content
        result_card_container.clear()

        # If any fields have TBD, show warning
        if fields_with_tbd:
            with result_card_container:
                ui.html(
                    "<div class='p-4 bg-yellow-100 border-l-4 border-yellow-500 rounded'>"
                    "<strong>Error:</strong> The following fields are still set to 'TBD':<br>"
                    "<ul class='list-disc list-inside mt-2'>"
                    + "".join(f"<li>{field}</li>" for field in fields_with_tbd)
                    + "</ul>"
                    "</div>",
                    sanitize=False,
                ).classes("w-full")
        else:
            # Calculate system size number when all fields are filled
            try:
                sys_num = system_size_calculation(inputs_data)
                state["calculated_system_size_number"] = sys_num

                sys_size_obj = calculate_system_size(model, sys_num)
                state["calculated_system_size"] = sys_size_obj
                if sys_size_obj is None:
                    raise ValueError("System size not found")
                with result_card_container:
                    ui.html(
                        f"<div class='p-4 bg-green-100 border-l-4 border-green-500 rounded'>"
                        f"<strong>✓ System Size:</strong> {sys_size_obj.name}"
                        "</div>",
                        sanitize=False,
                    ).classes("w-full")

                # Show the second button if it exists
                if second_button_container is not None:
                    second_button_container.set_visibility(True)
            except Exception as e:
                state["calculated_system_size_number"] = None
                if second_button_container is not None:
                    second_button_container.set_visibility(False)
                with result_card_container:
                    ui.html(
                        "<div class='p-4 bg-red-100 border-l-4 border-red-500 rounded'>"
                        f"<strong>✗ Error calculating system size:</strong> {str(e)}"
                        "</div>",
                        sanitize=False,
                    ).classes("w-full")

    def process_with_system_size() -> None:
        """Handles the second button action: writes system size, evaluates requirements/criteria, and displays in tableviews."""
        current_size = state["calculated_system_size"]

        if current_size is None:
            ui.notify(
                "System size not available. Please submit configuration first.",
                type="warning",
                position="top",
            )
            return

        try:
            # Step 1: Write system size (needed for further calculations)
            write_system_size(current_size, model)

            # Step 2: Evaluate requirements and criteria
            requirements, criteria = evaluate_requirements_and_criteria(
                model, current_size
            )

            # Step 3: Generate CSV content in memory (for download functionality)
            requirements_csv = generate_csv_content_requirements(requirements)
            criteria_csv = generate_csv_content_criteria(criteria)

            # Step 4: Update tableviews container
            if tableviews_container is not None:
                tableviews_container.clear()
                with tableviews_container:
                    # Create a column container
                    with ui.column().classes("w-full"):
                        # Header row with buttons positioned at top left and top right (ABOVE tableviews)
                        with ui.row().classes(
                            "w-full justify-between items-center mb-2"
                        ):
                            # Toggle buttons at top left
                            with ui.row().classes("items-center gap-2"):
                                requirements_toggle = ui.button("Requirements").classes(
                                    "px-4 py-2 rounded-lg bg-blue-600 text-white"
                                )
                                criteria_toggle = ui.button("Criteria").classes(
                                    "px-4 py-2 rounded-lg bg-gray-200 text-gray-700"
                                )

                            # Download buttons at top right
                            def download_requirements(req_csv=requirements_csv):
                                ui.download(req_csv, filename="requirements.csv")

                            def download_criteria(crit_csv=criteria_csv):
                                ui.download(crit_csv, filename="criteria.csv")

                            with ui.row().classes("items-center gap-2"):
                                ui.button(
                                    "Download Requirements CSV",
                                    on_click=download_requirements,
                                ).classes(
                                    "px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700"
                                )
                                ui.button(
                                    "Download Criteria CSV", on_click=download_criteria
                                ).classes(
                                    "px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700"
                                )

                        # Create tableviews BELOW the buttons
                        requirements_table = create_requirements_tableview(requirements)
                        criteria_table = create_criteria_tableview(criteria)

                        # Initially show requirements, hide criteria
                        criteria_table.set_visibility(False)

                        # Toggle function that updates both tableviews and button styles
                        def show_tableview(
                            view_type,
                            req_table=requirements_table,
                            crit_table=criteria_table,
                            req_btn=requirements_toggle,
                            crit_btn=criteria_toggle,
                        ):
                            if view_type == "requirements":
                                req_table.set_visibility(True)
                                crit_table.set_visibility(False)
                                req_btn.classes(
                                    "px-4 py-2 rounded-lg bg-blue-600 text-white"
                                )
                                crit_btn.classes(
                                    "px-4 py-2 rounded-lg bg-gray-200 text-gray-700"
                                )
                            else:
                                req_table.set_visibility(False)
                                crit_table.set_visibility(True)
                                req_btn.classes(
                                    "px-4 py-2 rounded-lg bg-gray-200 text-gray-700"
                                )
                                crit_btn.classes(
                                    "px-4 py-2 rounded-lg bg-blue-600 text-white"
                                )

                        # Set click handlers
                        requirements_toggle.on_click(
                            lambda: show_tableview("requirements")
                        )
                        criteria_toggle.on_click(lambda: show_tableview("criteria"))

                tableviews_container.set_visibility(True)

        except Exception as e:
            ui.notify(
                f"Error processing requirements and criteria: {str(e)}",
                type="negative",
                position="top",
            )
            if tableviews_container is not None:
                tableviews_container.set_visibility(False)

    ## Page Layout

    # Use a centered column for the entire page content
    with ui.row().classes("w-full justify-center p-4 sm:p-8 bg-gray-50 min-h-screen"):
        # Card container for the form
        with ui.card().classes("w-full max-w-4xl shadow-xl rounded-2xl p-6 sm:p-10"):
            ui.label(FORM_SUBTITLE).classes("text-lg text-gray-500 mb-6")

            # Form Grid Layout (Dynamically Generated Select Inputs)
            with ui.grid().classes("grid-cols-1 gap-x-8 gap-y-6 w-full"):
                # Dynamic component generation loop - iterates over the augmented config
                for field_name, config in dynamic_options.items():
                    options_list = config["options"]

                    # Determine CSS classes for responsive layout
                    # All fields are now full width
                    field_classes = "w-full"
                    dropdown_classes = "w-full"

                    # Create a container for each field to ensure proper layout
                    # Use flex column with consistent spacing to align dropdowns
                    with ui.column().classes(f"{field_classes} flex flex-col"):
                        # Field name (title) above
                        ui.label(config["label"]).classes(
                            "text-lg font-semibold text-gray-800 mb-1"
                        )

                        # Description below the title, above the dropdown
                        description_text = config["description"]
                        ui.markdown(description_text).classes(
                            "text-sm text-gray-600 mb-3"
                        )

                        # Generate the ui.select component with label (shows inside/above the field)
                        # options is now a simple list of label strings
                        # The value will be the selected label string
                        initial_value = data[field_name]
                        ui.select(
                            label=config["placeholder"],
                            options=options_list,
                            value=initial_value,
                            # on_change updates the data dictionary with the selected label
                            # If value is None (cleared), reset to first option
                            on_change=lambda e,
                            name=field_name,
                            opts=options_list: data.update(
                                {name: e.value if e.value is not None else opts[0]}
                            ),
                        ).classes(dropdown_classes).props(
                            f"outlined icon={config['icon']}"
                        )

            # Separator
            ui.separator().classes("my-6")

            # --- Result Display Area (above submit button) ---
            with ui.card().classes("w-full mb-4") as result_card_container:
                # Initially empty, will be populated on submit
                pass

            # --- Final Action Button ---
            with ui.row().classes("w-full items-center justify-center gap-4"):
                # Submit Button
                ui.button("Submit Configuration", on_click=submit_form).classes(
                    "px-8 py-3 bg-indigo-600 text-white rounded-lg shadow-lg hover:bg-indigo-700 transition duration-300 w-full sm:w-auto"
                )

                # Second Button (initially hidden, appears after successful calculation)
                with ui.row().classes("w-full sm:w-auto") as second_button_container:
                    ui.button(
                        "Process with System Size", on_click=process_with_system_size
                    ).classes(
                        "px-8 py-3 bg-green-600 text-white rounded-lg shadow-lg hover:bg-green-700 transition duration-300 w-full sm:w-auto"
                    )
                # Initially hide the second button
                second_button_container.set_visibility(False)

            # --- Tableviews Container (initially hidden) ---
            with ui.card().classes("w-full mt-4") as tableviews_container:
                # Initially empty, will be populated after processing
                pass
            tableviews_container.set_visibility(False)

            # Footer
            create_footer()


# Since we are running this in a Docker container, we ensure the host is '0.0.0.0'
if __name__ in {"__main__", "__mp_main__"}:
    # Access the environment variable (defined in Dockerfile/docker-compose)
    theme_color = os.environ.get("APP_THEME_COLOR", "indigo")
    ui.run(
        host="0.0.0.0",
        port=80,
        title="DETECT in SysML v2",
        favicon="images/Syside_only_logo_light_favicon.svg",
    )
