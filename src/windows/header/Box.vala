namespace App.Windows.Header {
    using Adw;
    using Gtk;

    public class Box : Gtk.Box {

        public signal void nickname_change_requested (string server_id, string nickname);

        Gtk.MenuButton menu_button { get; set; }
        Gtk.MenuButton profile_button { get; set; }
        Adw.HeaderBar header_bar { get; set; }
        Gtk.Label profile_name;
        Gtk.Label profile_username;
        Gtk.Label nickname_label;
        Gtk.Label nickname_status;
        Gtk.Entry nickname_entry;
        Gtk.Button nickname_edit_button;
        App.Models.User? current_user;
        string? current_server_id;
        bool updating_nickname;
        bool nickname_editing;

        public Box () {
            var menu = new Menu ();
            menu.append (_("_Preferences"), "app.preferences");
            menu.append (_("_Keyboard Shortcuts"), "win.show-help-overlay");
            menu.append (_("_Donate"), "app.donate");
            menu.append (_("_About"), "app.about");

            menu_button = new Gtk.MenuButton ();
            menu_button.set_tooltip_text (_("Main Menu"));
            menu_button.set_icon_name ("bars-symbolic");
            menu_button.set_menu_model (menu);

            var profile_box = new Gtk.Box (Orientation.VERTICAL, 6);
            profile_box.set_margin_top (12);
            profile_box.set_margin_bottom (12);
            profile_box.set_margin_start (14);
            profile_box.set_margin_end (14);

            profile_name = new Gtk.Label (_("Jan Galek"));
            profile_name.set_xalign (0);
            profile_name.add_css_class ("heading");
            profile_box.append (profile_name);

            profile_username = new Gtk.Label (_("@jan_galek"));
            profile_username.set_xalign (0);
            profile_username.add_css_class ("dim-label");
            profile_box.append (profile_username);

            var nickname_header = new Gtk.Box (Orientation.HORIZONTAL, 8);
            nickname_label = new Gtk.Label (_("Nickname on this server"));
            nickname_label.set_xalign (0);
            nickname_label.set_hexpand (true);
            nickname_label.add_css_class ("caption");
            nickname_header.append (nickname_label);

            nickname_edit_button = new Gtk.Button ();
            nickname_edit_button.set_icon_name ("document-edit-symbolic");
            nickname_edit_button.add_css_class ("flat");
            nickname_edit_button.set_tooltip_text (_("Edit nickname"));
            nickname_edit_button.clicked.connect (toggle_nickname_editing);
            nickname_header.append (nickname_edit_button);
            profile_box.append (nickname_header);

            nickname_entry = new Gtk.Entry ();
            nickname_entry.placeholder_text = _("Use your profile name");
            nickname_entry.set_editable (false);
            nickname_entry.changed.connect (on_nickname_changed);
            profile_box.append (nickname_entry);

            nickname_status = new Gtk.Label (null);
            nickname_status.set_xalign (0);
            nickname_status.add_css_class ("success");
            profile_box.append (nickname_status);

            var notifications_row = new Gtk.Box (Orientation.HORIZONTAL, 12);
            var notifications_label = new Gtk.Label (_("Notifications"));
            notifications_label.set_xalign (0);
            notifications_label.set_hexpand (true);
            notifications_row.append (notifications_label);
            var notifications_switch = new Gtk.Switch ();
            notifications_switch.set_active (true);
            notifications_switch.set_valign (Align.CENTER);
            notifications_row.append (notifications_switch);
            profile_box.append (notifications_row);

            var profile_popover = new Gtk.Popover ();
            profile_popover.set_child (profile_box);

            profile_button = new Gtk.MenuButton ();
            profile_button.set_label ("J");
            profile_button.set_tooltip_text (_("Your profile and settings"));
            profile_button.set_popover (profile_popover);

            header_bar = new Adw.HeaderBar ();
            header_bar.pack_end (profile_button);
            header_bar.pack_end (menu_button);
            header_bar.set_hexpand (true);


            append (header_bar);
        }

        public void set_user (App.Models.User user) {
            current_user = user;
            profile_name.label = user.display_name;
            profile_username.label = @"@$(user.username)";
            profile_button.set_label (user.display_name.substring (0, 1).up ());
            update_nickname_entry ();
        }

        public void set_server_context (string server_id, string server_name) {
            current_server_id = server_id;
            nickname_label.label = @"$(server_name) - $(_("Nickname"))";
            update_nickname_entry ();
        }

        private void update_nickname_entry () {
            if (current_user == null || current_server_id == null) {
                updating_nickname = true;
                nickname_entry.text = "";
                updating_nickname = false;
                return;
            }

            updating_nickname = true;
            nickname_entry.text = current_user.get_server_nickname (current_server_id);
            updating_nickname = false;
        }

        private void on_nickname_changed () {
            if (updating_nickname || !nickname_editing) {
                return;
            }
            nickname_status.label = "";
        }

        private void toggle_nickname_editing () {
            if (nickname_editing) {
                if (current_server_id == null || nickname_entry.text.strip ().length == 0) {
                    nickname_status.label = _("Nickname cannot be empty");
                    return;
                }

                nickname_editing = false;
                nickname_entry.set_editable (false);
                nickname_edit_button.set_icon_name ("document-edit-symbolic");
                nickname_edit_button.set_tooltip_text (_("Edit nickname"));
                nickname_status.label = _("Saving nickname...");
                nickname_change_requested (current_server_id, nickname_entry.text.strip ());
                return;
            }

            nickname_editing = true;
            nickname_entry.set_editable (nickname_editing);

            nickname_edit_button.set_icon_name ("emblem-ok-symbolic");
            nickname_edit_button.set_tooltip_text (_("Save nickname"));
            nickname_entry.grab_focus ();
            nickname_entry.set_position (nickname_entry.text.length);
        }

        public void set_nickname_saved (string nickname) {
            if (current_user != null && current_server_id != null) {
                current_user.set_server_nickname (current_server_id, nickname);
            }
            nickname_status.label = _("Nickname saved");
            Timeout.add (1500, () => {
                nickname_status.label = "";
                return Source.REMOVE;
            });
        }

        public void set_nickname_failed (string error_message) {
            nickname_editing = true;
            nickname_entry.set_editable (true);
            nickname_edit_button.set_icon_name ("emblem-ok-symbolic");
            nickname_edit_button.set_tooltip_text (_("Save nickname"));
            nickname_status.label = error_message;
        }
    }
}