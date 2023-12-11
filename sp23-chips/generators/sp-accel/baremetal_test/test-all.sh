cd ../../../sims/vcs/
for executable in "$@"
do
	echo "Running $executable"
	make CONFIG=SPTileTestDigitalChipConfig BINARY=../../generators/sp-accel/baremetal_test/${executable} run-binary-debug
done

