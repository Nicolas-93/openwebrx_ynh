#!/bin/bash

#=================================================
# COMMON VARIABLES
#=================================================

# dependencies used by the app
repo_url="https://repo.openwebrx.de/debian"
repo_key="https://repo.openwebrx.de/debian/key.gpg.txt"

pkg_dependencies="python3 python3-pkg-resources \
soapysdr-tools \
wsjtx \
debconf"

extra_pkg_dependencies="csdr \
netcat \
owrx-connector hpsdrconnector \
python3-js8py python3-csdr python3-digiham direwolf \
js8call runds-connector aprs-symbols m17-demod nmux codecserver"
