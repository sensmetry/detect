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


def write_system_size(
    system_size: syside.EnumerationUsage, model: syside.Model
) -> None:
    """This takes the system size enumeration usage and assigns it as the value for the
    system_size attribute usage. While currently the script does not save the new value in the
    SysML v2 file, the value is still needed so that syside.Compiler can evaluate the boolean
    logic that is used to filter the requirements and criteria.
    """
    calculated_size_element: syside.AttributeUsage | None = None
    for attribute_usage in model.nodes(syside.AttributeUsage):
        if attribute_usage.name == "system_size":
            calculated_size_element = attribute_usage
            break

    if calculated_size_element is None:
        raise ValueError("system_size part usage not found")

    _, size_element_value = (
        calculated_size_element.feature_value_member.set_member_element(
            syside.FeatureReferenceExpression
        )
    )
    reference_value = size_element_value.referent_member
    _1, _2 = reference_value.set_member_element(system_size)


def evaluate_requirement(
    requirement_sysml: syside.RequirementUsage, system_size: syside.EnumerationUsage
) -> bool:
    """Evaluate whether a requirement applies for the given system size.

    Args:
        requirement_sysml: The requirement usage to evaluate
        system_size: The system size enumeration to evaluate against

    Returns:
        True if the requirement applies for this system size, False otherwise

    Raises:
        ValueError: If the requirement has invalid constraints or evaluation fails
    """
    constraints = requirement_sysml.assumed_constraints.collect()
    if len(constraints) != 1:
        raise ValueError(
            f"Requirement {requirement_sysml.name} has {len(constraints)} constraints, expected 1"
        )

    constraint = constraints[0]
    if not isinstance(constraint, syside.ConstraintUsage):
        raise ValueError(
            f"Requirement {requirement_sysml.name} has a constraint that is not a constraint usage"
        )

    constraint_expression = constraint.result_expression
    if constraint_expression is None:
        raise ValueError(
            f"Requirement {requirement_sysml.name} has no constraint expression"
        )

    evaluation, report = syside.Compiler().evaluate(constraint_expression)
    if report.fatal:
        raise ValueError(
            f"Failed to evaluate constraint expression for {requirement_sysml.name}: {report}"
        )
    if evaluation is None:
        raise ValueError(
            f"Failed to evaluate constraint expression for {requirement_sysml.name}"
        )

    if not isinstance(evaluation, bool):
        raise ValueError(
            f"Constraint expression for {requirement_sysml.name} did not evaluate to a boolean value"
        )
    return evaluation


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


def get_system_size_number(model: syside.Model) -> int | None:
    """Extract and calculate the system size number from input values in the model.

    Args:
        model: The SysML model containing the ecosystem and inputs

    Returns:
        The calculated system size number

    Raises:
        ValueError: If inputs are missing, invalid, or still set to TBD
    """
    ecosystem_sysml = get_ecosystem_sysml_element(model)
    inputs_data: dict[str, int] = {}
    inputs_feature: syside.ItemUsage | syside.ItemDefinition | None = None

    inputs_feature = get_named_item(ecosystem_sysml, "inputs")
    if inputs_feature is None:
        raise ValueError("inputs attribute not found")

    for feature in inputs_feature.owned_elements.collect():
        if not isinstance(feature, syside.Feature):
            raise ValueError(f"Input element '{feature.name}' is not a feature")

        expression = feature.feature_value_expression
        if expression is None:
            raise ValueError(f"Element '{feature.name}' has no value expression")

        evaluation, report = syside.Compiler().evaluate(expression)
        if report.fatal:
            raise ValueError(
                f"Failed to evaluate expression for '{feature.name}': {report}"
            )
        if evaluation is None:
            raise ValueError(f"Failed to evaluate expression for '{feature.name}'")
        if not isinstance(evaluation, syside.EnumerationUsage):
            raise ValueError(
                f"Expression for '{feature.name}' did not evaluate to an enumeration usage"
            )

        if (number_value := evaluate_enum_value(evaluation)) == 0:
            raise ValueError(f"Expression for '{feature.name}' is still TBD")

        if feature.name is None:
            raise ValueError(f"Input element '{feature.name}' has no name")

        inputs_data[feature.name] = number_value

    return system_size_calculation(inputs_data)


def calculate_system_size(
    model: syside.Model, system_size_number: int
) -> syside.EnumerationUsage | None:
    """Determine the system size enumeration based on the calculated system size number.

    Args:
        model: The SysML model
        system_size_number: The calculated numeric system size

    Returns:
        The system size enumeration (e.g., Small, Medium, Large)

    Raises:
        ValueError: If required attributes are missing or evaluation fails
    """
    ecosystem_sysml = get_ecosystem_sysml_element(model)

    system_size_number_element = get_named_attribute(
        ecosystem_sysml, "system_size_number"
    )
    if system_size_number_element is None:
        raise ValueError("system_size_number attribute not found")

    # Set the value of the system_size_number attribute so that the syside.Compiler can evaluate the boolean
    # logic that is used to determine the system size enum value
    _, system_size_number_value = (
        system_size_number_element.feature_value_member.set_member_element(
            syside.LiteralRational
        )
    )
    system_size_number_value.value = system_size_number

    system_size_element = get_named_attribute(ecosystem_sysml, "system_size")
    if system_size_element is None:
        raise ValueError("{system_size} attribute not found")

    expression = system_size_element.feature_value_expression
    if expression is None:
        raise ValueError(f"{system_size} attribute has no value expression")

    evaluation, report = syside.Compiler().evaluate(expression)
    if report.fatal:
        raise ValueError(f"Failed to evaluate expression for {system_size}: {report}")
    if evaluation is None:
        raise ValueError(f"Failed to evaluate expression for {system_size}")
    if not isinstance(evaluation, syside.EnumerationUsage):
        raise ValueError(
            f"Expression for {system_size} did not evaluate to an enumeration usage"
        )

    return evaluation


def evaluate_requirements_and_criteria(
    model: syside.Model, system_size: syside.EnumerationUsage
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

        if "DE_Ecosystem_req_Def" in definitions:
            if evaluate_requirement(requirement_sysml, system_size):
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

                weight = evaluation
                requirements.append(Requirement(id, description, weight))

        elif "Criteria_Def" in definitions:
            if evaluate_requirement(requirement_sysml, system_size):
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

                weight = evaluation
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

    system_size_number = get_system_size_number(model)
    if system_size_number is None:
        raise ValueError("System size number not found")

    system_size = calculate_system_size(model, system_size_number)
    if system_size is None:
        raise ValueError("System size not found")

    print("\n" + "=" * 40)
    print(f"  System Size: {system_size.name}")
    print("=" * 40 + "\n")

    write_system_size(system_size, model)

    requirements, criteria = evaluate_requirements_and_criteria(model, system_size)

    save_requirements_to_csv(requirements)
    save_criteria_to_csv(criteria)
