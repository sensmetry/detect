package DETECT_Lifecycle_Phases {
    doc
    /* Use Case 2 (UC2): Identify DE ecosystem Tool Types by Lifecycle Phase.
     * Defines the logic to map user-selected lifecycle phases to required tool categories.
     */

    private import ScalarValues::Boolean;
    private import Tool_Types::Tool_Type_e;

    part def DETECT_user_lcp {
        doc
        /* A person using DETECT method to evaluate DE tool using UC2. */
    }

    use case def DETECT_uc2_Def {
        attribute uc_status defined by status_e_lcp default status_e_lcp::Red;
    }

    /**
     * The Tool_Profile part defines the structure for capturing a user's
     * lifecycle phase needs and outputting the mapped tools.
     */
    part def Tool_Profile {

        /**
         * USER INPUTS: 6 Lifecycle Categories with Boolean selections for phases.
         *
         * All phases must be written in the following format: "phase_ACRONYM_title" to comply with app compiler.
         *
         */
        item inputs {
            item 'Materiel Solutions Analysis Phase (MSA)' {
                attribute phase_requirement_development : Boolean default false;
                attribute phase_analysis_of_alternatives : Boolean default false;
                attribute phase_contract_studies : Boolean default false;
            }

            item 'Technology Maturity and Risk Reduction Phase (TMRR)' {
                attribute phase_mature_requirements : Boolean default false;
                attribute phase_prototype_contracts : Boolean default false;
                attribute phase_prototyping : Boolean default false;
                attribute phase_preliminary_design_development : Boolean default false;
                attribute phase_CDD_validation : Boolean default false;
                attribute phase_RFP_release_decision_development : Boolean default false;
            }

            item 'Engineering and Manufacturing Development Phase (EMD)' {
                attribute phase_development_contracts : Boolean default false;
                attribute phase_complete_system_design : Boolean default false;
                attribute phase_system_development : Boolean default false;
                attribute phase_developmental_testing : Boolean default false;
            }

            item 'Production and Deployment Phase (P&D)' {
                attribute phase_production_contracts : Boolean default false;
                attribute phase_low_rate_initial_production : Boolean default false;
                attribute phase_operational_testing : Boolean default false;
                attribute phase_full_rate_production_decision : Boolean default false;
                attribute phase_full_rate_production : Boolean default false;
                attribute phase_full_rate_production_deployment : Boolean default false;
            }

            item 'Operation and Support Phase (O&S)' {
                attribute phase_sustainment_contracts : Boolean default false;
                attribute phase_system_sustainment : Boolean default false;
            }

            item 'All Phases' {
                attribute phase_strategy_development : Boolean default false;
                attribute phase_technical_reviews : Boolean default false;
                attribute phase_cost_estimation_and_affordability : Boolean default false;
                attribute phase_program_management : Boolean default false;
            }
        }

        /* --- MODEL OUTPUTS --- */

        /* --- 1 MSA - Materiel Solutions Analysis Phase --- */

        derived attribute develop_requirements_tools : Tool_Type_e[*] =
            if inputs.'Materiel Solutions Analysis Phase (MSA)'.phase_requirement_development ?
            (
                Tool_Type_e::'2.1 Low Fidelity Simulations',
                Tool_Type_e::'2.6 Mission Models',
                Tool_Type_e::'3.1 Requirements Management Tools',
                Tool_Type_e::'3.2 Architecture Tools',
                Tool_Type_e::'3.3 Shared Architecture Tools',
                Tool_Type_e::'5.3 Data Persistence',
                Tool_Type_e::'5.4 Digital Thread',
                Tool_Type_e::'8.1 Word Processing and Document Collaboration',
                Tool_Type_e::'8.2 Presentation Software',
                Tool_Type_e::'8.3 Spreadsheets',
                Tool_Type_e::'8.4 Email and Communication Platforms',
                Tool_Type_e::'8.5 Task Management and Project Planning',
                Tool_Type_e::'8.6 Shared Drives and Cloud Storage',
                Tool_Type_e::'9 Host Platform',
                Tool_Type_e::'10 Cybersecurity'
            )
            else null;

        derived attribute analysis_of_alternatives_tools : Tool_Type_e[*] =
            if inputs.'Materiel Solutions Analysis Phase (MSA)'.phase_analysis_of_alternatives ?
            (
                Tool_Type_e::'2.1 Low Fidelity Simulations',
                Tool_Type_e::'2.6 Mission Models',
                Tool_Type_e::'3.1 Requirements Management Tools',
                Tool_Type_e::'3.2 Architecture Tools',                
                Tool_Type_e::'3.3 Shared Architecture Tools',      
                Tool_Type_e::'5.1 Data Analytics and Visualization',
                Tool_Type_e::'5.2 Data Integration',
                Tool_Type_e::'5.3 Data Persistence',
                Tool_Type_e::'5.4 Digital Thread',
                Tool_Type_e::'8.1 Word Processing and Document Collaboration',
                Tool_Type_e::'8.2 Presentation Software',
                Tool_Type_e::'8.3 Spreadsheets',
                Tool_Type_e::'8.4 Email and Communication Platforms',
                Tool_Type_e::'8.5 Task Management and Project Planning',
                Tool_Type_e::'8.6 Shared Drives and Cloud Storage',
                Tool_Type_e::'9 Host Platform',
                Tool_Type_e::'10 Cybersecurity'
            )
            else null;

        derived attribute study_contracts_tools : Tool_Type_e[*] =
            if inputs.'Materiel Solutions Analysis Phase (MSA)'.phase_contract_studies ?
            (
                Tool_Type_e::'5.3 Data Persistence',
                Tool_Type_e::'5.4 Digital Thread',
                Tool_Type_e::'8.1 Word Processing and Document Collaboration',
                Tool_Type_e::'8.2 Presentation Software',
                Tool_Type_e::'8.3 Spreadsheets',
                Tool_Type_e::'8.4 Email and Communication Platforms',
                Tool_Type_e::'8.5 Task Management and Project Planning',
                Tool_Type_e::'8.6 Shared Drives and Cloud Storage',
                Tool_Type_e::'9 Host Platform',
                Tool_Type_e::'10 Cybersecurity'
            )
            else null;

        /* --- 2 TMRR - Technology Maturity and Risk Reduction Phase --- */

        derived attribute mature_rqts_tools : Tool_Type_e[*] =
            if inputs.'Technology Maturity and Risk Reduction Phase (TMRR)'.phase_mature_requirements ?
            (
                Tool_Type_e::'2.1 Low Fidelity Simulations',
                Tool_Type_e::'2.6 Mission Models',
                Tool_Type_e::'3.1 Requirements Management Tools',
                Tool_Type_e::'3.2 Architecture Tools', 
                Tool_Type_e::'3.3 Shared Architecture Tools',
                Tool_Type_e::'5.1 Data Analytics and Visualization',
                Tool_Type_e::'5.2 Data Integration',
                Tool_Type_e::'5.3 Data Persistence',
                Tool_Type_e::'5.4 Digital Thread',
                Tool_Type_e::'8.1 Word Processing and Document Collaboration',
                Tool_Type_e::'8.2 Presentation Software',
                Tool_Type_e::'8.3 Spreadsheets',
                Tool_Type_e::'8.4 Email and Communication Platforms',
                Tool_Type_e::'8.5 Task Management and Project Planning',
                Tool_Type_e::'8.6 Shared Drives and Cloud Storage',
                Tool_Type_e::'9 Host Platform',
                Tool_Type_e::'10 Cybersecurity'
            )
            else null;

        derived attribute proto_contr_tools : Tool_Type_e[*] =
            if inputs.'Technology Maturity and Risk Reduction Phase (TMRR)'.phase_prototype_contracts ?
            (
                Tool_Type_e::'5.3 Data Persistence',
                Tool_Type_e::'5.4 Digital Thread',
                Tool_Type_e::'8.1 Word Processing and Document Collaboration',
                Tool_Type_e::'8.2 Presentation Software',
                Tool_Type_e::'8.3 Spreadsheets',
                Tool_Type_e::'8.4 Email and Communication Platforms',
                Tool_Type_e::'8.5 Task Management and Project Planning',
                Tool_Type_e::'8.6 Shared Drives and Cloud Storage',
                Tool_Type_e::'9 Host Platform',
                Tool_Type_e::'10 Cybersecurity'
            )
            else null;

        derived attribute prototyping_tools : Tool_Type_e[*] =
            if inputs.'Technology Maturity and Risk Reduction Phase (TMRR)'.phase_prototyping ?
            (
                Tool_Type_e::'1.1 Computer Aided Design (CAD)',
                Tool_Type_e::'1.2 Electrical computer-aided design (ECAD)',
                Tool_Type_e::'1.3 Product Lifecycle Management (PLM)',
                Tool_Type_e::'2.1 Low Fidelity Simulations',
                Tool_Type_e::'2.2 Computational Fluid Dynamics (CFD)',
                Tool_Type_e::'2.3 Finite Element Analysis (FEA)',
                Tool_Type_e::'2.4 Electromagnetic (EM)',
                Tool_Type_e::'2.5 Dynamic Simulations',
                Tool_Type_e::'2.6 Mission Models',
                Tool_Type_e::'2.7 Simulation Managers',
                Tool_Type_e::'3.1 Requirements Management Tools',
                Tool_Type_e::'3.2 Architecture Tools',
                Tool_Type_e::'3.3 Shared Architecture Tools',
                Tool_Type_e::'5.1 Data Analytics and Visualization',
                Tool_Type_e::'5.2 Data Integration',
                Tool_Type_e::'5.3 Data Persistence',
                Tool_Type_e::'5.4 Digital Thread',
                Tool_Type_e::'6.1 Physical Product Definition and Representation',
                Tool_Type_e::'6.2 Process Modeling & Simulation',
                Tool_Type_e::'6.3 Manufacturing Execution Software (MES)',
                Tool_Type_e::'8.1 Word Processing and Document Collaboration',
                Tool_Type_e::'8.2 Presentation Software',
                Tool_Type_e::'8.3 Spreadsheets',
                Tool_Type_e::'8.4 Email and Communication Platforms',
                Tool_Type_e::'8.5 Task Management and Project Planning',
                Tool_Type_e::'8.6 Shared Drives and Cloud Storage',
                Tool_Type_e::'9 Host Platform',
                Tool_Type_e::'10 Cybersecurity'
            )
            else null;

        derived attribute dev_prel_design_tools : Tool_Type_e[*] =
            if inputs.'Technology Maturity and Risk Reduction Phase (TMRR)'.phase_preliminary_design_development ?
            (
                Tool_Type_e::'1.1 Computer Aided Design (CAD)',
                Tool_Type_e::'1.2 Electrical computer-aided design (ECAD)',
                Tool_Type_e::'1.3 Product Lifecycle Management (PLM)',
                Tool_Type_e::'2.1 Low Fidelity Simulations',
                Tool_Type_e::'2.2 Computational Fluid Dynamics (CFD)',
                Tool_Type_e::'2.3 Finite Element Analysis (FEA)',
                Tool_Type_e::'2.4 Electromagnetic (EM)',
                Tool_Type_e::'2.5 Dynamic Simulations',
                Tool_Type_e::'2.6 Mission Models',
                Tool_Type_e::'2.7 Simulation Managers',
                Tool_Type_e::'3.1 Requirements Management Tools',
                Tool_Type_e::'3.2 Architecture Tools',
                Tool_Type_e::'3.3 Shared Architecture Tools',
                Tool_Type_e::'5.1 Data Analytics and Visualization',
                Tool_Type_e::'5.2 Data Integration',
                Tool_Type_e::'5.3 Data Persistence',
                Tool_Type_e::'5.4 Digital Thread',
                Tool_Type_e::'6.1 Physical Product Definition and Representation',
                Tool_Type_e::'6.2 Process Modeling & Simulation',
                Tool_Type_e::'6.3 Manufacturing Execution Software (MES)',
                Tool_Type_e::'8.1 Word Processing and Document Collaboration',
                Tool_Type_e::'8.2 Presentation Software',
                Tool_Type_e::'8.3 Spreadsheets',
                Tool_Type_e::'8.4 Email and Communication Platforms',
                Tool_Type_e::'8.5 Task Management and Project Planning',
                Tool_Type_e::'8.6 Shared Drives and Cloud Storage',
                Tool_Type_e::'9 Host Platform',
                Tool_Type_e::'10 Cybersecurity'
            )
            else null;

        derived attribute cdd_validation_tools : Tool_Type_e[*] =
            if inputs.'Technology Maturity and Risk Reduction Phase (TMRR)'.phase_CDD_validation ?
            (
                Tool_Type_e::'5.1 Data Analytics and Visualization',
                Tool_Type_e::'5.2 Data Integration',
                Tool_Type_e::'5.3 Data Persistence',
                Tool_Type_e::'5.4 Digital Thread',
                Tool_Type_e::'8.1 Word Processing and Document Collaboration',
                Tool_Type_e::'8.2 Presentation Software',
                Tool_Type_e::'8.3 Spreadsheets',
                Tool_Type_e::'8.4 Email and Communication Platforms',
                Tool_Type_e::'8.5 Task Management and Project Planning',
                Tool_Type_e::'8.6 Shared Drives and Cloud Storage',
                Tool_Type_e::'9 Host Platform',
                Tool_Type_e::'10 Cybersecurity'
            )
            else null;

        derived attribute dev_rfp_dec_tools : Tool_Type_e[*] =
            if inputs.'Technology Maturity and Risk Reduction Phase (TMRR)'.phase_RFP_release_decision_development ?
            (
                Tool_Type_e::'5.1 Data Analytics and Visualization',
                Tool_Type_e::'5.2 Data Integration',
                Tool_Type_e::'5.3 Data Persistence',
                Tool_Type_e::'5.4 Digital Thread',
                Tool_Type_e::'8.1 Word Processing and Document Collaboration',
                Tool_Type_e::'8.2 Presentation Software',
                Tool_Type_e::'8.3 Spreadsheets',
                Tool_Type_e::'8.4 Email and Communication Platforms',
                Tool_Type_e::'8.5 Task Management and Project Planning',
                Tool_Type_e::'8.6 Shared Drives and Cloud Storage',
                Tool_Type_e::'9 Host Platform',
                Tool_Type_e::'10 Cybersecurity'
            )
            else null;

        /* --- 3 EMD - Engineering and Manufacturing Development Phase --- */

        derived attribute dev_contr_tools : Tool_Type_e[*] =
            if inputs.'Engineering and Manufacturing Development Phase (EMD)'.phase_development_contracts ?
            (
                Tool_Type_e::'5.3 Data Persistence',
                Tool_Type_e::'5.4 Digital Thread',
                Tool_Type_e::'8.1 Word Processing and Document Collaboration',
                Tool_Type_e::'8.2 Presentation Software',
                Tool_Type_e::'8.3 Spreadsheets',
                Tool_Type_e::'8.4 Email and Communication Platforms',
                Tool_Type_e::'8.5 Task Management and Project Planning',
                Tool_Type_e::'8.6 Shared Drives and Cloud Storage',
                Tool_Type_e::'9 Host Platform',
                Tool_Type_e::'10 Cybersecurity'
            )
            else null;

        derived attribute sys_design_tools : Tool_Type_e[*] =
            if inputs.'Engineering and Manufacturing Development Phase (EMD)'.phase_complete_system_design ?
            (
                Tool_Type_e::'1.1 Computer Aided Design (CAD)',
                Tool_Type_e::'1.2 Electrical computer-aided design (ECAD)',
                Tool_Type_e::'1.3 Product Lifecycle Management (PLM)',
                Tool_Type_e::'2.1 Low Fidelity Simulations',
                Tool_Type_e::'2.2 Computational Fluid Dynamics (CFD)',
                Tool_Type_e::'2.3 Finite Element Analysis (FEA)',
                Tool_Type_e::'2.4 Electromagnetic (EM)',
                Tool_Type_e::'2.5 Dynamic Simulations',
                Tool_Type_e::'2.6 Mission Models',
                Tool_Type_e::'2.7 Simulation Managers',
                Tool_Type_e::'3.1 Requirements Management Tools',
                Tool_Type_e::'3.2 Architecture Tools',
                Tool_Type_e::'3.3 Shared Architecture Tools',
                Tool_Type_e::'4.1 Integrated Development Environments (IDEs)',
                Tool_Type_e::'4.2 Version Control Systems',
                Tool_Type_e::'4.3 Continuous Integration/Continuous Deployment (CI/CD)',
                Tool_Type_e::'4.4 Testing Frameworks',
                Tool_Type_e::'5.1 Data Analytics and Visualization',
                Tool_Type_e::'5.2 Data Integration',
                Tool_Type_e::'5.3 Data Persistence',
                Tool_Type_e::'5.4 Digital Thread',
                Tool_Type_e::'6.1 Physical Product Definition and Representation',
                Tool_Type_e::'6.2 Process Modeling & Simulation',
                Tool_Type_e::'6.3 Manufacturing Execution Software (MES)',
                Tool_Type_e::'7.1 Supply Chain Planning & Optimization',
                Tool_Type_e::'8.1 Word Processing and Document Collaboration',
                Tool_Type_e::'8.2 Presentation Software',
                Tool_Type_e::'8.3 Spreadsheets',
                Tool_Type_e::'8.4 Email and Communication Platforms',
                Tool_Type_e::'8.5 Task Management and Project Planning',
                Tool_Type_e::'8.6 Shared Drives and Cloud Storage',
                Tool_Type_e::'9 Host Platform',
                Tool_Type_e::'10 Cybersecurity'
            )
            else null;

        derived attribute develop_sys_tools : Tool_Type_e[*] =
            if inputs.'Engineering and Manufacturing Development Phase (EMD)'.phase_system_development ?
            (
                Tool_Type_e::'1.1 Computer Aided Design (CAD)',
                Tool_Type_e::'1.2 Electrical computer-aided design (ECAD)',
                Tool_Type_e::'1.3 Product Lifecycle Management (PLM)',
                Tool_Type_e::'2.1 Low Fidelity Simulations',
                Tool_Type_e::'2.2 Computational Fluid Dynamics (CFD)',
                Tool_Type_e::'2.3 Finite Element Analysis (FEA)',
                Tool_Type_e::'2.4 Electromagnetic (EM)',
                Tool_Type_e::'2.5 Dynamic Simulations',
                Tool_Type_e::'2.6 Mission Models',
                Tool_Type_e::'2.7 Simulation Managers',
                Tool_Type_e::'3.1 Requirements Management Tools',
                Tool_Type_e::'3.2 Architecture Tools',
                Tool_Type_e::'3.3 Shared Architecture Tools',
                Tool_Type_e::'4.1 Integrated Development Environments (IDEs)',
                Tool_Type_e::'4.2 Version Control Systems',
                Tool_Type_e::'4.3 Continuous Integration/Continuous Deployment (CI/CD)',
                Tool_Type_e::'4.4 Testing Frameworks',
                Tool_Type_e::'5.1 Data Analytics and Visualization',
                Tool_Type_e::'5.2 Data Integration',
                Tool_Type_e::'5.3 Data Persistence',
                Tool_Type_e::'5.4 Digital Thread',
                Tool_Type_e::'6.1 Physical Product Definition and Representation',
                Tool_Type_e::'6.2 Process Modeling & Simulation',
                Tool_Type_e::'6.3 Manufacturing Execution Software (MES)',
                Tool_Type_e::'7.1 Supply Chain Planning & Optimization',
                Tool_Type_e::'8.1 Word Processing and Document Collaboration',
                Tool_Type_e::'8.2 Presentation Software',
                Tool_Type_e::'8.3 Spreadsheets',
                Tool_Type_e::'8.4 Email and Communication Platforms',
                Tool_Type_e::'8.5 Task Management and Project Planning',
                Tool_Type_e::'8.6 Shared Drives and Cloud Storage',
                Tool_Type_e::'9 Host Platform',
                Tool_Type_e::'10 Cybersecurity'
            )
            else null;

        derived attribute dev_testing_tools : Tool_Type_e[*] =
            if inputs.'Engineering and Manufacturing Development Phase (EMD)'.phase_developmental_testing ?
            (
                Tool_Type_e::'1.3 Product Lifecycle Management (PLM)',
                Tool_Type_e::'2.1 Low Fidelity Simulations',
                Tool_Type_e::'2.2 Computational Fluid Dynamics (CFD)',
                Tool_Type_e::'2.3 Finite Element Analysis (FEA)',
                Tool_Type_e::'2.4 Electromagnetic (EM)',
                Tool_Type_e::'2.5 Dynamic Simulations',
                Tool_Type_e::'2.6 Mission Models',
                Tool_Type_e::'2.7 Simulation Managers',
                Tool_Type_e::'3.1 Requirements Management Tools',
                Tool_Type_e::'3.2 Architecture Tools',
                Tool_Type_e::'3.3 Shared Architecture Tools',
                Tool_Type_e::'4.1 Integrated Development Environments (IDEs)',
                Tool_Type_e::'4.2 Version Control Systems',
                Tool_Type_e::'4.3 Continuous Integration/Continuous Deployment (CI/CD)',
                Tool_Type_e::'4.4 Testing Frameworks',
                Tool_Type_e::'5.1 Data Analytics and Visualization',
                Tool_Type_e::'5.2 Data Integration',
                Tool_Type_e::'5.3 Data Persistence',
                Tool_Type_e::'5.4 Digital Thread',
                Tool_Type_e::'8.1 Word Processing and Document Collaboration',
                Tool_Type_e::'8.2 Presentation Software',
                Tool_Type_e::'8.3 Spreadsheets',
                Tool_Type_e::'8.4 Email and Communication Platforms',
                Tool_Type_e::'8.5 Task Management and Project Planning',
                Tool_Type_e::'8.6 Shared Drives and Cloud Storage',
                Tool_Type_e::'9 Host Platform',
                Tool_Type_e::'10 Cybersecurity'
            )
            else null;
        
        /* --- 4 P&D - Production and Deployment Phase --- */

        derived attribute prod_contr_tools : Tool_Type_e[*] =
            if inputs.'Production and Deployment Phase (P&D)'.phase_production_contracts ?
            (
                Tool_Type_e::'1.3 Product Lifecycle Management (PLM)',
                Tool_Type_e::'5.3 Data Persistence',
                Tool_Type_e::'5.4 Digital Thread',
                Tool_Type_e::'8.1 Word Processing and Document Collaboration',
                Tool_Type_e::'8.2 Presentation Software',
                Tool_Type_e::'8.3 Spreadsheets',
                Tool_Type_e::'8.4 Email and Communication Platforms',
                Tool_Type_e::'8.5 Task Management and Project Planning',
                Tool_Type_e::'8.6 Shared Drives and Cloud Storage',
                Tool_Type_e::'9 Host Platform',
                Tool_Type_e::'10 Cybersecurity'
            )
            else null;

        derived attribute lr_init_prod_tools : Tool_Type_e[*] =
            if inputs.'Production and Deployment Phase (P&D)'.phase_low_rate_initial_production ?
            (
                Tool_Type_e::'1.3 Product Lifecycle Management (PLM)',
                Tool_Type_e::'2.1 Low Fidelity Simulations',
                Tool_Type_e::'2.7 Simulation Managers',
                Tool_Type_e::'5.1 Data Analytics and Visualization',
                Tool_Type_e::'5.2 Data Integration',
                Tool_Type_e::'5.3 Data Persistence',
                Tool_Type_e::'5.4 Digital Thread',
                Tool_Type_e::'6.1 Physical Product Definition and Representation',
                Tool_Type_e::'6.2 Process Modeling & Simulation',
                Tool_Type_e::'6.3 Manufacturing Execution Software (MES)',
                Tool_Type_e::'7.1 Supply Chain Planning & Optimization',
                Tool_Type_e::'7.2 Transportation and Distribution Management',
                Tool_Type_e::'7.3 Inventory Management',
                Tool_Type_e::'8.1 Word Processing and Document Collaboration',
                Tool_Type_e::'8.2 Presentation Software',
                Tool_Type_e::'8.3 Spreadsheets',
                Tool_Type_e::'8.4 Email and Communication Platforms',
                Tool_Type_e::'8.5 Task Management and Project Planning',
                Tool_Type_e::'8.6 Shared Drives and Cloud Storage',
                Tool_Type_e::'9 Host Platform',
                Tool_Type_e::'10 Cybersecurity'
            )
            else null;

        derived attribute operational_test_tools : Tool_Type_e[*] =
            if inputs.'Production and Deployment Phase (P&D)'.phase_operational_testing ?
            (
                Tool_Type_e::'1.3 Product Lifecycle Management (PLM)',
                Tool_Type_e::'2.1 Low Fidelity Simulations',
                Tool_Type_e::'2.2 Computational Fluid Dynamics (CFD)',
                Tool_Type_e::'2.6 Mission Models',
                Tool_Type_e::'2.7 Simulation Managers',
                Tool_Type_e::'3.1 Requirements Management Tools',
                Tool_Type_e::'3.2 Architecture Tools',
                Tool_Type_e::'3.3 Shared Architecture Tools',
                Tool_Type_e::'4.2 Version Control Systems',
                Tool_Type_e::'5.1 Data Analytics and Visualization',
                Tool_Type_e::'5.2 Data Integration',
                Tool_Type_e::'5.3 Data Persistence',
                Tool_Type_e::'5.4 Digital Thread',
                Tool_Type_e::'8.1 Word Processing and Document Collaboration',
                Tool_Type_e::'8.2 Presentation Software',
                Tool_Type_e::'8.3 Spreadsheets',
                Tool_Type_e::'8.4 Email and Communication Platforms',
                Tool_Type_e::'8.5 Task Management and Project Planning',
                Tool_Type_e::'8.6 Shared Drives and Cloud Storage',
                Tool_Type_e::'9 Host Platform',
                Tool_Type_e::'10 Cybersecurity'
            )
            else null;

        derived attribute frp_dec_tools : Tool_Type_e[*] =
            if inputs.'Production and Deployment Phase (P&D)'.phase_full_rate_production_decision ?
            (
                Tool_Type_e::'5.1 Data Analytics and Visualization',
                Tool_Type_e::'5.2 Data Integration',
                Tool_Type_e::'5.3 Data Persistence',
                Tool_Type_e::'5.4 Digital Thread',
                Tool_Type_e::'8.1 Word Processing and Document Collaboration',
                Tool_Type_e::'8.2 Presentation Software',
                Tool_Type_e::'8.3 Spreadsheets',
                Tool_Type_e::'8.4 Email and Communication Platforms',
                Tool_Type_e::'8.5 Task Management and Project Planning',
                Tool_Type_e::'8.6 Shared Drives and Cloud Storage',
                Tool_Type_e::'9 Host Platform',
                Tool_Type_e::'10 Cybersecurity'
            )
            else null;

        derived attribute fr_tools : Tool_Type_e[*] =
            if inputs.'Production and Deployment Phase (P&D)'.phase_full_rate_production ?
            (
                Tool_Type_e::'1.3 Product Lifecycle Management (PLM)',
                Tool_Type_e::'5.1 Data Analytics and Visualization',
                Tool_Type_e::'5.2 Data Integration',
                Tool_Type_e::'5.3 Data Persistence',
                Tool_Type_e::'5.4 Digital Thread',
                Tool_Type_e::'6.1 Physical Product Definition and Representation',
                Tool_Type_e::'6.2 Process Modeling & Simulation',
                Tool_Type_e::'6.3 Manufacturing Execution Software (MES)',
                Tool_Type_e::'7.1 Supply Chain Planning & Optimization',
                Tool_Type_e::'7.2 Transportation and Distribution Management',
                Tool_Type_e::'7.3 Inventory Management',
                Tool_Type_e::'8.1 Word Processing and Document Collaboration',
                Tool_Type_e::'8.2 Presentation Software',
                Tool_Type_e::'8.3 Spreadsheets',
                Tool_Type_e::'8.4 Email and Communication Platforms',
                Tool_Type_e::'8.5 Task Management and Project Planning',
                Tool_Type_e::'8.6 Shared Drives and Cloud Storage',
                Tool_Type_e::'9 Host Platform',
                Tool_Type_e::'10 Cybersecurity'
            )
            else null;

        derived attribute prod_deployment_tools : Tool_Type_e[*] =
            if inputs.'Production and Deployment Phase (P&D)'.phase_full_rate_production_deployment ?
            (
                Tool_Type_e::'1.3 Product Lifecycle Management (PLM)',
                Tool_Type_e::'5.1 Data Analytics and Visualization',
                Tool_Type_e::'5.2 Data Integration',
                Tool_Type_e::'5.3 Data Persistence',
                Tool_Type_e::'5.4 Digital Thread',
                Tool_Type_e::'6.1 Physical Product Definition and Representation',
                Tool_Type_e::'6.2 Process Modeling & Simulation',
                Tool_Type_e::'6.3 Manufacturing Execution Software (MES)',
                Tool_Type_e::'7.1 Supply Chain Planning & Optimization',
                Tool_Type_e::'7.2 Transportation and Distribution Management',
                Tool_Type_e::'7.3 Inventory Management',
                Tool_Type_e::'7.4 Sustainment and Maintenance',
                Tool_Type_e::'8.1 Word Processing and Document Collaboration',
                Tool_Type_e::'8.2 Presentation Software',
                Tool_Type_e::'8.3 Spreadsheets',
                Tool_Type_e::'8.4 Email and Communication Platforms',
                Tool_Type_e::'8.5 Task Management and Project Planning',
                Tool_Type_e::'8.6 Shared Drives and Cloud Storage',
                Tool_Type_e::'9 Host Platform',
                Tool_Type_e::'10 Cybersecurity'
            )
            else null;  

        /* --- 5 O&S - Operations and Support Phase --- */

        derived attribute sustainment_contr_tools : Tool_Type_e[*] =
            if inputs.'Operation and Support Phase (O&S)'.phase_sustainment_contracts ?
            (
                Tool_Type_e::'1.3 Product Lifecycle Management (PLM)',
                Tool_Type_e::'5.3 Data Persistence',
                Tool_Type_e::'5.4 Digital Thread',
                Tool_Type_e::'8.1 Word Processing and Document Collaboration',
                Tool_Type_e::'8.2 Presentation Software',
                Tool_Type_e::'8.3 Spreadsheets',
                Tool_Type_e::'8.4 Email and Communication Platforms',
                Tool_Type_e::'8.5 Task Management and Project Planning',
                Tool_Type_e::'8.6 Shared Drives and Cloud Storage',
                Tool_Type_e::'9 Host Platform',
                Tool_Type_e::'10 Cybersecurity'
            )
            else null;

        derived attribute sustain_sys_tools : Tool_Type_e[*] =
            if inputs.'Operation and Support Phase (O&S)'.phase_system_sustainment ?
            (
                Tool_Type_e::'1.3 Product Lifecycle Management (PLM)',
                Tool_Type_e::'5.1 Data Analytics and Visualization',
                Tool_Type_e::'5.2 Data Integration',
                Tool_Type_e::'5.3 Data Persistence',
                Tool_Type_e::'5.4 Digital Thread',
                Tool_Type_e::'7.1 Supply Chain Planning & Optimization',
                Tool_Type_e::'7.2 Transportation and Distribution Management',
                Tool_Type_e::'7.3 Inventory Management',
                Tool_Type_e::'7.4 Sustainment and Maintenance',
                Tool_Type_e::'8.1 Word Processing and Document Collaboration',
                Tool_Type_e::'8.2 Presentation Software',
                Tool_Type_e::'8.3 Spreadsheets',
                Tool_Type_e::'8.4 Email and Communication Platforms',
                Tool_Type_e::'8.5 Task Management and Project Planning',
                Tool_Type_e::'8.6 Shared Drives and Cloud Storage',
                Tool_Type_e::'9 Host Platform',
                Tool_Type_e::'10 Cybersecurity'
            )
            else null;

        /* --- 6 All Phases --- */

        derived attribute strategies_tools : Tool_Type_e[*] =
            if inputs.'All Phases'.phase_strategy_development ?
            (
                Tool_Type_e::'3.1 Requirements Management Tools',
                Tool_Type_e::'3.2 Architecture Tools',
                Tool_Type_e::'3.3 Shared Architecture Tools',
                Tool_Type_e::'8.1 Word Processing and Document Collaboration',
                Tool_Type_e::'8.2 Presentation Software',
                Tool_Type_e::'8.3 Spreadsheets',
                Tool_Type_e::'8.4 Email and Communication Platforms',
                Tool_Type_e::'8.5 Task Management and Project Planning',
                Tool_Type_e::'8.6 Shared Drives and Cloud Storage'
            )
            else null;

        derived attribute tr_tools : Tool_Type_e[*] =
            if inputs.'All Phases'.phase_technical_reviews ?
            (
                Tool_Type_e::'3.1 Requirements Management Tools',
                Tool_Type_e::'3.2 Architecture Tools',
                Tool_Type_e::'3.3 Shared Architecture Tools',
                Tool_Type_e::'8.1 Word Processing and Document Collaboration',
                Tool_Type_e::'8.2 Presentation Software',
                Tool_Type_e::'8.3 Spreadsheets',
                Tool_Type_e::'8.4 Email and Communication Platforms',
                Tool_Type_e::'8.5 Task Management and Project Planning',
                Tool_Type_e::'8.6 Shared Drives and Cloud Storage'
            )
            else null;

        derived attribute cost_estimation_and_affordability_tools : Tool_Type_e[*] =
            if inputs.'All Phases'.phase_cost_estimation_and_affordability ?
            (
                Tool_Type_e::'3.1 Requirements Management Tools',
                Tool_Type_e::'3.2 Architecture Tools',
                Tool_Type_e::'3.3 Shared Architecture Tools',
                Tool_Type_e::'8.1 Word Processing and Document Collaboration',
                Tool_Type_e::'8.2 Presentation Software',
                Tool_Type_e::'8.3 Spreadsheets',
                Tool_Type_e::'8.4 Email and Communication Platforms',
                Tool_Type_e::'8.5 Task Management and Project Planning',
                Tool_Type_e::'8.6 Shared Drives and Cloud Storage'
            )
            else null;

        derived attribute program_management_tools : Tool_Type_e[*] =
            if inputs.'All Phases'.phase_program_management ?
            (
                Tool_Type_e::'8.1 Word Processing and Document Collaboration',
                Tool_Type_e::'8.2 Presentation Software',
                Tool_Type_e::'8.3 Spreadsheets',
                Tool_Type_e::'8.4 Email and Communication Platforms',
                Tool_Type_e::'8.5 Task Management and Project Planning',
                Tool_Type_e::'8.6 Shared Drives and Cloud Storage'
            )
            else null;
    }
    
    enum def status_e_lcp {
        Green {
            doc
            /* The feature is implemented */
        }
        Red {
            doc
            /* The feature is NOT implemented */
        }
    }

}
