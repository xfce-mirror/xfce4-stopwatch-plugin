dnl xfce4-stopwatch-plugin
dnl 2009 Diego Ongaro <ongardie@gmail.com>

dnl This file (configure.in.in) is based on that of the
dnl xfce4-places-plugin and the xfce4-notes-plugin.

dnl The xfce4-notes-plugin configure.in.in header is reproduced here:
dnl
dnl xfce4-notes-plugin - Notes plugin for the Xfce4 panel
dnl
dnl 2003 Benedikt Meurer <benedikt.meurer@unix-ag.uni-siegen.de>
dnl 2003 Jakob Henriksson <b0kaj+dev@lysator.liu.se>
dnl 2006, 2008, 2009 Mike Massonnet <mmassonnet@gmail.com>

dnl version info
XDT_VERSION_INIT([0.5.0], [git])

dnl initialize autoconf
AC_COPYRIGHT([Copyright (c) 2009 Diego Ongaro <ongardie@gmail.com>])
AC_COPYRIGHT([Copyright (c) 2020 Natanael Copa <ncopa@alpinelinux.org])
AC_INIT([xfce4-stopwatch-plugin], [xdt_version], [ncopa@alpinelinux.org])
AC_PREREQ([2.50])
AC_CONFIG_MACRO_DIRS([m4])

dnl AC_CANONICAL_TARGET()

dnl initialize automake
AM_INIT_AUTOMAKE([dist-xz foreign])
AM_CONFIG_HEADER([config.h])
AM_MAINTAINER_MODE()
AM_SILENT_RULES([yes])

dnl check for basic programs
AC_PROG_CC_C_O()
AC_PROG_LD()
AC_PROG_INSTALL()
IT_PROG_INTLTOOL([0.35.0])

dnl libtool
LT_PREREQ([2.4])
LT_INIT([disable-static])

dnl check for required packages
XDT_CHECK_PACKAGE([GTK], [gtk+-3.0])
XDT_CHECK_PACKAGE([LIBXFCE4UTIL], [libxfce4util-1.0], [4.13.0])
XDT_CHECK_PACKAGE([LIBXFCE4PANEL], [libxfce4panel-2.0], [4.13.0])

dnl check for i18n support
XDT_I18N()

dnl Check for debugging support
XDT_FEATURE_DEBUG([xdt_debug_default])

AC_OUTPUT([
Makefile
icons/Makefile
icons/16x16/Makefile
icons/22x22/Makefile
icons/24x24/Makefile
icons/32x32/Makefile
icons/scalable/Makefile
panel-plugin/Makefile
po/Makefile.in
])

dnl print configuration
echo
echo "Build Configuration:"
echo
echo "* Maintainer Mode:        $USE_MAINTAINER_MODE"
echo "* Debug Support:          $enable_debug"
echo

