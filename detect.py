"""Helper script for the DETECT v2 SysML v2 implementation.

This script depends on Syside Automator (https://docs.sensmetry.com/automator/install.html).

Running the script evaluates every use case declared in the models against the input
files in `model/` and writes one CSV per output into the `Output` folder. See the README
 for the use cases and their inputs.

The model is parsed once into the types below, whose constructors check its shape and
raise `ValueError` naming what is missing. Everything after that evaluates the parsed
expressions and can fail only if evaluation itself fails.
"""

import csv
import os
from collections.abc import Iterable, Mapping, Sequence
from dataclasses import dataclass
from enum import Enum
from typing import NewType

import syside

MODEL_DIR = "model"
OUTPUT_DIR = "Output"

TOOL_TYPE_ENUMERATION = "Tool_Type_e"

# Weights are exact rationals in the model. They are rounded only when written out.
WEIGHT_DECIMALS = 4

CategoryName = NewType("CategoryName", str)
"""Name of a group of input flags, such as a lifecycle phase or a job family."""

FlagName = NewType("FlagName", str)
"""Name of a single boolean input flag within a profile."""

ToolTypeName = NewType("ToolTypeName", str)
"""Name of a `Tool_Type_e` enumeration literal."""

Header = list[str]
Rows = list[list[object]]


def model_files(model_dir: str = MODEL_DIR) -> list[str]:
    """List the model files to load, sorted by name."""
    return sorted(
        os.path.join(model_dir, name) for name in os.listdir(model_dir) if name.endswith(".sysml")
    )


def parse_model(files: Sequence[str] | None = None) -> syside.Model:
    """Load the model from the given files, or from every model in `model/`.

    Raises:
        ValueError: If the model does not load cleanly
    """
    model, diagnostics = syside.load_model(list(files) if files is not None else model_files())
    errors = list(diagnostics.errors)
    if errors:
        for error in errors:
            print(error)
        raise ValueError(f"Model failed to load with {len(errors)} error(s)")
    return model


# --- Shape checks -------------------------------------------------------------------------


def require[ValueType](value: ValueType | None, what: str) -> ValueType:
    """Return the value, or raise `ValueError` naming what is missing."""
    if value is None:
        raise ValueError(f"{what} is missing")
    return value


def member[ElementType: syside.Element](
    namespace: syside.Namespace, member_name: str, expected: type[ElementType]
) -> ElementType:
    """Return the member with that name.

    Raises:
        ValueError: If there is no such member or it is not of the expected type
    """
    found = namespace.get_member(member_name)
    if not isinstance(found, expected):
        raise ValueError(f"'{namespace.name}' has no {expected.__name__} named '{member_name}'")
    return found


def documentation(namespace: syside.Namespace, comment_name: str) -> str:
    """Return the body of the documentation comment with that name."""
    return member(namespace, comment_name, syside.Documentation).body.strip()


def value_expression(feature: syside.Feature) -> syside.Expression:
    """Return the feature's value expression."""
    return require(feature.feature_value_expression, f"Value expression of '{feature.name}'")


def evaluate[ValueType](
    expression: syside.Expression,
    expected: type[ValueType],
    what: str,
    scope: syside.Type | None = None,
) -> ValueType | None:
    """Evaluate an expression and return its value, or None if it evaluates to null.

    Raises:
        ValueError: If evaluation fails or the value is neither null nor of the expected type
    """
    compiler = syside.Compiler()
    evaluation, report = (
        compiler.evaluate(expression)
        if scope is None
        else compiler.evaluate(expression, scope=scope)
    )
    if report.fatal:
        raise ValueError(f"Failed to evaluate {what}: {report}")
    if evaluation is None:
        return None
    if not isinstance(evaluation, expected):
        raise ValueError(
            f"{what} evaluated to {type(evaluation).__name__}, expected {expected.__name__}"
        )
    return evaluation


def evaluate_required[ValueType](
    expression: syside.Expression, expected: type[ValueType], what: str
) -> ValueType:
    """Evaluate an expression whose value must not be null."""
    return require(evaluate(expression, expected, what), f"Value of {what}")


# --- Ecosystem sizing ----------------------------------------------------------------------


