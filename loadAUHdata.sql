/* Copy source data to sql table */

/* "AUH Medication Varenr and frequencies.xlsx" */
CREATE TABLE IF NOT EXISTS AUH_FREQUENCIES (
  vnr INTEGER PRIMARY KEY,
  frequency INTEGER,
  emptyone varchar(1), -- Excel exports some additional empty rows.
  emptytwo varchar(1),
  emptythree varchar(1)
);

/* "mapping ATC.csv" */
CREATE TABLE IF NOT EXISTS AUH_PRODUCTS (
    vnr INTEGER PRIMARY KEY,
    Pname VARCHAR(255),
    dosf_LT VARCHAR(255),
    Streng VARCHAR(255),
    packtext VARCHAR(255),
    DRUGID BIGINT, -- integer was not large enough
    strnum DECIMAL,
    strunut VARCHAR(255),
    PACKSIZE VARCHAR(255),
    ATC VARCHAR(9) -- 005-04-2016: no druglist to get to atc
);


COPY AUH_FREQUENCIES FROM '/Users/Maxim/Google Drive/Bedrijf/Projects/Janssen-OHDSI AUH/Execution/Drug_Mapping_Scripts/data_files/AUH Medication Varenr and frequencies.csv'
WITH CSV HEADER;
COPY AUH_PRODUCTS FROM '/Users/Maxim/Google Drive/Bedrijf/Projects/Janssen-OHDSI AUH/Execution/Drug_Mapping_Scripts/data_files/Lars_01042016_mapping_ATC.csv'
WITH CSV HEADER ENCODING 'windows-1252';
