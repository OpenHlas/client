namespace App.Services {
    public interface IMasterClient : GLib.Object {
        public abstract async bool login_async (string username, string password) throws GLib.Error;
        public abstract async bool register_async (string username, string email, string password) throws GLib.Error;

        public abstract string? get_current_token ();
        public abstract App.Models.User? get_current_user ();
        public abstract async Gee.ArrayList<App.Models.Server> get_my_servers_async () throws GLib.Error;
        public abstract async Gee.ArrayList<App.Models.Server> discover_servers_async () throws GLib.Error;
        public abstract async Gee.ArrayList<App.Models.Channel> get_channels_async (string server_id) throws GLib.Error;
        public abstract async Gee.ArrayList<App.Models.Message> get_messages_async (string channel_id) throws GLib.Error;
        public abstract async App.Models.Message send_message_async (string channel_id, string content) throws GLib.Error;
    }

    public errordomain MasterError {
        AUTH_FAILED,
        NETWORK_ERROR,
        INVALID_DATA,
        SERVER_ERROR
    }
}