@dataclass(frozen=True)
class Question:
    """A sizing question: an enumeration-typed input attribute of the ecosystem.

    Attributes:
        name: The attribute name
        number: The attribute's short name, which numbers the question in the model
        description: The `Description` documentation
        question: The `Question` documentation
        attribute: The attribute in the input file that receives the answer
        literals: The enumeration literals by name
        values: The scoring value of each literal, by name
    """

    name: str
    number: str
    description: str
    question: str
    attribute: syside.AttributeUsage
    literals: Mapping[str, syside.EnumerationUsage]
    values: Mapping[str, int]

    @property
    def options(self) -> list[str]:
        """The literal names in ascending order of scoring value."""
        return sorted(self.values, key=lambda name: self.values[name])

    def answer(self, literal_name: str) -> None:
        """Write the named literal into the input file as this question's value."""
        literal = self.literals.get(literal_name)
        if literal is None:
            raise ValueError(f"'{literal_name}' is not an option of '{self.name}'")
        _, reference = self.attribute.feature_value_member.set_member_element(
            syside.FeatureReferenceExpression
        )
        reference.referent_member.set_member_element(literal)

    @staticmethod
    def parse(attribute: syside.AttributeUsage) -> "Question | None":
        """Parse an input attribute, or return None if it is not typed by an enumeration.

        The ported model carries one unfinished input with no enumeration, which is skipped.
        """
        name = require(attribute.name, "Name of a sizing input")
        definitions = attribute.attribute_definitions.collect()
        if not definitions or not isinstance(definitions[0], syside.EnumerationDefinition):
            return None
        enumeration = definitions[0]

        # The documentation and the number live on the attribute in the definition, which
        # the attribute in the input file redefines.
        heritage = attribute.heritage
        if not heritage:
            raise ValueError(f"Input '{name}' redefines nothing to read documentation from")
        declared = heritage[0][1]

        literals: dict[str, syside.EnumerationUsage] = {}
        values: dict[str, int] = {}
        for literal in enumeration.enumerated_values.collect():
            literal_name = require(literal.declared_name, f"Name of a literal of '{name}'")
            value = member(literal, "value", syside.Feature)
            literals[literal_name] = literal
            values[literal_name] = evaluate_required(
                value_expression(value), int, f"value of '{literal_name}'"
            )

        return Question(
            name,
            require(declared.short_name, f"Short name of '{name}'"),
            documentation(declared, "Description"),
            documentation(declared, "Question"),
            attribute,
            literals,
            values,
        )


class EntryKind(Enum):
    """The two kinds of entry the sizing selects, with their requirement definition."""

    REQUIREMENT = ("DETECT_Sizing::DE_Ecosystem_req_Def", ("Description",), "requirements.csv")
    CRITERION = ("DETECT_Sizing::Criteria_Def", ("Criteria", "Context"), "criteria.csv")

    def __init__(self, definition: str, texts: tuple[str, ...], filename: str) -> None:
        self.definition = definition
        self.texts = texts
        self.filename = filename

    @property
    def header(self) -> Header:
        """The CSV header: id, weight, then one column per documentation text."""
        return ["id", "value", *(text.lower() for text in self.texts)]


@dataclass(frozen=True)
class Entry:
    """A requirement or criterion, applicable or not depending on the ecosystem's size.

    Attributes:
        id: The short name, such as `R1.2` or `C3`
        kind: Whether it is a requirement or a criterion
        texts: The documentation texts the kind names, in that order
        applicability: The expression that yields a requirement usage when the entry
            applies and null when it does not
        weight_expression: The `weight` attribute's value expression
    """

    id: str
    kind: EntryKind
    texts: tuple[str, ...]
    applicability: syside.Expression
    weight_expression: syside.Expression

    def applies(self) -> bool:
        """Whether the entry applies at the ecosystem's current size."""
        return (
            evaluate(self.applicability, syside.RequirementUsage, f"applicability of {self.id}")
            is not None
        )

    def weight(self) -> float:
        """The entry's weight, exact as the model computes it."""
        return evaluate_required(self.weight_expression, float, f"weight of {self.id}")

    @staticmethod
    def parse(
        usage: syside.RequirementUsage, kinds: Mapping[EntryKind, syside.RequirementDefinition]
    ) -> "Entry":
        """Parse a listed requirement usage."""
        short_name = require(usage.short_name, f"Short name of requirement '{usage.name}'")
        kind = next(
            (kind for kind, definition in kinds.items() if usage.specializes(definition)), None
        )
        if kind is None:
            raise ValueError(f"Requirement '{short_name}' is neither a requirement nor a criterion")
        return Entry(
            short_name,
            kind,
            tuple(documentation(usage, text) for text in kind.texts),
            value_expression(usage),
            value_expression(member(usage, "weight", syside.AttributeUsage)),
        )


