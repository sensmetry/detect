package DETECT_Job_Series {
    doc
    /* Use Case 3 (UC3): Identify DE ecosystem Tool Types by Job Series.
     * Defines the logic to map user-selected job series to required tool categories.
     */

    private import ScalarValues::Boolean;
    private import Tool_Types::Tool_Type_e;

    part def DETECT_user_jobs {
        doc
        /* A person using DETECT method to evaluate DE tool using UC2. */
    }

    use case def DETECT_uc3_Def {
        attribute uc_status defined by status_e_jobs default status_e_jobs::Red;
    }    

    /**
     * The Job_Series_Profile part defines the structure for capturing an organization's
     * roles and outputting the tool types they require.
     */
    part def Job_Series_Profile {
        
        /**
         * USER INPUTS: 3 Job Series Categories with Boolean selections for roles.
         *
         * All phases must be written in the following format: "phase_ACRONYM_title" to comply with app compiler.
         *
         */
        item inputs {
            item 'Engineering and Architecture' {
                attribute role_general_engineering : Boolean default false;
                attribute role_safety_engineering : Boolean default false;
                attribute role_materials_engineering : Boolean default false;
                attribute role_mechanical_engineering : Boolean default false;
                attribute role_nuclear_engineering : Boolean default false;
                attribute role_electrical_engineering : Boolean default false;
                attribute role_computer_engineering : Boolean default false;
                attribute role_aerospace_engineering : Boolean default false;
                attribute role_chemical_engineering : Boolean default false;
                attribute role_industrial_engineering : Boolean default false;
            }

            item 'Physical Sciences' {
                attribute role_physics : Boolean default false;
                attribute role_chemistry : Boolean default false;
            }

            item 'Mathematical Sciences' {
                attribute role_general_mathematics_and_statistics : Boolean default false;
                attribute role_operations_research : Boolean default false;
                attribute role_computer_science : Boolean default false;
            }
        }

        /* --- MODEL OUTPUTS --- */

        /* --- 1 - Engineering and Architecture Group --- */

        derived attribute general_engineering_tools : Tool_Type_e[*] =
            if inputs.'Engineering and Architecture'.role_general_engineering ?
            (
                Tool_Type_e::'1.3 Product Lifecycle Management (PLM)',
                Tool_Type_e::'2.1 Low Fidelity Simulations',
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

        derived attribute safety_engineering_tools : Tool_Type_e[*] =
            if inputs.'Engineering and Architecture'.role_safety_engineering ?
            (
                Tool_Type_e::'2.3 Finite Element Analysis (FEA)',
                Tool_Type_e::'2.5 Dynamic Simulations',
                Tool_Type_e::'3.1 Requirements Management Tools',
                Tool_Type_e::'3.2 Architecture Tools',
                Tool_Type_e::'5.4 Digital Thread',
                Tool_Type_e::'6.3 Manufacturing Execution Software (MES)',
                Tool_Type_e::'7.4 Sustainment and Maintenance',
                Tool_Type_e::'8.1 Word Processing and Document Collaboration',
                Tool_Type_e::'8.2 Presentation Software',
                Tool_Type_e::'8.3 Spreadsheets',
                Tool_Type_e::'8.4 Email and Communication Platforms',
                Tool_Type_e::'8.5 Task Management and Project Planning',
                Tool_Type_e::'8.6 Shared Drives and Cloud Storage'
            )
            else null;
            
        derived attribute materials_engineering_tools : Tool_Type_e[*] =
            if inputs.'Engineering and Architecture'.role_materials_engineering ?
            (
                Tool_Type_e::'1.1 Computer Aided Design (CAD)',
                Tool_Type_e::'2.1 Low Fidelity Simulations',
                Tool_Type_e::'2.3 Finite Element Analysis (FEA)',
                Tool_Type_e::'2.5 Dynamic Simulations',
                Tool_Type_e::'5.4 Digital Thread',
                Tool_Type_e::'6.1 Physical Product Definition and Representation',
                Tool_Type_e::'8.1 Word Processing and Document Collaboration',
                Tool_Type_e::'8.2 Presentation Software',
                Tool_Type_e::'8.3 Spreadsheets',
                Tool_Type_e::'8.4 Email and Communication Platforms',
                Tool_Type_e::'8.5 Task Management and Project Planning',
                Tool_Type_e::'8.6 Shared Drives and Cloud Storage'
            )
            else null;

        derived attribute mechanical_engineering_tools : Tool_Type_e[*] =
            if inputs.'Engineering and Architecture'.role_mechanical_engineering ?
            (
                Tool_Type_e::'1.1 Computer Aided Design (CAD)',
                Tool_Type_e::'1.3 Product Lifecycle Management (PLM)',
                Tool_Type_e::'2.1 Low Fidelity Simulations',
                Tool_Type_e::'2.2 Computational Fluid Dynamics (CFD)',
                Tool_Type_e::'2.3 Finite Element Analysis (FEA)',
                Tool_Type_e::'2.5 Dynamic Simulations',
                Tool_Type_e::'3.1 Requirements Management Tools',
                Tool_Type_e::'5.1 Data Analytics and Visualization',
                Tool_Type_e::'5.2 Data Integration',
                Tool_Type_e::'5.4 Digital Thread',
                Tool_Type_e::'6.1 Physical Product Definition and Representation',
                Tool_Type_e::'6.3 Manufacturing Execution Software (MES)',
                Tool_Type_e::'8.1 Word Processing and Document Collaboration',
                Tool_Type_e::'8.2 Presentation Software',
                Tool_Type_e::'8.3 Spreadsheets',
                Tool_Type_e::'8.4 Email and Communication Platforms',
                Tool_Type_e::'8.5 Task Management and Project Planning',
                Tool_Type_e::'8.6 Shared Drives and Cloud Storage'
            )
            else null;

        derived attribute nuclear_engineering_tools : Tool_Type_e[*] =
            if inputs.'Engineering and Architecture'.role_nuclear_engineering ?
            (
                Tool_Type_e::'2.1 Low Fidelity Simulations',
                Tool_Type_e::'2.2 Computational Fluid Dynamics (CFD)',
                Tool_Type_e::'2.3 Finite Element Analysis (FEA)',
                Tool_Type_e::'2.5 Dynamic Simulations',
                Tool_Type_e::'2.7 Simulation Managers',
                Tool_Type_e::'5.1 Data Analytics and Visualization',
                Tool_Type_e::'5.2 Data Integration',
                Tool_Type_e::'5.4 Digital Thread',
                Tool_Type_e::'8.1 Word Processing and Document Collaboration',
                Tool_Type_e::'8.2 Presentation Software',
                Tool_Type_e::'8.3 Spreadsheets',
                Tool_Type_e::'8.4 Email and Communication Platforms',
                Tool_Type_e::'8.5 Task Management and Project Planning',
                Tool_Type_e::'8.6 Shared Drives and Cloud Storage'
            )
            else null;

        derived attribute electrical_engineering_tools : Tool_Type_e[*] =
            if inputs.'Engineering and Architecture'.role_electrical_engineering ?
            (
                Tool_Type_e::'1.2 Electrical computer-aided design (ECAD)',
                Tool_Type_e::'2.1 Low Fidelity Simulations',
                Tool_Type_e::'2.4 Electromagnetic (EM)',
                Tool_Type_e::'2.5 Dynamic Simulations',
                Tool_Type_e::'3.1 Requirements Management Tools',
                Tool_Type_e::'5.1 Data Analytics and Visualization',
                Tool_Type_e::'5.2 Data Integration',
                Tool_Type_e::'5.4 Digital Thread',
                Tool_Type_e::'6.3 Manufacturing Execution Software (MES)',
                Tool_Type_e::'8.1 Word Processing and Document Collaboration',
                Tool_Type_e::'8.2 Presentation Software',
                Tool_Type_e::'8.3 Spreadsheets',
                Tool_Type_e::'8.4 Email and Communication Platforms',
                Tool_Type_e::'8.5 Task Management and Project Planning',
                Tool_Type_e::'8.6 Shared Drives and Cloud Storage'
            )
            else null;

        derived attribute computer_engineering_tools : Tool_Type_e[*] =
            if inputs.'Engineering and Architecture'.role_computer_engineering ?
            (
                Tool_Type_e::'2.1 Low Fidelity Simulations',
                Tool_Type_e::'2.5 Dynamic Simulations',
                Tool_Type_e::'3.1 Requirements Management Tools',
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

        derived attribute aerospace_engineering_tools : Tool_Type_e[*] =
            if inputs.'Engineering and Architecture'.role_aerospace_engineering ?
            (
                Tool_Type_e::'1.1 Computer Aided Design (CAD)',
                Tool_Type_e::'1.3 Product Lifecycle Management (PLM)',
                Tool_Type_e::'2.1 Low Fidelity Simulations',
                Tool_Type_e::'2.2 Computational Fluid Dynamics (CFD)',
                Tool_Type_e::'2.3 Finite Element Analysis (FEA)',
                Tool_Type_e::'2.5 Dynamic Simulations',
                Tool_Type_e::'2.6 Mission Models',
                Tool_Type_e::'2.7 Simulation Managers',
                Tool_Type_e::'3.1 Requirements Management Tools',
                Tool_Type_e::'3.2 Architecture Tools',
                Tool_Type_e::'3.3 Shared Architecture Tools',
                Tool_Type_e::'5.1 Data Analytics and Visualization',
                Tool_Type_e::'5.2 Data Integration',
                Tool_Type_e::'5.4 Digital Thread',
                Tool_Type_e::'8.1 Word Processing and Document Collaboration',
                Tool_Type_e::'8.2 Presentation Software',
                Tool_Type_e::'8.3 Spreadsheets',
                Tool_Type_e::'8.4 Email and Communication Platforms',
                Tool_Type_e::'8.5 Task Management and Project Planning',
                Tool_Type_e::'8.6 Shared Drives and Cloud Storage'
            )
            else null;

        derived attribute chemical_engineering_tools : Tool_Type_e[*] =
            if inputs.'Engineering and Architecture'.role_chemical_engineering ?
            (
                Tool_Type_e::'2.1 Low Fidelity Simulations',
                Tool_Type_e::'2.2 Computational Fluid Dynamics (CFD)',
                Tool_Type_e::'2.3 Finite Element Analysis (FEA)',
                Tool_Type_e::'2.5 Dynamic Simulations',
                Tool_Type_e::'2.7 Simulation Managers',
                Tool_Type_e::'5.1 Data Analytics and Visualization',
                Tool_Type_e::'5.4 Digital Thread',
                Tool_Type_e::'8.1 Word Processing and Document Collaboration',
                Tool_Type_e::'8.2 Presentation Software',
                Tool_Type_e::'8.3 Spreadsheets',
                Tool_Type_e::'8.4 Email and Communication Platforms',
                Tool_Type_e::'8.5 Task Management and Project Planning',
                Tool_Type_e::'8.6 Shared Drives and Cloud Storage'
            )
            else null;

        derived attribute industrial_engineering_tools : Tool_Type_e[*] =
            if inputs.'Engineering and Architecture'.role_industrial_engineering ?
            (
                Tool_Type_e::'2.1 Low Fidelity Simulations',
                Tool_Type_e::'2.5 Dynamic Simulations',
                Tool_Type_e::'2.7 Simulation Managers',
                Tool_Type_e::'3.1 Requirements Management Tools',
                Tool_Type_e::'3.2 Architecture Tools',
                Tool_Type_e::'3.3 Shared Architecture Tools',
                Tool_Type_e::'5.1 Data Analytics and Visualization',
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
                Tool_Type_e::'8.6 Shared Drives and Cloud Storage'
            )
            else null;

        /* --- 2 - Physical Sciences Group --- */

        derived attribute physics_tools : Tool_Type_e[*] =
            if inputs.'Physical Sciences'.role_physics ?
            (
                Tool_Type_e::'2.1 Low Fidelity Simulations',
                Tool_Type_e::'2.2 Computational Fluid Dynamics (CFD)',
                Tool_Type_e::'2.3 Finite Element Analysis (FEA)',
                Tool_Type_e::'2.4 Electromagnetic (EM)',
                Tool_Type_e::'2.5 Dynamic Simulations',
                Tool_Type_e::'4.1 Integrated Development Environments (IDEs)',
                Tool_Type_e::'4.2 Version Control Systems',
                Tool_Type_e::'5.1 Data Analytics and Visualization',
                Tool_Type_e::'5.2 Data Integration',
                Tool_Type_e::'5.4 Digital Thread',
                Tool_Type_e::'8.1 Word Processing and Document Collaboration',
                Tool_Type_e::'8.2 Presentation Software',
                Tool_Type_e::'8.3 Spreadsheets',
                Tool_Type_e::'8.4 Email and Communication Platforms',
                Tool_Type_e::'8.5 Task Management and Project Planning',
                Tool_Type_e::'8.6 Shared Drives and Cloud Storage'
            )
            else null;

        derived attribute chemistry_tools : Tool_Type_e[*] =
            if inputs.'Physical Sciences'.role_chemistry ?
            (
                Tool_Type_e::'2.1 Low Fidelity Simulations',
                Tool_Type_e::'2.5 Dynamic Simulations',
                Tool_Type_e::'5.1 Data Analytics and Visualization',
                Tool_Type_e::'5.2 Data Integration',
                Tool_Type_e::'5.4 Digital Thread',
                Tool_Type_e::'8.1 Word Processing and Document Collaboration',
                Tool_Type_e::'8.2 Presentation Software',
                Tool_Type_e::'8.3 Spreadsheets',
                Tool_Type_e::'8.4 Email and Communication Platforms',
                Tool_Type_e::'8.5 Task Management and Project Planning',
                Tool_Type_e::'8.6 Shared Drives and Cloud Storage'
            )
            else null;
            
        /* --- 3 - Mathematical Sciences Group --- */

        derived attribute general_math_and_stats_tools : Tool_Type_e[*] =
            if inputs.'Mathematical Sciences'.role_general_mathematics_and_statistics ?
            (
                Tool_Type_e::'2.1 Low Fidelity Simulations',
                Tool_Type_e::'2.5 Dynamic Simulations',
                Tool_Type_e::'2.7 Simulation Managers',
                Tool_Type_e::'4.1 Integrated Development Environments (IDEs)',
                Tool_Type_e::'4.2 Version Control Systems',
                Tool_Type_e::'5.1 Data Analytics and Visualization',
                Tool_Type_e::'5.2 Data Integration',
                Tool_Type_e::'5.4 Digital Thread',
                Tool_Type_e::'8.1 Word Processing and Document Collaboration',
                Tool_Type_e::'8.2 Presentation Software',
                Tool_Type_e::'8.3 Spreadsheets',
                Tool_Type_e::'8.4 Email and Communication Platforms',
                Tool_Type_e::'8.5 Task Management and Project Planning',
                Tool_Type_e::'8.6 Shared Drives and Cloud Storage'
            )
            else null;

        derived attribute ops_research_tools : Tool_Type_e[*] =
            if inputs.'Mathematical Sciences'.role_operations_research ?
            (
                Tool_Type_e::'2.1 Low Fidelity Simulations',
                Tool_Type_e::'2.5 Dynamic Simulations',
                Tool_Type_e::'2.6 Mission Models',
                Tool_Type_e::'2.7 Simulation Managers',
                Tool_Type_e::'4.1 Integrated Development Environments (IDEs)',
                Tool_Type_e::'4.2 Version Control Systems',
                Tool_Type_e::'5.1 Data Analytics and Visualization',
                Tool_Type_e::'5.4 Digital Thread',
                Tool_Type_e::'7.1 Supply Chain Planning & Optimization',
                Tool_Type_e::'7.2 Transportation and Distribution Management',
                Tool_Type_e::'7.4 Sustainment and Maintenance',
                Tool_Type_e::'8.1 Word Processing and Document Collaboration',
                Tool_Type_e::'8.2 Presentation Software',
                Tool_Type_e::'8.3 Spreadsheets',
                Tool_Type_e::'8.4 Email and Communication Platforms',
                Tool_Type_e::'8.5 Task Management and Project Planning',
                Tool_Type_e::'8.6 Shared Drives and Cloud Storage'
            )
            else null;

        derived attribute compsci_tools : Tool_Type_e[*] =
            if inputs.'Mathematical Sciences'.role_computer_science ?
            (
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
    }

    enum def status_e_jobs {
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
