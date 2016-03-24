/* Load translated dose forms from danish
   Translated in google sheets. Encoding errors manually corrected.*/

-- First export unique dose forms
COPY (
   SELECT dosf_lt, COUNT(*) as auh_freq
   FROM auh_products
   GROUP BY dosf_lt
   ORDER BY COUNT(*) DESC
) TO '/Users/Maxim/Documents/Drug_mapping_OHDSI/data_files/to_translate_dose_form.csv' WITH HEADER CSV;

/* DO TRANSLATION IN GOOGLE SHEETS */

-- Load data into new schema
CREATE TABLE IF NOT EXISTS auh_doses (
   dosf_lt VARCHAR(255),
   frequency integer,
   dosf_lt_corrected VARCHAR(255),
   dosf_lt_en VARCHAR(255)
);

COPY auh_doses
FROM '/Users/Maxim/Documents/Drug_mapping_OHDSI/data_files/translated_dose_form.csv' WITH HEADER CSV;
