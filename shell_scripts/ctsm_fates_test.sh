#!/bin/bash

# Make this script executable with: chmod +x ./xxx.sh

# Base directories
HOME_DIR="$HOME"
PROJECTS_DIR="$HOME_DIR/projects"
CTSM_VERSION="CTSM_5_1_dev160"
SCRATCH_DIR="$PROJECTS_DIR/scratch/$CTSM_VERSION"
CTSM_DIR="$HOME_DIR/$CTSM_VERSION"
CIME_DIR="$CTSM_DIR/cime/scripts"
# GDRIVE_SCIENCE_DIR="$HOME_DIR/GDrive_Science/1_FATES_CASES"
CESM_INPUT_DIR="$PROJECTS_DIR/inputdata"

# Specific paths
CASE_NAME="CTSM_FATES_TEST"
# CASE_SUBPATH="system_test/$CASE_NAME"
# CASE_DIR="$HOME_DIR/CASES_$CTSM_VERSION/$CASE_SUBPATH"
ARCHIVE_DIR="$SCRATCH_DIR/archive/$CASE_SUBPATH"
SCRATCH_CASE_DIR="$SCRATCH_DIR/$CASE_SUBPATH"

# Change to CIME scripts directory
cd "$CIME_DIR"

# Query configuration (commented out since they're not used)
# ./query_config --grids
# ./query_config --compsets clm

# Set model and component parameters
CIME_MODEL="cesm"
# COMP="I2000Clm51Fates"
COMP="2000_DATM%QIA_ELM%BGC-FATES_SICE_SOCN_SROF_SGLC_SWAV"
RES="1x1_brazil"
MACH="SI"

# Create new case
./create_newcase --case "$CASE_DIR" --res "$RES" --compset "$COMP" --machine "$MACH" --run-unsupported

# Change to the test case directory
cd "$CASE_DIR"

./xmlchange --id STOP_N --val 1
./xmlchange --id RUN_STARTDATE --val '2001-01-01'
./xmlchange --id STOP_OPTION --val nyears
./xmlchange --id DATM_CLMNCEP_YR_START --val 1996
./xmlchange --id DATM_CLMNCEP_YR_END --val 1997
./xmlchange --id CLM_FORCE_COLDSTART --val on

./case.setup

# ./preview_namelists
# ./check_input_data
# ./check_input_data --download

./case.build

./case.submit

# Change to the archive directory
cd "$ARCHIVE_DIR/lnd/hist"

# Concatenate output files
ncrcat *.h0.*.nc "Aggregated_${CASE_NAME}_Output.nc"

# View concatenated output
# ncvue "Aggregated_${CASE_NAME}_Output.nc"
