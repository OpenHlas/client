namespace App.Widgets {
    using Gtk;

    public class ChatArea : Gtk.Box {

        public Gtk.ListView messages_view { get; private set; }
        public signal void message_submitted (string content);

        private Gtk.StringList messages;
        private Gtk.Label channel_title;
        private Gtk.Entry message_entry;
        private Gtk.Button emoji_button;
        private Gtk.Button send_button;
        private Gtk.Revealer emoji_revealer;
        private Gtk.Overlay messages_overlay;
        private App.Utils.Emoji emoji;

        public ChatArea () {
            Object (orientation: Orientation.VERTICAL, spacing: 0);
            set_vexpand (true);
            set_hexpand (true);
            set_size_request (440, -1);

            emoji = new App.Utils.Emoji ();

            channel_title = new Gtk.Label (_("# general"));
            channel_title.set_xalign (0);
            channel_title.add_css_class ("title-3");
            channel_title.set_margin_start (18);
            channel_title.set_margin_top (14);
            channel_title.set_margin_bottom (10);
            append (channel_title);

            messages = new Gtk.StringList (null);
            messages.append (_("Jan Galek - Welcome to OpenHlas!"));
            messages.append (_("Jan Galek - Select a channel to start chatting."));

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

            var input_row = new Gtk.Box (Orientation.HORIZONTAL, 8);
            input_row.set_margin_start (18);
            input_row.set_margin_end (18);
            input_row.set_margin_top (10);
            input_row.set_margin_bottom (14);

            message_entry = new Gtk.Entry ();
            message_entry.placeholder_text = _("Write a message");
            message_entry.set_hexpand (true);
            message_entry.activate.connect (on_message_entry_activate);
            input_row.append (message_entry);

            emoji_button = new Gtk.Button.with_label ("🙂");
            emoji_button.add_css_class ("flat");
            emoji_button.set_tooltip_text (_("Insert emoji"));
            emoji_button.clicked.connect (toggle_emoji_picker);
            input_row.append (emoji_button);

            send_button = new Gtk.Button.with_label (_("Send"));
            send_button.add_css_class ("suggested-action");
            send_button.clicked.connect (submit_message);
            input_row.append (send_button);

            var categories_box = new Gtk.Box (Orientation.HORIZONTAL, 12);
            categories_box.add_css_class ("emoji-picker");
            categories_box.set_hexpand (true);
            categories_box.set_margin_top (8);
            categories_box.set_margin_bottom (8);
            categories_box.set_margin_start (8);
            categories_box.set_margin_end (8);
            apply_emoji_picker_style ();

            var category_stack = new Gtk.Stack ();
            category_stack.set_hexpand (true);
            category_stack.set_vexpand (true);
            category_stack.set_margin_end (8);
            category_stack.set_transition_type (Gtk.StackTransitionType.SLIDE_LEFT_RIGHT);

            var category_sidebar = new Gtk.StackSidebar ();
            category_sidebar.set_size_request (120, -1);
            category_sidebar.set_vexpand (true);
            category_sidebar.set_stack (category_stack);

            var emoji_scroll = new Gtk.ScrolledWindow ();
            emoji_scroll.set_policy (Gtk.PolicyType.NEVER, Gtk.PolicyType.AUTOMATIC);
            emoji_scroll.set_min_content_height (180);
            emoji_scroll.set_max_content_height (300);
            emoji_scroll.set_propagate_natural_height (false);
            emoji_scroll.set_hexpand (true);
            emoji_scroll.set_vexpand (true);
            emoji_scroll.set_child (category_stack);

            int category_index = 0;
            foreach (var category in emoji.get_picker_categories ()) {
                var emoji_flow_box = new Gtk.FlowBox ();
                emoji_flow_box.set_selection_mode (Gtk.SelectionMode.NONE);
                emoji_flow_box.set_row_spacing (4);
                emoji_flow_box.set_column_spacing (4);
                emoji_flow_box.set_homogeneous (false);
                emoji_flow_box.set_min_children_per_line (1);
                emoji_flow_box.set_max_children_per_line (12);
                emoji_flow_box.set_halign (Gtk.Align.FILL);
                emoji_flow_box.set_valign (Gtk.Align.START);
                emoji_flow_box.set_hexpand (true);
                emoji_flow_box.set_margin_end (8);

                foreach (var emoji_character in category.emojis) {
                    var emoji_button_item = new Gtk.Button.with_label (emoji_character);
                    emoji_button_item.add_css_class ("flat");
                    emoji_button_item.set_size_request (36, 36);
                    emoji_button_item.set_tooltip_text (emoji_character);
                    emoji_button_item.clicked.connect (() => {
                        insert_emoji (emoji_character);
                        emoji_revealer.reveal_child = false;
                    });
                    emoji_flow_box.append (emoji_button_item);
                }

                category_stack.add_titled (emoji_flow_box, @"category-$category_index", category.title);
                category_index++;
            }

            categories_box.append (category_sidebar);
            categories_box.append (emoji_scroll);

            emoji_revealer = new Gtk.Revealer ();
            emoji_revealer.set_transition_type (Gtk.RevealerTransitionType.SLIDE_UP);
            emoji_revealer.set_reveal_child (false);
            emoji_revealer.set_halign (Gtk.Align.FILL);
            emoji_revealer.set_hexpand (true);
            emoji_revealer.set_child (categories_box);
            emoji_revealer.set_valign (Gtk.Align.END);
            emoji_revealer.set_margin_bottom (4);
            messages_overlay.add_overlay (emoji_revealer);
            append (input_row);
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

        private void toggle_emoji_picker () {
            emoji_revealer.set_reveal_child (!emoji_revealer.reveal_child);
        }

        private void apply_emoji_picker_style () {
            var provider = new Gtk.CssProvider ();
            string css = """
                .emoji-picker {
                    background-color: @window_bg_color;
                    border: 1px solid @border_color;
                    border-radius: 8px;
                    padding: 8px;
                }
            """;
            provider.load_from_data (css.data);

            var display = Gdk.Display.get_default ();
            if (display != null) {
                Gtk.StyleContext.add_provider_for_display (
                    display,
                    provider,
                    Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
                );
            }
        }

        private void on_message_entry_activate () {
            submit_message ();
        }

        private void submit_message () {
            var content = emoji.replace_shortcodes (message_entry.text.strip ());
            if (content.length == 0) {
                return;
            }
            message_submitted (content);
            message_entry.text = "";
        }

        private void insert_emoji (string emoji) {
            var current = message_entry.text;
            message_entry.text = current + emoji;
            message_entry.grab_focus ();
            message_entry.set_position (message_entry.text.length);
        }
    }
}