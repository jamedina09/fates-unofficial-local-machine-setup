#!/bin/bash

rm -rf /Users/MedinaJA/projects/scratch/E3SM_FATES_TEST
rm -rf /Users/MedinaJA/projects/archive/E3SM_FATES_TEST

# Set up base directories
HOME_DIR="$HOME"
PROJECTS_DIR="$HOME_DIR/projects"
E3SM_VERSION="E3SM_069c226"
SCRATCH_DIR="$PROJECTS_DIR/scratch"
E3SM_DIR="$HOME_DIR/$E3SM_VERSION"
CIME_DIR="$E3SM_DIR/cime/scripts"
CASE_NAME="E3SM_FATES_TEST"
CASE_DIR="$SCRATCH_DIR/$CASE_NAME"
ARCHIVE_DIR="$PROJECTS_DIR/archive/$CASE_NAME"
CESM_INPUT_DIR="$PROJECTS_DIR/inputdata"
CLMFORC_DIR="$CESM_INPUT_DIR/atm/datm7" # Adjust this path if needed

# Change to CIME scripts directory
cd "$CIME_DIR" || exit 1

# Set model and component parameters
CIME_MODEL="e3sm"
COMP="2000_DATM%QIA_ELM%BGC-FATES_SICE_SOCN_SROF_SGLC_SWAV"
RES="1x1_brazil"
MACH="SI"
COMPILER="gnu"

# Create new case
./create_newcase --case "$CASE_DIR" --res "$RES" --compset "$COMP" --machine "$MACH" --compiler=${COMPILER}
# --debug
# --driver mct 

# Print debug information (very verbose) to file /Users/MedinaJA/E3SM_069c226/cime/scripts/create_newcase.log
# Change to the case directory
cd "$CASE_DIR" || exit 1

# Change XML settings (some settings for a 1-year run)
xmlchanges=(
    "STOP_N=1"
    "RUN_STARTDATE=2001-01-01"
    "STOP_OPTION=nyears"
    "DATM_CLMNCEP_YR_START=1996"
    "DATM_CLMNCEP_YR_END=1997"
    "ELM_FORCE_COLDSTART=on"
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

./xmlchange PIO_VERSION=2
./xmlchange NTASKS_ATM=1
./xmlchange NTASKS_CPL=1
./xmlchange NTASKS_GLC=1
./xmlchange NTASKS_OCN=1
./xmlchange NTASKS_WAV=1
./xmlchange NTASKS_ICE=1
./xmlchange NTASKS_LND=1
./xmlchange NTASKS_ROF=1
./xmlchange NTASKS_ESP=1
./xmlchange ROOTPE_ATM=0
./xmlchange ROOTPE_CPL=0
./xmlchange ROOTPE_GLC=0
./xmlchange ROOTPE_OCN=0
./xmlchange ROOTPE_WAV=0
./xmlchange ROOTPE_ICE=0
./xmlchange ROOTPE_LND=0
./xmlchange ROOTPE_ROF=0
./xmlchange ROOTPE_ESP=0
./xmlchange NTHRDS_ATM=1
./xmlchange NTHRDS_CPL=1
./xmlchange NTHRDS_GLC=1
./xmlchange NTHRDS_OCN=1
./xmlchange NTHRDS_WAV=1
./xmlchange NTHRDS_ICE=1
./xmlchange NTHRDS_LND=1
./xmlchange NTHRDS_ROF=1
./xmlchange NTHRDS_ESP=1


# Set up the case
./case.setup
#   -d, --debug           Print debug information (very verbose) to file /Users/MedinaJA/projects/scratch/E3SM_FATES_TEST/case.setup.log

# Preview and check input data
# ./preview_run
# ./preview_namelists
# ./check_input_data --download

# Build the case
./case.build --debug
#  --debug --verbose --separate-builds --ninja
#   -d, --debug           Print debug information (very verbose) to file /Users/MedinaJA/projects/scratch/E3SM_FATES_TEST/case.build.log

# # Submit the case to run
# ./case.submit

# # Change to the archive directory for output processing
# ARCHIVE_HIST_DIR="$ARCHIVE_DIR/lnd/hist"
# if [[ ! -d "$ARCHIVE_HIST_DIR" ]]; then
#     echo "Error: Archive history directory not found at $ARCHIVE_HIST_DIR"
#     exit 1
# fi

# cd "$ARCHIVE_HIST_DIR" || exit 1

# # Concatenate output files
# ncrcat *.h0.*.nc "Aggregated_${CASE_NAME}_Output.nc"
