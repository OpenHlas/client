namespace App.Windows {
    using Adw;
    using Gtk;
    public class Window : Adw.ApplicationWindow {

        Adw.ToolbarView toolbar_view { get; set; }
        protected Gtk.Box content_box { get; set; }
        private Gtk.Stack content_stack;
        private Services.IMasterClient master_client;
        private GLib.Settings settings;
        private Content.View? current_view;
        private bool close_without_quitting;

        public Window () {
            Object (application: (Adw.Application) GLib.Application.get_default (), title: Config.APP_NAME);
            settings = new GLib.Settings ("com.github.openhlas.client");
            set_default_size (1200, 760);
            load_window_state ();
            master_client = create_master_client ();
            build_ui ();
        }

        private Services.IMasterClient create_master_client () {
            var environment = Environment.get_variable ("OPENHLAS_ENV");
            if (environment == "dev" || environment == "development") {
                message ("OpenHlas development environment: using mock master client.");
                return new Services.MockMasterClient ();
            }

            return new Services.MasterClient ();
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

        private void build_ui (owned Gtk.Box? content = null) {
            toolbar_view = new Adw.ToolbarView ();

            var header = new Header.Box ();
            toolbar_view.add_top_bar (header);

            content_stack = new Gtk.Stack ();
            content_stack.set_vexpand (true);
            content_stack.set_hexpand (true);
            content_stack.add_named (new Content.Loading (), "loading");
            content_stack.set_visible_child_name ("loading");

            if (content == null) {
                var saved_split_position = settings.get_int ("channel-split-position");
                if (saved_split_position < 240) {
                    saved_split_position = 240;
                }

                current_view = new Content.Default (master_client, saved_split_position);
                var default_content = (Content.Default) current_view;
                default_content.user_loaded.connect (header.set_user);
                default_content.user_loaded.connect (show_content);
                content = (Gtk.Box) current_view.get_widget ();
            }

            set_content_view (content);
            toolbar_view.set_content (content_stack);
            set_content (toolbar_view);
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