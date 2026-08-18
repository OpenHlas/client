namespace App {
    using Adw;
    using Gtk;
    using GLib;
    public class Application : Adw.Application {
        private ProgressBar progress_bar;
        Button download_btn;
        private string language = "en";
        private GLib.Settings settings;

        public Application () {
            Object (
                    application_id: Config.APP_ID,
                    flags: ApplicationFlags.DEFAULT_FLAGS
            );

            settings = new GLib.Settings ("com.github.openhlas.client");
            language = settings.get_string ("language");
            apply_language (language);
            Intl.setlocale (LocaleCategory.ALL, "");
            Intl.bindtextdomain (Config.APP_ID, Environment.get_variable ("TEXTDOMAINDIR") ?? Config.LOCALE_DIR);
            Intl.bind_textdomain_codeset (Config.APP_ID, "UTF-8");
            Intl.textdomain (Config.APP_ID);

            var language_action = new SimpleAction ("set-language", new VariantType ("s"));
            language_action.activate.connect ((parameter) => {
                set_language (parameter.get_string ());
            });
            add_action (language_action);

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

        private void apply_language (string language_code) {
            Environment.set_variable ("LANGUAGE", language_code, true);
        }

        private void set_language (string language_code) {
            if (language == language_code) {
                return;
            }

            language = language_code;
            settings.set_string ("language", language_code);

            apply_language (language_code);
            Intl.setlocale (LocaleCategory.ALL, "");
            Intl.textdomain (Config.APP_ID);
            refresh_main_window ();
        }

        private void refresh_main_window () {
            var old_window = active_window;
            var main_window = new Windows.Window ();
            main_window.present ();

            if (old_window != null && old_window != main_window) {
                old_window.hide ();
                old_window.close ();
            }
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