package DETECT_Input_Job_Series {
    doc
    /* User Input File for UC3.
     * Instructions: Set the boolean value to 'true' if your DE ecosystem 
     * needs to support that specific job series.
     */

    private import DETECT_Job_Series::*; 

    part job_series_tool_profile : Job_Series_Profile { 
        
        item :>> inputs {

            attribute :>> 'Engineering and Architecture'.role_general_engineering = false;
            attribute :>> 'Engineering and Architecture'.role_safety_engineering = false;
            attribute :>> 'Engineering and Architecture'.role_materials_engineering = false;
            attribute :>> 'Engineering and Architecture'.role_mechanical_engineering = false;
            attribute :>> 'Engineering and Architecture'.role_nuclear_engineering = false;
            attribute :>> 'Engineering and Architecture'.role_electrical_engineering = false;
            attribute :>> 'Engineering and Architecture'.role_computer_engineering = false;
            attribute :>> 'Engineering and Architecture'.role_aerospace_engineering = false;
            attribute :>> 'Engineering and Architecture'.role_chemical_engineering = false;
            attribute :>> 'Engineering and Architecture'.role_industrial_engineering = false;

            attribute :>> 'Physical Sciences'.role_physics = false;
            attribute :>> 'Physical Sciences'.role_chemistry = false;

            attribute :>> 'Mathematical Sciences'.role_general_mathematics_and_statistics = false;
            attribute :>> 'Mathematical Sciences'.role_operations_research = false;
            attribute :>> 'Mathematical Sciences'.role_computer_science = false;
        }
    }
}
