
AM_CPPFLAGS =								\
	-I$(top_srcdir)							\
	-DGETTEXT_PACKAGE=\""$(GETTEXT_PACKAGE)"\"			\
	-DPACKAGE_LOCALE_DIR=\""$(localedir)"\"

#
# Plugin
#

plugindir = $(libdir)/xfce4/panel/plugins
plugin_LTLIBRARIES = libstopwatch.la

libstopwatch_la_SOURCES =						\
	stopwatchtimer.h						\
	stopwatchtimer.c						\
	stopwatch.h							\
	stopwatch.c

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

desktop_in_files =							\
	xfce4-stopwatch-plugin.desktop.in

desktopdir = $(datadir)/xfce4/panel/plugins
desktop_DATA = xfce4-stopwatch-plugin.desktop

@INTLTOOL_DESKTOP_RULE@

#
# Extra
#

EXTRA_DIST =								\
	$(desktop_in_files)

DISTCLEANFILES =							\
	$(desktop_DATA)
