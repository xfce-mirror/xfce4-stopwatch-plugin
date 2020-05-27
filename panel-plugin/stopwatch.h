/*
 * Copyright (C) Natanael Copa <ncopa@alpinelinux.org>
 *
 * SPDX-License-Identifier: MIT
 *
 */

#ifndef __STOPWATCH_H__
#define __STOPWATCH_H__

G_BEGIN_DECLS

#include "stopwatchtimer.h"

typedef struct {
	XfcePanelPlugin *plugin;
	GtkWidget	*ebox;
	GtkWidget	*box;
	GtkWidget	*button;
	GtkWidget	*label;
	GtkWidget	*menuitem_reset;
	StopwatchTimer	*timer;
	guint		timeout_id;

} StopwatchPlugin;

G_END_DECLS
#endif
