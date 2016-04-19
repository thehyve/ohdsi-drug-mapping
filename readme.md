Please read me.

The drug mapping is executed with execute_drug_mapping.sh

Assumptions:
 - psql installed
 - Initialized the vocabulary of the OMOP CDM v5.
 - No password on the database
 - Two csv datasets should be in the folder input_datasets and two manual mapping files in manual_mappings"


Execute the drug mapping with the following commands:
    chmod u+x execute_drug_mapping.sh
    ./execute_drug_mapping.sh <databasename>
