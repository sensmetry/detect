# Digital Engineering Tool Evaluation Criteria Template (DETECT)

SysML v2 implementation of the DoD/DoW
[DETECT](https://de-bok.org/asset/79686e328d91955163060b984e211ee05c774173)
framework for digital engineering ecosystem sizing and tool evaluation.

DETECT (Digital Engineering Tool Evaluation Criteria Template) is a framework
that helps organizations understand their Digital Engineering (DE) ecosystem,
identify needs and gaps, and lower the barrier of entry to implementing
effective DE in their workplace. Drawing on authoritative sources from DoD/DoW
and industry, DETECT provides guidance for programs to use in developing and
improving their DE ecosystem.

The framework provides project managers, engineers, and analysts with two
standardized templates: one for DE ecosystem requirements and one for tool
evaluation criteria. These templates can be tailored using DETECT, ultimately
assisting with DE ecosystem development and tool trade studies.

This package is a SysML v2 implementation of DETECT, adapted from the original
SysML v1.6 model developed by the DEM&S team and dedicated to the public domain.
The SysML v2 translation was created by Sensmetry, and is licensed under the
permissive MIT license.

The SysML v2 version of DETECT can be used in one of two ways:

- **On the web** – Go to [`detect.syside.app`](https://detect.syside.app), fill
  out the form, and download the filtered list of criteria and requirements.
  _This service is completely free._
- **Locally** – Download this package, enter your data in the
  `detect_input.sysml` file, use Syside Automator and the provided `detect.py`
  Python script to evaluate your system size and receive the filtered list of
  criteria and requirements. _This approach requires a valid Syside Pro license.
  For a free trial, go to [syside.sensmetry.com](https://syside.sensmetry.com)_

## Output

The tool generates two CSV files in the `Output/` directory (when using the tool
locally) or for download (when using the tool online):

- **criteria.csv** – Contains filtered evaluation criteria with columns:
  - `id` – Criteria identifier
  - `value` – Weight value for the calculated ecosystem size
  - `criteria` – Criteria description
  - `context` – Context information

- **requirements.csv** – Contains filtered requirements with columns:
  - `id` – Requirement identifier
  - `value` – Weight value for the calculated ecosystem size
  - `description` – Requirement description

## Model Structure

- **detect_input.sysml** – Main data entry point, includes DE ecosystem instance
- **detect_criteria_list.sysml** – A model list of all weighted evaluation
  criteria
- **detect_requirement_list.sysml** – A model list of all weighted Digital
  Engineering Ecosystem requirements
- **detect_definitions.sysml** – Core definitions and calculations
- **detect_use_cases.sysml** – Use Cases model view for DETECT method.

## Use the Tool Locally

### Prerequisites

**For only using `detect.py`**:

- Python 3.12+
- [`syside`](https://pypi.org/project/syside/) – Python library for SysML v2
  model analysis and modification, developed by Sensmetry. Installation
  instructions available in [Syside
  documentation](https://docs.sensmetry.com/automator/install.html).

**For also using `webapp_main.py`**:

- [`nicegui`](https://pypi.org/project/nicegui/) – Python library for simple
  web-based user interfaces.

### Instructions

1. Open the model in a SysML v2 tool
2. Enter `Determine_DE_Sizing::de_ecosystem` parameters in `detect_input.sysml`
3. Run the script from the command line:

   ```bash
   python detect.py
   ```

4. The model calculates the ecosystem size (Small/Medium/Large) based on the
   input parameters
5. Based on the calculated ecosystem size, criteria from
   `detect_criteria_list.sysml` and requirements from
   `detect_requirement_list.sysml` are filtered and saved in the `Output/`
   folder as:
   - `criteria.csv` - Evaluation criteria with weights
   - `requirements.csv` - Digital Engineering Ecosystem requirements with
     weights

## Develop and Deploy the Tool

### Extend DETECT

The SysML v2 models are the "source-of-truth" artifacts that are then used by
both `detect.py` and `webapp_main.py` scripts. Therefore, the majority of the
work that needs to be done to extend DETECT can be done directly in the SysML v2
models without the need to touch the Python scripts.

E.g. if you want to add one more question to the questionnaire, you should
modify the `DETECT_Sizing::DE_Ecosystem::DETECT_Inputs` item in the
`detect_definitions.sysml` file, as well as adding a new enumeration to
`DETECT_Sizing::DETECT_enumerations` package in the same file, as well as
accordingly adjusting the `detect_input.sysml` file. After adding a new
question, you should be able to see the changes appear in the webapp (running
`webapp_main.py`) and locally when running `detect.py`.

### Deployment

This repository also contains the source code of the webapp, which allows you to
self-host it. However, **self-hosting it requires a valid Syside Automator
license**. To obtain it, refer to [Syside's Product
Page](https://syside.sensmetry.com). The hosted version at
[detect.syside.app](https://detect.syside.app) does not require a Syside
Automator license.

#### Locally

You can run the `webapp_main.py` file on your machine. This will spin up a
developmental version of the webapp that should automatically reload whenever
you change the `webapp_main.py` file. If you make changes in `.sysml` files, you can force the reload by opening the `webapp_main.py` file and saving it.

By default, the webapp launches on port 80. This may cause problems when running on the local machine. To adjust the port, edit the value in the `webapp_main.py` file's `main` function:

```python
ui.run(
    host="0.0.0.0",
    port=80, # <-- Change this
    title="DETECT in SysML v2",
    favicon="images/Syside_only_logo_light_favicon.svg",
)
```

#### Using Docker

We provide a `Dockerfile` that builds an image with the webapp. The current
Dockerfile assumes that you have a Syside license that allows for Offline /
Air-gapped usage (for different types of Syside licenses, refer to
[documentation](https://docs.sensmetry.com/support/licensing.html#license-types)).
Before building the Docker image, you should obtain a license file according to
[Offline Licensing
documentation](https://docs.sensmetry.com/support/offline_installation.html#generate-license-file)
and put that license file in the root of this project as `syside-license.lic`.

If you are not able to use offline Syside licenses, you need to modify the
Dockerfile to instead expect a Syside license key, rather than a license file.
To do so, modify the `ENV SYSIDE_LICENSE_FILE=/app/syside-license.lic` line to
`ENV SYSIDE_LICENSE_KEY=<your-license-key>`.

Afterwards, you can build the Docker image using `docker build -t detect .` and
deploy it to your environment.

## Additional Resources

- [DETECT Webapp (by Sensmetry)](https://detect.syside.app)
- [DETECT Infosheet](https://de-bok.org/asset/54489e0b638ea1d0564d408abf7c211c7ac4a423)
- [DETECT User Guide](https://de-bok.org/asset/0be5bae06967d6deefb520564763a3575446d3ee)
- [DETECT v1 overview](https://de-bok.org/asset/0275584048738dec328f6d2959641a041e9743c7)
- [DETECT Information in Excel](https://de-bok.org/asset/f6646eaee1e16b160a930acb0f7f8fb5d94b0980)
- [DETECT SysML v1 Model File](https://de-bok.org/asset/f6646eaee1e16b160a930acb0f7f8fb5d94b0980)
