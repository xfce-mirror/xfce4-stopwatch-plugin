/*
 * Copyright (C) Natanael Copa <ncopa@alpinelinux.org>
 *
 * SPDX-License-Identifier: MIT
 *
 */

#ifndef __STOPWATCH_TIMER_H__
#define __STOPWATCH_TIMER_H__

#include <glib.h>

G_BEGIN_DECLS

/* Stopwatch Timer
*/

typedef struct _StopwatchTimer	StopwatchTimer;

StopwatchTimer *stopwatch_timer_new (void);

void stopwatch_timer_destroy (StopwatchTimer *timer);
void stopwatch_timer_start (StopwatchTimer *timer);
void stopwatch_timer_stop (StopwatchTimer *timer);
void stopwatch_timer_reset (StopwatchTimer *timer);
void stopwatch_timer_get_state (StopwatchTimer *timer, gint64 *start, gint64 *end);
void stopwatch_timer_set_state (StopwatchTimer *timer, gint64 start, gint64 end);

gint64 stopwatch_timer_elapsed (StopwatchTimer *timer);
gboolean stopwatch_timer_is_active (StopwatchTimer *timer);

G_END_DECLS

#endif
