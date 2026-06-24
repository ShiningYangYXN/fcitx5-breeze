#!/bin/bash
#
# Installation script for fcitx5-breeze.
# Based on upstream work by scratch-er (2021-2024), distributed under GPLv3.
# Modifications by Shining Yang in 2026.
# Copyright (C) 2026 Shining Yang
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

set -e

if (( $# >= 2 )) ; then
echo "Too many arguments. Expected 0 or 1, found $#." >&2
exit 1
elif (( $# == 1 )) ; then
    install_prefix="$1"
else
    install_prefix="$HOME/.local"
fi
install_dir="$install_prefix/share/fcitx5/themes"

if [[ ! -e $install_dir ]] ; then
    mkdir $install_dir
fi

for i in $(ls build) ; do
    chmod 644 "build/${i}"/*
done

cp -rf --no-preserve=ownership --preserve=mode build/* $install_dir
echo "fcitx5-breeze is successfully installed to $install_dir."
