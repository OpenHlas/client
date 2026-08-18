namespace App.Widgets {
    using Gtk;

    public class ChatArea : Gtk.Box {

        public Gtk.ListView messages_view { get; private set; }
        public signal void message_submitted (string content);

        private Gtk.StringList messages;
        private Gtk.Label channel_title;
        private Gtk.Overlay messages_overlay;

        public ChatArea () {
            Object (orientation: Orientation.VERTICAL, spacing: 0);
            set_vexpand (true);
            set_hexpand (true);
            set_size_request (440, -1);

            channel_title = new Gtk.Label ("# general");
            channel_title.set_xalign (0);
            channel_title.add_css_class ("title-3");
            channel_title.set_margin_start (18);
            channel_title.set_margin_top (14);
            channel_title.set_margin_bottom (10);
            append (channel_title);

            messages = new Gtk.StringList (null);
            messages.append ("Jan Galek - Welcome to OpenHlas!");
            messages.append ("Jan Galek - Select a channel to start chatting.");

            var factory = new Gtk.SignalListItemFactory ();
            factory.setup.connect ((object) => {
                var list_item = object as Gtk.ListItem;
                var label = new Gtk.Label (null);
                label.set_xalign (0);
                label.set_wrap (true);
                label.set_margin_start (18);
                label.set_margin_end (18);
                label.set_margin_top (8);
                label.set_margin_bottom (8);
                list_item.child = label;
            });
            factory.bind.connect ((object) => {
                var list_item = object as Gtk.ListItem;
                var label = list_item.child as Gtk.Label;
                var item = list_item.item as Gtk.StringObject;
                label.label = item.string;
            });

            var selection_model = new Gtk.SingleSelection (messages);
            messages_view = new Gtk.ListView (selection_model, factory);
            messages_view.set_vexpand (true);

            messages_overlay = new Gtk.Overlay ();
            messages_overlay.set_vexpand (true);
            messages_overlay.set_hexpand (true);
            messages_overlay.set_child (messages_view);
            append (messages_overlay);

            var message_entry = new MessageEntry ();
            message_entry.message_submitted.connect ((content) => {
                message_submitted (content);
            });
            messages_overlay.add_overlay (message_entry.emoji_popup);
            append (message_entry);
        }

        public void set_channel (string channel_name) {
            channel_title.label = @"# $channel_name";
            while (messages.n_items > 0) {
                messages.remove (0);
            }
            messages.append (@"Jan Galek - Welcome to #$channel_name!");
            messages.append (@"Jan Galek - This is the $channel_name channel.");
        }

        public void set_messages (Gee.ArrayList<App.Models.Message> channel_messages) {
            while (messages.n_items > 0) {
                messages.remove (0);
            }
            foreach (var message in channel_messages) {
                messages.append (@"$(message.author_name) - $(message.content)");
            }
        }

    }
}