/* Copyright (c) Natanael Copa <ncopa@alpinelinux.org>
 * SPDX-License-Identifier: MIT
 */

#ifdef HAVE_CONFIG_H
#include <config.h>
#endif

#include <libxfce4panel/xfce-panel-plugin.h>
#include <libxfce4util/libxfce4util.h>

#include "stopwatch.h"

static void stopwatch_construct (XfcePanelPlugin *plugin);
XFCE_PANEL_PLUGIN_REGISTER (stopwatch_construct);

static void
update_start_stop_image (GtkToggleButton *button) {
	int active;
	GtkWidget *image;
	const char *icon_names[2] = { "media-playback-start", "media-playback-pause" };

	active = gtk_toggle_button_get_active (button);

	image = gtk_image_new_from_icon_name (icon_names[active & 1], GTK_ICON_SIZE_BUTTON);
	gtk_button_set_image (GTK_BUTTON (button), image);
}

static void
stopwatch_toggle (GtkToggleButton *button, gpointer user_data) {
	update_start_stop_image (button);
}

static StopwatchPlugin *
stopwatch_new (XfcePanelPlugin *plugin)
{
	StopwatchPlugin *stopwatch;
	GtkOrientation orientation;

	stopwatch = g_slice_new0(StopwatchPlugin);

	stopwatch->plugin = plugin;

	stopwatch->ebox = gtk_event_box_new ();
	gtk_widget_show (stopwatch->ebox);

	orientation = xfce_panel_plugin_get_orientation (plugin);

	stopwatch->box = gtk_box_new (orientation, 2);
	gtk_widget_show (stopwatch->box);
	gtk_container_add (GTK_CONTAINER (stopwatch->ebox), stopwatch->box);

	stopwatch->label = gtk_label_new (_(" 00:00:00 "));
	gtk_label_set_selectable (GTK_LABEL (stopwatch->label), FALSE);
	gtk_label_set_angle (GTK_LABEL (stopwatch->label), orientation == GTK_ORIENTATION_HORIZONTAL ? 0 : 270);
	gtk_widget_show (stopwatch->label);
	gtk_box_pack_start (GTK_BOX (stopwatch->box), stopwatch->label, FALSE, FALSE, 0);

	stopwatch->button = gtk_toggle_button_new ();
	gtk_widget_set_can_default (stopwatch->button, FALSE);
	gtk_widget_set_can_focus (stopwatch->button, FALSE);
	gtk_widget_set_focus_on_click (stopwatch->button, FALSE);
	gtk_button_set_relief (GTK_BUTTON (stopwatch->button), FALSE);
	gtk_widget_show (stopwatch->button);
	update_start_stop_image (GTK_TOGGLE_BUTTON (stopwatch->button));
	gtk_box_pack_start (GTK_BOX (stopwatch->box), stopwatch->button, FALSE, FALSE, 0);

	g_signal_connect (stopwatch->button, "toggled", G_CALLBACK (stopwatch_toggle), stopwatch);

	return stopwatch;
}

static void
stopwatch_free (XfcePanelPlugin *plugin, StopwatchPlugin *stopwatch)
{
	gtk_widget_destroy (stopwatch->box);
	g_slice_free (StopwatchPlugin, stopwatch);
}

static void
stopwatch_orientation_changed (XfcePanelPlugin *plugin,
			       GtkOrientation orientation,
			       StopwatchPlugin *stopwatch)
{
	gtk_orientable_set_orientation (GTK_ORIENTABLE (stopwatch->box), orientation);
	gtk_label_set_angle (GTK_LABEL (stopwatch->label), orientation == GTK_ORIENTATION_HORIZONTAL ? 0 : 270);
}

static gboolean
stopwatch_size_changed (XfcePanelPlugin *plugin,
			gint size,
			StopwatchPlugin *stopwatch)
{
	GtkOrientation orientation;
	orientation = xfce_panel_plugin_get_orientation (plugin);

	if (orientation == GTK_ORIENTATION_HORIZONTAL) {
		gtk_widget_set_size_request (GTK_WIDGET (plugin), -1, size);
	} else {
		gtk_widget_set_size_request (GTK_WIDGET (plugin), size, -1);
	}

	return TRUE;
}

static void
stopwatch_construct (XfcePanelPlugin *plugin)
{
	StopwatchPlugin *stopwatch;

	xfce_textdomain (GETTEXT_PACKAGE, PACKAGE_LOCALE_DIR, "UTF-8");

	stopwatch = stopwatch_new (plugin);
	gtk_container_add (GTK_CONTAINER (plugin), stopwatch->ebox);
	xfce_panel_plugin_add_action_widget (plugin, stopwatch->ebox);

	g_signal_connect (G_OBJECT (plugin), "free-data", G_CALLBACK (stopwatch_free), stopwatch);
	g_signal_connect (G_OBJECT (plugin), "orientation-changed", G_CALLBACK (stopwatch_orientation_changed), stopwatch);
	g_signal_connect (G_OBJECT (plugin), "size-changed", G_CALLBACK (stopwatch_size_changed), stopwatch);
}
