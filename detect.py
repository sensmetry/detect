"""
This script is a helper script for the DETECT SysML v2 implementation.

This script depends on Syside Automator (https://docs.sensmetry.com/automator/install.html).
It was tested with v0.8.3, but newer versions should also work.

To use the tool, first make your choices in the `detect_input.sysml` file by
changing the values of the attributes from "TBD". After saving that file, run
this script.

This script will then output the calculated system size to the terminal and
produce two CSV files (`criteria.csv` and `requirements.csv`) in the `Output`
folder. These files will contained the filtered list of criteria and
requirements from `detect_criteria_list.sysml` and `detect_requirement_list.sysml`
models, according to the calculated system size.
"""

import csv
import os
import re
import syside


SYSML_FILES = [
    "detect_input.sysml",
    "detect_definitions.sysml",
    "detect_criteria_list.sysml",
    "detect_requirement_list.sysml",
]


VALID_REQUIREMENT_NAMES = ["valid_requirement", "valid_criteria"]


class Requirement:
    id: str
    description: str
    value: float | int

    def __init__(self, id: str, description: str, value: float | int):
        self.id = id
        self.description = description
        self.value = value


class Criteria:
    id: str
    criteria: str
    context: str
    value: float | int

    def __init__(self, id: str, criteria: str, context: str, value: float | int):
        self.id = id
        self.criteria = criteria
        self.context = context
        self.value = value


def evaluate_enum_value(evaluation: syside.EnumerationUsage) -> int:
    """Extract and evaluate the numeric value from an enumeration usage.

    Args:
        evaluation: The enumeration usage to extract the value from

    Returns:
        The integer value associated with the enumeration

    Raises:
        ValueError: If the value cannot be extracted or evaluated
    """
    for feature in evaluation.features.collect():
        if isinstance(feature, syside.ReferenceUsage) and feature.name == "value":
            expression = feature.feature_value_expression
            if expression is None:
                raise ValueError(f"Element '{feature.name}' has no value expression")

            evaluation_value, report = syside.Compiler().evaluate(expression)

            if report.fatal:
                raise ValueError(
                    f"Failed to evaluate expression for '{feature.name}': {report}"
                )
            if evaluation_value is None:
                raise ValueError(f"Failed to evaluate expression for '{feature.name}'")
            if not isinstance(evaluation_value, int):
                raise ValueError(
                    f"Expression for '{feature.name}' did not evaluate to an integer value"
                )

            return evaluation_value
    return 0


def get_named_documentation_comment(
    namespace: syside.Namespace, comment_name: str
) -> str | None:
    """Retrieve a documentation comment by name from a namespace.

    Args:
        namespace: The namespace to search for documentation
        comment_name: The name of the documentation comment to retrieve

    Returns:
        The comment body as a string, or None if not found
    """
    for doc in namespace.documentation.collect():
        if doc.declared_name == comment_name:
            comment = doc.body.strip()
            return comment
    return None


def get_named_attribute(
    namespace: syside.Namespace, attribute_name: str
) -> syside.AttributeUsage | None:
    """Find and return an attribute usage by name within a namespace.

    Args:
        namespace: The namespace to search
        attribute_name: The name of the attribute to find

    Returns:
        The attribute usage if found, None otherwise

    Raises:
        ValueError: If the found element is not an attribute usage
    """
    for attribute in namespace.owned_elements.collect():
        if attribute.name == attribute_name:
            if not isinstance(attribute, syside.AttributeUsage):
                raise ValueError(
                    f"Found {attribute.name} but it is not an attribute usage"
                )
            return attribute
    return None


def get_named_item(
    namespace: syside.Namespace, item_name: str
) -> syside.ItemUsage | syside.ItemDefinition | None:
    """Find and return an item usage or item definition by name within a namespace.

    Args:
        namespace: The namespace to search
        item_name: The name of the item to find

    Returns:
        The item usage or item definition if found, None otherwise

    Raises:
        ValueError: If the found element is not an item usage or item definition
    """
    for item in namespace.owned_elements.collect():
        if item.name == item_name:
            if not isinstance(item, syside.ItemUsage | syside.ItemDefinition):
                raise ValueError(
                    f"Found {item.name} but it is not an item usage or item definition"
                )
            return item
    return None


