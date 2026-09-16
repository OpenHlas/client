namespace App.Services {
    public class MockNodeClient : GLib.Object, INodeClient {
        public bool connected { get; private set; }

        public async bool connect_to_node (string uri, string token) {
            connected = true;
            return true;
        }

        public new void disconnect () {
            connected = false;
        }

        public void send_message (string json_payload) {
        }
    }
}