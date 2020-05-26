/*
 * Copyright (C) Natanael Copa <ncopa@alpinelinux.org>
 *
 * SPDX-License-Identifier: MIT
 *
 */

#ifndef __STOPWATCH_H__
#define __STOPWATCH_H__

G_BEGIN_DECLS

typedef struct {
	XfcePanelPlugin *plugin;
	GtkWidget	*ebox;
	GtkWidget	*box;
	GtkWidget	*button;
	GtkWidget	*label;
} StopwatchPlugin;

G_END_DECLS
#endif
