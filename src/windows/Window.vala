namespace App.Windows {
    using Adw;
    using Gtk;
    public class Window : Adw.ApplicationWindow {

        Adw.ToolbarView toolbar_view { get; set; }
        protected Gtk.Box content_box { get; set; }

        public Window () {
            Object (application: (Adw.Application) GLib.Application.get_default (), title: Config.APP_NAME);
            build_ui ();
        }

        private void build_ui (owned Gtk.Box? content = null) {
            toolbar_view = new Adw.ToolbarView ();

            var header = new Header.Box ();
            toolbar_view.add_top_bar (header);

            if (content == null) {
                content = new Content.Box ();
            }

            set_content_view (content);
            set_content (toolbar_view);
        }

        public void set_content_view (Gtk.Box content) {
            if (this.content_box != null) {
                this.toolbar_view.set_content (null);
                this.content_box.unparent ();
                this.content_box = null;
            }

            this.content_box = content;
            this.toolbar_view.set_content (content);
        }

        public void append (Gtk.Widget widget) {
            this.set_child (widget);
        }
    }
}