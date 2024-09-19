#!/bin/bash

# Set up base directories
HOME_DIR="$HOME"
PROJECTS_DIR="$HOME_DIR/projects"
CTSM_VERSION="CTSM_5_1_dev160"
SCRATCH_DIR="$PROJECTS_DIR/scratch"
CTSM_DIR="$HOME_DIR/$CTSM_VERSION"
CIME_DIR="$CTSM_DIR/cime/scripts"
CASE_NAME="CTSM_FATES_TEST"
CASE_DIR="$SCRATCH_DIR/$CASE_NAME"
ARCHIVE_DIR="$PROJECTS_DIR/archive/$CASE_NAME"
CESM_INPUT_DIR="$PROJECTS_DIR/inputdata"
CLMFORC_DIR="$CESM_INPUT_DIR/atm/datm7" # Adjust this path if needed

# Change to CIME scripts directory
cd "$CIME_DIR" || exit 1

# Set model and component parameters
CIME_MODEL="cesm"
COMP="2000_DATM%GSWP3v1_CLM51%FATES_SICE_SOCN_MOSART_SGLC_SWAV"
RES="1x1_brazil"
MACH="SI"

# Create new case
./create_newcase --case "$CASE_DIR" --res "$RES" --compset "$COMP" --machine "$MACH" --run-unsupported

# Change to the case directory
cd "$CASE_DIR" || exit 1

# Change XML settings (some settings for a 1-year run)
xmlchanges=(
    "STOP_N=1"
    "RUN_STARTDATE=2001-01-01"
    "STOP_OPTION=nyears"
    "DATM_YR_START=1996"
    "DATM_YR_END=1997"
    "CLM_FORCE_COLDSTART=on"
    "DIN_LOC_ROOT=$CESM_INPUT_DIR"
    "DIN_LOC_ROOT_CLMFORC=$CLMFORC_DIR"
    "EXEROOT=$CASE_DIR/bld"
    "RUNDIR=$CASE_DIR/run"
    "DOUT_S_ROOT=$ARCHIVE_DIR"
)

# Apply XML changes
for change in "${xmlchanges[@]}"; do
    if ! ./xmlchange "$change"; then
        echo "Error: Failed to apply XML change: $change"
        exit 1
    fi
done

# Set up the case
./case.setup

# Preview and check input data
./preview_namelists
./check_input_data --download

# Build the case
./case.build

# Submit the case to run
./case.submit

# Change to the archive directory for output processing
ARCHIVE_HIST_DIR="$ARCHIVE_DIR/lnd/hist"
if [[ ! -d "$ARCHIVE_HIST_DIR" ]]; then
    echo "Error: Archive history directory not found at $ARCHIVE_HIST_DIR"
    exit 1
fi

cd "$ARCHIVE_HIST_DIR" || exit 1

# Concatenate output files
ncrcat *.h0.*.nc "Aggregated_${CASE_NAME}_Output.nc"
