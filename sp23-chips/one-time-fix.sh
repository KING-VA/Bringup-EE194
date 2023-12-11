#!/usr/bin/env bash


cd ./vlsi/hammer-cadence-plugins
git checkout f9e323b
cd ..
pip install -e hammer-cadence-plugins --upgrade
git add ./hammer-cadence-plugins
git commit -m "restore to older cadence"