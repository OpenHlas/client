namespace App.Widgets {
    using Adw;
    using Gtk;

    public class ChannelList : Gtk.Box {

        private Gtk.ListBox list_box;
        private Gee.ArrayList<Adw.ActionRow> rows = new Gee.ArrayList<Adw.ActionRow> ();

        public signal void channel_selected (string channel_id);

        public ChannelList () {
            Object (orientation: Gtk.Orientation.VERTICAL, spacing: 0);

            list_box = new Gtk.ListBox ();
            list_box.selection_mode = Gtk.SelectionMode.SINGLE;
            list_box.set_show_separators (false);
            list_box.set_vexpand (false);
            list_box.row_selected.connect (on_row_selected);
            append (list_box);
        }

        private void on_row_selected (Gtk.ListBoxRow? row) {
            if (row == null) {
                return;
            }

            var channel_id = row.get_data<string> ("channel-id");
            if (channel_id != null) {
                channel_selected (channel_id);
            }
        }

        public void add_channel (App.Models.Channel channel) {
            var row = new Adw.ActionRow ();
            row.title = @"# $(channel.name)";
            row.set_activatable (true);
            row.set_data<string> ("channel-id", channel.id);
            row.set_data<string> ("channel-name", channel.name);
            list_box.append (row);
            rows.add (row);
        }

        public void clear_channels () {
            list_box.remove_all ();
            rows.clear ();
        }

        public void select_first () {
            list_box.select_row (list_box.get_row_at_index (0));
        }

        public void set_compact (bool compact) {
            foreach (var row in rows) {
                var channel_name = row.get_data<string> ("channel-name");
                row.title = compact ? "" : @"# $channel_name";
            }
        }
    }
}