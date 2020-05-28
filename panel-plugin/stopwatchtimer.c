/*
 * Copyright (C) Natanael Copa <ncopa@alpinelinux.org>
 *
 * SPDX-License-Identifier: MIT
 *
 */

#include "stopwatchtimer.h"

/* Stopwatch Timer
*/

struct _StopwatchTimer {
	guint64 start;
	guint64 end;
};

/**
 * stopwatch_timer_new:
 *
 * Creates a new timer
 *
 * Returns: a new #StopwatchTimer
 **/
StopwatchTimer *
stopwatch_timer_new (void)
{
	StopwatchTimer *timer = g_new (StopwatchTimer, 1);
	timer->start = 0;
	timer->end = 0;
	return timer;
}

/**
 * stopwatch_timer_destroy:
 * @timer: a #StopwatchTimer to destroy.
 *
 * Destroys a stopwatch timer, freeing its associated resources.
 **/
void
stopwatch_timer_destroy (StopwatchTimer *timer)
{
	g_return_if_fail (timer != NULL);
	g_free (timer);
}

/**
 * stopwatch_timer_start:
 * @timer: a #StopwatchTimer.
 *
 * Marks a start time, so that future calls to stopwatch_timer_elapsed() will
 * report the timse since stopwatch_timer_start() was called. Does nothing
 * if @timer was already started.
 **/
void
stopwatch_timer_start (StopwatchTimer *timer)
{
	g_return_if_fail (timer != NULL);

	timer->start = g_get_monotonic_time () - (timer->end - timer->start);
	timer->end = 0;
}

/**
 * stopwatch_timer_stop:
 * @timer: a #StopwatchTimer.
 *
 * Marks an end time, so calls to stopwatch_timer_elapsed() will return the
 * difference between this end time and the start time.
 **/
 void
stopwatch_timer_stop (StopwatchTimer *timer)
{
	g_return_if_fail (timer != NULL);

	timer->end = g_get_monotonic_time ();
}

/**
 * stopwatch_timer_reset:
 * @timer: a #StopwatchTimer.
 *
 * Resets start and end time of the timer without changing the running state.
 **/
void
stopwatch_timer_reset (StopwatchTimer *timer)
{
	g_return_if_fail (timer != NULL);

	timer->start = stopwatch_timer_is_active (timer) ? g_get_monotonic_time () : 0;
	timer->end = 0;
}

/**
 * stopwatch_timer_elapsed:
 * @timer: a #StopwatchTimer.
 *
 * If @timer has been started but not stopped, obtains the time since
 * the timer was started. If @timer has been stopped, obtains the
 * elapsed time betthen the time it was started and the time it was
 * stopped.
 *
 * Return: total number of microseconds as guint64.
 **/

guint64
stopwatch_timer_elapsed (StopwatchTimer *timer)
{
	g_return_val_if_fail (timer != NULL, 0);

	return stopwatch_timer_is_active (timer) ? g_get_monotonic_time () - timer->start : timer->end - timer->start;
}

/**
 * stopwatch_timer_get_state:
 * @timer: a #StopwatchTimer.
 * @start: return location for start time
 * @end: return location for end time
 *
 * Set the current state in @start and @end.
 **/
void
stopwatch_timer_get_state (StopwatchTimer *timer, guint64 *start, guint64 *end)
{
	*start = timer->start;
	*end = timer->end;
}

/**
 * stopwatch_timer_get_state:
 * @timer: a #StopwatchTimer.
 * @start: start time
 * @end: end time
 *
 * Set the current state from @start and @end.
 **/
void
stopwatch_timer_set_state (StopwatchTimer *timer, guint64 start, guint64 end)
{
	timer->start = start;
	timer->end = end;
}

/**
 * stopwatch_timer_is_active:
 * @timer: a #StopwatchTimer
 *
 * Exposes wheter the timer is currently active.
 *
 * Returns: %TRUE if timer is running, %FALSE otherwise
 **/
gboolean
stopwatch_timer_is_active (StopwatchTimer *timer)
{
	g_return_val_if_fail (timer != NULL, FALSE);

	return timer->start != 0 && timer->end == 0;
}
