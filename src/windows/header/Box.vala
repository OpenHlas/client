namespace App.Windows.Header {
    using Adw;
    using Gtk;

    public class Box : Gtk.Box {

        Gtk.MenuButton menu_button { get; set; }
        Adw.HeaderBar header_bar { get; set; }

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

            header_bar = new Adw.HeaderBar ();
            header_bar.pack_end (menu_button);
            header_bar.set_hexpand (true);


            append (header_bar);
        }
    }
}