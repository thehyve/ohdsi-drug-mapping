Please read me.

The drug mapping is executed with execute_drug_mapping.sh

Dependencies:
 - psql installed
 - Initialized the vocabulary of the OMOP CDM v5.
 - No password on the local database
 - Two csv datasets should be in the folder input_datasets and two manual mapping files in manual_mappings"

dit geeft een probleem
Execute the drug mapping with the following commands:
    chmod u+x execute_drug_mapping.sh
    ./execute_drug_mapping.sh <databasename>
