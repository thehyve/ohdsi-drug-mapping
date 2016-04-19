/* Copy source data to auh schema of sql table */
-- 19-04-2016 switched to relative \copy. Let op: geen enters toegestaan

/* "AUH Medication Varenr and frequencies.xlsx" */
CREATE TABLE IF NOT EXISTS auh.frequencies (
  vnr INTEGER PRIMARY KEY,
  frequency INTEGER,
  emptyone varchar(1), -- Excel exports some additional empty rows.
  emptytwo varchar(1),
  emptythree varchar(1)
);
\copy auh.frequencies FROM 'input_datasets/AUH Medication Varenr and frequencies.csv' WITH CSV HEADER

/* "mapping ATC.csv" */
CREATE TABLE IF NOT EXISTS auh.products (
    vnr INTEGER PRIMARY KEY,
    Pname VARCHAR(255),
    dosf_LT VARCHAR(255),
    Streng VARCHAR(255),
    packtext VARCHAR(255),
    DRUGID BIGINT, -- integer was not large enough
    strnum DECIMAL,
    strunut VARCHAR(255),
    PACKSIZE VARCHAR(255),
    ATC VARCHAR(9) -- 05-04-2016: no druglist needed anymore to get to atc
);
\copy auh.products FROM 'input_datasets/mapping_ATC.csv' WITH CSV HEADER ENCODING 'windows-1252'
