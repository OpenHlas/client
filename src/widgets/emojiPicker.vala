namespace App.Widgets {
    using Gtk;

    public class EmojiPicker : Gtk.Box {
        public signal void emoji_selected (string emoji);
        public Gtk.Revealer popup { get; private set; }

        private App.Utils.Emoji emoji;

        public EmojiPicker () {
            Object (orientation: Orientation.HORIZONTAL, spacing: 0);

            emoji = new App.Utils.Emoji ();

            var button = new Gtk.Button.with_label ("🙂");
            button.add_css_class ("flat");
            button.set_tooltip_text (_("Insert emoji"));
            button.clicked.connect (toggle_popup);
            append (button);

            var categories_box = new Gtk.Box (Orientation.HORIZONTAL, 12);
            categories_box.add_css_class ("emoji-picker");
            categories_box.set_hexpand (true);
            categories_box.set_margin_top (8);
            categories_box.set_margin_bottom (8);
            categories_box.set_margin_start (8);
            categories_box.set_margin_end (8);
            apply_style ();

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
            category_stack.notify["visible-child"].connect (() => {
                emoji_scroll.get_vadjustment ().set_value (0);
            });

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
                    var emoji_button = new Gtk.Button.with_label (emoji_character);
                    emoji_button.add_css_class ("flat");
                    emoji_button.set_size_request (36, 36);
                    emoji_button.set_tooltip_text (emoji_character);
                    emoji_button.clicked.connect (() => {
                        emoji_selected (emoji_character);
                        popup.set_reveal_child (false);
                    });
                    emoji_flow_box.append (emoji_button);
                }

                category_stack.add_titled (emoji_flow_box, @"category-$category_index", category.title);
                category_index++;
            }

            categories_box.append (category_sidebar);
            categories_box.append (emoji_scroll);

            popup = new Gtk.Revealer ();
            popup.set_transition_type (Gtk.RevealerTransitionType.SLIDE_UP);
            popup.set_reveal_child (false);
            popup.set_halign (Gtk.Align.FILL);
            popup.set_hexpand (true);
            popup.set_child (categories_box);
            popup.set_valign (Gtk.Align.END);
            popup.set_margin_bottom (4);
        }

        private void toggle_popup () {
            popup.set_reveal_child (!popup.reveal_child);
        }

        private void apply_style () {
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
    }
}
