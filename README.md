# Fcitx5-breeze

适配KDE Breeze主题的Fcitx5主题。

Fcitx5 theme to match KDE's Breeze style.

修改自https://gitlab.com/scratch-er/fcitx5-breeze, 移除了SVG转PNG的逻辑，对高分屏更加友好。

Adapted from https://gitlab.com/scratch-er/fcitx5-breeze, removed the conversion from SVG to PNG to make it more friendly for HiDPI screens.

## 构建项目 Build

运行`build.py`以构建项目。

Run `bulid.py` to build this theme.

这个主题使用svg矢量图制作。构建脚本首先从.svg.in文件生成.svg文件，再从.conf.in文件生成各个主题的配置文件，然后得到完整的主题。

This themes uses svg as the source format. The build scripts generates .svg files from .svg.in files, then generates theme config files from .conf.in files to build the whole theme.

## 安装主题 Installation

在构建主题之后，运行`install.sh`以安装主题。您也可以从Releases页面下载一个已经构建好的版本。默认情况下，主题会安装到`~/.local`。

To install this theme, you need to build it first or get a pre-built package from the releases page. Then run `install.sh`. By default, this will install the theme into `~/.local`.

```shell
./install.sh
```

您可以指定其他的安装路径，例如，使用以下命令可以将主题安装到`/usr/local`。注意，安装到全局需要sudo权限。

To specify another installation prefix, for example, if you want install this theme into `/usr/local`. Note that sudo permission is required for global installations.

```shell
sudo ./install.sh /usr/local
```

要删除该主题，请运行命令`./uninstall.sh <安装路径>`，例如：

To uninstall this theme, run `./uninstall.sh <installation-prefix>`, for example:

```shell
./uninstall.sh ~/.local
```

## 构建脚本的工作原理 How this works

构建脚本的职责是从后缀为`.svg.in`与`.conf.in`的模板文件生成svg矢量图与配置文件。在模板文件中，两个`$`符号之间的内容被视为变量名，而`build.json`中记录了各个变量的可能取值。构建脚本会遍历这些变量的所有可能取值，将模板文件中对应的变量名替换为变量值。

The build script generates config files and svg files from the `.conf.in` and `.svg.in` templates. In an template file, any string quoted by `$` are variable names. `build.json` contains the possible values of the variables. The build scripts generates all possible combinations of the values of the variables, an replaces the variable names in the templates with corresponding values.

## 致谢 Acknowledgements

本项目基于Fcitx5的自带主题，以及KDE Plasma的Breeze主题。

This project is based on the default Fcitx5 theme and Breeze Plasma theme.

本项目是https://gitlab.com/scratch-er/fcitx5-breeze的现代分支。

This project is a modern fork of https://gitlab.com/scratch-er/fcitx5-breeze.
