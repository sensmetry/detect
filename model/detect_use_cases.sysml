package DETECT_Use_Cases {
    doc Acknowledgement
    /* This file contains content from DETECT model file for SysML v1.6 by Daniel Hettema, OUSD (R&E).
     * Original content is dedicated to the Public Domain.
     * Modifications Copyright (c) 2025 Sensmetry.
     */

    doc Description
    /* This view provides the use cases that this model is planning to address. It also provides
     * active links to help the user navigate to the corresponding user instructions for each use
     * case.
     *
     * DETECT is currently addressing the 'Determine DE Ecosystem Sizing' Use Case.
     */

    private import DETECT_Input;
    private import DETECT_Sizing;
    private import DETECT_Input_Lifecycle_Phases;
    private import DETECT_Lifecycle_Phases;
    private import DETECT_Input_Job_Series;
    private import DETECT_Job_Series;

    use case <UC1> 'Ecosystem Sizing' defined by DETECT_Sizing::DETECT_uc1_Def {
        subject redefines DETECT_Input::de_ecosystem; // right-click on "de_ecosystem", select "Go to Definition" to navigate to model data entry inputs
        actor engineer defined by DETECT_Sizing::DETECT_user;
        actor manager defined by DETECT_Sizing::DETECT_user;

        objective {
            doc
            /* Determine DE Ecosystem Sizing and export weighted DE Ecosystem Tool Evaluation
             * Criteria and Requirements.
             */
        }
        doc
        /* The output requirements and criteria can be tailored if necessary to make the language
         * more clear to the organization.
         */

        attribute redefines uc_status = DETECT_Sizing::status_e::Green; // implemented
    }

    use case <UC2> 'Tool Types by Lifecycle Phase'
        defined by DETECT_Lifecycle_Phases::DETECT_uc2_Def {
        subject redefines DETECT_Input_Lifecycle_Phases::ecosystem_tool_profile;
        actor engineer defined by DETECT_Lifecycle_Phases::DETECT_user_lcp;
        actor manager defined by DETECT_Lifecycle_Phases::DETECT_user_lcp;

        objective {
            doc
            /* Determine DE Ecosystem possible tool types from known lifecycle phases
             * your effort must support, and export a list of appropriate tool
             * types per each necessary phase.
             */
        }

        attribute redefines uc_status = DETECT_Lifecycle_Phases::status_e_lcp::Green; // implemented
    }

    use case <UC3> 'Tools Types by Job Series'
        defined by DETECT_Job_Series::DETECT_uc3_Def {
        subject redefines DETECT_Input_Job_Series::job_series_tool_profile;
        actor manager defined by DETECT_Job_Series::DETECT_user_jobs;
        actor senior_leader defined by DETECT_Job_Series::DETECT_user_jobs;

        objective {
            doc
            /* Determine DE Ecosystem possible tool types from known job series
             * your effort must involve, and export lists of appropriate tool
             * types per each necessary job series.
             */
        }

        attribute redefines uc_status = DETECT_Job_Series::status_e_jobs::Green; // implemented
    }
}
