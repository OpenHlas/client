namespace App.Dialogs {
    using Adw;
    using Gtk;

    public class About {

        private const string[] DEVELOPERS = {
            "Jan Galek https://github.com/JanGalek",
            null
        };

        private const string[] THANKS = {
            "GNOME Project https://www.gnome.org/",
            "Font Awesome https://fontawesome.com/",
            null
        };

        public static void show (Gtk.Window parent_window) {
            var dialog = new Adw.AboutDialog ();

            dialog.set_application_name (Config.APP_NAME);
            dialog.set_application_icon (Config.APP_ID);
            dialog.set_version ("v" + Config.APP_VERSION);

            dialog.set_comments (_("Vala application template"));
            dialog.add_link ("GitHub", "https://github.com/OpenHlas/client");
            dialog.set_issue_url ("https://github.com/OpenHlas/client/issues/new/choose");
            dialog.set_copyright (get_copyright ());
            dialog.set_license_type (Gtk.License.GPL_3_0);
            dialog.set_developers (DEVELOPERS);
            dialog.set_translator_credits (_("translator-credits"));
            dialog.add_credit_section (_("Special thanks to"), THANKS);

            dialog.present (parent_window);
        }

        private static string get_copyright () {
            return "© " + get_copyright_year () + " " + Config.APP_AUTHOR;
        }

        private static string get_copyright_year () {
            var current_year = new DateTime.now_local ().get_year ();

            if (current_year > Config.CREATED_YEAR) {
                return Config.CREATED_YEAR.to_string () + " - " + current_year.to_string ();
            }

            return current_year.to_string ();
        }
    }
}