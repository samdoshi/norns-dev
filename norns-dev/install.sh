#!/bin/bash -e

source /tmp/install/install-lib.sh

install_setup_apt

install_packages

install_jack2
install_supercollider
install_sc3_plugins
install_nanomsg
install_libmonome
install_go
install_ldoc

install_clean_apt
