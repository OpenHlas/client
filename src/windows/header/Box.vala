namespace App.Windows.Header {
    using Adw;
    using Gtk;

    [GtkTemplate (ui = "/com/github/OpenHlas/client/ui/header.ui")]
    public class Box : Gtk.Box {
        [GtkChild]
        private unowned Gtk.MenuButton menu_button;
        [GtkChild]
        private unowned Gtk.MenuButton profile_button;
        [GtkChild]
        private unowned Gtk.Label profile_name;
        [GtkChild]
        private unowned Gtk.Label profile_username;

        public Box () {
            var menu = new Menu ();
            menu.append (_("_Preferences"), "app.preferences");
            menu.append (_("_Keyboard Shortcuts"), "win.show-help-overlay");
            menu.append (_("_Donate"), "app.donate");
            menu.append (_("_About"), "app.about");

            menu_button.set_tooltip_text (_("Main Menu"));
            menu_button.set_icon_name ("bars-symbolic");
            menu_button.set_menu_model (menu);
        }

        public void set_user (App.Models.User user) {
            profile_name.label = user.display_name;
            profile_username.label = @"@$(user.username)";
            profile_button.set_label (user.display_name.substring (0, 1).up ());
        }
    }
}
