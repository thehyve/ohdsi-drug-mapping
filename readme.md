Drug mapping
============

The drug mapping scripts are executed with execute_drug_mapping.sh

### Dependencies:
 - psql installed
 - Initialized the vocabulary of the `OMOP CDM v5`.
 - No password on the local database
 - The two input csv datasets (products and frequencies) should be in the folder `input_datasets` 

Execute the drug mapping with the following commands:  
`chmod u+x execute_drug_mapping.sh`  
`sh execute_drug_mapping.sh <databasename>`  (Linux/Mac)
`execute_drug_mappings.bat <databasename>` (Windows)
