namespace App.Services {
    public class MockMasterClient : GLib.Object, IMasterClient {
        private string? auth_token = null;
        private App.Models.User? current_user = null;
        private Gee.HashMap<string, Gee.ArrayList<App.Models.Channel>> channels_by_server;
        private Gee.HashMap<string, Gee.ArrayList<App.Models.Message>> messages_by_channel;

        public MockMasterClient () {
            channels_by_server = new Gee.HashMap<string, Gee.ArrayList<App.Models.Channel>> ();
            messages_by_channel = new Gee.HashMap<string, Gee.ArrayList<App.Models.Message>> ();
            seed_data ();
        }

        private void seed_data () {
            add_server_channels ("srv_1", { "general", "notes", "links" });
            add_server_channels ("srv_2", { "lobby", "gaming", "off-topic" });
            add_server_channels ("srv_3", { "development", "releases", "help" });

            add_message ("general", "Jan Galek", "Welcome to OpenHlas!");
            add_message ("general", "Jan Galek", "Select a channel to start chatting.");
            add_message ("development", "Jan Galek", "Welcome to the development channel.");
            add_message ("gaming", "Jan Galek", "What are you playing today?");
        }

        private void add_server_channels (string server_id, string[] names) {
            var channels = new Gee.ArrayList<App.Models.Channel> ();
            foreach (var name in names) {
                channels.add (new App.Models.Channel (name, name));
            }
            channels_by_server.set (server_id, channels);
        }

        private void add_message (string channel_id, string author_name, string content) {
            if (!messages_by_channel.has_key (channel_id)) {
                messages_by_channel.set (channel_id, new Gee.ArrayList<App.Models.Message> ());
            }
            var messages = messages_by_channel.get (channel_id);
            messages.add (new App.Models.Message (
                @"msg_$(messages.size)", channel_id, "usr_1", author_name, content, GLib.get_real_time ()
            ));
        }

        public string? get_current_token () {
            return auth_token;
        }

        public App.Models.User? get_current_user () {
            return current_user;
        }

        private async void sleep_async (uint interval_ms) {
            Timeout.add (interval_ms, () => {
                sleep_async.callback ();
                return Source.REMOVE;
            });
            yield;
        }

        public async bool login_async (string username, string password) throws GLib.Error {
            yield sleep_async (3500);

            if (username == "admin" && password == "admin") {
                auth_token = "mock_jwt_token_123456789";
                current_user = new App.Models.User ("usr_1", "jan_galek", "Jan Galek", "avatar_1.png");
                return true;
            }

            throw new MasterError.AUTH_FAILED ("Neplatné uživatelské jméno nebo heslo.");
        }

        public async bool register_async (string username, string email, string password) throws GLib.Error {
            yield sleep_async (300);
            auth_token = "mock_jwt_token_987654321";
            current_user = new App.Models.User ("usr_2", username, username, "default_avatar.png");
            return true;
        }

        public async Gee.ArrayList<App.Models.Server> get_my_servers_async () throws GLib.Error {
            yield sleep_async (200);

            var servers = new Gee.ArrayList<App.Models.Server> ();

            // Mockovaný profilový server (osobní)
            var personal = new App.Models.Server ("srv_1", "Můj Profil & Zápisky", "ws://localhost:8081/ws");
            personal.icon_name = "user-info-symbolic";
            servers.add (personal);

            // Mockovaný herní server
            var gaming = new App.Models.Server ("srv_2", "Herní Komunita", "ws://localhost:8082/ws");
            gaming.icon_name = "input-gaming-symbolic";
            servers.add (gaming);

            // Mockovaný vývojářský server
            var dev = new App.Models.Server ("srv_3", "Vala & Go Devs", "ws://localhost:8083/ws");
            dev.icon_name = "code-context-symbolic";
            servers.add (dev);

            return servers;
        }

        public async Gee.ArrayList<App.Models.Server> discover_servers_async () throws GLib.Error {
            yield sleep_async (200);

            var servers = new Gee.ArrayList<App.Models.Server> ();
            servers.add (new App.Models.Server ("srv_pub_1", "OpenHlas CZ/SK", "ws://openhlas.cz/ws"));
            servers.add (new App.Models.Server ("srv_pub_2", "Linux Gaming", "ws://linuxgaming.org/ws"));

            return servers;
        }

        public async Gee.ArrayList<App.Models.Channel> get_channels_async (string server_id) throws GLib.Error {
            yield sleep_async (100);
            var channels = channels_by_server.get (server_id);
            if (channels == null) {
                throw new MasterError.INVALID_DATA ("Server neexistuje.");
            }
            return channels;
        }

        public async Gee.ArrayList<App.Models.Message> get_messages_async (string channel_id) throws GLib.Error {
            yield sleep_async (100);
            if (!messages_by_channel.has_key (channel_id)) {
                messages_by_channel.set (channel_id, new Gee.ArrayList<App.Models.Message> ());
            }
            return messages_by_channel.get (channel_id);
        }

        public async bool set_server_nickname_async (string server_id, string nickname) throws GLib.Error {
            yield sleep_async (80);
            var trimmed_nickname = nickname.strip ();
            if (current_user == null || trimmed_nickname.length == 0) {
                throw new MasterError.INVALID_DATA ("Nickname nesmí být prázdný.");
            }

            current_user.set_server_nickname (server_id, trimmed_nickname);
            return true;
        }

        public async App.Models.Message send_message_async (string server_id, string channel_id, string content) throws GLib.Error {
            yield sleep_async (50);
            var trimmed_content = content.strip ();
            if (trimmed_content.length == 0) {
                throw new MasterError.INVALID_DATA ("Zpráva nesmí být prázdná.");
            }
            var author_name = current_user != null
                ? current_user.get_server_nickname (server_id)
                : "Jan Galek";
            add_message (channel_id, author_name, trimmed_content);
            var messages = messages_by_channel.get (channel_id);
            return messages.get (messages.size - 1);
        }
    }
}