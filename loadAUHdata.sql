/* Copy source data to sql table */

/* "AUH Medication Varenr and frequencies.xlsx" */
CREATE TABLE IF NOT EXISTS auh_frequencies (
  vnr INTEGER PRIMARY KEY,
  frequency INTEGER,
  emptyone varchar(1), -- Excel exports some additional empty rows.
  emptytwo varchar(1),
  emptythree varchar(1)
);

/* "mapping ATC.csv" */
CREATE TABLE IF NOT EXISTS auh_products (
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

-- 19-04-2016 switched to relative \copy
\COPY auh_frequencies
FROM '/input_datasets/AUH Medication Varenr and frequencies.csv' WITH CSV HEADER;

\COPY auh_products
FROM '/input_datsets/mapping_ATC.csv' WITH CSV HEADER ENCODING 'windows-1252';