def _referenced_requirements(expression: syside.Expression) -> list[syside.RequirementUsage]:
    """Return the requirement usages a sequence expression refers to, in sequence order.

    Returns an empty list when the expression is not a sequence of references to
    requirement usages.
    """
    if isinstance(expression, syside.FeatureReferenceExpression):
        referent = expression.referent
        return [referent] if isinstance(referent, syside.RequirementUsage) else []
    if (
        isinstance(expression, syside.OperatorExpression)
        and expression.operator == syside.Operator.Comma
    ):
        referenced: list[syside.RequirementUsage] = []
        for operand in expression.operands.collect():
            found = _referenced_requirements(operand)
            if not found:
                return []
            referenced.extend(found)
        return referenced
    return []


def _requirement_lists(namespace: syside.Namespace) -> list[list[syside.RequirementUsage]]:
    """Return the sequences of requirement usages that a namespace's reference usages declare."""
    lists: list[list[syside.RequirementUsage]] = []
    for element in namespace.owned_elements.collect():
        if (
            isinstance(element, syside.ReferenceUsage)
            and element.feature_value_expression is not None
        ):
            referenced = _referenced_requirements(element.feature_value_expression)
            if referenced:
                lists.append(referenced)
    return lists


def parse_entries(model: syside.Model) -> list[Entry]:
    """Parse every listed requirement and criterion, in the model's own ordering.

    The model lists its entries in sequences such as `criteria_list = (C1, ..., C12)`
    and, within each entry, `criteria_1_subcriteria = ('C1.1', ...)`. The weights are
    `1.0 / size(list)` over these sequences, so they are the ordering the model itself
    relies on. Entries come out depth first, each before the entries in its own sequence.
    """
    kinds = {kind: _requirement_definition(model, kind.definition) for kind in EntryKind}
    entries: list[Entry] = []
    seen: set[str] = set()

    def visit(usages: Sequence[syside.RequirementUsage]) -> None:
        for usage in usages:
            entry = Entry.parse(usage, kinds)
            if entry.id not in seen:
                seen.add(entry.id)
                entries.append(entry)
            for nested in _requirement_lists(usage):
                visit(nested)

    for package in model.nodes(syside.Package):
        for listed in _requirement_lists(package):
            visit(listed)
    return entries


def _requirement_definition(
    model: syside.Model, qualified_name: str
) -> syside.RequirementDefinition:
    """Return the requirement definition with that qualified name."""
    for definition in model.nodes(syside.RequirementDefinition):
        if str(definition.qualified_name) == qualified_name:
            return definition
    raise ValueError(f"Requirement definition '{qualified_name}' not found")


@dataclass(frozen=True)
class Ecosystem:
    """The ecosystem being sized: its questions, its size, and the entries the size selects.

    Attributes:
        part: The part usage in the input file that carries the answers
        questions: The sizing questions, in declaration order
        size_expression: The `system_size` attribute's value expression
        all_answered_expression: The `no_TBD_values` constraint's expression
        entries: Every requirement and criterion, in the model's ordering
    """

    part: syside.PartUsage
    questions: Sequence[Question]
    size_expression: syside.Expression
    all_answered_expression: syside.Expression
    entries: Sequence[Entry]

    def answer(self, answers: Mapping[str, str]) -> None:
        """Write answers, keyed by question name, into the input file."""
        by_name = {question.name: question for question in self.questions}
        for name, literal_name in answers.items():
            if name not in by_name:
                raise ValueError(f"'{name}' is not a sizing question")
            by_name[name].answer(literal_name)

    def all_answered(self) -> bool:
        """Evaluate the model's own check that no answer is still the placeholder."""
        return evaluate_required(self.all_answered_expression, bool, "no_TBD_values")

    def size(self) -> syside.EnumerationUsage:
        """Evaluate the ecosystem's size."""
        return evaluate_required(self.size_expression, syside.EnumerationUsage, "system_size")

    def applicable(self, kind: EntryKind) -> list[Entry]:
        """The entries of one kind that apply at the current size, in the model's ordering."""
        return [entry for entry in self.entries if entry.kind is kind and entry.applies()]

    @staticmethod
    def parse(part: syside.PartUsage, model: syside.Model) -> "Ecosystem":
        """Parse the ecosystem part usage of the sizing use case."""
        inputs = member(part, "inputs", syside.ItemUsage)
        questions = [
            question
            for attribute in inputs.owned_elements.collect()
            if isinstance(attribute, syside.AttributeUsage)
            and (question := Question.parse(attribute)) is not None
        ]
        return Ecosystem(
            part,
            questions,
            value_expression(member(part, "system_size", syside.AttributeUsage)),
            require(
                member(part, "no_TBD_values", syside.ConstraintUsage).result_expression,
                "Result expression of no_TBD_values",
            ),
            parse_entries(model),
        )


