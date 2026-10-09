"""Tests for the DETECT v2 evaluator.

These run against the model files in `model/`. They are skipped when that directory
holds no model files.
"""

import os

import pytest

import detect
import webapp_main
from detect import Ecosystem, EntryKind, Profile, UseCase

pytestmark = pytest.mark.skipif(
    not os.path.isdir(detect.MODEL_DIR) or not detect.model_files(),
    reason="no model files in model/",
)


@pytest.fixture(scope="module")
def use_cases() -> list[UseCase]:
    """Parse the model once for the whole module."""
    return detect.parse(detect.parse_model())


@pytest.fixture(scope="module")
def ecosystem(use_cases: list[UseCase]) -> Ecosystem:
    """The ecosystem the sizing use case acts on."""
    return detect.ecosystem(use_cases)


@pytest.fixture(scope="module")
def profiles(use_cases: list[UseCase]) -> list[Profile]:
    """The profiles the tool type use cases act on."""
    return [use_case.subject for use_case in use_cases if isinstance(use_case.subject, Profile)]


def _answer_every_question(ecosystem: Ecosystem, position: int) -> None:
    """Answer every sizing question with the option at a given position.

    Options are ordered by their scoring value, so position 0 is the placeholder.
    """
    ecosystem.answer(
        {question.name: question.options[position] for question in ecosystem.questions}
    )


def test_use_cases_are_read_from_the_model(
    use_cases: list[UseCase], profiles: list[Profile]
) -> None:
    """The model declares one sizing use case and at least one tool type use case."""
    assert [use_case.id for use_case in use_cases] == sorted(use_case.id for use_case in use_cases)
    for use_case in use_cases:
        assert use_case.title and use_case.objective
    assert len(profiles) == len(use_cases) - 1
    assert profiles


def test_sizing_questions_are_read_from_the_model(ecosystem: Ecosystem) -> None:
    """Every sizing question carries the number and documentation the interface needs."""
    assert ecosystem.questions
    for question in ecosystem.questions:
        assert question.number.startswith("Q")
        assert question.description
        assert question.question
        assert len(question.values) == 4  # three answers plus TBD
        assert question.values[question.options[0]] == webapp_main.PLACEHOLDER_VALUE


def test_unanswered_questions_are_rejected(ecosystem: Ecosystem) -> None:
    """Leaving every question at TBD fails the model's own constraint."""
    _answer_every_question(ecosystem, 0)
    assert ecosystem.all_answered() is False


@pytest.mark.parametrize(
    ("position", "expected_size"),
    [(1, "Small"), (2, "Medium"), (3, "Large")],
)
def test_system_size_follows_the_answers(
    ecosystem: Ecosystem, position: int, expected_size: str
) -> None:
    """Answering every question at one level yields the size the model defines for it."""
    _answer_every_question(ecosystem, position)
    assert ecosystem.all_answered() is True
    assert ecosystem.size().name == expected_size


def test_larger_ecosystems_select_more_entries(ecosystem: Ecosystem) -> None:
    """Filtering is monotonic: a larger ecosystem never drops an entry a smaller one had."""
    for kind in EntryKind:
        counts = []
        for position in (1, 2, 3):
            _answer_every_question(ecosystem, position)
            counts.append(len(ecosystem.applicable(kind)))
        assert counts == sorted(counts)
        assert counts[0] > 0


def test_every_entry_is_fully_populated(ecosystem: Ecosystem) -> None:
    """Each entry carries the texts the CSV and the tables need, and a positive weight."""
    for entry in ecosystem.entries:
        assert entry.id
        assert len(entry.texts) == len(entry.kind.texts)
        assert all(entry.texts)
        assert entry.weight() > 0


def test_entries_follow_the_declared_order(ecosystem: Ecosystem) -> None:
    """Entries come out in the order of the model's own sequences, parents before children."""
    order = {entry.id: position for position, entry in enumerate(ecosystem.entries)}
    for entry_id in order:
        parent = entry_id.rpartition(".")[0]
        if parent:
            assert order[parent] < order[entry_id]
    _answer_every_question(ecosystem, 3)
    for kind in EntryKind:
        applicable = [entry.id for entry in ecosystem.applicable(kind)]
        assert applicable == sorted(applicable, key=lambda entry_id: order[entry_id])


def test_weights_of_siblings_sum_to_one(ecosystem: Ecosystem) -> None:
    """Weights are kept exact, so the top-level entries' weights sum to one."""
    for kind in EntryKind:
        top_level = [
            entry.weight()
            for entry in ecosystem.entries
            if entry.kind is kind and "." not in entry.id
        ]
        assert sum(top_level) == pytest.approx(1.0)


def test_profiles_expose_their_inputs(profiles: list[Profile]) -> None:
    """Both tool type profiles expose the inputs the interface groups into sections."""
    for profile in profiles:
        assert len(profile.flags) > 1
        assert 1 < len({flag.category for flag in profile.flags}) < len(profile.flags)


def test_selecting_nothing_requires_nothing(profiles: list[Profile]) -> None:
    """With no phases or roles selected, the model requires no tool types."""
    for profile in profiles:
        assert profile.mapping().tools_for([]) == []


def test_every_input_requires_at_least_one_tool_type(profiles: list[Profile]) -> None:
    """No input is inert: selecting any single one requires at least one tool type."""
    for profile in profiles:
        mapping = profile.mapping()
        for flag in mapping.flags:
            assert mapping.tools_for([flag.name]), f"{flag.name} requires no tool types"


def test_tool_selection_grows_with_the_selection(profiles: list[Profile]) -> None:
    """Adding a selection never removes a tool type that a smaller selection required."""
    for profile in profiles:
        mapping = profile.mapping()
        names = [flag.name for flag in mapping.flags]
        for size in range(1, len(names)):
            smaller = set(mapping.tools_for(names[:size]))
            larger = set(mapping.tools_for(names[: size + 1]))
            assert smaller <= larger


def test_every_required_tool_type_is_attributed_to_a_selection(profiles: list[Profile]) -> None:
    """The interface can always explain why a tool type appears in the result."""
    for profile in profiles:
        mapping = profile.mapping()
        names = [flag.name for flag in mapping.flags]
        for tool in mapping.tools_for(names):
            assert mapping.flags_requiring(tool, names)


def test_required_tool_types_follow_the_enumeration(profiles: list[Profile]) -> None:
    """Required tool types come out in the order the tool type enumeration declares."""
    for profile in profiles:
        mapping = profile.mapping()
        tools = mapping.tools_for([flag.name for flag in mapping.flags])
        assert tools == sorted(tools, key=lambda tool: mapping.tool_order[tool])


def test_input_files_are_readable(profiles: list[Profile]) -> None:
    """The selections in the upstream input files can be read back for the CLI path."""
    for profile in profiles:
        assert isinstance(profile.selections(), list)
