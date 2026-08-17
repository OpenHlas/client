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

            Gtk.IconTheme.get_for_display (display).add_resource_path ("/com/github/JanGalek/vala-application-template");

            style_manager.set_color_scheme (Adw.ColorScheme.FORCE_DARK);

            var main_window = new Windows.Window ();
            main_window.present ();
        }

        private async void download_and_extract_process () {
            this.download_btn.sensitive = false;

            var downloader = new Utils.Downloader ();

            downloader.progress_changed.connect ((pct) => {
                this.progress_bar.fraction = pct;
            });

            string archive_name = "g3_mod.tar.xz";
            string cache_dir = Path.build_filename (Environment.get_user_cache_dir (), "universal-workshop");
            string archive_path = Path.build_filename (cache_dir, archive_name);
            string game_path = "/cesta/k/Gothic 3";

            try {
                this.progress_bar.text = "Stahování…";
                yield downloader.download_async ("https://example.com/g3_mod.tar.xz", archive_path);

                this.progress_bar.text = "Zálohování a rozbalování…";
                this.progress_bar.pulse ();

                /**
                   var extractor = new Extractor ();
                   yield extractor.extract_mod_async (archive_path, game_path, "g3_sample_mod");
                 */
                this.progress_bar.fraction = 1.0;
                this.progress_bar.text = "Hotovo!";
            } catch (Error e) {
                this.progress_bar.text = "Chyba: " + e.message;
            }

            this.download_btn.sensitive = true;
        }
    }
}