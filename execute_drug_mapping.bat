REM Turn off echoing of the commands itself (the @ causes this command itself to not show)
@echo off

REM Take database name as input
set DATABASE_NAME="%1"

IF "%DATABASE_NAME%" == "" (
    ECHO "Please input a database name: "
    ECHO "./execute_drug_mapping.bat <database_name>"
    pauses
    EXIT
)

ECHO "Starting the automatic drug mapping with Postgresql."
ECHO "Using the database '%DATABASE_NAME%', public schema."

ECHO "Loading the auh source data and mappings..."
psql %DATABASE_NAME% -c "DROP SCHEMA IF EXISTS auh CASCADE;"
psql %DATABASE_NAME% -c "CREATE SCHEMA IF NOT EXISTS auh;"
psql %DATABASE_NAME% -f sql_map\loadAUHdata.sql
psql %DATABASE_NAME% -f sql_map\loadManualMappings.sql

ECHO "Creating mappings..."
REM Preparation for actual mappings. Important order

psql %DATABASE_NAME% -c "DROP SCHEMA IF EXISTS map CASCADE;"
psql %DATABASE_NAME% -c "CREATE SCHEMA IF NOT EXISTS map;"
ECHO "ATC to RxNorm: "
psql %DATABASE_NAME% -f sql_map\map_atcToRxNorm.sql
ECHO "Varenr to RxNorm: "
psql %DATABASE_NAME% -f sql_map\map_varenr_to_ingredient.sql
ECHO "Single ingredient drugs: "
psql %DATABASE_NAME% -f sql_map\create_drug_strength_single_ingredient.sql

REM Mappings to different levels. Order of execution not important

ECHO "Varenr to Drug Component: "
psql %DATABASE_NAME% -f sql_map\map_varenr_to_component.sql
ECHO "Varenr to Drug Form: "
psql %DATABASE_NAME% -f sql_map\map_varenr_to_drug_form.sql
ECHO "Varenr to Clinical Drug: "
psql %DATABASE_NAME% -f sql_map\map_varenr_to_clinical_drug.sql

ECHO "Combining mappings..."
psql %DATABASE_NAME% -f sql_map\map_unify_varenr_mappings.sql
REM Override drugs that are manually mapped
psql %DATABASE_NAME% -f sql_map\combine_manual_and_automated_mapping.sql

ECHO "Statistics:"
psql %DATABASE_NAME% -f sql_stats\stats_complete_mapping.sql

ECHO "Export to exports/complete_mapping.csv"
psql %DATABASE_NAME% -f sql_map\export_complete_mapping.sql
