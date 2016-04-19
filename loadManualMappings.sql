/* Load manual mappings */

-- Dose form
CREATE TABLE IF NOT EXISTS auh.map_dose_form (
   dosf_lt VARCHAR(255),
   frequency integer,
   dosf_lt_en VARCHAR(255),
   dose_concept_id integer,
   rxnorm_term VARCHAR(255),
   other_options VARCHAR(255),
   remarks VARCHAR(255)
);
\copy auh.map_dose_form FROM 'manual_mappings/dose_form_mapping.csv' WITH HEADER CSV

-- Units
CREATE TABLE IF NOT EXISTS auh.map_unit (
   strunut VARCHAR(255),
   concept_id integer,
   concept_name VARCHAR(255),
   num_unit_concept_id integer,
   denom_unit_concept_id integer
);
\copy auh.map_unit FROM 'manual_mappings/unit_mapping.csv' WITH HEADER CSV
