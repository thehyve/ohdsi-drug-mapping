/* Copy source data to sql table */

/* "mapping Varenr.csv" */
CREATE TABLE IF NOT EXISTS AUH_PRODUCTS (
    vnr INTEGER PRIMARY KEY,
    Pname VARCHAR(255),
    Productname_en VARCHAR(255),
    dosf_LT VARCHAR(255),
    Streng VARCHAR(255),
    packtext VARCHAR(255),
    DRUGID BIGINT, -- integer was not large enough
    strnum VARCHAR(255),
    strunut VARCHAR(255),
    PACKSIZE VARCHAR(255)
);

/* "GodkendteLagemidler.xlsx" First tab ('Godkendte') */
CREATE TABLE IF NOT EXISTS AUH_DRUGLIST (
  Drugid BIGINT PRIMARY KEY,
  Navn VARCHAR(255),
  emptyone VARCHAR(1),
  Lægemiddelform VARCHAR(255),
  Styrketekst VARCHAR(255),
  AktiveSubstanser text, -- Values sometimes 1000+ char long.
  MftIndehaver VARCHAR(255),
  ATCkode VARCHAR(8),
  "Godkendt procedure" VARCHAR(20),
  "Godkendt rolle" VARCHAR(10),
  Registreringsdato VARCHAR(10),
  "Er i Medicinpriser" VARCHAR(3),
  emptytwo VARCHAR(1),
  emptythree VARCHAR(1)
);

/* "AUH Medication Varenr and frequencies.xlsx" */
CREATE TABLE IF NOT EXISTS AUH_FREQUENCIES (
  vnr INTEGER PRIMARY KEY,
  frequency INTEGER,
  emptyone varchar(1), -- Excel exports some additional empty rows.
  emptytwo varchar(1),
  emptythree varchar(1)
);


COPY AUH_PRODUCTS FROM '/Users/Maxim/Documents/Drug_mapping_OHDSI/mapping Varenr.csv' WITH CSV HEADER;
COPY AUH_DRUGLIST FROM '/Users/Maxim/Documents/Drug_mapping_OHDSI/GodkendteLagemidler.csv' WITH CSV HEADER;
COPY AUH_FREQUENCIES FROM '/Users/Maxim/Documents/Drug_mapping_OHDSI/AUH Medication Varenr and frequencies.csv' WITH CSV HEADER;
