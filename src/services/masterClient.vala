namespace App.Services {
    public class MasterClient : GLib.Object, IMasterClient {

        private MasterError unavailable () {
            return new MasterError.NETWORK_ERROR (
                "Produkční master server zatím není implementovaný. Nastav OPENHLAS_ENV=dev pro vývojová mock data."
            );
        }

        public async bool login_async (string username, string password) throws GLib.Error {
            throw unavailable ();
        }

        public async bool register_async (string username, string email, string password) throws GLib.Error {
            throw unavailable ();
        }

        public string? get_current_token () {
            return null;
        }

        public App.Models.User? get_current_user () {
            return null;
        }

        public async Gee.ArrayList<App.Models.Server> get_my_servers_async () throws GLib.Error {
            throw unavailable ();
        }

        public async Gee.ArrayList<App.Models.Server> discover_servers_async () throws GLib.Error {
            throw unavailable ();
        }

        public async Gee.ArrayList<App.Models.Channel> get_channels_async (string server_id) throws GLib.Error {
            throw unavailable ();
        }

        public async Gee.ArrayList<App.Models.Message> get_messages_async (string channel_id) throws GLib.Error {
            throw unavailable ();
        }

        public async App.Models.Message send_message_async (string channel_id, string content) throws GLib.Error {
            throw unavailable ();
        }
    }
}