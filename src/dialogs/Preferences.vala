namespace App.Dialogs {
    using Adw;
    using Gtk;

    public class Preferences : Adw.PreferencesDialog {
        public signal void nickname_change_requested (string server_id, string nickname);
        public signal void language_changed (string language);
        public signal void theme_changed (string theme);

        private App.Models.User user;
        private Gee.ArrayList<App.Models.Server> servers;
        private Gee.HashMap<string, Gtk.Entry> nickname_entries;
        private Gee.HashMap<string, Gtk.Label> status_labels;

        private string current_language;
        private string current_theme;

        public Preferences (App.Models.User user, Gee.ArrayList<App.Models.Server> servers, string current_language, string current_theme) {
            this.user = user;
            this.servers = servers;
            this.current_language = current_language;
            this.current_theme = current_theme;
            nickname_entries = new Gee.HashMap<string, Gtk.Entry> ();
            status_labels = new Gee.HashMap<string, Gtk.Label> ();
            build_ui ();
        }

        private void build_ui () {
            set_title (_("Preferences"));

            var general_page = new Adw.PreferencesPage ();
            general_page.set_title (_("General"));
            general_page.set_icon_name ("preferences-system-symbolic");

            var general_group = new Adw.PreferencesGroup ();
            general_group.set_title (_("Basic settings"));
            general_group.set_description (_("Control the basic behavior of OpenHlas."));

            var notifications_row = new Adw.SwitchRow ();
            notifications_row.set_title (_("Notifications"));
            notifications_row.set_subtitle (_("Show notifications for new messages."));
            notifications_row.set_active (true);
            general_group.add (notifications_row);

            var language_row = new Adw.ComboRow ();
            language_row.set_title (_("Language"));
            var languages = new Gtk.StringList ({ "English", "Czech" });
            language_row.set_model (languages);
            language_row.selected = current_language == "cs" ? 1 : 0;
            language_row.notify["selected"].connect (() => {
                language_changed (language_row.selected == 1 ? "cs" : "en");
            });
            general_group.add (language_row);

            var theme_row = new Adw.ComboRow ();
            theme_row.set_title (_("Theme"));
            var themes = new Gtk.StringList ({ "System", "Light", "Dark" });
            theme_row.set_model (themes);
            theme_row.selected = current_theme == "light" ? 1 : current_theme == "dark" ? 2 : 0;
            theme_row.notify["selected"].connect (() => {
                var theme = theme_row.selected == 1 ? "light" : theme_row.selected == 2 ? "dark" : "system";
                theme_changed (theme);
            });
            general_group.add (theme_row);
            general_page.add (general_group);
            add (general_page);

            var servers_page = new Adw.PreferencesPage ();
            servers_page.set_title (_("Servers"));
            servers_page.set_icon_name ("network-server-symbolic");

            var servers_group = new Adw.PreferencesGroup ();
            servers_group.set_title (_("Server nicknames"));
            servers_group.set_description (_("Choose how other users see you on each server."));

            foreach (var server in servers) {
                var row = new Adw.ActionRow ();
                row.use_markup = false;
                row.set_title (server.name);
                row.set_subtitle (user.get_server_nickname (server.id));

                var nickname_entry = new Gtk.Entry ();
                nickname_entry.set_text (user.get_server_nickname (server.id));
                nickname_entry.set_width_chars (14);
                nickname_entry.set_valign (Align.CENTER);
                nickname_entries[server.id] = nickname_entry;
                row.add_suffix (nickname_entry);

                var save_button = new Gtk.Button ();
                save_button.set_icon_name ("document-save-symbolic");
                save_button.add_css_class ("flat");
                save_button.set_tooltip_text (_("Save nickname"));
                save_button.set_valign (Align.CENTER);
                save_button.clicked.connect (() => {
                    save_nickname (server.id, nickname_entry.text);
                });
                row.add_suffix (save_button);

                var status_label = new Gtk.Label (null);
                status_label.add_css_class ("dim-label");
                status_labels[server.id] = status_label;
                row.add_suffix (status_label);
                servers_group.add (row);
            }

            servers_page.add (servers_group);
            add (servers_page);
        }

        private void save_nickname (string server_id, string nickname) {
            var trimmed_nickname = nickname.strip ();
            if (trimmed_nickname.length == 0) {
                status_labels[server_id].label = _("Nickname cannot be empty");
                return;
            }

            status_labels[server_id].label = _("Saving...");
            nickname_change_requested (server_id, trimmed_nickname);
        }

        public void set_nickname_saved (string server_id, string nickname) {
            user.set_server_nickname (server_id, nickname);
            nickname_entries[server_id].text = nickname;
            status_labels[server_id].label = _("Saved");
        }

        public void set_nickname_failed (string server_id, string message) {
            status_labels[server_id].label = message;
        }
    }
}
