#!/bin/bash
#
##########################################################################
#
#    This file is part of OCEMR.
#
#    OCEMR is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    OCEMR is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with OCEMR.  If not, see <http://www.gnu.org/licenses/>.
#
#
#########################################################################
#       Copyright 2011-8 Philip Freeman <elektron@halo.nu>
#       Copyright 2018 Pat Freeman <github@e2r4.com>
##########################################################################
VAR=~/var
APP_DIR=.
APP=$APP_DIR/ocemr
UTIL=./util

export PYTHONPATH=$APP_DIR

mkdir -p ${VAR}/{db,backups,gnupg}
chmod 700 ${VAR}/gnupg

#if [ ! -e ${VAR}/gnupg/secring.gpg ]; then
#	cat contrib/gpg_server_key.options  | gpg --home ${VAR}/gnupg --gen-key --batch
#fi

if [ -e ${VAR}/db/ocemr.db ]; then
	echo SQLite database present, aborting initialization...
	exit 10
fi


python ${APP}/manage.py migrate

#----------

python ${UTIL}/import_symptom_csv.py
python ${UTIL}/import_vital_csv.py
python ${UTIL}/import_examnotes_csv.py
python ${UTIL}/import_labs_csv.py
python ${UTIL}/import_dx_csv.py
python ${UTIL}/import_rx_csv.py

#----------
#
# python ./util/import_test_patients_csv.py
#

echo "all done initializing in ${VAR}/db/ocemr.db"
