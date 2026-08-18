namespace App.Models {
    public class User : GLib.Object {
        public string id { get; set; }
        public string username { get; set; }
        public string display_name { get; set; }
        public string avatar_url { get; set; }
        private Gee.HashMap<string, string> server_nicknames;

        public User (string id, string username, string display_name, string avatar_url) {
            this.id = id;
            this.username = username;
            this.display_name = display_name;
            this.avatar_url = avatar_url;
            server_nicknames = new Gee.HashMap<string, string> ();
        }

        public string get_server_nickname (string server_id) {
            if (server_nicknames.has_key (server_id)) {
                return server_nicknames[server_id];
            }
            return display_name;
        }

        public void set_server_nickname (string server_id, string nickname) {
            server_nicknames[server_id] = nickname.strip ();
        }
    }
}