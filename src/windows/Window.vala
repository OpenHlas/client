namespace App.Windows {
    using Adw;
    using Gtk;
    public class Window : Adw.ApplicationWindow {

        Adw.ToolbarView toolbar_view { get; set; }
        protected Gtk.Box content_box { get; set; }
        private Adw.NavigationSplitView split_view;
        private Widgets.ChannelList channels_list;
        private Widgets.ChatArea chat_area;
        private unowned Gtk.ListView messages_list;

        private Services.IMasterClient master_client;
        private Gtk.ListBox server_listbox;
        private Gtk.Box server_column;
        private Gtk.Box channel_column;
        private Gtk.Paned channel_paned;
        private int channel_split_position = 240;
        private string? selected_channel_id;
        private GLib.KeyFile window_state = new GLib.KeyFile ();
        private string window_state_path;

        public Window () {
            Object (application: (Adw.Application) GLib.Application.get_default (), title: Config.APP_NAME);
            window_state_path = Path.build_filename (Environment.get_user_config_dir (), "openhlas", "window.ini");
            set_default_size (1200, 760);
            load_window_state ();
            build_ui ();
            master_client = create_master_client ();
            load_initial_data.begin ();
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
                channel_split_position = window_state.get_integer ("sidebar", "channel-position");
                if (channel_split_position < 240) {
                    channel_split_position = 240;
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

        private void save_window_state () {
            try {
                var config_dir = Path.get_dirname (window_state_path);
                DirUtils.create_with_parents (config_dir, 0755);
                window_state.set_integer ("window", "width", get_width ());
                window_state.set_integer ("window", "height", get_height ());
                window_state.set_integer ("sidebar", "channel-position", channel_paned.position);
                window_state.save_to_file (window_state_path);
            } catch (GLib.Error e) {
                warning ("Failed to save window state: %s", e.message);
            }
        }

        private async void load_initial_data () {
            try {
                // Přihlásíme mockovaného uživatele admin/admin
                yield master_client.login_async ("admin", "admin");

                // Načteme jeho servery
                var servers = yield master_client.get_my_servers_async ();

                foreach (var server in servers) {
                    add_server_row (server);
                }
            } catch (GLib.Error e) {
                warning ("Failed to load data from the master server: %s", e.message);
            }
        }

        private void add_server_row (Models.Server server) {
            var row = new Adw.ActionRow ();
            row.use_markup = false;
            row.title = "";
            row.subtitle = "";
            row.subtitle_lines = 0;
            row.set_data<string> ("server-id", server.id);
            row.set_tooltip_text (server.name);
            row.add_prefix (create_server_avatar (server));
            server_listbox.append (row);
            if (server_listbox.get_selected_row () == null) {
                server_listbox.select_row (row);
            }
        }

        private Gtk.Widget create_server_avatar (Models.Server server) {
            var avatar = new Adw.Avatar (40, get_server_initials (server.name), true);

            if (server.image_path != null && FileUtils.test (server.image_path, FileTest.IS_REGULAR)) {
                try {
                    avatar.custom_image = Gdk.Texture.from_filename (server.image_path);
                    avatar.show_initials = false;
                } catch (GLib.Error e) {
                    warning ("Failed to load server image '%s': %s", server.image_path, e.message);
                }
            }

            return avatar;
        }

        private string get_server_initials (string server_name) {
            var normalized_name = server_name.strip ();
            if (normalized_name.length <= 2) {
                return normalized_name.up ();
            }
            return normalized_name.substring (0, 2).up ();
        }

        private void build_ui (owned Gtk.Box? content = null) {
            toolbar_view = new Adw.ToolbarView ();

            var header = new Header.Box ();
            toolbar_view.add_top_bar (header);

            if (content == null) {
                var root = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
                root.set_vexpand (true);
                root.set_hexpand (true);
                split_view = new Adw.NavigationSplitView ();
                split_view.set_vexpand (true);
                split_view.set_hexpand (true);
                split_view.set_min_sidebar_width (72);
                split_view.set_max_sidebar_width (88);
                split_view.set_sidebar_width_fraction (0.08);

                server_column = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
                server_column.set_size_request (72, -1);

                server_listbox = new Gtk.ListBox ();
                server_listbox.selection_mode = Gtk.SelectionMode.SINGLE;
                server_listbox.set_show_separators (false);
                server_listbox.set_vexpand (true);
                server_listbox.row_selected.connect (on_server_selected);
                server_column.append (server_listbox);

                channel_column = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
                channel_column.set_size_request (240, -1);
                channel_column.set_vexpand (true);
                channel_column.set_hexpand (true);

                var channel_toolbar = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
                channel_toolbar.set_margin_start (12);
                channel_toolbar.set_margin_end (8);
                channel_toolbar.set_margin_top (6);
                channel_toolbar.set_margin_bottom (6);

                var channels_label = new Gtk.Label (_("Channels"));
                channels_label.set_xalign (0);
                channels_label.set_hexpand (false);
                channels_label.set_ellipsize (Pango.EllipsizeMode.NONE);
                channels_label.add_css_class ("heading");
                channel_toolbar.append (channels_label);
                var channel_toolbar_spacer = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
                channel_toolbar_spacer.set_hexpand (true);
                channel_toolbar.append (channel_toolbar_spacer);
                channel_column.append (channel_toolbar);

                channels_list = new Widgets.ChannelList ();
                channels_list.set_vexpand (true);
                channels_list.channel_selected.connect (on_channel_selected);
                channel_column.append (channels_list);

                chat_area = new Widgets.ChatArea ();
                chat_area.message_submitted.connect (on_message_submitted);
                messages_list = chat_area.messages_view;
                var main_content = new Content.Box ();
                main_content.set_vexpand (true);
                main_content.set_hexpand (true);
                main_content.set_size_request (420, -1);
                main_content.append (chat_area);

                channel_paned = new Gtk.Paned (Gtk.Orientation.HORIZONTAL);
                channel_paned.set_vexpand (true);
                channel_paned.set_hexpand (true);
                channel_paned.set_wide_handle (true);
                channel_paned.set_resize_start_child (false);
                channel_paned.set_resize_end_child (true);
                channel_paned.set_shrink_start_child (false);
                channel_paned.set_shrink_end_child (false);
                channel_paned.set_start_child (channel_column);
                channel_paned.set_end_child (main_content);
                channel_paned.set_position (channel_split_position);

                split_view.set_sidebar (new Adw.NavigationPage (server_column, _("Servers")));
                split_view.set_content (new Adw.NavigationPage (channel_paned, _("Chat")));
                root.append (split_view);
                content = root;
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

        private void on_server_selected (Gtk.ListBoxRow? row) {
            if (row == null) {
                return;
            }

            var server_id = row.get_data<string> ("server-id");
            if (server_id == null) {
                return;
            }

            load_channels_for_server.begin (server_id);
        }

        private void on_channel_selected (string channel_id) {
            selected_channel_id = channel_id;
            chat_area.set_channel (channel_id);
            load_messages_for_channel.begin (channel_id);
        }

        private async void load_channels_for_server (string server_id) {
            try {
                var channels = yield master_client.get_channels_async (server_id);
                channels_list.clear_channels ();
                foreach (var channel in channels) {
                    channels_list.add_channel (channel);
                }
                channels_list.select_first ();
            } catch (GLib.Error e) {
                warning ("Failed to load channels: %s", e.message);
            }
        }

        private async void load_messages_for_channel (string channel_id) {
            try {
                var messages = yield master_client.get_messages_async (channel_id);
                chat_area.set_messages (messages);
            } catch (GLib.Error e) {
                warning ("Failed to load messages: %s", e.message);
            }
        }

        private void on_message_submitted (string content) {
            if (selected_channel_id != null) {
                send_message.begin (selected_channel_id, content);
            }
        }

        private async void send_message (string channel_id, string content) {
            try {
                yield master_client.send_message_async (channel_id, content);
                yield load_messages_for_channel (channel_id);
            } catch (GLib.Error e) {
                warning ("Failed to send message: %s", e.message);
            }
        }

    }
}