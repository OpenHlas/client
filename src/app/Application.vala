namespace App {
    using Adw;
    using Gtk;
    using GLib;
    public class Application : Adw.Application {
        private ProgressBar progress_bar;
        Button download_btn;

        public Application () {
            Object (
                    application_id: Config.APP_ID,
                    flags: ApplicationFlags.DEFAULT_FLAGS
            );

            ActionEntry[] action_entries = {
                //{ "report", this.on_report_action },
                //{ "preferences", this.on_preferences_action },
                { "about", this.on_about_action },
                //{ "donate", this.on_donate_action },
                //{ "reload", this.on_reload_action },
                //{ "on_language_change", this.on_language_change },
                { "quit", this.quit },
            };
            this.add_action_entries (action_entries, this);
        }

        void on_about_action () {
            Dialogs.About.show (this.active_window);
        }

        public override void activate () {
            var display = Gdk.Display.get_default ();

            Gtk.IconTheme.get_for_display (display).add_resource_path ("/com/github/OpenHlas/client");

            style_manager.set_color_scheme (Adw.ColorScheme.FORCE_DARK);

            var main_window = new Windows.Window ();
            main_window.present ();
        }
    }
}