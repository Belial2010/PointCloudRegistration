#!/bin/sh
#==============================================================================
# Define Preparation of data ect.

Prepare()
{
	# Setup folders needed
	TNAME=`basename -- "$0"`
	FIG=../../figures/${TNAME%.*}
	DAT=../../data
	MAT=../../matlab

	mkdir -p fig $FIG $FIG/data dat

	# Define input and output paths
	export INPUT_PATH="dat/"
	export OUTPUT_PATH="dat/"

	echo "Input and output paths defined by:"
	echo "   Input : $INPUT_PATH"
	echo "   Output: $OUTPUT_PATH"
	echo ' '

	# Fetch the data needed from the data folder
	cp $DAT/bunnyPartial1.ply dat/bunnyClean.ply
	cp $DAT/bunnyPartial2.ply dat/bunnyTransform.ply

	# Rotation in degrees: 30, 30, 45 
	NOISE_TYPE=none \
	ROTATION="0.52,0.52,0.79" \
	TRANSLATION="0.05,0.0,-0.01" \
		./GenerateData.exe bunnyTransform.ply bunnyTransform.ply

}

# End of Preparation
#==============================================================================
# Define the actual test part of the script 

Program()
{
	export NOISE_TYPE=gaussian
	export NOISE_STRENGTH=0.2
	./GenerateData.exe bunnyClean.ply gaussianBunny1.ply
	./GenerateData.exe bunnyTransform.ply gaussianBunny2.ply
	echo " "

	export ALPHA=1.6
	export INI_R=0.14
	export END_R=0.15
	export NUM_R=2
	export EXPORT_CORRESPONDENCES=true

	OUTPUT_NAME=bunny  ./Registration.exe bunny

	OUTPUT_NAME=gaussian ./Registration.exe gaussian

}

# End of Program
#==============================================================================
# Define Visualize

Visualize()
{
	echo ' '
	echo Visualizing

	MATTESTS="'bunny','gaussian'"

	MATOPT="-wait -nodesktop -nosplash"
	matlab $MATOPT \
	-r "addpath('$MAT');displayCorrespondences({$MATTESTS},'dat/','fig/');exit"
}

# End of Visualize
#==============================================================================
# Define Finalize

Finalize()
{
	rm -fr $FIG
	mkdir -p fig $FIG $FIG/data 

	mv -ft $FIG fig/*
	mv -ft $FIG/data dat/*
	rm -fr *.exe *.sh fig dat

	echo "   Figures moved to $FIG."
	echo "   Data used located in $FIG/data"
}

# End of Visualize
#==============================================================================
# Define Early Termination

Early()
{
	rm -fr *.ply *.exe *.sh fig dat
	echo ' '
	echo ' ================= WARNING: EARLY TERMINATION ================= '
	cat error.err 
	echo ' ===================== ERRORS SHOWN ABOVE ===================== '
	echo ' '
}

# End of Early Termination
#==============================================================================
# Call Functions
echo __________________________________________________________________________
echo 'Preparing data and folders'
echo ' '
full_start=`date +%s.%N`
Prepare

if [ -s error.err ] ; then
	Early
	exit
fi

echo ' '
echo __________________________________________________________________________
echo 'Commencing tests:'
echo ' '
test_start=`date +%s.%N`

Program

test_end=`date +%s.%N`
runtime=$(echo $test_end $test_start | awk '{ printf "%f", $1 - $2 }')
echo "Computation time for test: $runtime seconds."
if [ -s error.err ] ; then
	Early
	exit
fi

echo ' '
echo __________________________________________________________________________

Visualize

if [ -s error.err ] ; then
	Early
	exit
fi

echo ' '
echo __________________________________________________________________________
echo ' '
echo Finalizing

Finalize

if [ -s error.err ] ; then
	Early
	exit
fi
full_end=`date +%s.%N`
runtime=$(echo $full_end $full_start | awk '{ printf "%f", $1 - $2 }')
echo "Computation time for full test: $runtime seconds."
echo 'Test concluded successfully.'
echo __________________________________________________________________________
# ==============================   End of File   ==============================