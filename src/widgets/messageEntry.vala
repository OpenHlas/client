namespace App.Widgets {
    using Gtk;

    public class MessageEntry : Gtk.Box {
        public signal void message_submitted (string content);
        public Gtk.Widget emoji_popup { get; private set; }

        private Gtk.Entry entry;
        private App.Utils.Emoji emoji;
        private EmojiPicker emoji_picker;

        public MessageEntry () {
            Object (orientation: Orientation.HORIZONTAL, spacing: 8);
            set_margin_start (18);
            set_margin_end (18);
            set_margin_top (10);
            set_margin_bottom (14);

            emoji = new App.Utils.Emoji ();
            entry = new Gtk.Entry ();
            entry.placeholder_text = _("Write a message");
            entry.set_hexpand (true);
            entry.activate.connect (submit_message);
            append (entry);

            emoji_picker = new EmojiPicker ();
            emoji_picker.emoji_selected.connect (insert_emoji);
            emoji_popup = emoji_picker.popup;
            append (emoji_picker);

            var send_button = new Gtk.Button.with_label (_("Send"));
            send_button.add_css_class ("suggested-action");
            send_button.clicked.connect (submit_message);
            append (send_button);
        }

        private void submit_message () {
            var content = emoji.replace_shortcodes (entry.text.strip ());
            if (content.length == 0) {
                return;
            }
            message_submitted (content);
            entry.text = "";
        }

        private void insert_emoji (string value) {
            entry.text = entry.text + value;
            entry.grab_focus ();
            entry.set_position (entry.text.length);
        }
    }
}
