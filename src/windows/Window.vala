namespace App.Windows {
    using Adw;
    using Gtk;
    public class Window : Adw.ApplicationWindow {

        Adw.ToolbarView toolbar_view { get; set; }
        protected Gtk.Box content_box { get; set; }
        private Gtk.Stack content_stack;
        private Services.IMasterClient master_client;
        private GLib.KeyFile window_state = new GLib.KeyFile ();
        private string window_state_path;
        private Content.View? current_view;

        public Window () {
            Object (application: (Adw.Application) GLib.Application.get_default (), title: Config.APP_NAME);
            window_state_path = Path.build_filename (Environment.get_user_config_dir (), "openhlas", "window.ini");
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
            return base.close_request ();
        }

        private void load_window_state () {
            try {
                window_state.load_from_file (window_state_path, GLib.KeyFileFlags.NONE);

                var saved_split_position = window_state.get_integer ("sidebar", "channel-position");
                if (saved_split_position < 240) {
                    saved_split_position = 240;
                }

                var width = window_state.get_integer ("window", "width");
                var height = window_state.get_integer ("window", "height");
                if (width > 0 && height > 0) {
                    set_default_size (width, height);
                }
            } catch (GLib.Error e) {
                // The first run has no saved state yet.
            }
        }

        private void build_ui (owned Gtk.Box? content = null) {
            toolbar_view = new Adw.ToolbarView ();

            var header = new Header.Box ();
            header.nickname_change_requested.connect ((server_id, nickname) => {
                save_server_nickname.begin (header, server_id, nickname);
            });
            toolbar_view.add_top_bar (header);

            content_stack = new Gtk.Stack ();
            content_stack.set_vexpand (true);
            content_stack.set_hexpand (true);
            content_stack.add_named (new Content.Loading (), "loading");
            content_stack.set_visible_child_name ("loading");

            if (content == null) {
                var saved_split_position = 240;
                try {
                    window_state.load_from_file (window_state_path, GLib.KeyFileFlags.NONE);
                    saved_split_position = window_state.get_integer ("sidebar", "channel-position");
                    if (saved_split_position < 240) {
                        saved_split_position = 240;
                    }
                } catch (GLib.Error e) {
                    // The first run has no saved state yet.
                }

                current_view = new Content.Default (master_client, saved_split_position);
                var default_content = (Content.Default) current_view;
                default_content.user_loaded.connect (header.set_user);
                default_content.server_selected.connect (header.set_server_context);
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

        private async void save_server_nickname (Header.Box header, string server_id, string nickname) {
            try {
                yield master_client.set_server_nickname_async (server_id, nickname);
                header.set_nickname_saved (nickname);
            } catch (GLib.Error e) {
                header.set_nickname_failed (e.message);
            }
        }

        private void save_window_state () {
            var split_position = 240;
            if (current_view != null) {
                split_position = current_view.get_split_position ();
            }

            try {
                var config_dir = Path.get_dirname (window_state_path);
                DirUtils.create_with_parents (config_dir, 0755);
                window_state.set_integer ("window", "width", get_width ());
                window_state.set_integer ("window", "height", get_height ());
                window_state.set_integer ("sidebar", "channel-position", split_position);
                window_state.save_to_file (window_state_path);
            } catch (GLib.Error e) {
                warning ("Failed to save window state: %s", e.message);
            }
        }

    }
}