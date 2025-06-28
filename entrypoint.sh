#!/bin/bash
set -e

if [ -f /input/namelist.in ]; then
    cp /input/namelist.in /tracmass/namelist.in
fi

sed -i -e 's/^\s*outDataDir\s*=.*/outDataDir="\/output\/"/g' /tracmass/namelist.in

sed -i -e 's/^\s*seeddir\s*=.*/seeddir="\/input\/"/g' /tracmass/namelist.in
sed -i -e 's/^\s*topoDataDir\s*=.*/topoDataDir="\/input\/"/g' /tracmass/namelist.in
sed -i -e 's/^\s*physDataDir\s*=.*/physDataDir="\/input\/data\/"/g' /tracmass/namelist.in

cp /tracmass/namelist.in /output/namelist.out

cd /tracmass
./runtracmass
