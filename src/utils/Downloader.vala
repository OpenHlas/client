namespace App.Utils {
    using Soup;
    using GLib;

    public class Downloader : Object {
        public signal void progress_changed (double percent);

        private Session session;

        public Downloader () {
            session = new Session ();
        }

        public async bool download_async (string url, string destination) throws Error {
            File dest_file = File.new_for_path (destination);

            File parent_dir = dest_file.get_parent ();
            if (!parent_dir.query_exists (null)) {
                parent_dir.make_directory_with_parents (null);
            }

            var message = new Message ("GET", url);
            FileOutputStream out_stream = yield dest_file.replace_async (null, false, FileCreateFlags.NONE, Priority.DEFAULT, null);

            InputStream in_stream = yield session.send_async (message, Priority.DEFAULT, null);

            int64 total_bytes = message.response_headers.get_content_length ();
            int64 downloaded_bytes = 0;

            uint8[] buffer = new uint8[8192];

            while (true) {
                ssize_t bytes_read = yield in_stream.read_async (buffer, Priority.DEFAULT, null);

                if (bytes_read == 0) {
                    break;
                }

                yield out_stream.write_all_async (buffer[0 : bytes_read], Priority.DEFAULT, null, null);

                downloaded_bytes += bytes_read;

                if (total_bytes > 0) {
                    double progress = (double) downloaded_bytes / (double) total_bytes;
                    progress_changed (progress);
                }
            }

            yield out_stream.close_async (Priority.DEFAULT, null);

            yield in_stream.close_async (Priority.DEFAULT, null);

            return true;
        }
    }
}