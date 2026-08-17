namespace App.Models {
    public class Server : GLib.Object {
        public string id { get; set; }
        public string name { get; set; }
        public string ws_url { get; set; }
        public string? icon_name { get; set; default = "network-server-symbolic"; }
        public string? image_path { get; set; default = null; }

        public Server (string id, string name, string ws_url) {
            this.id = id;
            this.name = name;
            this.ws_url = ws_url;
        }
    }
}