def entry_rows(kind: EntryKind, entries: Sequence[Entry]) -> tuple[Header, Rows]:
    """Return the header and rows of a requirements or criteria output."""
    return (
        kind.header,
        [[entry.id, round(entry.weight(), WEIGHT_DECIMALS), *entry.texts] for entry in entries],
    )


# --- Tool type profiles --------------------------------------------------------------------


@dataclass(frozen=True)
class Flag:
    """A boolean input of a profile, together with the group that owns it."""

    category: CategoryName
    name: FlagName
    attribute: syside.AttributeUsage


@dataclass(frozen=True)
class ProfileMapping:
    """Which tool types each input flag requires.

    Attributes:
        flags: Every boolean input the profile declares, in declaration order
        tools_by_flag: The tool types each flag requires when it is selected
        tool_order: The position of each tool type in the tool type enumeration
    """

    flags: Sequence[Flag]
    tools_by_flag: Mapping[FlagName, Sequence[ToolTypeName]]
    tool_order: Mapping[ToolTypeName, int]

    def tools_for(self, selected: Iterable[FlagName]) -> list[ToolTypeName]:
        """Return the tool types required by the selected flags, in enumeration order.

        Raises:
            ValueError: If a mapping yields a tool type the enumeration does not declare
        """
        required = {tool for flag in selected for tool in self.tools_by_flag.get(flag, ())}
        undeclared = required - self.tool_order.keys()
        if undeclared:
            raise ValueError(
                f"Tool types not declared by the enumeration: {', '.join(sorted(undeclared))}"
            )
        return sorted(required, key=lambda tool: self.tool_order[tool])

    def flags_requiring(self, tool: ToolTypeName, selected: Iterable[FlagName]) -> list[FlagName]:
        """Return the selected flags whose mapping includes the tool type."""
        return [flag for flag in selected if tool in self.tools_by_flag.get(flag, ())]


