#!/bin/bash

#=================================================
# COMMON VARIABLES
#=================================================

# dependencies used by the app
repo_url="https://repo.openwebrx.de/debian"
repo_key="https://repo.openwebrx.de/debian/key.gpg.txt"

pkg_dependencies="python3 python3-pkg-resources \
soapysdr-tools \
wsjtx direwolf js8call \
netcat debconf"

extra_pkg_dependencies="csdr \
owrx-connector hpsdrconnector \
python3-js8py python3-csdr python3-digiham \
runds-connector aprs-symbols m17-demod nmux codecserver"

src_dir=/usr/local/src

#=================================================
# Dream
#=================================================

dream_pkg_dependencies="qtbase5-dev qt5-qmake qtbase5-dev-tools \
libpulse0 libpulse-dev libopus0 libopus-dev libfaad2 libfaad-dev \
libfftw3-dev"


function install_dream {
    ynh_print_info --message="Installing Dream's dependencies"
    ynh_install_app_dependencies $dream_pkg_dependencies
    
    ynh_print_info --message="Setting up Dream source files..."
    ynh_setup_source --source_id=dream \
                     --dest_dir="$src_dir/dream"

    ynh_print_info --message="Compiling and installing Dream..."
    pushd $src_dir/dream
        ynh_exec_warn_less qmake CONFIG+="console warn_off" || ynh_die
        ynh_exec_warn_less make -j $(nb_jobs) && make install || ynh_die
    popd
}

function remove_dream {
    ynh_print_info --message="Removing Dream"
    pushd $src_dir/dream
    	ynh_exec_fully_quiet make uninstall
    	cd ..
    	ynh_secure_remove dream/
    popd
}

#=================================================
# codec2 / freedv_rx
#=================================================

codec2_build_dependencies="cmake checkinstall"
tmp_codec2=$(mktemp -d)

function install_codec2 {
    ynh_print_info --message="Installing codec2 build dependencies"
    ynh_package_install $codec2_build_dependencies

    ynh_print_info --message="Setting up codec2 source files..."
    ynh_setup_source --source_id=codec2 \
                     --dest_dir="$tmp_codec2"

    ynh_print_info --message="Compiling and installing codec2..."
    mkdir $tmp_codec2/build
    pushd $tmp_codec2/build
        ynh_exec_warn_less cmake .. || ynh_die
        ynh_exec_warn_less make -j $(nb_jobs) || ynh_die
        ynh_exec_warn_less checkinstall -y \
                                        --pkgname=codec2 \
                                        --pkgversion=1.0.3 \
                                        --pkglicense=LGPL2.1 || ynh_die
        install -m 0755 src/freedv_rx /usr/local/bin
        ldconfig
    popd
    
    ynh_secure_remove $tmp_codec2
}

function remove_codec2 {
    ynh_print_info --message="Removing codec2"
    ynh_exec_warn_less ynh_package_autoremove codec2
    ynh_secure_remove /usr/local/bin/freedv_rx
}


#=================================================
# PERSONAL HELPERS
#=================================================

function nb_jobs {
    expr $(nproc) / 3 + 1
}
