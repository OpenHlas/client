namespace App.Models {
    public class Message : GLib.Object {
        public string id { get; construct; }
        public string channel_id { get; construct; }
        public string author_id { get; construct; }
        public string author_name { get; construct; }
        public string content { get; construct; }
        public int64 timestamp { get; construct; }

        public Message (string id, string channel_id, string author_id,
                        string author_name, string content, int64 timestamp) {
            Object (
                id: id,
                channel_id: channel_id,
                author_id: author_id,
                author_name: author_name,
                content: content,
                timestamp: timestamp
            );
        }
    }
}