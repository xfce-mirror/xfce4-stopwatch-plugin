
AM_CPPFLAGS =								\
	-I$(top_srcdir)							\
	-DGETTEXT_PACKAGE=\""$(GETTEXT_PACKAGE)"\"			\
	-DPACKAGE_LOCALE_DIR=\""$(localedir)"\"

#
# Plugin
#

plugindir = $(libdir)/xfce4/panel/plugins
plugin_LTLIBRARIES = libstopwatch.la

libstopwatch_la_SOURCES =					\
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

desktop_in_in_files =							\
	xfce4-stopwatch-plugin.desktop.in.in
desktop_in_files = $(desktop_in_in_files:.desktop.in.in=.desktop.in)

desktopdir = $(datadir)/xfce4/panel/plugins
desktop_DATA = xfce4-stopwatch-plugin.desktop
@INTLTOOL_DESKTOP_RULE@

xfce4-stopwatch-plugin.desktop.in: xfce4-stopwatch-plugin.desktop.in.in
	sed -e "s^@EXTERNAL_PLUGIN_PATH@^$(plugindir)^" \
		$< > $@

#
# Extra
#

EXTRA_DIST =								\
	$(desktop_in_in_files)

DISTCLEANFILES =							\
	$(desktop_DATA)							\
	$(desktop_in_files)
