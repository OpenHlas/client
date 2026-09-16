namespace App.ViewModels {
    public class MainViewModel : GLib.Object {
        public signal void user_loaded (Models.User user);
        public signal void servers_loaded (Gee.ArrayList<Models.Server> servers);
        public signal void channels_loaded (Gee.ArrayList<Models.Channel> channels);
        public signal void messages_loaded (Gee.ArrayList<Models.Message> messages);
        public signal void server_nickname_saved (string server_id, string nickname);
        public signal void server_nickname_failed (string server_id, string error_message);
        public signal void operation_failed (string operation, string error_message);

        private Services.IMasterClient master_client;
        private Services.INodeClient node_client;

        public Models.User? current_user { get; private set; }
        public Gee.ArrayList<Models.Server>? servers { get; private set; }
        public string? selected_server_id { get; private set; }
        public string? selected_channel_id { get; private set; }

        public MainViewModel (Services.IMasterClient master_client, Services.INodeClient node_client) {
            this.master_client = master_client;
            this.node_client = node_client;
        }

        public async void initialize () {
            try {
                yield master_client.login_async ("admin", "admin");
                current_user = master_client.get_current_user ();
                if (current_user != null) {
                    user_loaded (current_user);
                }

                servers = yield master_client.get_my_servers_async ();
                servers_loaded (servers);
            } catch (GLib.Error error) {
                operation_failed (_("load initial data"), error.message);
            }
        }

        public async void select_server (string server_id, string ws_url) {
            selected_server_id = server_id;
            node_client.disconnect ();

            try {
                var token = master_client.get_current_token ();
                if (token != null) {
                    yield node_client.connect_to_node (ws_url, token);
                }

                var channels = yield master_client.get_channels_async (server_id);
                channels_loaded (channels);
            } catch (GLib.Error error) {
                operation_failed (_("load channels"), error.message);
            }
        }

        public async void select_channel (string channel_id) {
            selected_channel_id = channel_id;
            try {
                var messages = yield master_client.get_messages_async (channel_id);
                messages_loaded (messages);
            } catch (GLib.Error error) {
                operation_failed (_("load messages"), error.message);
            }
        }

        public async void submit_message (string content) {
            if (selected_server_id == null || selected_channel_id == null) {
                return;
            }

            try {
                yield master_client.send_message_async (selected_server_id, selected_channel_id, content);
                yield select_channel (selected_channel_id);
            } catch (GLib.Error error) {
                operation_failed (_("send message"), error.message);
            }
        }

        public async void save_server_nickname (string server_id, string nickname) {
            try {
                yield master_client.set_server_nickname_async (server_id, nickname);
                server_nickname_saved (server_id, nickname);
            } catch (GLib.Error error) {
                server_nickname_failed (server_id, error.message);
                operation_failed (_("save nickname"), error.message);
            }
        }
    }
}