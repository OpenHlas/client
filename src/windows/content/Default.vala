namespace App.Windows.Content {
    using Adw;
    using Gtk;

    public class Default : Gtk.Box, View {
        public signal void user_loaded (Models.User user);
        private Adw.NavigationSplitView split_view;
        private Widgets.ChannelList channels_list;
        private Widgets.ChatArea chat_area;
        private unowned Gtk.ListView messages_list;
        private ViewModels.MainViewModel main_view_model;
        private Gtk.ListBox server_listbox;
        private Gtk.Box server_column;
        private Gtk.Box channel_column;
        private Gtk.Paned channel_paned;
        private int channel_split_position;

        public Default (ViewModels.MainViewModel main_view_model, int channel_split_position = 240) {
            Object (orientation: Orientation.VERTICAL, spacing: 0);
            this.main_view_model = main_view_model;
            this.channel_split_position = channel_split_position;
            build_ui ();
            bind_view_model ();
            main_view_model.initialize.begin ();
        }

        public int get_split_position () {
            return channel_paned.position;
        }

        public Gtk.Widget get_widget () {
            return this;
        }

        public void show_preferences (Gtk.Window parent) {
            if (main_view_model.current_user == null || main_view_model.servers == null) {
                return;
            }

            var application = (App.Application) GLib.Application.get_default ();
            var preferences = new Dialogs.Preferences (
                main_view_model.current_user,
                main_view_model.servers,
                application.get_language (),
                application.get_theme ()
            );
            preferences.language_changed.connect (application.set_language);
            preferences.theme_changed.connect (application.set_theme);
            preferences.nickname_change_requested.connect ((server_id, nickname) => {
                main_view_model.save_server_nickname.begin (server_id, nickname);
            });
            main_view_model.server_nickname_saved.connect (preferences.set_nickname_saved);
            main_view_model.server_nickname_failed.connect (preferences.set_nickname_failed);
            preferences.present (parent);
        }

        private void bind_view_model () {
            main_view_model.user_loaded.connect ((user) => user_loaded (user));
            main_view_model.servers_loaded.connect ((servers) => {
                foreach (var server in servers) {
                    add_server_row (server);
                }
            });
            main_view_model.channels_loaded.connect ((channels) => {
                channels_list.clear_channels ();
                foreach (var channel in channels) {
                    channels_list.add_channel (channel);
                }
                channels_list.select_first ();
            });
            main_view_model.messages_loaded.connect (chat_area.set_messages);
            main_view_model.operation_failed.connect ((operation, error_message) => {
                warning ("Failed to %s: %s", operation, error_message);
            });
        }

        private void build_ui () {
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
            main_content.set_size_request (440, -1);
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
            append (split_view);
        }

        private void add_server_row (Models.Server server) {
            var row = new Adw.ActionRow ();
            row.use_markup = false;
            row.title = "";
            row.subtitle = "";
            row.subtitle_lines = 0;
            row.set_data<string> ("server-id", server.id);
            row.set_data<string> ("server-name", server.name);
            row.set_data<string> ("server-ws-url", server.ws_url);
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

        private void on_server_selected (Gtk.ListBoxRow? row) {
            if (row == null) {
                return;
            }

            var server_id = row.get_data<string> ("server-id");
            if (server_id == null) {
                return;
            }

            var ws_url = row.get_data<string> ("server-ws-url");
            if (ws_url != null) {
                main_view_model.select_server.begin (server_id, ws_url);
            }
        }

        private void on_channel_selected (string channel_id) {
            chat_area.set_channel (channel_id);
            main_view_model.select_channel.begin (channel_id);
        }

        private void on_message_submitted (string content) {
            main_view_model.submit_message.begin (content);
        }
    }
}