def is_valid_requirement(requirement_sysml: syside.RequirementUsage) -> bool:
    """
    Validate a requirement usage by checking if it has a valid expression or null.

    Args:
        requirement_sysml: The requirement usage to validate

    Returns:
        True if the requirement is valid, False otherwise
    """
    expression = requirement_sysml.feature_value_expression
    if expression is None:
        return False

    evaluation, report = syside.Compiler().evaluate(expression)
    if report.fatal:
        raise ValueError(
            f"Failed to evaluate expression for {requirement_sysml.name}: {report}"
        )

    if not isinstance(evaluation, syside.RequirementUsage):
        if evaluation is None:
            return False
        else:
            raise ValueError(
                f"Expression for {requirement_sysml.name} evaluated to an unexpected type: {type(evaluation)}"
            )
    else:
        if evaluation.name in VALID_REQUIREMENT_NAMES:
            return True
        else:
            return False


def parse_model() -> syside.Model:
    """Load and parse the SysML model from the defined SYSML_FILES.

    Returns:
        The parsed SysML model

    Raises:
        Prints any errors encountered during model loading
    """
    model, diagnostics = syside.load_model(SYSML_FILES)
    if diagnostics.errors:
        for error in diagnostics.errors:
            print(error)
    return model


def get_ecosystem_sysml_element(model: syside.Model) -> syside.PartUsage:
    """Find and return the DE_Ecosystem part usage from the model.

    Args:
        model: The SysML model to search

    Returns:
        The DE_Ecosystem part usage

    Raises:
        ValueError: If the DE_Ecosystem part usage is not found
    """
    part_usages_sysml = model.nodes(syside.PartUsage)
    ecosystem_sysml: syside.PartUsage | None = None
    for part_usage in part_usages_sysml:
        if part_usage.part_definitions[0].name == "DE_Ecosystem":
            ecosystem_sysml = part_usage
            break
    if ecosystem_sysml is None:
        raise ValueError("DE_Ecosystem part usage not found")
    assert isinstance(ecosystem_sysml, syside.PartUsage)
    return ecosystem_sysml


def system_size_calculation(data: dict[str, int]) -> int:
    """Calculate the system size number by summing all input values.

    Args:
        data: Dictionary of input names to their numeric values

    Returns:
        The sum of all input values
    """
    return sum(data.values())


def no_TBD_values(model: syside.Model) -> bool:
    """Checks if any of the input fields are still set to TBD.

    Args:
        model: The SysML model

    Returns:
        True if no TBD values are found, False otherwise

    Raises:
        ValueError: If inputs are missing or invalid
    """
    ecosystem_sysml = get_ecosystem_sysml_element(model)
    constraint_usage: syside.ConstraintUsage | None = None

    for element in ecosystem_sysml.owned_elements.collect():
        if (
            isinstance(element, syside.ConstraintUsage)
            and element.name == "no_TBD_values"
        ):
            constraint_usage = element
            break
    if constraint_usage is None:
        raise ValueError("no_TBD_values constraint not found")

    constraint_expression = constraint_usage.result_expression
    if constraint_expression is None:
        raise ValueError("no_TBD_values constraint has no result expression")

    evaluation, report = syside.Compiler().evaluate(constraint_expression)
    if report.fatal:
        raise ValueError(f"Failed to evaluate expression for no_TBD_values: {report}")
    if evaluation is None:
        raise ValueError("Failed to evaluate expression for no_TBD_values")
    if not isinstance(evaluation, bool):
        raise ValueError(
            "Expression for no_TBD_values did not evaluate to a boolean value"
        )

    return evaluation


