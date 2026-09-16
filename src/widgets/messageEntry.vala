namespace App.Widgets {
    using Gtk;

    [GtkTemplate (ui = "/com/github/OpenHlas/client/ui/message-entry.ui")]
    public class MessageEntry : Gtk.Box {
        public signal void message_submitted (string content);
        public Gtk.Widget emoji_popup { get; private set; }

        [GtkChild]
        private unowned Gtk.Entry entry;
        [GtkChild]
        private unowned Gtk.Box emoji_slot;
        [GtkChild]
        private unowned Gtk.Button send_button;
        private App.Utils.Emoji emoji;
        private EmojiPicker emoji_picker;

        public MessageEntry () {
            emoji = new App.Utils.Emoji ();
            entry.activate.connect (submit_message);

            emoji_picker = new EmojiPicker ();
            emoji_picker.emoji_selected.connect (insert_emoji);
            emoji_popup = emoji_picker.popup;
            emoji_slot.append (emoji_picker);

            send_button.clicked.connect (submit_message);
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
