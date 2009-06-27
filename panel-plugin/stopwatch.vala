/* stopwatch.vala
 *
 * Copyright (c) 2009 Diego Ongaro <ongardie@gmail.com>
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 */

private class TimerButton : Gtk.ToggleButton {

	private time_t committed;

	private uint tickId;
	private time_t started;

	private void updateDisplay (time_t elapsed) {
		var seconds = elapsed % 60;
		var minutes = (elapsed / 60) % 60;
		var hours   = (elapsed / 60) / 60;

		this.set_label ("%02d:%02d:%02d".printf ((int) hours,
							 (int) minutes,
							 (int) seconds));
	}

	public TimerButton () {
		this.reset ();

		this.toggled += (s) => {
			if (this.active)
				this.start ();
			else
				this.stop ();
		};
	}

	private bool tick () {
		if (this.started == -1)
			return false;

		this.updateDisplay (this.committed + (time_t () - this.started));
		return true;
	}

	public void start () {
		this.active = true;

		this.started = time_t ();
		this.tickId = GLib.Timeout.add_seconds (1, tick);
	}

	public void stop () {
		this.active = false;

		if (this.tickId > 0) {
			GLib.Source.remove (this.tickId);
			this.tickId = 0;
		}

		if (this.started != -1) {
			this.committed += (time_t () - this.started);
			this.started = -1;
		}

		this.updateDisplay (this.committed);
	}

	public void reset () {
		this.stop ();
		this.committed = 0;
		this.updateDisplay ((time_t) 0);
	}
}

public class StopwatchPlugin : GLib.Object {
	private TimerButton timerButton;
	public StopwatchPlugin (Xfce.PanelPlugin panel_plugin) {

		var box = new Gtk.HBox (false, 0);

		timerButton = new TimerButton ();
		box.add (timerButton);

		var resetButton = new Gtk.Button ();
		var refreshImage = new Gtk.Image.from_stock (Gtk.STOCK_REFRESH,
		                                             Gtk.IconSize.BUTTON);
		resetButton.set_image (refreshImage);
		resetButton.clicked += (s) => {
			timerButton.reset ();
		};
		box.add (resetButton);

		panel_plugin.add (box);
		panel_plugin.show_all ();

		panel_plugin.size_changed += (p, size) => {
			return true;
		};
	}


	static StopwatchPlugin plugin;

	public static void register (Xfce.PanelPlugin panel_plugin) {
		plugin = new StopwatchPlugin (panel_plugin);
	}

	public static int main (string[] args) {
		return Xfce.PanelPluginRegisterExternal (ref args,
		                                         StopwatchPlugin.register);
	}
}