@dataclass(frozen=True)
class Profile:
    """A part definition mapping boolean selections to tool types, and its input file.

    Attributes:
        definition: The part definition carrying the flags and the derived tool attributes
        part: The part usage in the input file that carries the selections
        flags: The definition's boolean inputs, in declaration order
        tool_attributes: Name and value expression of each derived tool attribute
        tool_order: The position of each tool type in the tool type enumeration
    """

    definition: syside.PartDefinition
    part: syside.PartUsage
    flags: Sequence[Flag]
    tool_attributes: Sequence[tuple[str, syside.Expression]]
    tool_order: Mapping[ToolTypeName, int]

    def set_flags(self, selected: Iterable[FlagName]) -> None:
        """Set the selected flags true and every other flag false in the definition."""
        wanted = set(selected)
        for flag in self.flags:
            _, literal = flag.attribute.feature_value_member.set_member_element(
                syside.LiteralBoolean
            )
            literal.value = flag.name in wanted

    def _tools_yielded(self, name: str, expression: syside.Expression) -> list[ToolTypeName]:
        """Evaluate one derived tool attribute against the current flags."""
        evaluation = evaluate(expression, object, name, scope=self.definition)
        if evaluation is None:
            return []
        candidates = evaluation if isinstance(evaluation, list) else [evaluation]
        tools: list[ToolTypeName] = []
        for candidate in candidates:
            if not isinstance(candidate, syside.EnumerationUsage) or candidate.name is None:
                raise ValueError(f"'{name}' yielded {type(candidate)}, expected a tool type")
            tools.append(ToolTypeName(candidate.name))
        return tools

    def mapping(self) -> ProfileMapping:
        """Derive which tool types each flag requires.

        Each flag is set on its own and every derived tool attribute is evaluated, so the
        mapping comes from the model rather than from reading the model's source text.

        The models express each mapping as `if inputs.<flag> ? (tools) else null`, one
        derived attribute per flag, so a tool type is required exactly when one of the
        flags mapping to it is selected. This method checks that assumption and reports a
        derived attribute that no single flag activates, which would mean its condition
        is not a plain disjunction of flags and that taking the union would silently drop
        it.
        """
        tools_by_flag: dict[FlagName, Sequence[ToolTypeName]] = {}
        activated: set[str] = set()

        for flag in self.flags:
            self.set_flags([flag.name])
            required: list[ToolTypeName] = []
            for name, expression in self.tool_attributes:
                tools = self._tools_yielded(name, expression)
                if tools:
                    activated.add(name)
                    required.extend(tools)
            tools_by_flag[flag.name] = required
        self.set_flags([])

        inert = sorted(name for name, _ in self.tool_attributes if name not in activated)
        if inert:
            raise ValueError(
                f"Profile '{self.definition.name}' has derived tool attributes that no single "
                f"input flag activates: {', '.join(inert)}. Their conditions are not a plain "
                "disjunction of input flags, so this mapping would omit them."
            )
        return ProfileMapping(self.flags, tools_by_flag, self.tool_order)

    def selections(self) -> list[FlagName]:
        """Read the flags the input file sets to true, in declaration order."""
        inputs = member(self.part, "inputs", syside.ItemUsage)
        selected: list[FlagName] = []
        for attribute in inputs.owned_elements.collect():
            if not isinstance(attribute, syside.AttributeUsage):
                continue
            expression = attribute.feature_value_expression
            if not isinstance(expression, syside.LiteralBoolean) or not expression.value:
                continue
            # The input file redefines each flag through a feature chain, so the flag's
            # name is that of the chain's last feature.
            name = attribute.name
            for redefinition in attribute.owned_redefinitions.collect():
                redefined = redefinition.redefined_feature
                last = None if redefined is None else redefined.last_chaining_feature
                if last is not None and last.name is not None:
                    name = last.name
            selected.append(FlagName(require(name, f"Name of an input in '{self.part.name}'")))
        return selected

    @staticmethod
    def parse(part: syside.PartUsage, model: syside.Model) -> "Profile":
        """Parse the profile part usage of a tool type use case."""
        definition = require(
            next(iter(part.part_definitions.collect()), None), f"Definition of '{part.name}'"
        )
        flags = [
            Flag(CategoryName(category.name), FlagName(attribute.name), attribute)
            for category in member(definition, "inputs", syside.ItemUsage).owned_elements.collect()
            if isinstance(category, syside.ItemUsage) and category.name is not None
            for attribute in category.owned_elements.collect()
            if isinstance(attribute, syside.AttributeUsage) and attribute.name is not None
        ]
        tool_attributes = [
            (require(element.name, "Name of a derived tool attribute"), value_expression(element))
            for element in definition.owned_elements.collect()
            if isinstance(element, syside.AttributeUsage)
            and element.is_derived
            and TOOL_TYPE_ENUMERATION
            in [
                attribute_definition.name
                for attribute_definition in element.attribute_definitions.collect()
            ]
        ]
        return Profile(definition, part, flags, tool_attributes, _tool_type_order(model))


def _tool_type_order(model: syside.Model) -> dict[ToolTypeName, int]:
    """Return the position of each literal in the tool type enumeration."""
    for enumeration in model.nodes(syside.EnumerationDefinition):
        if enumeration.name == TOOL_TYPE_ENUMERATION:
            return {
                ToolTypeName(literal.name): position
                for position, literal in enumerate(enumeration.enumerated_values.collect())
                if literal.name is not None
            }
    raise ValueError(f"Enumeration '{TOOL_TYPE_ENUMERATION}' not found")


def format_display_name(raw_name: str) -> str:
    """Turn a SysML attribute name into a readable title.

    The models require flags to be named `phase_ACRONYM_title` or `role_ACRONYM_title`.
    The prefix is removed and words are capitalised, leaving acronyms as declared.
    """
    cleaned = raw_name.removeprefix("phase_").removeprefix("role_")
    words = cleaned.split("_")
    return " ".join(word if word.isupper() else word.capitalize() for word in words)


