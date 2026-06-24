#!/usr/bin/env python3
#
# Build script for fcitx5-breeze.
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

import json
import os
import shutil

config_file = "build.json"

files = {}
variables = {}
tags = []
build_config = []


def mkne(dirname):
    if not os.path.exists(dirname):
        os.mkdir(dirname)


# 从源文件中替换掉变量的值并写入目标文件
def replace_variables(src_file, dst_file):
    src_file = open(src_file, "rt")
    dst_file = open(dst_file, "wt")
    content = src_file.read()
    for k, v in variables.items():
        content = content.replace(f"${k}$", v)
    dst_file.write(content)
    src_file.close()
    dst_file.close()


def write_file(dirname):
    dst_dir = os.path.join("build", dirname)
    mkne(dst_dir)
    for dst_file, src_file in files.items():
        dst_file = os.path.join(dst_dir, dst_file)
        if src_file.endswith(".svg.in"):
            # 根据模板生成SVG文件
            tmp_file = os.path.join("tmp", os.path.basename(src_file) + ".svg")
            replace_variables(src_file, tmp_file)
            shutil.copy(tmp_file, dst_file)
        elif src_file.endswith(".in"):
            # 生成配置文件
            replace_variables(src_file, dst_file)
        else:
            # 简单复制
            shutil.copy(src_file, dst_file)


def build(level):
    if level == len(build_config):
        dir_name = ""
        for tag in tags:
            dir_name += tag + "-"
        dir_name = dir_name[:-1]
        print("Building theme " + dir_name)
        write_file(dir_name)
    else:
        conf_list = build_config[level]
        for conf in conf_list:
            conf_tag = conf.get("tag", "none")
            conf_files = conf.get("files", {})
            conf_vars = conf.get("variables", {})
            tags.append(conf_tag)
            files.update(conf_files)
            variables.update(conf_vars)
            build(level + 1)
            tags.pop()
            for k in conf_files.keys():
                files.pop(k)
            for k in conf_vars.keys():
                variables.pop(k)


config_file = open(config_file, "rt")
build_config = json.load(config_file)
config_file.close()

mkne("tmp")
mkne("build")

build(0)
print("Build successful.")
shutil.rmtree("tmp")
print("Cleanup successful.")
