# Digital Engineering Tool Evaluation Criteria Template (DETECT)

DETECT (Digital Engineering Tool Evaluation Criteria Template) is a framework
that helps organizations understand their Digital Engineering (DE) ecosystem,
identify needs and gaps, and lower the barrier of entry to implementing
effective DE in their workplace. Drawing on authoritative sources from DoD and
industry, DETECT provides guidance for programs to use in developing and
improving their DE ecosystem.

The framework provides project managers, engineers, and analysts with two
standardized templates: one for DE ecosystem requirements and one for tool
evaluation criteria. These templates can be tailored using DETECT, ultimately
assisting with DE ecosystem development and tool trade studies.

This tool is a webapp implementation of DETECT, adapted from the original SysML
v1.6 model developed by the DEM&S team and dedicated to the public domain This
webapp is based on the SysML v2 translation that was created by Sensmetry.

The data (questions, available choices, criteria and requirements) shown on this
webapp are automatically parsed from an underlying SysML v2 model by [Syside
Automator](https://docs.sensmetry.com/automator/). The logic of system size
calculation and the selection of applicable criteria and requirements according
to the system size is also encoded in the underlying SysML v2 model that is then
evaluated by [Syside Automator](https://docs.sensmetry.com/automator/). The
webapp is an auto-generated user-friendly interface that automatically adapts if
the SysML v2 models are changed.

## Getting Started

This webapp guides you through a streamlined process to generate tailored
requirements and evaluation criteria:

1. **Answer the Questions**: Use the dropdown interface to select parameters
   that describe your environment, such as project scope, team size, complexity,
   and organizational factors. Start by clicking the `Start Configuration`
   button.

2. **Automatic Sizing**: After answering all the questions and clicking `Submit
   Configuration` button, the DETECT tool calculates your ecosystem size (Small,
   Medium, or Large) based on your selections.

3. **Generate Tailored Output**: Clicking the `Process with System Size` button
   makes the tool select a customized set of Digital Engineering ecosystem
   requirements and tool evaluation criteria aligned with the auto-calculated
   size.

4. **Review and Customize**: Review the generated requirements and criteria in
   tables shown in the webapp. For more details, download them as CSV files. You
   can further customize these lists for your specific project or tool trade
   study.

This process reduces the time practitioners need to make informed decisions and
enables quicker development of robust Digital Engineering ecosystems.

## Output Files

**requirements.csv** – Contains filtered Digital Engineering Ecosystem
requirements with columns:

- `id` — Requirement identifier
- `value` — Weight value for the calculated ecosystem size
- `description` – Requirement description

**criteria.csv** – Contains filtered tool evaluation criteria with columns:

- `id` – Criteria identifier
- `value` – Weight value for the calculated ecosystem size
- `criteria` – Criteria description
- `context` – Context information

## Additional Resources

- [DETECT SysML v2 model (by Sensmetry)](https://github.com/sensmetry/detect)
- [DETECT Infosheet](https://de-bok.org/asset/54489e0b638ea1d0564d408abf7c211c7ac4a423)
- [DETECT User Guide](https://de-bok.org/asset/0be5bae06967d6deefb520564763a3575446d3ee)
- [DETECT v1 overview](https://de-bok.org/asset/0275584048738dec328f6d2959641a041e9743c7)
- [DETECT Information in Excel](https://de-bok.org/asset/f6646eaee1e16b160a930acb0f7f8fb5d94b0980)
- [DETECT SysML v1 Model File](https://de-bok.org/asset/f6646eaee1e16b160a930acb0f7f8fb5d94b0980)
