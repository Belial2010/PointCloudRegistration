# Testing

All tests are defined in shell scripts and can be called in an organised matter
through the scripts in this folder. Data used in any test defined in these 
folders are located in the data folder and visualisations are done through 
matlab. 
Both testing scripts allow the input "all" which will automatically 
locate and run all defined tests.

## Run Test

	> runtest.sh TESTNAME1 [TESTNAME2 ...]
	> runtest.py TESTNAME1 [TESTNAME2 ...]

The scripts runtest.sh and runtest.py can be used to run the tests locally. The
test scripts are located in the shell (.sh) or test (.py) folders. Running the
tests with this function will create temporary folders and export the figures
and such to a figure folder when complete. All tests are performed in parallel
processes and the output and errors will be located in the log folder for the
test.

## Submit Test

	> submit.sh TESTNAME1 [TESTNAME2 ...]

This function will organise the files nescesary for testing into logfolders and 
submit the tests onto the LSF based system on the DTU HPC cluster. The defined 
tests are located in the folder called shell/ and LSF settings are defined by
files in submit/.