namespace App.Models {
    public class User : GLib.Object {
        public string id { get; set; }
        public string username { get; set; }
        public string display_name { get; set; }
        public string avatar_url { get; set; }

        public User (string id, string username, string display_name, string avatar_url) {
            this.id = id;
            this.username = username;
            this.display_name = display_name;
            this.avatar_url = avatar_url;
        }
    }
}