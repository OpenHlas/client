namespace App.Widgets {
    using Gtk;

    [GtkTemplate (ui = "/com/github/OpenHlas/client/ui/chat-area.ui")]
    public class ChatArea : Gtk.Box {

        [GtkChild]
        public unowned Gtk.ListView messages_view;
        public signal void message_submitted (string content);

        private Gtk.StringList messages;
        [GtkChild]
        private unowned Gtk.Label channel_title;
        [GtkChild]
        private unowned Gtk.Overlay messages_overlay;

        public ChatArea () {
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
            messages_view.model = selection_model;
            messages_view.factory = factory;

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