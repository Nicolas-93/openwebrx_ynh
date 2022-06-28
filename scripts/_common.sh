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

#=================================================
# DREAM
#=================================================

dream_pkg_dependencies="qtbase5-dev qt5-qmake qtbase5-dev-tools \
libpulse0 libpulse-dev libopus0 libopus-dev libfaad2 libfaad-dev \
libfftw3-dev"


function install_dream {
    ynh_print_info --message="Installing DREAM's dependencies"
    ynh_install_app_dependencies $dream_pkg_dependencies
    
    ynh_print_info --message="Setting up DREAM source files..."
    ynh_setup_source --source_id=dream \
                     --dest_dir=/usr/local/src/dream

    ynh_print_info --message="Compiling and installing DREAM..."
    pushd /usr/local/src/dream
        ynh_exec_warn_less qmake CONFIG+="console warn_off"
        ynh_exec_warn_less make -j $(expr $(nproc) / 3 + 1) && make install
    popd

}

function remove_dream {
    pushd /usr/local/src/dream
    	ynh_exec_fully_quiet make uninstall
    	cd ..
    	ynh_secure_remove dream/
    popd
}
