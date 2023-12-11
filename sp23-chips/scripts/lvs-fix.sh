#!/usr/bin/env bash

SCRIPT_PATH=$(dirname -- "$0";)

pushd "../$(SCRIPT_PATH)"
cd ..
git clone https://github.com/ucb-bar/hammer.git
pip install -e hammer/
popd
pip uninstall hammer-cadence-plugins
pip uninstall hammer-synopsys-plugins

