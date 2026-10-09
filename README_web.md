# Digital Engineering Tool Evaluation Criteria Template (DETECT) v2

DETECT (Digital Engineering Tool Evaluation Criteria Template) is a framework that helps organizations understand their Digital Engineering (DE) ecosystem, identify needs and gaps, and lower the barrier of entry to implementing effective DE in their workplace. Drawing on authoritative sources from DoD and industry, DETECT provides guidance for programs to use in developing and improving their DE ecosystem.

Version 2 extends the framework from ecosystem sizing alone to three use cases: sizing, tool types by lifecycle phase, and tool types by job series.

The data shown here — questions, available choices, lifecycle phases, job series, criteria, requirements and tool mappings — is parsed from an underlying SysML v2 model by [Syside Automator](https://docs.sensmetry.com/automator/). The sizing calculation, the selection of applicable criteria and requirements, and the mapping from selections to required tool types are all encoded in that model and evaluated by Syside.

## Getting Started

Click `Start Configuration`, then work through the tabs. There is one tab per use case the model declares, named by the use case's short name and title.

**UC1, Ecosystem Sizing.** Answer the ten questions using the dropdowns, then click `Submit Configuration` to calculate your ecosystem size (Small, Medium or Large). Click `Process with System Size` to generate the tailored requirements and evaluation criteria for that size, and download either as CSV.

**UC2, Tool Types by Lifecycle Phase.** Tick the lifecycle phases your ecosystem must support, grouped by acquisition phase, then click `Evaluate UC2`. The result lists every required tool type together with the phases that require it.

**UC3, Tool Types by Job Series.** Tick the job series your ecosystem must support, then click `Evaluate UC3`. The result lists every required tool type together with the roles that require it.

## Output Files

**requirements.csv** — Digital Engineering ecosystem requirements: `id`, `value` (weight at the calculated size), `description`.

**criteria.csv** — tool evaluation criteria: `id`, `value`, `criteria`, `context`.

**uc2_tools.csv** — required tool types by lifecycle phase: `tool_type`, `required_by`.

**uc3_tools.csv** — required tool types by job series: `tool_type`, `required_by`.

## DETECT Resources

- [DETECT Conversion Blog Post](https://sensmetry.com/sysml-v1-to-sysml-v2-migration-of-detect-benefits-lessons-learned/)
- [DETECT Infosheet](https://de-bok.org/asset/54489e0b638ea1d0564d408abf7c211c7ac4a423)
- [DETECT User Guide](https://de-bok.org/asset/0be5bae06967d6deefb520564763a3575446d3ee)
- [DETECT v1 Overview](https://de-bok.org/asset/0275584048738dec328f6d2959641a041e9743c7)
