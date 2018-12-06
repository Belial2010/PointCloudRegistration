#!/bin/sh
echo "====================================================================="
echo "generateData.sh:                                                     "
echo "   This is the test generateData. This test will display the effect  "
echo "   of several settings for the data generation program.              "
echo "                                                                     "

DAT=../../data
FIG=../../figures/RegistrationPair
MAT=../../matlab

# ==============================================================================
# Generate all the data needed
export INPUT_PATH="./"
export OUTPUT_PATH="./"

echo "Input and output paths defined by:                                   "
echo "Input : $INPUT_PATH                                                  "
echo "Output: $OUTPUT_PATH                                                 "
echo "                                                                     "

# Clean model
echo "   Fetching clean models"
cp $DAT/bunnyPartial1.ply bunnyClean.ply
cp $DAT/bunnyPartial2.ply bunnyTransform.ply

# Test transformation
echo "   Generating transformed model."
export NOISE_TYPE=none
export ROTATION="0.52,0.52,0.79" # degrees: 30, 30, 45
export TRANSLATION="0.1,-0.4,-0.1"
./GenerateData bunnyTransform.ply bunnyTransform.ply

echo "====================================================================="
echo "Commencing tests:                                                    "

# Test registration
./Registration bunnyClean.ply bunnyTransform.ply

if [ -s error.err ] ; then
	exit
fi
# ==============================================================================
# Export the figures using matlab
echo "Running matlab to complete visualisation.                            "
mkdir fig $FIG -p
matlab -wait -nodesktop -nosplash \
	-r "addpath('$MAT');
	displayRegistration('bunny','./','fig');
	displayRegistration('result','./','fig');
	animateRegistration('bunny','result','./','fig');
	exit;" 
mv -t $FIG fig/*
echo "Results placed in folder:                                            "
echo $FIG
echo "====================================================================="
