[![License](https://img.shields.io/badge/License-GPL%20v2-blue.svg)](https://gitlab.xfce.org/panel-plugins/xfce4-stopwatch-plugin/-/blob/master/COPYING)

# xfce4-stopwatch-plugin

Xfce4-stopwatch-plugin is a simple stopwatch plugin for Xfce panel.

----

### Homepage

[Xfce4-stopwatch-plugin documentation](https://docs.xfce.org/panel-plugins/xfce4-stopwatch-plugin)

### Changelog

See [NEWS](https://gitlab.xfce.org/panel-plugins/xfce4-stopwatch-plugin/-/blob/master/NEWS) for details on changes and fixes made in the current release.

### Source Code Repository

[Xfce4-stopwatch-plugin source code](https://gitlab.xfce.org/panel-plugins/xfce4-stopwatch-plugin)

### Download a Release Tarball

[Xfce4-stopwatch-plugin archive](https://archive.xfce.org/src/panel-plugins/xfce4-stopwatch-plugin)
    or
[Xfce4-stopwatch-plugin tags](https://gitlab.xfce.org/panel-plugins/xfce4-stopwatch-plugin/-/tags)

### Required Packages

* [GLib](https://wiki.gnome.org/Projects/GLib)
* [GTK](https://www.gtk.org)
* [libxfce4ui](https://gitlab.xfce.org/xfce/libxfce4ui)
* [libxfce4util](https://gitlab.xfce.org/xfce/libxfce4util)
* [xfce4-panel](https://gitlab.xfce.org/xfce/xfce4-panel)

For detailed information on the minimum required versions, check [meson.build](https://gitlab.xfce.org/panel-plugins/xfce4-stopwatch-plugin/-/blob/master/meson.build)

### Installation

From source code repository: 

    % cd xfce4-stopwatch-plugin
    % meson setup build
    % meson compile -C build
    % meson install -C build

From release tarball:

    % tar xf xfce4-stopwatch-plugin-<version>.tar.xz
    % cd xfce4-stopwatch-plugin-<version>
    % meson setup build
    % meson compile -C build
    % meson install -C build

### Uninstallation

    % ninja uninstall -C build

### Reporting Bugs

Visit the [reporting bugs](https://docs.xfce.org/panel-plugins/xfce4-stopwatch-plugin/bugs) page to view currently open bug reports and instructions on reporting new bugs or submitting bugfixes.