def calculate_system_size(
    model: syside.Model,
) -> syside.EnumerationUsage | None:
    """Evaluates the system size expression and returns the system size enumeration.

    Args:
        model: The SysML model
        system_size_number: The calculated numeric system size

    Returns:
        The system size enumeration (e.g., Small, Medium, Large)

    Raises:
        ValueError: If required attributes are missing or evaluation fails
    """
    ecosystem_sysml = get_ecosystem_sysml_element(model)

    system_size_element = get_named_attribute(ecosystem_sysml, "system_size")
    if system_size_element is None:
        raise ValueError("system_size attribute not found")

    expression = system_size_element.feature_value_expression
    if expression is None:
        raise ValueError("system_size attribute has no value expression")

    evaluation, report = syside.Compiler().evaluate(expression)
    if report.fatal:
        raise ValueError(f"Failed to evaluate expression for system_size: {report}")
    if evaluation is None:
        raise ValueError("Failed to evaluate expression for system_size")
    if not isinstance(evaluation, syside.EnumerationUsage):
        raise ValueError(
            "Expression for system_size did not evaluate to an enumeration usage"
        )

    return evaluation


def evaluate_requirements_and_criteria(
    model: syside.Model,
) -> tuple[list[Requirement], list[Criteria]]:
    """Evaluate and filter requirements and criteria based on the system size.

    Args:
        model: The SysML model containing requirements and criteria
        system_size: The calculated system size enumeration

    Returns:
        A tuple containing:
            - List of requirements that apply to this system size
            - List of criteria that apply to this system size

    Raises:
        ValueError: If requirements/criteria are missing required fields or evaluation fails
    """
    requirements: list[Requirement] = []
    criteria: list[Criteria] = []

    for requirement_sysml in model.nodes(syside.RequirementUsage):
        definitions = [
            definition.name for definition in requirement_sysml.definitions.collect()
        ]

        if requirement_sysml.name in VALID_REQUIREMENT_NAMES:
            continue

        if "DE_Ecosystem_req_Def" in definitions:
            if is_valid_requirement(requirement_sysml):
                if (id := requirement_sysml.short_name) is None:
                    raise ValueError(
                        f"Requirement '{requirement_sysml.name}' has no short name"
                    )

                if (
                    description := get_named_documentation_comment(
                        requirement_sysml, "Description"
                    )
                ) is None:
                    raise ValueError(
                        f"Requirement '{requirement_sysml.name}' has no description"
                    )

                weight_element = get_named_attribute(requirement_sysml, "weight")
                if weight_element is None:
                    raise ValueError(
                        f"Weight attribute not found for requirement '{requirement_sysml.name}'"
                    )

                weight_expression = weight_element.feature_value_expression
                if weight_expression is None:
                    raise ValueError(
                        f"Weight attribute '{weight_element.name}' has no value expression"
                    )

                evaluation, report = syside.Compiler().evaluate(weight_expression)
                if report.fatal:
                    raise ValueError(
                        f"Failed to evaluate weight expression for {requirement_sysml.name}: {report}"
                    )
                if evaluation is None:
                    raise ValueError(
                        f"Failed to evaluate weight expression for {requirement_sysml.name}"
                    )
                if not isinstance(evaluation, float | int):
                    raise ValueError(
                        f"Weight expression for {requirement_sysml.name} did not evaluate to a float value"
                    )

                weight = round(evaluation, 4)
                requirements.append(Requirement(id, description, weight))

        elif "Criteria_Def" in definitions:
            if is_valid_requirement(requirement_sysml):
                if (id := requirement_sysml.short_name) is None:
                    raise ValueError(
                        f"Requirement '{requirement_sysml.name}' has no short name"
                    )

                if (
                    criteria_str := get_named_documentation_comment(
                        requirement_sysml, "Criteria"
                    )
                ) is None:
                    raise ValueError(
                        f"Requirement '{requirement_sysml.name}' has no criteria"
                    )

                if (
                    context := get_named_documentation_comment(
                        requirement_sysml, "Context"
                    )
                ) is None:
                    raise ValueError(
                        f"Requirement '{requirement_sysml.name}' has no context"
                    )

                weight_element = get_named_attribute(requirement_sysml, "weight")
                if weight_element is None:
                    raise ValueError(
                        f"Weight attribute not found for requirement '{requirement_sysml.name}'"
                    )

                weight_expression = weight_element.feature_value_expression
                if weight_expression is None:
                    raise ValueError(
                        f"Weight attribute '{weight_element.name}' has no value expression"
                    )

                evaluation, report = syside.Compiler().evaluate(weight_expression)
                if report.fatal:
                    raise ValueError(
                        f"Failed to evaluate weight expression for {requirement_sysml.name}: {report}"
                    )
                if evaluation is None:
                    raise ValueError(
                        f"Failed to evaluate weight expression for {requirement_sysml.name}"
                    )
                if not isinstance(evaluation, float | int):
                    raise ValueError(
                        f"Weight expression for {requirement_sysml.name} did not evaluate to a float value"
                    )

                weight = round(evaluation, 4)
                criteria.append(Criteria(id, criteria_str, context, weight))

    return requirements, criteria


