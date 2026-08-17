namespace App.Services {
    public class NodeClient : GLib.Object {
        private Soup.Session session;
        private Soup.WebsocketConnection? ws_conn = null;

        public signal void event_received (string event_name, string json_data);
        public signal void message_received (string json_data);

        public NodeClient () {
            session = new Soup.Session ();
        }

        public async bool connect_to_node (string uri, string token) {
            var msg = new Soup.Message ("GET", uri);
            msg.request_headers.append ("Authorization", @"Bearer $token");

            try {
                ws_conn = yield session.websocket_connect_async (
                    msg,
                    null,
                    null,
                    GLib.Priority.DEFAULT,
                    null
                );

                ws_conn.message.connect ((type, bytes) => {
                    if (type == Soup.WebsocketDataType.TEXT) {
                        string payload = (string) bytes.get_data ();
                        parse_event_payload (payload);
                    }
                });

                return true;
            } catch (Error e) {
                warning ("Failed to connect to OpenHlas Node: %s", e.message);
                return false;
            }
        }

        public void send_message (string json_payload) {
            if (ws_conn != null && ws_conn.state == Soup.WebsocketState.OPEN) {
                ws_conn.send_text (json_payload);
            }
        }

        private void parse_event_payload (string payload) {
            try {
                var parser = new Json.Parser ();
                parser.load_from_data (payload, -1);

                var root = parser.get_root ();
                if (root == null || root.get_node_type () != Json.NodeType.OBJECT) {
                    warning ("Received WebSocket payload is not an object: %s", payload);
                    return;
                }

                var obj = root.get_object ();
                if (!obj.has_member ("event")) {
                    warning ("Received WebSocket payload does not contain an event: %s", payload);
                    return;
                }

                string event_name = obj.get_string_member ("event");
                if (!obj.has_member ("data")) {
                    event_received (event_name, "{}");
                    return;
                }

                var data = obj.get_member ("data");
                var generator = new Json.Generator ();
                generator.set_root (data.copy ());

                string json_data = generator.to_data (null);
                event_received (event_name, json_data);

                if (event_name == "message_create" || event_name == "message_created") {
                    message_received (json_data);
                }
            } catch (Error e) {
                warning ("Failed to parse WebSocket event: %s", e.message);
            }
        }
    }
}