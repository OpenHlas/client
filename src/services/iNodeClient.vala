namespace App.Services {
    public interface INodeClient : GLib.Object {
        public abstract async bool connect_to_node (string uri, string token);
        public abstract void disconnect ();
        public abstract void send_message (string json_payload);
    }
}