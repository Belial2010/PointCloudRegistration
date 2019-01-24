#!/bin/sh

# Find all tests if specified
if [ "$1" = "all" ] ; then
	for test in `ls shell/*`;
	do 
		t_name=`basename -- "$test"`
		tests+="${t_name%.*} "
	done
	./figure_remake.sh $tests
	exit
fi
MFLAGS="-wait -nodesktop -nosplash"
for test in $@ ;
do
	DAT="figures/$test/data"
	FIG="figures/$test"

	rm -f 	$FIG/*.png   $FIG/*.eps   $FIG/*.pdf \
			$FIG/*/*.png $FIG/*/*.pdf $FIG/*/*.eps
	case "$test" in
		generateData)
			FIGS="'bunnyClean','bunnyGaussian','bunnyNoise','bunnyOutliers',"
			FIGS+="'bunnyTransform'"
			matlab $MFLAGS -r "
				addpath('matlab');
				displayRegistration({$FIGS},'$DAT','$FIG');
				exit;" 
		;;
		noiseTest)
			FIGS="'bunny','resultClean','resultGauss1','resultGauss2',"
			FIGS+="'resultOut1','resultOut2','resultOut3'"
			matlab $MFLAGS -r "
				addpath('matlab');
				displayRegistration({$FIGS},'$DAT','$FIG');
				exit;" 
		;;
		gaussianTest)
			FIGS="'bun10','gauss10','bun15','gauss15'"
			matlab $MFLAGS -r "
				addpath('matlab');
				displayCorrespondences({$FIGS},'$DAT','$FIG');
				exit;"
		;;	
		versionCompare)
			FIGS="'fgr_open3d','fpfh_open3d','local'"
			matlab $MFLAGS -r "
				addpath('matlab');
				displayRegistration({$FIGS},'$DAT','$FIG');
				exit;" 
		;;
		foxTest)
			FIGS="'local','open3d'"
			VER="left right upright upsidedown"
			for v in $VER ;
			do
				matlab $MFLAGS -r "
					addpath('matlab');
					displayRegistration({$FIGS},'$DAT/$v','$FIG/$v',true);
					exit;" 
			done
		;;
		sealTest)
			FIGS="'local','open3d'"
			VER="left right upright"
			for v in $VER ;
			do
				matlab $MFLAGS -r "
					addpath('matlab');
					displayRegistration({$FIGS},'$DAT/$v','$FIG/$v',true);
					exit;" 
			done
		;;
	esac
done
