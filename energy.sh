#!/bin/bash

# Absolute path to the MATLAB script
MATLAB_SCRIPT="/home/vikkk/MATLAB/Projects/filters/gaussian.m"

# Path to the MATLAB executable
MATLAB_CMD="/usr/local/MATLAB/R2024a/bin/matlab"

# Check if powerstat is installed
if ! command -v powerstat &> /dev/null
then
    echo "powerstat could not be found, please install it first."
    exit
fi


# Check if the MATLAB script exists
if [ ! -f "$MATLAB_SCRIPT" ]; then
    echo "MATLAB script $MATLAB_SCRIPT does not exist."
    exit
fi

# Run powerstat before running the MATLAB script (e.g., 120 readings, each for 1 second)
sudo powerstat -d 0 1 120 > powerstat_before.log &

# Get the PID of the powerstat command
POWERSTAT_PID=$!

# Run the MATLAB program and measure the time
/usr/bin/time -f "\nElapsed time: %E\nUser time: %U\nSystem time: %S\nCPU: %P" $MATLAB_CMD -batch "run('$MATLAB_SCRIPT')"

# Wait for powerstat to finish
wait $POWERSTAT_PID

# Run powerstat again after running the MATLAB script (e.g., 120 readings, each for 1 second)
sudo powerstat -d 0 1 120 > powerstat_after.log


# Extract the average power consumption data
BEFORE_POWER=$(grep -oP '(?<=Average power dissipation \(W\): )\d+\.\d+' powerstat_before.log)
AFTER_POWER=$(grep -oP '(?<=Average power dissipation \(W\): )\d+\.\d+' powerstat_after.log)

# Check if power readings were extracted correctly
if [ -z "$BEFORE_POWER" ] || [ -z "$AFTER_POWER" ]; then
    echo "Failed to extract power readings from powerstat logs."
    exit
fi

# Calculate the energy consumed
ENERGY_CONSUMED=$(echo "$AFTER_POWER - $BEFORE_POWER" | bc)

echo "Energy consumed by MATLAB program: $ENERGY_CONSUMED W"

# Clean up log files
rm powerstat_before.log powerstat_after.log