def tool_rows(
    mapping: ProfileMapping, selected: Sequence[FlagName], separator: str = "; "
) -> tuple[Header, Rows]:
    """Return the header and rows of a tool types output.

    Each row names a required tool type and the selections that require it.
    """
    return (
        ["tool_type", "required_by"],
        [
            [
                tool,
                separator.join(
                    format_display_name(flag) for flag in mapping.flags_requiring(tool, selected)
                ),
            ]
            for tool in mapping.tools_for(selected)
        ],
    )


# --- Use cases -----------------------------------------------------------------------------


@dataclass(frozen=True)
class UseCase:
    """A use case the model declares, with the parsed part it acts on.

    Attributes:
        id: The use case's short name, such as `UC2`
        title: The use case's declared name
        objective: The body of the objective's documentation
        subject: The ecosystem to size, or the profile to map to tool types
    """

    id: str
    title: str
    objective: str
    subject: Ecosystem | Profile

    @property
    def tools_csv_filename(self) -> str:
        """The name of the CSV holding a tool type use case's output."""
        return f"{self.id.lower()}_tools.csv"

    @staticmethod
    def parse(usage: syside.UseCaseUsage, model: syside.Model) -> "UseCase":
        """Parse a use case usage. Its subject must redefine a part usage in an input file."""
        short_name = require(usage.short_name, f"Short name of use case '{usage.name}'")
        objective = require(usage.objective_requirement, f"Objective of '{short_name}'")
        objective_docs = objective.documentation.collect()
        if not objective_docs:
            raise ValueError(f"Objective of '{short_name}' is not documented")

        parameter = require(usage.subject_parameter, f"Subject of '{short_name}'")
        part = next(
            (
                redefinition.redefined_feature
                for redefinition in parameter.owned_redefinitions.collect()
                if isinstance(redefinition.redefined_feature, syside.PartUsage)
            ),
            None,
        )
        if part is None:
            raise ValueError(f"Subject of '{short_name}' does not redefine a part usage")

        # The sizing use case acts on the part that carries `system_size`; every other
        # use case acts on a profile.
        subject: Ecosystem | Profile
        if isinstance(part.get_member("system_size"), syside.AttributeUsage):
            subject = Ecosystem.parse(part, model)
        else:
            subject = Profile.parse(part, model)

        return UseCase(
            short_name,
            require(usage.name, f"Name of use case '{short_name}'"),
            objective_docs[0].body.strip(),
            subject,
        )


def parse(model: syside.Model) -> list[UseCase]:
    """Parse the use cases the model declares, sorted by short name."""
    return sorted(
        (UseCase.parse(usage, model) for usage in model.nodes(syside.UseCaseUsage)),
        key=lambda use_case: use_case.id,
    )


def ecosystem(use_cases: Iterable[UseCase]) -> Ecosystem:
    """Return the one ecosystem among the use cases' subjects."""
    ecosystems = [
        use_case.subject for use_case in use_cases if isinstance(use_case.subject, Ecosystem)
    ]
    if len(ecosystems) != 1:
        raise ValueError(f"Expected one sizing use case, found {len(ecosystems)}")
    return ecosystems[0]


# --- Command line --------------------------------------------------------------------------


def write_csv(filename: str, header: Header, rows: Rows) -> str:
    """Write a CSV into the output directory, creating it if needed, and return its path."""
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    filepath = os.path.join(OUTPUT_DIR, filename)
    with open(filepath, "w", newline="", encoding="utf-8") as csvfile:
        writer = csv.writer(csvfile)
        writer.writerow(header)
        writer.writerows(rows)
    return filepath


def main() -> None:
    """Evaluate every use case from the input files and write the CSV outputs."""
    for use_case in parse(parse_model()):
        print(f"\n{use_case.id}: {use_case.title}")
        subject = use_case.subject
        if isinstance(subject, Ecosystem):
            if not subject.all_answered():
                raise ValueError(f"Some {use_case.id} sizing fields are still set to TBD")
            print(f"  System size: {subject.size().name}")
            for kind in EntryKind:
                entries = subject.applicable(kind)
                path = write_csv(kind.filename, *entry_rows(kind, entries))
                print(f"  {len(entries)} {kind.name.lower()} entries -> {path}")
        else:
            selected = subject.selections()
            header, rows = tool_rows(subject.mapping(), selected)
            path = write_csv(use_case.tools_csv_filename, header, rows)
            print(f"  {len(rows)} tool types from {len(selected)} selections -> {path}")
    print()


if __name__ == "__main__":
    main()
