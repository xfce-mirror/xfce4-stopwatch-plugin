# This file was based on that of xfce4-notes-plugin.

INCLUDES =								\
	-I$(top_srcdir)							\
	-DGETTEXT_PACKAGE=\""$(GETTEXT_PACKAGE)"\"			\
	-DPACKAGE_LOCALE_DIR=\""$(localedir)"\"

#
# Vala sources
#

stopwatch_VAPISOURCES =

stopwatch_VALASOURCES =							\
	stopwatch.vala

stopwatch_VALABUILTSOURCES = $(stopwatch_VALASOURCES:.vala=.c)

if MAINTAINER_MODE
BUILT_SOURCES = vala.stamp
$(stopwatch_VALABUILTSOURCES): vala.stamp
vala.stamp: $(stopwatch_VALASOURCES)
	$(VALAC) --vapidir=$(srcdir) --pkg=libxfce4panel-2.0 $^ -C
	touch $@
endif

#
# Plugin
#

plugindir = $(libexecdir)/xfce4/panel/plugins
plugin_LTLIBRARIES = libstopwatch.la

libstopwatch_la_SOURCES =					\
	$(stopwatch_VALABUILTSOURCES)

libstopwatch_la_CFLAGS =						\
	@LIBXFCE4PANEL_CFLAGS@						\
	@LIBXFCE4UTIL_CFLAGS@						\
	@LIBXFCE4UI_CFLAGS@

libstopwatch_la_LIBADD =						\
	@LIBXFCE4PANEL_LIBS@						\
	@LIBXFCE4UTIL_LIBS@						\
	@LIBXFCE4UI_LIBS@

#
# Plugin desktop file
#

desktop_in_in_files =							\
	xfce4-stopwatch-plugin.desktop.in.in
desktop_in_files = $(desktop_in_in_files:.desktop.in.in=.desktop.in)

desktopdir = $(datadir)/xfce4/panel/plugins
desktop_DATA = xfce4-stopwatch-plugin.desktop
@INTLTOOL_DESKTOP_RULE@

%.desktop.in: %.desktop.in.in
	sed -e "s^@EXTERNAL_PLUGIN_PATH@^$(plugindir)^" \
		$< > $@

#
# Extra
#

EXTRA_DIST =								\
	$(stopwatch_VAPISOURCES)						\
	$(stopwatch_VALASOURCES)						\
	$(desktop_in_in_files)

if MAINTAINER_MODE
CLEANFILES =								\
	$(BUILT_SOURCES)						\
	$(stopwatch_VALABUILTSOURCES)
endif

DISTCLEANFILES =							\
	$(desktop_DATA)							\
	$(desktop_in_files)
