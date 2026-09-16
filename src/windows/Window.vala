namespace App.Windows {
    using Adw;
    using Gtk;

    [GtkTemplate (ui = "/com/github/OpenHlas/client/ui/window.ui")]
    public class Window : Adw.ApplicationWindow {

        [GtkChild]
        private unowned Adw.ToolbarView toolbar_view;
        [GtkChild]
        private unowned Gtk.Stack content_stack;
        private Header.Box header;
        protected Gtk.Box content_box { get; set; }
        private ViewModels.MainViewModel main_view_model;
        private GLib.Settings settings;
        private Content.View? current_view;
        private bool close_without_quitting;

        public Window (ViewModels.MainViewModel main_view_model) {
            Object (application: (Adw.Application) GLib.Application.get_default (), title: Config.APP_NAME);
            this.main_view_model = main_view_model;
            settings = new GLib.Settings ("com.github.openhlas.client");
            load_window_state ();
            build_content ();
        }

        public override bool close_request () {
            save_window_state ();
            if (!close_without_quitting) {
                var application = GLib.Application.get_default ();
                application.quit ();
            }
            return base.close_request ();
        }

        public void close_for_refresh () {
            close_without_quitting = true;
            set_visible (false);
        }

        private void load_window_state () {
            var width = settings.get_int ("window-width");
            var height = settings.get_int ("window-height");
            if (width > 0 && height > 0) {
                set_default_size (width, height);
            }
        }

        private void build_content () {
            header = new Header.Box ();
            toolbar_view.add_top_bar (header);

            content_stack.add_named (new Content.Loading (), "loading");
            content_stack.set_visible_child_name ("loading");

            var saved_split_position = settings.get_int ("channel-split-position");
            if (saved_split_position < 240) {
                saved_split_position = 240;
            }

            current_view = new Content.Default (main_view_model, saved_split_position);
            var default_content = (Content.Default) current_view;
            default_content.user_loaded.connect (header.set_user);
            default_content.user_loaded.connect (show_content);
            set_content_view ((Gtk.Box) current_view.get_widget ());
        }

        private void show_content (Models.User user) {
            content_stack.set_visible_child_name ("content");
        }

        public void set_content_view (Gtk.Box content) {
            if (this.content_box != null) {
                this.toolbar_view.set_content (null);
                this.content_box.unparent ();
                this.content_box = null;
            }

            this.content_box = content;
            content_stack.add_named (content, "content");
        }

        public void append (Gtk.Widget widget) {
            this.set_child (widget);
        }

        public void show_preferences () {
            if (current_view != null) {
                current_view.show_preferences (this);
            }
        }

        private void save_window_state () {
            var split_position = 240;
            if (current_view != null) {
                split_position = current_view.get_split_position ();
            }

            settings.set_int ("window-width", get_width ());
            settings.set_int ("window-height", get_height ());
            settings.set_int ("channel-split-position", split_position);
        }

    }
}