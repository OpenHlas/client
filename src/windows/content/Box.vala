namespace App.Windows.Content {
    using Adw;
    using Gtk;

    public class Box : Gtk.Box {
        public Box () {
            Object (orientation: Orientation.VERTICAL, spacing: 0);
        }
    }
}