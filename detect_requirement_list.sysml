package DETECT_Requirement_List {
    doc Acknowledgement
    /* This file contains content from DETECT model file for SysML v1.6 by Daniel Hettema, OUSD (R&E).
     * Original content is dedicated to the Public Domain.
     * Modifications Copyright (c) 2025 Sensmetry.
     */

    doc Description
    /* This package provides a listing of all the DE Ecosystem requirements with weights and the mapping to DE ecosystem size. */

    private import DETECT_Input;
    private import DETECT_Sizing::*;

    requirement <R1> tech_and_inno defined by DE_Ecosystem_req_Def {
        doc Description
        /* Advanced Technologies and Innovation */
        subject DE_Ecosystem = DETECT_Input::de_ecosystem;
        attribute redefines weight =
            if DETECT_Input::de_ecosystem.system_size ==
                DETECT_enumerations::Ecosystem_size_e::Small
                ?    0.1667
                else if DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Medium
                ?    0.1667
                else if DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large
                ?    0.1667
                else 0.0;
        assume constraint {
            DETECT_Input::de_ecosystem.system_size ==
            DETECT_enumerations::Ecosystem_size_e::Large or
            DETECT_Input::de_ecosystem.system_size ==
            DETECT_enumerations::Ecosystem_size_e::Medium or
            DETECT_Input::de_ecosystem.system_size == DETECT_enumerations::Ecosystem_size_e::Small
        }

        requirement <'R1.1'> inno defined by DE_Ecosystem_req_Def {
            doc Description
            /* Innovation */
            subject DE_Ecosystem = DETECT_Input::de_ecosystem;
            attribute redefines weight =
                if DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Medium
                    ?    0.5
                    else if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Large
                    ?    0.5
                    else 0.0;
            assume constraint {
                DETECT_Input::de_ecosystem.system_size ==
                DETECT_enumerations::Ecosystem_size_e::Large or
                DETECT_Input::de_ecosystem.system_size ==
                DETECT_enumerations::Ecosystem_size_e::Medium
            }

            requirement <'R1.1.1'> inno_prototyping defined by DE_Ecosystem_req_Def {
                doc Description
                /* The DE ecosystem shall support prototyping activities for ecosystem improvements */
                subject DE_Ecosystem = DETECT_Input::de_ecosystem;
                attribute redefines weight =
                    if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Large
                        ?    0.125
                        else 0.0;
                assume constraint {
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large
                }
            }
            requirement <'R1.1.2'> inno_prototyping_apps defined by DE_Ecosystem_req_Def {
                doc Description
                /* The DE ecosystem shall accommodate intelligent applications that enable rigorous prototyping to facilitate digital to physical prototypes and proof of concept activities */
                subject DE_Ecosystem = DETECT_Input::de_ecosystem;
                attribute redefines weight =
                    if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Large
                        ?    0.125
                        else 0.0;
                assume constraint {
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large
                }
            }
            requirement <'R1.1.3'> inno_development_apps defined by DE_Ecosystem_req_Def {
                doc Description
                /* The DE ecosystem shall accommodate intelligent applications that enable rigorous development of early and often automated testing of system performance requirements */
                subject DE_Ecosystem = DETECT_Input::de_ecosystem;
                attribute redefines weight =
                    if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Medium
                        ?    0.25
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Large
                        ?    0.125
                        else 0.0;
                assume constraint {
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Medium
                }
            }
            requirement <'R1.1.4'> inno_traceability defined by DE_Ecosystem_req_Def {
                doc Description
                /* The DE ecosystem shall accommodate intelligent applications that enable cross-domain traceability of design thread, analytical thread and proof of concept analysis */
                subject DE_Ecosystem = DETECT_Input::de_ecosystem;
                attribute redefines weight =
                    if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Medium
                        ?    0.25
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Large
                        ?    0.125
                        else 0.0;
                assume constraint {
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Medium
                }
            }
        }

        requirement <'R1.2'> tech defined by DE_Ecosystem_req_Def {
            doc Description
            /* Technologies */
            subject DE_Ecosystem = DETECT_Input::de_ecosystem;
            attribute redefines weight =
                if DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Small
                    ?    1
                    else if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Medium
                    ?    0.5
                    else if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Large
                    ?    0.5
                    else 0.0;
            assume constraint {
                DETECT_Input::de_ecosystem.system_size ==
                DETECT_enumerations::Ecosystem_size_e::Large or
                DETECT_Input::de_ecosystem.system_size ==
                DETECT_enumerations::Ecosystem_size_e::Medium or
                DETECT_Input::de_ecosystem.system_size ==
                DETECT_enumerations::Ecosystem_size_e::Small
            }
            requirement <'R1.2.1'> tech_sw defined by DE_Ecosystem_req_Def {
                doc Description
                /* The DE ecosystem shall provide the software tools, software libraries, software builds, and automated testing capabilities needed for development and operations (DevOps) process implementations */
                subject DE_Ecosystem = DETECT_Input::de_ecosystem;
                attribute redefines weight =
                    if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Large
                        ?    0.25
                        else 0.0;
                assume constraint {
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large
                }
            }
            requirement <'R1.2.2'> tech_rnd defined by DE_Ecosystem_req_Def {
                doc Description
                /* The DE ecosystem shall provide advanced technologies to support leading-edge research and development capabilities such as, but not limited to, big data analytics, machine learning, artificial intelligence, ontology, virtual reality, augmented reality, and 5G technologies */
                subject DE_Ecosystem = DETECT_Input::de_ecosystem;
                attribute redefines weight =
                    if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Small
                        ?    0.5
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Medium
                        ?    0.5
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Large
                        ?    0.25
                        else 0.0;
                assume constraint {
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Medium or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Small
                }
            }
        }
    }

    requirement <R2> collab defined by DE_Ecosystem_req_Def {
        doc Description
        /* Collaboration */
        subject DE_Ecosystem = DETECT_Input::de_ecosystem;
        attribute redefines weight =
            if DETECT_Input::de_ecosystem.system_size ==
                DETECT_enumerations::Ecosystem_size_e::Small
                ?    0.1667
                else if DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Medium
                ?    0.1667
                else if DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large
                ?    0.1667
                else 0.0;
        assume constraint {
            DETECT_Input::de_ecosystem.system_size ==
            DETECT_enumerations::Ecosystem_size_e::Large or
            DETECT_Input::de_ecosystem.system_size ==
            DETECT_enumerations::Ecosystem_size_e::Medium or
            DETECT_Input::de_ecosystem.system_size == DETECT_enumerations::Ecosystem_size_e::Small
        }

        requirement <'R2.1'> resources defined by DE_Ecosystem_req_Def {
            doc Description
            /* Resources */
            subject DE_Ecosystem = DETECT_Input::de_ecosystem;
            attribute redefines weight =
                if DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Small
                    ?    0.5
                    else if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Medium
                    ?    0.5
                    else if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Large
                    ?    0.5
                    else 0.0;
            assume constraint {
                DETECT_Input::de_ecosystem.system_size ==
                DETECT_enumerations::Ecosystem_size_e::Large or
                DETECT_Input::de_ecosystem.system_size ==
                DETECT_enumerations::Ecosystem_size_e::Medium or
                DETECT_Input::de_ecosystem.system_size ==
                DETECT_enumerations::Ecosystem_size_e::Small
            }

            requirement <'R2.1.1'> resources_notifications defined by DE_Ecosystem_req_Def {
                doc Description
                /* The DE ecosystem shall provide automated notifications capability to all applicable change events */
                subject DE_Ecosystem = DETECT_Input::de_ecosystem;
                attribute redefines weight =
                    if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Small
                        ?    0.1667
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Medium
                        ?    0.1667
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Large
                        ?    0.1667
                        else 0.0;
                assume constraint {
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Medium or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Small
                }
            }
            requirement <'R2.1.2'> resources_connections defined by DE_Ecosystem_req_Def {
                doc Description
                /* The DE ecosystem shall be sized for growth in the number of connections and types of accesses (VM, web portal, others) to support (TBD) users */
                subject DE_Ecosystem = DETECT_Input::de_ecosystem;
                attribute redefines weight =
                    if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Small
                        ?    0.1667
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Medium
                        ?    0.1667
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Large
                        ?    0.1667
                        else 0.0;
                assume constraint {
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Medium or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Small
                }
            }
            requirement <'R2.1.3'> resources_sharing defined by DE_Ecosystem_req_Def {
                doc Description
                /* The DE ecosystem shall enable sharing of models, data, and simulations from authorized users and engineering disciplines */
                subject DE_Ecosystem = DETECT_Input::de_ecosystem;
                attribute redefines weight =
                    if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Small
                        ?    0.1667
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Medium
                        ?    0.1667
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Large
                        ?    0.1667
                        else 0.0;
                assume constraint {
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Medium or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Small
                }
            }
        }

        requirement <'R2.2'> users defined by DE_Ecosystem_req_Def {
            doc Description
            /* Users */
            subject DE_Ecosystem = DETECT_Input::de_ecosystem;
            attribute redefines weight =
                if DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Small
                    ?    0.5
                    else if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Medium
                    ?    0.5
                    else if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Large
                    ?    0.5
                    else 0.0;
            assume constraint {
                DETECT_Input::de_ecosystem.system_size ==
                DETECT_enumerations::Ecosystem_size_e::Large or
                DETECT_Input::de_ecosystem.system_size ==
                DETECT_enumerations::Ecosystem_size_e::Medium or
                DETECT_Input::de_ecosystem.system_size ==
                DETECT_enumerations::Ecosystem_size_e::Small
            }

            requirement <'R2.2.1'> users_teleconferencing defined by DE_Ecosystem_req_Def {
                doc Description
                /* The DE ecosystem shall support remote teleconferencing with messaging, audio, and video */
                subject DE_Ecosystem = DETECT_Input::de_ecosystem;
                attribute redefines weight =
                    if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Small
                        ?    0.1667
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Medium
                        ?    0.1
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Large
                        ?    0.1
                        else 0.0;
                assume constraint {
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Medium or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Small
                }
            }
            requirement <'R2.2.2'> users_concurrent defined by DE_Ecosystem_req_Def {
                doc Description
                /* The DE ecosystem shall be sized and maintained for (TBD) number of users for concurrent use of program identified capabilities and functions appropriate for the program. (e.g., data managers, data users, data creators) */
                subject DE_Ecosystem = DETECT_Input::de_ecosystem;
                attribute redefines weight =
                    if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Medium
                        ?    0.1
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Large
                        ?    0.1
                        else 0.0;
                assume constraint {
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Medium
                }
            }
            requirement <'R2.2.3'> users_identify defined by DE_Ecosystem_req_Def {
                doc Description
                /* The DE ecosystem shall be sized and maintained for the number of users to be 100% of identified program personnel */
                subject DE_Ecosystem = DETECT_Input::de_ecosystem;
                attribute redefines weight =
                    if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Small
                        ?    0.1667
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Medium
                        ?    0.1
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Large
                        ?    0.1
                        else 0.0;
                assume constraint {
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Medium or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Small
                }
            }
            requirement <'R2.2.4'> users_network_access defined by DE_Ecosystem_req_Def {
                doc Description
                /* The DE ecosystem shall provide network access to authenticated users, organizations, and stakeholders */
                subject DE_Ecosystem = DETECT_Input::de_ecosystem;
                attribute redefines weight =
                    if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Small
                        ?    0.1667
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Medium
                        ?    0.1
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Large
                        ?    0.1
                        else 0.0;
                assume constraint {
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Medium or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Small
                }
            }
            requirement <'R2.2.5'> users_simulation_access defined by DE_Ecosystem_req_Def {
                doc Description
                /* The DE ecosystem shall provide the access for authenticated users and stakeholders to execute simulations and perform data analytics */
                subject DE_Ecosystem = DETECT_Input::de_ecosystem;
                attribute redefines weight =
                    if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Medium
                        ?    0.1
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Large
                        ?    0.1
                        else 0.0;
                assume constraint {
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Medium
                }
            }
        }
    }

    requirement <R3> data defined by DE_Ecosystem_req_Def {
        doc Description
        /* Data */
        subject DE_Ecosystem = DETECT_Input::de_ecosystem;
        attribute redefines weight =
            if DETECT_Input::de_ecosystem.system_size ==
                DETECT_enumerations::Ecosystem_size_e::Small
                ?    0.1667
                else if DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Medium
                ?    0.1667
                else if DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large
                ?    0.1667
                else 0.0;
        assume constraint {
            DETECT_Input::de_ecosystem.system_size ==
            DETECT_enumerations::Ecosystem_size_e::Large or
            DETECT_Input::de_ecosystem.system_size ==
            DETECT_enumerations::Ecosystem_size_e::Medium or
            DETECT_Input::de_ecosystem.system_size == DETECT_enumerations::Ecosystem_size_e::Small
        }

        requirement <'R3.1'> exchange defined by DE_Ecosystem_req_Def {
            doc Description
            /* Exchange */
            subject DE_Ecosystem = DETECT_Input::de_ecosystem;
            attribute redefines weight =
                if DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Small
                    ?    0.5
                    else if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Medium
                    ?    0.3333
                    else if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Large
                    ?    0.3333
                    else 0.0;
            assume constraint {
                DETECT_Input::de_ecosystem.system_size ==
                DETECT_enumerations::Ecosystem_size_e::Large or
                DETECT_Input::de_ecosystem.system_size ==
                DETECT_enumerations::Ecosystem_size_e::Medium or
                DETECT_Input::de_ecosystem.system_size ==
                DETECT_enumerations::Ecosystem_size_e::Small
            }

            requirement <'R3.1.1'> exchange_data_association defined by DE_Ecosystem_req_Def {
                doc Description
                /* The DE ecosystem shall provide a capability to associate data that has been generated by different engineering domains */
                subject DE_Ecosystem = DETECT_Input::de_ecosystem;
                attribute redefines weight =
                    if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Medium
                        ?    0.125
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Large
                        ?    0.0714
                        else 0.0;
                assume constraint {
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Medium
                }
            }
            requirement <'R3.1.2'> exchange_error_monitoring defined by DE_Ecosystem_req_Def {
                doc Description
                /* The DE ecosystem shall provide monitoring of error detection and quality assessment of all data translation across engineering tools */
                subject DE_Ecosystem = DETECT_Input::de_ecosystem;
                attribute redefines weight =
                    if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Large
                        ?    0.0714
                        else 0.0;
                assume constraint {
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large
                }
            }

            requirement <'R3.1.3'> exchange_automation defined by DE_Ecosystem_req_Def {
                doc Description
                /* The DE ecosystem shall provide a capability to automate data exchange within workflows of users */
                subject DE_Ecosystem = DETECT_Input::de_ecosystem;
                attribute redefines weight =
                    if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Medium
                        ?    0.125
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Large
                        ?    0.0714
                        else 0.0;
                assume constraint {
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Medium
                }
            }
            requirement <'R3.1.4'> exchange_standards defined by DE_Ecosystem_req_Def {
                doc Description
                /* The DE ecosystem shall accommodate model exchange standards, published standards and procedures for interoperability among supported modeling and analysis tools */
                subject DE_Ecosystem = DETECT_Input::de_ecosystem;
                attribute redefines weight =
                    if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Large
                        ?    0.0714
                        else 0.0;
                assume constraint {
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large
                }
            }
            requirement <'R3.1.5'> exchange_format_translation defined by DE_Ecosystem_req_Def {
                doc Description
                /* The DE ecosystem shall provide a capability to translate data formats between disparate engineering tools */
                subject DE_Ecosystem = DETECT_Input::de_ecosystem;
                attribute redefines weight =
                    if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Large
                        ?    0.0714
                        else 0.0;
                assume constraint {
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large
                }
            }
            requirement <'R3.1.6'> exchange_format_compatibility defined by DE_Ecosystem_req_Def {
                doc Description
                /* The DE ecosystem shall provide the compatibility to receive, store, and utilize data in specified formats, from both legacy and new tools and sources */
                subject DE_Ecosystem = DETECT_Input::de_ecosystem;
                attribute redefines weight =
                    if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Medium
                        ?    0.125
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Large
                        ?    0.0714
                        else 0.0;
                assume constraint {
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Medium
                }
            }
            requirement <'R3.1.7'> exchange_data_access defined by DE_Ecosystem_req_Def {
                doc Description
                /* The DE ecosystem shall provide access to metadata and supporting data for all data and information in the ecosystem */
                subject DE_Ecosystem = DETECT_Input::de_ecosystem;
                attribute redefines weight =
                    if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Medium
                        ?    0.125
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Large
                        ?    0.0714
                        else 0.0;
                assume constraint {
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Medium
                }
            }
        }

        requirement <'R3.2'> curation defined by DE_Ecosystem_req_Def {
            doc Description
            /* Curation */
            subject DE_Ecosystem = DETECT_Input::de_ecosystem;
            attribute redefines weight =
                if DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Small
                    ?    0.5
                    else if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Medium
                    ?    0.3333
                    else if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Large
                    ?    0.3333
                    else 0.0;
            assume constraint {
                DETECT_Input::de_ecosystem.system_size ==
                DETECT_enumerations::Ecosystem_size_e::Large or
                DETECT_Input::de_ecosystem.system_size ==
                DETECT_enumerations::Ecosystem_size_e::Medium or
                DETECT_Input::de_ecosystem.system_size ==
                DETECT_enumerations::Ecosystem_size_e::Small
            }

            requirement <'R3.2.1'> curation_config_mng defined by DE_Ecosystem_req_Def {
                doc Description
                /* The DE ecosystem shall contain formal configuration management for all models, simulations, analysis, and technical data as the authoritative-source-of-truth for the ecosystem */
                subject DE_Ecosystem = DETECT_Input::de_ecosystem;
                attribute redefines weight =
                    if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Small
                        ?    0.1
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Medium
                        ?    0.0625
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Large
                        ?    0.0625
                        else 0.0;
                assume constraint {
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Medium or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Small
                }
            }
            requirement <'R3.2.2'> auto_generated defined by DE_Ecosystem_req_Def {
                doc Description
                /* The DE ecosystem shall provide capabilities to maintain measures and metrics for both program-specific and ecosystem performance measuring */
                subject DE_Ecosystem = DETECT_Input::de_ecosystem;
                attribute redefines weight =
                    if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Medium
                        ?    0.0625
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Large
                        ?    0.0625
                        else 0.0;
                assume constraint {
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Medium
                }
            }
            requirement <'R3.2.3'> curation_discovery defined by DE_Ecosystem_req_Def {
                doc Description
                /* The DE ecosystem shall accommodate discovery of models and associated data from outside the local ecosystem instantiation */
                subject DE_Ecosystem = DETECT_Input::de_ecosystem;
                attribute redefines weight =
                    if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Small
                        ?    0.1
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Medium
                        ?    0.0625
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Large
                        ?    0.0625
                        else 0.0;
                assume constraint {
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Medium or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Small
                }
            }
            requirement <'R3.2.4'> curation_library_custom defined by DE_Ecosystem_req_Def {
                doc Description
                /* The DE ecosystem shall enable customization of library function executable applications */
                subject DE_Ecosystem = DETECT_Input::de_ecosystem;
                attribute redefines weight =
                    if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Medium
                        ?    0.0625
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Large
                        ?    0.0625
                        else 0.0;
                assume constraint {
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Medium
                }
            }
            requirement <'R3.2.5'> curation_reuse defined by DE_Ecosystem_req_Def {
                doc Description
                /* The DE ecosystem shall include the ability to curate models for reuse */
                subject DE_Ecosystem = DETECT_Input::de_ecosystem;
                attribute redefines weight =
                    if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Small
                        ?    0.1
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Medium
                        ?    0.0625
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Large
                        ?    0.0625
                        else 0.0;
                assume constraint {
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Medium
                }
            }
            requirement <'R3.2.6'> curation_audit defined by DE_Ecosystem_req_Def {
                doc Description
                /* The DE ecosystem shall provide auditable technical data curation over a full life-cycle of platforms/systems for (TBD) years */
                subject DE_Ecosystem = DETECT_Input::de_ecosystem;
                attribute redefines weight =
                    if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Medium
                        ?    0.0625
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Large
                        ?    0.0625
                        else 0.0;
                assume constraint {
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Medium
                }
            }
            requirement <'R3.2.7'> curation_library defined by DE_Ecosystem_req_Def {
                doc Description
                /* The DE ecosystem shall provide a library function of executable applications available for access and reuse */
                subject DE_Ecosystem = DETECT_Input::de_ecosystem;
                attribute redefines weight =
                    if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Small
                        ?    0.1
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Medium
                        ?    0.0625
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Large
                        ?    0.0625
                        else 0.0;
                assume constraint {
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Medium or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Small
                }
            }
            requirement <'R3.2.8'> curation_data_storing defined by DE_Ecosystem_req_Def {
                doc Description
                /* The DE ecosystem shall contain an organized data-storing structure for ease of discovery and navigation */
                subject DE_Ecosystem = DETECT_Input::de_ecosystem;
                attribute redefines weight =
                    if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Small
                        ?    0.1
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Medium
                        ?    0.0625
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Large
                        ?    0.0625
                        else 0.0;
                assume constraint {
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Medium or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Small
                }
            }
        }

        requirement <'R3.3'> storage defined by DE_Ecosystem_req_Def {
            doc Description
            /* Storage */
            subject DE_Ecosystem = DETECT_Input::de_ecosystem;
            attribute redefines weight =
                if DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Small
                    ?    0.5
                    else if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Medium
                    ?    0.3333
                    else if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Large
                    ?    0.3333
                    else 0.0;
            assume constraint {
                DETECT_Input::de_ecosystem.system_size ==
                DETECT_enumerations::Ecosystem_size_e::Large or
                DETECT_Input::de_ecosystem.system_size ==
                DETECT_enumerations::Ecosystem_size_e::Medium or
                DETECT_Input::de_ecosystem.system_size ==
                DETECT_enumerations::Ecosystem_size_e::Small
            }

            requirement <'R3.3.1'> storage_allocation defined by DE_Ecosystem_req_Def {
                doc Description
                /* The DE ecosystem shall provide for sufficient storage size allocations to all engineering technical data, for all major life cycle phases, with (TBD)% margin expansion */
                subject DE_Ecosystem = DETECT_Input::de_ecosystem;
                attribute redefines weight =
                    if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Small
                        ?    0.25
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Medium
                        ?    0.125
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Large
                        ?    0.125
                        else 0.0;
                assume constraint {
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Medium or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Small
                }
            }
            requirement <'R3.3.2'> storage_expansion_capacity defined by DE_Ecosystem_req_Def {
                doc Description
                /* The DE ecosystem shall provide (TBD)% storage expansion capacity for all data that is above and beyond the theoretical storage calculations needed for the ecosystem being developed */
                subject DE_Ecosystem = DETECT_Input::de_ecosystem;
                attribute redefines weight =
                    if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Medium
                        ?    0.125
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Large
                        ?    0.125
                        else 0.0;
                assume constraint {
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Medium
                }
            }
            requirement <'R3.3.3'> storage_availability defined by DE_Ecosystem_req_Def {
                doc Description
                /* The DE ecosystem shall make data available to all authorized users and ensure unmodified utilization on a recurring basis */
                subject DE_Ecosystem = DETECT_Input::de_ecosystem;
                attribute redefines weight =
                    if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Small
                        ?    0.25
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Medium
                        ?    0.125
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Large
                        ?    0.125
                        else 0.0;
                assume constraint {
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Medium or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Small
                }
            }
            requirement <'R3.3.4'> storage_critical_data defined by DE_Ecosystem_req_Def {
                doc Description
                /* The DE ecosystem shall require the need to enter and store critical data one time */
                subject DE_Ecosystem = DETECT_Input::de_ecosystem;
                attribute redefines weight =
                    if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Medium
                        ?    0.125
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Large
                        ?    0.125
                        else 0.0;
                assume constraint {
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Medium
                }
            }
        }
    }

    requirement <R4> environrment defined by DE_Ecosystem_req_Def {
        doc Description
        /* Environment */
        subject DE_Ecosystem = DETECT_Input::de_ecosystem;
        attribute redefines weight =
            if DETECT_Input::de_ecosystem.system_size ==
                DETECT_enumerations::Ecosystem_size_e::Small
                ?    0.1667
                else if DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Medium
                ?    0.1667
                else if DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large
                ?    0.1667
                else 0.0;
        assume constraint {
            DETECT_Input::de_ecosystem.system_size ==
            DETECT_enumerations::Ecosystem_size_e::Large or
            DETECT_Input::de_ecosystem.system_size ==
            DETECT_enumerations::Ecosystem_size_e::Medium or
            DETECT_Input::de_ecosystem.system_size == DETECT_enumerations::Ecosystem_size_e::Small
        }

        requirement <'R4.1'> licensing defined by DE_Ecosystem_req_Def {
            doc Description
            /* Licensing */
            subject DE_Ecosystem = DETECT_Input::de_ecosystem;
            attribute redefines weight =
                if DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Small
                    ?    0.25
                    else if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Medium
                    ?    0.25
                    else if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Large
                    ?    0.25
                    else 0.0;
            assume constraint {
                DETECT_Input::de_ecosystem.system_size ==
                DETECT_enumerations::Ecosystem_size_e::Large or
                DETECT_Input::de_ecosystem.system_size ==
                DETECT_enumerations::Ecosystem_size_e::Medium or
                DETECT_Input::de_ecosystem.system_size ==
                DETECT_enumerations::Ecosystem_size_e::Small
            }
            requirement <'R4.1.1'> licensing_metrics defined by DE_Ecosystem_req_Def {
                doc Description
                /* The DE ecosystem shall provide license and tool usage metrics */
                subject DE_Ecosystem = DETECT_Input::de_ecosystem;
                attribute redefines weight =
                    if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Small
                        ?    0.125
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Medium
                        ?    0.0833
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Large
                        ?    0.0833
                        else 0.0;
                assume constraint {
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Medium or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Small
                }
            }
            requirement <'R4.1.2'> licensing_warning_renewal defined by DE_Ecosystem_req_Def {
                doc Description
                /* The DE ecosystem shall have warning report capabilities for approaching license renewal dates */
                subject DE_Ecosystem = DETECT_Input::de_ecosystem;
                attribute redefines weight =
                    if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Small
                        ?    0.125
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Medium
                        ?    0.0833
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Large
                        ?    0.0833
                        else 0.0;
                assume constraint {
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Medium or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Small
                }
            }

            requirement <'R4.1.3'> licensing_warning_limit defined by DE_Ecosystem_req_Def {
                doc Description
                /* The DE ecosystem shall have warning report capabilities for approaching license capacity limits */
                subject DE_Ecosystem = DETECT_Input::de_ecosystem;
                attribute redefines weight =
                    if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Small
                        ?    0.125
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Medium
                        ?    0.0833
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Large
                        ?    0.0833
                        else 0.0;
                assume constraint {
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Medium or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Small
                }
            }
            requirement <'R4.1.4'> licensing_flexible_mng defined by DE_Ecosystem_req_Def {
                doc Description
                /* The DE ecosystem shall employ flexible license management strategies for all shared software that supports user availability of .999 (TBR) */
                subject DE_Ecosystem = DETECT_Input::de_ecosystem;
                attribute redefines weight =
                    if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Medium
                        ?    0.0833
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Large
                        ?    0.0833
                        else 0.0;
                assume constraint {
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Medium
                }
            }
            requirement <'R4.1.5'> licensing_warning_usage defined by DE_Ecosystem_req_Def {
                doc Description
                /* The DE ecosystem shall have warning report capabilities for low usage of tool licenses */
                subject DE_Ecosystem = DETECT_Input::de_ecosystem;
                attribute redefines weight =
                    if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Medium
                        ?    0.0833
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Large
                        ?    0.0833
                        else 0.0;
                assume constraint {
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Medium
                }
            }
            requirement <'R4.1.6'> licensing_sw defined by DE_Ecosystem_req_Def {
                doc Description
                /* The DE ecosystem shall facilitate new software tool license allocations within (TBD) days of a request */
                subject DE_Ecosystem = DETECT_Input::de_ecosystem;
                attribute redefines weight =
                    if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Small
                        ?    0.125
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Medium
                        ?    0.0833
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Large
                        ?    0.0833
                        else 0.0;
                assume constraint {
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Medium or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Small
                }
            }
        }

        requirement <'R4.2'> visualization defined by DE_Ecosystem_req_Def {
            doc Description
            /* Visualization */
            subject DE_Ecosystem = DETECT_Input::de_ecosystem;
            attribute redefines weight =
                if DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Small
                    ?    0.25
                    else if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Medium
                    ?    0.25
                    else if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Large
                    ?    0.25
                    else 0.0;
            assume constraint {
                DETECT_Input::de_ecosystem.system_size ==
                DETECT_enumerations::Ecosystem_size_e::Large or
                DETECT_Input::de_ecosystem.system_size ==
                DETECT_enumerations::Ecosystem_size_e::Medium or
                DETECT_Input::de_ecosystem.system_size ==
                DETECT_enumerations::Ecosystem_size_e::Small
            }

            requirement <'R4.2.1'> visual_capability defined by DE_Ecosystem_req_Def {
                doc Description
                /* The DE ecosystem shall have a fully integrated applicable visualization and reporting capability */
                subject DE_Ecosystem = DETECT_Input::de_ecosystem;
                attribute redefines weight =
                    if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Small
                        ?    0.5
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Medium
                        ?    0.5
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Large
                        ?    0.5
                        else 0.0;
                assume constraint {
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Medium or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Small
                }
            }
        }

        requirement <'R4.3'> portability defined by DE_Ecosystem_req_Def {
            doc Description
            /* Portability */
            subject DE_Ecosystem = DETECT_Input::de_ecosystem;
            attribute redefines weight =
                if DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Small
                    ?    0.25
                    else if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Medium
                    ?    0.25
                    else if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Large
                    ?    0.25
                    else 0.0;

            assume constraint {
                DETECT_Input::de_ecosystem.system_size ==
                DETECT_enumerations::Ecosystem_size_e::Large or
                DETECT_Input::de_ecosystem.system_size ==
                DETECT_enumerations::Ecosystem_size_e::Medium or
                DETECT_Input::de_ecosystem.system_size ==
                DETECT_enumerations::Ecosystem_size_e::Small
            }

            requirement <'R4.3.1'> port_offline defined by DE_Ecosystem_req_Def {
                doc Description
                /* The DE ecosystem shall support offline retrieval of TBD applicable data types and TBD applicable information formats */
                subject DE_Ecosystem = DETECT_Input::de_ecosystem;
                attribute redefines weight =
                    if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Large
                        ?    0.125
                        else 0.0;
                assume constraint {
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large
                }
            }
            requirement <'R4.3.2'> port_export_directly defined by DE_Ecosystem_req_Def {
                doc Description
                /* The DE ecosystem shall enable the export of data directly to applicable productivity software */
                subject DE_Ecosystem = DETECT_Input::de_ecosystem;
                attribute redefines weight =
                    if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Small
                        ?    0.5
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Medium
                        ?    0.25
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Large
                        ?    0.125
                        else 0.0;
                assume constraint {
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Medium or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Small
                }
            }
            requirement <'R4.3.3'> port_VMs defined by DE_Ecosystem_req_Def {
                doc Description
                /* The DE ecosystem shall provide portability of applications through Virtual Machines (VMs) and other applicable virtual means */
                subject DE_Ecosystem = DETECT_Input::de_ecosystem;
                attribute redefines weight =
                    if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Medium
                        ?    0.25
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Large
                        ?    0.125
                        else 0.0;
                assume constraint {
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Medium
                }
            }
            requirement <'R4.3.4'> port_export defined by DE_Ecosystem_req_Def {
                doc Description
                /* The DE ecosystem shall provide capability to export prototyped ecosystem improvements for reuse */
                subject DE_Ecosystem = DETECT_Input::de_ecosystem;
                attribute redefines weight =
                    if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Large
                        ?    0.125
                        else 0.0;
                assume constraint {
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large
                }
            }
        }

        requirement <'R4.4'> support defined by DE_Ecosystem_req_Def {
            doc Description
            /* Support */
            subject DE_Ecosystem = DETECT_Input::de_ecosystem;
            attribute redefines weight =
                if DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Small
                    ?    0.25
                    else if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Medium
                    ?    0.25
                    else if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Large
                    ?    0.25
                    else 0.0;
            assume constraint {
                DETECT_Input::de_ecosystem.system_size ==
                DETECT_enumerations::Ecosystem_size_e::Large or
                DETECT_Input::de_ecosystem.system_size ==
                DETECT_enumerations::Ecosystem_size_e::Medium or
                DETECT_Input::de_ecosystem.system_size ==
                DETECT_enumerations::Ecosystem_size_e::Small
            }

            requirement <'R4.4.1'> support_checkout defined by DE_Ecosystem_req_Def {
                doc Description
                /* The DE ecosystem shall provide for a formal, automated checkout of all applications and data */
                subject DE_Ecosystem = DETECT_Input::de_ecosystem;
                attribute redefines weight =
                    if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Medium
                        ?    0.0833
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Large
                        ?    0.0714
                        else 0.0;
                assume constraint {
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Medium
                }
            }
            requirement <'R4.4.2'> support_automation defined by DE_Ecosystem_req_Def {
                doc Description
                /* The DE ecosystem shall provide and support growth of automation and autonomous artifact generation */
                subject DE_Ecosystem = DETECT_Input::de_ecosystem;
                attribute redefines weight =
                    if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Medium
                        ?    0.0833
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Large
                        ?    0.0714
                        else 0.0;
                assume constraint {
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Medium
                }
            }
            requirement <'R4.4.3'> 'support_non-technical' defined by DE_Ecosystem_req_Def {
                doc Description
                /* The DE ecosystem shall incorporate mechanisms to support integrated workflows for managing non-technical programmatic work in progress, separate from released work product */
                subject DE_Ecosystem = DETECT_Input::de_ecosystem;
                attribute redefines weight =
                    if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Medium
                        ?    0.0833
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Large
                        ?    0.0714
                        else 0.0;
                assume constraint {
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Medium
                }
            }
            requirement <'R4.4.4'> auto_generated defined by DE_Ecosystem_req_Def {
                doc Description
                /* The DE ecosystem shall provide documentation and reference guidance describing the physical and virtual bounds of the ecosystem for ease and efficient user understanding of the ecosystem */
                subject DE_Ecosystem = DETECT_Input::de_ecosystem;
                attribute redefines weight =
                    if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Medium
                        ?    0.0833
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Large
                        ?    0.0714
                        else 0.0;
                assume constraint {
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Medium
                }
            }
            requirement <'R4.4.5'> support_query defined by DE_Ecosystem_req_Def {
                doc Description
                /* The DE ecosystem shall provide a query capability to search, locate, and access programmatic and engineering products by all authenticated users and stakeholders */
                subject DE_Ecosystem = DETECT_Input::de_ecosystem;
                attribute redefines weight =
                    if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Small
                        ?    0.5
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Medium
                        ?    0.0833
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Large
                        ?    0.0714
                        else 0.0;
                assume constraint {
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Medium or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Small
                }
            }
            requirement <'R4.4.6'> support_technical defined by DE_Ecosystem_req_Def {
                doc Description
                /* The DE ecosystem shall incorporate mechanisms to support integrated workflows for managing technical work in progress separate from released work product */
                subject DE_Ecosystem = DETECT_Input::de_ecosystem;
                attribute redefines weight =
                    if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Medium
                        ?    0.0833
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Large
                        ?    0.0714
                        else 0.0;
                assume constraint {
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Medium
                }
            }
            requirement <'R4.4.7'> support_requirements defined by DE_Ecosystem_req_Def {
                doc Description
                /* The DE ecosystem shall incorporate model centric workflows throughout the development life-cycle, from requirements definition, through requirements selloff and support of production, deployment, operation and sustainment life-cycle phases */
                subject DE_Ecosystem = DETECT_Input::de_ecosystem;
                attribute redefines weight =
                    if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Large
                        ?    0.0714
                        else 0.0;
                assume constraint {
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large
                }
            }
        }
    }

    requirement <R5> infrastructure defined by DE_Ecosystem_req_Def {
        doc Description
        /* Infrastructure */
        subject DE_Ecosystem = DETECT_Input::de_ecosystem;
        attribute redefines weight =
            if DETECT_Input::de_ecosystem.system_size ==
                DETECT_enumerations::Ecosystem_size_e::Small
                ?    0.1667
                else if DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Medium
                ?    0.1667
                else if DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large
                ?    0.1667
                else 0.0;
        assume constraint {
            DETECT_Input::de_ecosystem.system_size ==
            DETECT_enumerations::Ecosystem_size_e::Large or
            DETECT_Input::de_ecosystem.system_size ==
            DETECT_enumerations::Ecosystem_size_e::Medium or
            DETECT_Input::de_ecosystem.system_size == DETECT_enumerations::Ecosystem_size_e::Small
        }

        requirement <'R5.1'> software defined by DE_Ecosystem_req_Def {
            doc Description
            /* Software */
            subject DE_Ecosystem = DETECT_Input::de_ecosystem;
            attribute redefines weight =
                if DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Small
                    ?    0.5
                    else if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Medium
                    ?    0.3333
                    else if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Large
                    ?    0.3333
                    else 0.0;
            assume constraint {
                DETECT_Input::de_ecosystem.system_size ==
                DETECT_enumerations::Ecosystem_size_e::Large or
                DETECT_Input::de_ecosystem.system_size ==
                DETECT_enumerations::Ecosystem_size_e::Medium or
                DETECT_Input::de_ecosystem.system_size ==
                DETECT_enumerations::Ecosystem_size_e::Small
            }

            requirement <'R5.1.1'> sw_tools defined by DE_Ecosystem_req_Def {
                doc Description
                /* The DE ecosystem shall accommodate implementation of commercial off-the-shelf, custom, open source, and free-ware tools */
                subject DE_Ecosystem = DETECT_Input::de_ecosystem;
                attribute redefines weight =
                    if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Small
                        ?    0.5
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Medium
                        ?    0.1667
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Large
                        ?    0.1667
                        else 0.0;
                assume constraint {
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Medium or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Small
                }
            }
            requirement <'R5.1.2'> sw_access_legacy defined by DE_Ecosystem_req_Def {
                doc Description
                /* The DE ecosystem shall enable access to legacy modeling software and tools required to support engineering life-cycle activities */
                subject DE_Ecosystem = DETECT_Input::de_ecosystem;
                attribute redefines weight =
                    if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Medium
                        ?    0.1667
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Large
                        ?    0.1667
                        else 0.0;
                assume constraint {
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Medium
                }
            }
            requirement <'R5.1.3'> sw_ATO defined by DE_Ecosystem_req_Def {
                doc Description
                /* The DE ecosystem shall establish a mechanism to enable ATO reciprocity for widely adopted and approved software tools use */
                subject DE_Ecosystem = DETECT_Input::de_ecosystem;
                attribute redefines weight =
                    if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Medium
                        ?    0.1667
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Large
                        ?    0.1667
                        else 0.0;
                assume constraint {
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Medium
                }
            }
        }
        requirement <'R5.2'> networks defined by DE_Ecosystem_req_Def {
            doc Description
            /* Networks */
            subject DE_Ecosystem = DETECT_Input::de_ecosystem;
            attribute redefines weight =
                if DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Medium
                    ?    0.3333
                    else if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Large
                    ?    0.3333
                    else 0.0;
            assume constraint {
                DETECT_Input::de_ecosystem.system_size ==
                DETECT_enumerations::Ecosystem_size_e::Large or
                DETECT_Input::de_ecosystem.system_size ==
                DETECT_enumerations::Ecosystem_size_e::Medium
            }

            requirement <'R5.2.1'> networks_secure defined by DE_Ecosystem_req_Def {
                doc Description
                /* The DE ecosystem shall provide extensibility for secure connections to Federally Funded Research Centers (FFRDCs) */
                subject DE_Ecosystem = DETECT_Input::de_ecosystem;
                attribute redefines weight =
                    if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Large
                        ?    0.125
                        else 0.0;
                assume constraint {
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large
                }
            }
            requirement <'R5.2.2'> networks_classified defined by DE_Ecosystem_req_Def {
                doc Description
                /* The DE ecosystem shall provide extensibility with interoperability to both unclassified and classified Tri-Service and other defense networks */
                subject DE_Ecosystem = DETECT_Input::de_ecosystem;
                attribute redefines weight =
                    if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Large
                        ?    0.125
                        else 0.0;
                assume constraint {
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large
                }
            }
            requirement <'R5.2.3'> networks_remote defined by DE_Ecosystem_req_Def {
                doc Description
                /* The DE ecosystem shall support connectivity to remote, off-line, and geographically dispersed locations, throughout the development life-cycle and going into production, operations, and sustainment phases */
                subject DE_Ecosystem = DETECT_Input::de_ecosystem;
                attribute redefines weight =
                    if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Medium
                        ?    0.5
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Large
                        ?    0.125
                        else 0.0;
                assume constraint {
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Medium
                }
            }
            requirement <'R5.2.4'> networks_industry_academia defined by DE_Ecosystem_req_Def {
                doc Description
                /* The DE ecosystem shall provide extensibility with interoperability to applicable non-secure and secure connections to industry , academia and OCONUS networks */
                subject DE_Ecosystem = DETECT_Input::de_ecosystem;
                attribute redefines weight =
                    if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Large
                        ?    0.125
                        else 0.0;
                assume constraint {
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large
                }
            }
        }
        requirement <'R5.3'> hardwre defined by DE_Ecosystem_req_Def {
            doc Description
            /* Hardware/Computing */
            subject DE_Ecosystem = DETECT_Input::de_ecosystem;
            attribute redefines weight =
                if DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Small
                    ?    0.5
                    else if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Medium
                    ?    0.3333
                    else if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Large
                    ?    0.3333
                    else 0.0;
            assume constraint {
                DETECT_Input::de_ecosystem.system_size ==
                DETECT_enumerations::Ecosystem_size_e::Large or
                DETECT_Input::de_ecosystem.system_size ==
                DETECT_enumerations::Ecosystem_size_e::Medium or
                DETECT_Input::de_ecosystem.system_size ==
                DETECT_enumerations::Ecosystem_size_e::Small
            }

            requirement <'R5.3.1'> hw_productivity defined by DE_Ecosystem_req_Def {
                doc Description
                /* The DE ecosystem shall provide local basic engineering productivity computing and analysis capabilities, applicable for localized engineering scoped activities */
                subject DE_Ecosystem = DETECT_Input::de_ecosystem;
                attribute redefines weight =
                    if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Medium
                        ?    0.25
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Large
                        ?    0.1667
                        else 0.0;
                assume constraint {
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Medium
                }
            }
            requirement <'R5.3.2'> hw_IT_approved defined by DE_Ecosystem_req_Def {
                doc Description
                /* The DE ecosystem shall be implemented and maintained with approved IT hardware and software */
                subject DE_Ecosystem = DETECT_Input::de_ecosystem;
                attribute redefines weight =
                    if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Small
                        ?    0.5
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Medium
                        ?    0.25
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Large
                        ?    0.1667
                        else 0.0;
                assume constraint {
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Medium or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Small
                }
            }
            requirement <'R5.3.3'> hw_computing defined by DE_Ecosystem_req_Def {
                doc Description
                /* The DE ecosystem shall accommodate expansion of compute capabilities to support high-performance data analysis and computing power. */
                subject DE_Ecosystem = DETECT_Input::de_ecosystem;
                attribute redefines weight =
                    if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Large
                        ?    0.1667
                        else 0.0;
                assume constraint {
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large
                }
            }
        }
    }

    requirement <R6> security defined by DE_Ecosystem_req_Def {
        doc Description
        /* Security */
        subject DE_Ecosystem = DETECT_Input::de_ecosystem;
        attribute redefines weight =
            if DETECT_Input::de_ecosystem.system_size ==
                DETECT_enumerations::Ecosystem_size_e::Small
                ?    0.1667
                else if DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Medium
                ?    0.1667
                else if DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large
                ?    0.1667
                else 0.0;
        assume constraint {
            DETECT_Input::de_ecosystem.system_size ==
            DETECT_enumerations::Ecosystem_size_e::Large or
            DETECT_Input::de_ecosystem.system_size ==
            DETECT_enumerations::Ecosystem_size_e::Medium or
            DETECT_Input::de_ecosystem.system_size == DETECT_enumerations::Ecosystem_size_e::Small
        }

        requirement <'R6.1'> classification defined by DE_Ecosystem_req_Def {
            doc Description
            /* Classification */
            subject DE_Ecosystem = DETECT_Input::de_ecosystem;
            attribute redefines weight =
                if DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Small
                    ?    0.3333
                    else if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Medium
                    ?    0.3333
                    else if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Large
                    ?    0.3333
                    else 0.0;
            assume constraint {
                DETECT_Input::de_ecosystem.system_size ==
                DETECT_enumerations::Ecosystem_size_e::Large or
                DETECT_Input::de_ecosystem.system_size ==
                DETECT_enumerations::Ecosystem_size_e::Medium or
                DETECT_Input::de_ecosystem.system_size ==
                DETECT_enumerations::Ecosystem_size_e::Small
            }

            requirement <'R6.1.1'> class_ops_secret defined by DE_Ecosystem_req_Def {
                doc Description
                /* The DE ecosystem shall support operations in a Secret environment */
                subject DE_Ecosystem = DETECT_Input::de_ecosystem;
                attribute redefines weight =
                    if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Medium
                        ?    0.0833
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Large
                        ?    0.0714
                        else 0.0;
                assume constraint {
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Medium
                }
            }
            requirement <'R6.1.2'> class_ops_top_secret defined by DE_Ecosystem_req_Def {
                doc Description
                /* The DE ecosystem shall support operations in a Top Secret environment */
                subject DE_Ecosystem = DETECT_Input::de_ecosystem;
                attribute redefines weight =
                    if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Medium
                        ?    0.0833
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Large
                        ?    0.0714
                        else 0.0;
                assume constraint {
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Medium
                }
            }
            requirement <'R6.1.3'> class_ops_closed defined by DE_Ecosystem_req_Def {
                doc Description
                /* The DE ecosystem shall support operations in a closed community controlled applicable environment */
                subject DE_Ecosystem = DETECT_Input::de_ecosystem;
                attribute redefines weight =
                    if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Small
                        ?    0.1667
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Medium
                        ?    0.0833
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Large
                        ?    0.0714
                        else 0.0;
                assume constraint {
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Medium or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Small
                }
            }
            requirement <'R6.1.4'> class_promote_review defined by DE_Ecosystem_req_Def {
                doc Description
                /* The DE ecosystem shall have the capability to promote/demote classifications with a minimum two cleared person adjudication review */
                subject DE_Ecosystem = DETECT_Input::de_ecosystem;
                attribute redefines weight =
                    if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Medium
                        ?    0.0833
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Large
                        ?    0.0714
                        else 0.0;
                assume constraint {
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Medium
                }
            }
            requirement <'R6.1.5'> class_promote_auto defined by DE_Ecosystem_req_Def {
                doc Description
                /* The DE ecosystem shall provide extensibility for approved automation to promote/demote classifications */
                subject DE_Ecosystem = DETECT_Input::de_ecosystem;
                attribute redefines weight =
                    if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Large
                        ?    0.0714
                        else 0.0;
                assume constraint {
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large
                }
            }
            requirement <'R6.1.6'> class_ops_unclassified defined by DE_Ecosystem_req_Def {
                doc Description
                /* The DE ecosystem shall support operations in an Unclassified environment */
                subject DE_Ecosystem = DETECT_Input::de_ecosystem;
                attribute redefines weight =
                    if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Small
                        ?    0.1667
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Medium
                        ?    0.0833
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Large
                        ?    0.0714
                        else 0.0;
                assume constraint {
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Medium or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Small
                }
            }
            requirement <'R6.1.7'> class_promote defined by DE_Ecosystem_req_Def {
                doc Description
                /* The DE ecosystem shall provide extensibility to accommodate bi-directional classification translation (Promote/Demote) in a multiple-level-security environment */
                subject DE_Ecosystem = DETECT_Input::de_ecosystem;
                attribute redefines weight =
                    if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Small
                        ?    0.1667
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Medium
                        ?    0.0833
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Large
                        ?    0.0714
                        else 0.0;
                assume constraint {
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Medium or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Small
                }
            }
        }

        requirement <'R6.2'> access defined by DE_Ecosystem_req_Def {
            doc Description
            /* Access Control */
            subject DE_Ecosystem = DETECT_Input::de_ecosystem;
            attribute redefines weight =
                if DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Small
                    ?    0.3333
                    else if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Medium
                    ?    0.3333
                    else if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Large
                    ?    0.3333
                    else 0.0;
            assume constraint {
                DETECT_Input::de_ecosystem.system_size ==
                DETECT_enumerations::Ecosystem_size_e::Large or
                DETECT_Input::de_ecosystem.system_size ==
                DETECT_enumerations::Ecosystem_size_e::Medium or
                DETECT_Input::de_ecosystem.system_size ==
                DETECT_enumerations::Ecosystem_size_e::Small
            }

            requirement <'R6.2.1'> access_data defined by DE_Ecosystem_req_Def {
                doc Description
                /* The DE ecosystem shall provide authorized users access to models and associated data */
                subject DE_Ecosystem = DETECT_Input::de_ecosystem;
                attribute redefines weight =
                    if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Small
                        ?    0.1
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Medium
                        ?    0.0556
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Large
                        ?    0.0556
                        else 0.0;
                assume constraint {
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Medium or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Small
                }
            }
            requirement <'R6.2.2'> access_two_factor defined by DE_Ecosystem_req_Def {
                doc Description
                /* The DE ecosystem shall provide a two-factor authentication sign-on to the system */
                subject DE_Ecosystem = DETECT_Input::de_ecosystem;
                attribute redefines weight =
                    if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Small
                        ?    0.1
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Medium
                        ?    0.0556
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Large
                        ?    0.0556
                        else 0.0;
                assume constraint {
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Medium or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Small
                }
            }
            requirement <'R6.2.3'> access_modify_data defined by DE_Ecosystem_req_Def {
                doc Description
                /* The DE ecosystem shall provide authorized users privileges to modify models */
                subject DE_Ecosystem = DETECT_Input::de_ecosystem;
                attribute redefines weight =
                    if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Small
                        ?    0.1
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Medium
                        ?    0.0556
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Large
                        ?    0.0556
                        else 0.0;
                assume constraint {
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Medium or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Small
                }
            }
            requirement <'R6.2.4'> access_knowledge_transfer defined by DE_Ecosystem_req_Def {
                doc Description
                /* The DE ecosystem shall  provide accessible areas designated for knowledge transfer */
                subject DE_Ecosystem = DETECT_Input::de_ecosystem;
                attribute redefines weight =
                    if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Medium
                        ?    0.0556
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Large
                        ?    0.0556
                        else 0.0;
                assume constraint {
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Medium
                }
            }
            requirement <'R6.2.5'> access_NIST_access_control defined by DE_Ecosystem_req_Def {
                doc Description
                /* The DE ecosystem shall provide automated capability for managing access controls consistent with NIST access control guidance */
                subject DE_Ecosystem = DETECT_Input::de_ecosystem;
                attribute redefines weight =
                    if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Medium
                        ?    0.0556
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Large
                        ?    0.0556
                        else 0.0;
                assume constraint {
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Medium
                }
            }
            requirement <'R6.2.6'> access_new_users defined by DE_Ecosystem_req_Def {
                doc Description
                /* The DE ecosystem shall accommodate new user account approvals in less than TBD (days, hrs, minutes) */
                subject DE_Ecosystem = DETECT_Input::de_ecosystem;
                attribute redefines weight =
                    if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Small
                        ?    0.1
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Medium
                        ?    0.0556
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Large
                        ?    0.0556
                        else 0.0;
                assume constraint {
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Medium or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Small
                }
            }
            requirement <'R6.2.7'> 'accesss_sign-on' defined by DE_Ecosystem_req_Def {
                doc Description
                /* The DE ecosystem shall provide applicable CAC enabled sign-on or single sign-on capability for all authenticated users */
                subject DE_Ecosystem = DETECT_Input::de_ecosystem;
                attribute redefines weight =
                    if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Small
                        ?    0.1
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Medium
                        ?    0.0556
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Large
                        ?    0.0556
                        else 0.0;
                assume constraint {
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Medium or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Small
                }
            }
            requirement <'R6.2.8'> access_NIST_authentication defined by DE_Ecosystem_req_Def {
                doc Description
                /* The DE ecosystem shall comply with all applicable NIST Access Control guidance for identification and authentication of users and all network accesses */
                subject DE_Ecosystem = DETECT_Input::de_ecosystem;
                attribute redefines weight =
                    if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Medium
                        ?    0.0556
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Large
                        ?    0.0556
                        else 0.0;
                assume constraint {
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Medium
                }
            }
            requirement <'R6.2.9'> access_authoritative_data defined by DE_Ecosystem_req_Def {
                doc Description
                /* The DE ecosystem shall provide access for stakeholders and end users to all authoritative data and information at the appropriate classification level of the end user */
                subject DE_Ecosystem = DETECT_Input::de_ecosystem;
                attribute redefines weight =
                    if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Medium
                        ?    0.0556
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Large
                        ?    0.0556
                        else 0.0;
                assume constraint {
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Medium
                }
            }
        }

        requirement <'R6.3'> cybersecurity defined by DE_Ecosystem_req_Def {
            doc Description
            /* Cybersecurity */
            subject DE_Ecosystem = DETECT_Input::de_ecosystem;
            attribute redefines weight =
                if DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Small
                    ?    0.3333
                    else if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Medium
                    ?    0.3333
                    else if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Large
                    ?    0.3333
                    else 0.0;
            assume constraint {
                DETECT_Input::de_ecosystem.system_size ==
                DETECT_enumerations::Ecosystem_size_e::Large or
                DETECT_Input::de_ecosystem.system_size ==
                DETECT_enumerations::Ecosystem_size_e::Medium or
                DETECT_Input::de_ecosystem.system_size ==
                DETECT_enumerations::Ecosystem_size_e::Small
            }

            requirement <'R6.3.1'> cyber_ATO defined by DE_Ecosystem_req_Def {
                doc Description
                /* The DE ecosystem design shall support and enable authority to operate (ATO) requests within (TBD) working days */
                subject DE_Ecosystem = DETECT_Input::de_ecosystem;
                attribute redefines weight =
                    if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Small
                        ?    0.1667
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Medium
                        ?    0.1667
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Large
                        ?    0.125
                        else 0.0;
                assume constraint {
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Medium or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Small
                }
            }
            requirement <'R6.3.2'> cyber_IA defined by DE_Ecosystem_req_Def {
                doc Description
                /* The DE ecosystem shall  comply with applicable Information Assurance (IA) Risk Management Framework (RMF) requirements */
                subject DE_Ecosystem = DETECT_Input::de_ecosystem;
                attribute redefines weight =
                    if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Small
                        ?    0.1667
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Medium
                        ?    0.1667
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Large
                        ?    0.125
                        else 0.0;
                assume constraint {
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Medium or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Small
                }
            }
            requirement <'R6.3.3'> cyber_ATO_auto defined by DE_Ecosystem_req_Def {
                doc Description
                /* The DE ecosystem design shall provide extensibility to automate authority to operate (ATO) requests */
                subject DE_Ecosystem = DETECT_Input::de_ecosystem;
                attribute redefines weight =
                    if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Large
                        ?    0.125
                        else 0.0;
                assume constraint {
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large
                }
            }
            requirement <'R6.3.4'> cyber_CUI defined by DE_Ecosystem_req_Def {
                doc Description
                /* The DE ecosystem shall provide for Controlled Unclassified Information (CUI) and proprietary information segregation */
                subject DE_Ecosystem = DETECT_Input::de_ecosystem;
                attribute redefines weight =
                    if DETECT_Input::de_ecosystem.system_size ==
                        DETECT_enumerations::Ecosystem_size_e::Small
                        ?    0.1667
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Medium
                        ?    0.1667
                        else if DETECT_Input::de_ecosystem.system_size ==
                            DETECT_enumerations::Ecosystem_size_e::Large
                        ?    0.125
                        else 0.0;
                assume constraint {
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Large or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Medium or
                    DETECT_Input::de_ecosystem.system_size ==
                    DETECT_enumerations::Ecosystem_size_e::Small
                }
            }
        }
    }
}
