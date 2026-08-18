namespace App.Windows.Header {
    using Adw;
    using Gtk;

    public class Box : Gtk.Box {
        private Gtk.MenuButton profile_button;
        private Gtk.Label profile_name;
        private Gtk.Label profile_username;

        public Box () {
            var menu = new Menu ();
            menu.append (_("_Preferences"), "app.preferences");
            menu.append (_("_Keyboard Shortcuts"), "win.show-help-overlay");
            menu.append (_("_Donate"), "app.donate");
            menu.append (_("_About"), "app.about");

            var menu_button = new Gtk.MenuButton ();
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

            var profile_popover = new Gtk.Popover ();
            profile_popover.set_child (profile_box);

            profile_button = new Gtk.MenuButton ();
            profile_button.set_label ("J");
            profile_button.set_tooltip_text (_("Your profile"));
            profile_button.set_popover (profile_popover);

            var header_bar = new Adw.HeaderBar ();
            header_bar.pack_end (profile_button);
            header_bar.pack_end (menu_button);
            header_bar.set_hexpand (true);
            append (header_bar);
        }

        public void set_user (App.Models.User user) {
            profile_name.label = user.display_name;
            profile_username.label = @"@$(user.username)";
            profile_button.set_label (user.display_name.substring (0, 1).up ());
        }
    }
}
