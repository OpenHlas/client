namespace App.Models {
    public class Channel : GLib.Object {
        public string id { get; construct; }
        public string name { get; construct; }
        public string channel_type { get; construct; default = "text"; }

        public Channel (string id, string name, string channel_type = "text") {
            Object (
                id: id,
                name: name,
                channel_type: channel_type
            );
        }
    }
}