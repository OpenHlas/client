namespace App.Windows.Content {
    public interface View : GLib.Object {
        public abstract int get_split_position ();
        public abstract Gtk.Widget get_widget ();
    }
}
