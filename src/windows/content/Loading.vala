namespace App.Windows.Content {
    using Gtk;
    using WebKit;

    public class Loading : Gtk.Box {
        public Loading () {
            Object (orientation: Orientation.VERTICAL, spacing: 12);
            set_halign (Align.CENTER);
            set_valign (Align.CENTER);

            var loading_web_view = new WebView ();
            loading_web_view.set_size_request (180, 180);
            loading_web_view.set_background_color ({ 0.0f, 0.0f, 0.0f, 0.0f });

            var svg_data = GLib.resources_lookup_data (
                "/com/github/OpenHlas/client/icons/scalable/apps/openHlas-loading.svg",
                GLib.ResourceLookupFlags.NONE
            );
            var svg = (string) svg_data.get_data ();
            var html = @"<html><head><style>html,body{margin:0;background:transparent;overflow:hidden}svg{width:180px;height:180px;display:block}</style></head><body>$svg</body></html>";
            loading_web_view.load_html (html, "about:blank");
            append (loading_web_view);

            var loading_label = new Gtk.Label (_("Loading"));
            loading_label.add_css_class ("title-3");
            append (loading_label);

        }
    }
}