def natural_sort_key(id_str: str) -> tuple[str | int, ...]:
    """Generate a sort key for natural sorting of IDs like R1, R1.1, R2, R3.2.

    Args:
        id_str: ID string (e.g., "R1", "R1.1", "C2.3.4")

    Returns:
        Tuple for sorting: (prefix, num1, num2, ...)
    """
    # Split into prefix (letters) and numeric parts
    parts = re.split(r"(\d+)", id_str)
    # Filter out empty strings and convert numbers
    result: list[str | int] = []
    for part in parts:
        if part:
            if part.isdigit():
                result.append(int(part))
            else:
                result.append(part)
    return tuple(result)


def save_requirements_to_csv(
    requirements: list[Requirement], filename: str = "requirements.csv"
) -> None:
    """Save the filtered requirements to a CSV file.

    Args:
        requirements: List of requirements to save
        filename: Name of the CSV file (default: "requirements.csv")

    Note:
        Creates the Output directory if it doesn't exist.
        Requirements are sorted using natural sorting (R1, R1.1, R2, etc.)
    """
    output_dir = "Output"
    os.makedirs(output_dir, exist_ok=True)
    filepath = os.path.join(output_dir, filename)
    with open(filepath, "w", newline="", encoding="utf-8") as csvfile:
        writer = csv.writer(csvfile)
        writer.writerow(["id", "value", "description"])
        # Sort requirements by ID using natural sort
        sorted_requirements = sorted(
            requirements, key=lambda req: natural_sort_key(req.id)
        )
        for req in sorted_requirements:
            writer.writerow([req.id, req.value, req.description])


def save_criteria_to_csv(
    criteria: list[Criteria], filename: str = "criteria.csv"
) -> None:
    """Save the filtered criteria to a CSV file.

    Args:
        criteria: List of criteria to save
        filename: Name of the CSV file (default: "criteria.csv")

    Note:
        Creates the Output directory if it doesn't exist.
        Criteria are sorted using natural sorting (C1, C1.1, C2, etc.)
    """
    output_dir = "Output"
    os.makedirs(output_dir, exist_ok=True)
    filepath = os.path.join(output_dir, filename)
    with open(filepath, "w", newline="", encoding="utf-8") as csvfile:
        writer = csv.writer(csvfile)
        writer.writerow(["id", "value", "criteria", "context"])
        # Sort criteria by ID using natural sort
        sorted_criteria = sorted(criteria, key=lambda crit: natural_sort_key(crit.id))
        for crit in sorted_criteria:
            writer.writerow([crit.id, crit.value, crit.criteria, crit.context])


if __name__ == "__main__":
    model = parse_model()

    no_TBD_values(model)
    if not no_TBD_values(model):
        raise ValueError("Some fields are still set to TBD")

    system_size = calculate_system_size(model)
    if system_size is None:
        raise ValueError("System size not found")

    print("\n" + "=" * 40)
    print(f"  System Size: {system_size.name}")
    print("=" * 40 + "\n")

    requirements, criteria = evaluate_requirements_and_criteria(model)

    save_requirements_to_csv(requirements)
    save_criteria_to_csv(criteria)
