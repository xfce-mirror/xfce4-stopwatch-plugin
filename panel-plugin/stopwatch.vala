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

private struct MyTimeVal {
	public long tv_sec;
	public long tv_usec;

	public MyTimeVal.now () {
		var source = GLib.TimeVal ();
		this.tv_sec  = source.tv_sec;
		this.tv_usec = source.tv_usec;
	}

	public MyTimeVal.zero () {
		this.tv_sec = 0;
		this.tv_usec = 0;
	}

	public MyTimeVal.add (MyTimeVal a, MyTimeVal b) {
		if (b.tv_usec + a.tv_usec > 1000000) { /* carry */
			this.tv_usec = a.tv_usec + b.tv_usec - 1000000;
			this.tv_sec = a.tv_sec + b.tv_sec + 1;
		}
		else {
			this.tv_usec = a.tv_usec + b.tv_usec;
			this.tv_sec = a.tv_sec + b.tv_sec;
		}
	}

	public MyTimeVal.sub (MyTimeVal a, MyTimeVal b) {
		if (b.tv_usec > a.tv_usec) { /* borrow */
			this.tv_usec = (a.tv_usec + 1000000) - b.tv_usec;
			this.tv_sec = (a.tv_sec - 1) - b.tv_sec;
		}
		else {
			this.tv_usec = a.tv_usec - b.tv_usec;
			this.tv_sec = a.tv_sec - b.tv_sec;
		}
	}

}

private class Timer : GLib.Object {
	private MyTimeVal committed;

	private uint tickId;
	private MyTimeVal? started;

	public MyTimeVal elapsed {
		get {
			if (this.started == null)
				return this.committed;
			else
				return MyTimeVal.add (this.committed,
				                      MyTimeVal.sub (MyTimeVal.now (),
				                                     (!) this.started));
		}
		set {
			this.stop ();
			this.committed = value;
			this.changed ();
		}
	}

	public signal void changed ();

	public Timer () {
		this.reset ();
	}

	private bool tick () {
		if (this.started == null)
			return false;

		this.changed ();
		return true;
	}

	public void start () {
		this.started = MyTimeVal.now ();
		this.tickId = GLib.Timeout.add_seconds (1, tick);
	}

	public void stop () {
		if (this.tickId > 0) {
			GLib.Source.remove (this.tickId);
			this.tickId = 0;
		}

		if (this.started != null) {
			this.committed = MyTimeVal.add (this.committed,
			                                MyTimeVal.sub (MyTimeVal.now (),
			                                               (!) this.started));
			this.started = null;
		}

		this.changed ();
	}

	public void reset () {
		this.elapsed = MyTimeVal.zero ();
	}

}


private class TimerButton : Gtk.ToggleButton {

	private Timer timer;

	private void updateDisplay (MyTimeVal elapsed) {
		var seconds = (int) (elapsed.tv_sec % 60);
		var minutes = (int) ((elapsed.tv_sec / 60) % 60);
		var hours   = (int) ((elapsed.tv_sec / 60) / 60);

		this.set_label ("%02d:%02d:%02d".printf (hours,
		                                         minutes,
		                                         seconds));
	}

	public TimerButton (Timer timer) {
		this.timer = timer;

		/* style like xfce_create_panel_toggle_button */
		this.can_default = false;
		this.can_focus = false;
		this.focus_on_click = false;
		this.set_relief (Gtk.ReliefStyle.NONE);

		this.updateDisplay (this.timer.elapsed);

		this.toggled += (s) => {
			if (this.active)
				this.start ();
			else
				this.stop ();
		};

		this.timer.changed += (s) => {
			this.updateDisplay (this.timer.elapsed);
		};
	}

	public void start () {
		this.active = true;
		this.timer.start ();
	}

	public void stop () {
		this.active = false;
		this.timer.stop ();
	}

	public void reset () {
		this.active = false;
		this.timer.reset ();
	}
}

public class StopwatchPlugin : GLib.Object {

	private Timer timer;
	private TimerButton timerButton;
	private Xfce.HVBox box;

	private void save (Xfce.PanelPlugin panel_plugin) {
		var rc = new Xfce.Rc (panel_plugin.save_location (true), false);
		var elapsed = timer.elapsed;
		rc.write_entry ("elapsed_sec",  "%ld".printf (elapsed.tv_sec));
		rc.write_entry ("elapsed_usec", "%ld".printf (elapsed.tv_usec));
	}

	private void load (Xfce.PanelPlugin panel_plugin) {
		var rc = new Xfce.Rc (panel_plugin.lookup_rc_file (), true);
		var elapsed = MyTimeVal.zero ();
		rc.read_entry ("elapsed_sec",  "0").scanf ("%ld", out elapsed.tv_sec);
		rc.read_entry ("elapsed_usec", "0").scanf ("%ld", out elapsed.tv_usec);
		timer.elapsed = elapsed;
	}

	public StopwatchPlugin (Xfce.PanelPlugin panel_plugin) {

		this.timer = new Timer ();
		this.load (panel_plugin);

		var orientation = panel_plugin.get_orientation ();

		box = new Xfce.HVBox (orientation, false, 0);
		panel_plugin.orientation_changed += (s, orientation) => {
			box.set_orientation (orientation);
		};

		timerButton = new TimerButton (timer);
		panel_plugin.add_action_widget (timerButton);
		box.add (timerButton);

		var resetButton = new Gtk.Button ();

		/* style like xfce_create_panel_button */
		resetButton.can_default = false;
		resetButton.can_focus = false;
		resetButton.focus_on_click = false;
		resetButton.set_relief (Gtk.ReliefStyle.NONE);

		var refreshImage = new Gtk.Image.from_stock (Gtk.STOCK_REFRESH,
		                                             Gtk.IconSize.BUTTON);
		resetButton.set_image (refreshImage);
		resetButton.clicked += (s) => {
			timerButton.reset ();
		};
		panel_plugin.add_action_widget (resetButton);
		box.add (resetButton);

		panel_plugin.add (box);
		panel_plugin.show_all ();

		panel_plugin.size_changed += (p, size) => {
			return true;
		};

		panel_plugin.save += this.save;
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
