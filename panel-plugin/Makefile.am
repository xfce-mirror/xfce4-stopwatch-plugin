
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
	@LIBXFCE4UTIL_CFLAGS@

libstopwatch_la_LDFLAGS =						\
	-avoid-version							\
	-module								\
	-no-undefined							\
	-export-symbols-regex '^xfce_panel_module_(preinit|init|construct)'

libstopwatch_la_LIBADD =						\
	@LIBXFCE4PANEL_LIBS@						\
	@LIBXFCE4UTIL_LIBS@

#
# Plugin desktop file
#

desktop_in_files =							\
	xfce4-stopwatch-plugin.desktop.in

desktopdir = $(datadir)/xfce4/panel/plugins
desktop_DATA = xfce4-stopwatch-plugin.desktop

%.desktop: %.desktop.in
	$(AM_V_GEN) $(MSGFMT) --desktop --template $< -d $(top_srcdir)/po -o $@

#
# Extra
#

EXTRA_DIST =								\
	$(desktop_in_files)						\
	meson.build							\
	$(NULL)

DISTCLEANFILES =							\
	$(desktop_DATA)
