#!/bin/bash
#Wtf, je mag geen spaties rond '=' teken doen...

DATABASE_NAME="$1"

echo "Starting the automatic drug mapping with Postgresql."
echo "Using the database '$DATABASE_NAME', public schema."

echo
echo "Loading the auh source data and mappings..."
psql $DATABASE_NAME -c "CREATE SCHEMA IF NOT EXISTS auh;"
psql $DATABASE_NAME -f loadAUHdata.sql
psql $DATABASE_NAME -f loadManualMappings.sql

echo
echo "Creating mappings..."
# Preparation for actual mappings. Important order
psql $DATABASE_NAME -c "CREATE SCHEMA IF NOT EXISTS map;"
printf "ATC to RxNorm: "
psql $DATABASE_NAME -f map_atcToRxNorm.sql
printf "Varenr to RxNorm: "
psql $DATABASE_NAME -f map_varenr_to_ingredient.sql
printf "Single ingredient drugs: "
psql $DATABASE_NAME -f create_drug_strength_single_ingredient.sql

# Mappings to different levels. Order of execution not important
printf "Varenr to Drug Component: "
psql $DATABASE_NAME -f map_varenr_to_component.sql
printf "Varenr to Drug Form: "
psql $DATABASE_NAME -f map_varenr_to_drug_form.sql
printf "Varenr to Clinical Drug: "
psql $DATABASE_NAME -f map_varenr_to_clinical_drug.sql

echo
echo "Combining mappings..."
# Last step
psql $DATABASE_NAME -f unify_vnr_mappings.sql

echo
echo "Statistics:"
# Stats
psql $DATABASE_NAME -f stats_complete_mapping.sql

# Export
echo "Export to exports/complete_mapping.csv"
psql $DATABASE_NAME -f export_complete_mapping.sql
