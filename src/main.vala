namespace App {
    public static int main (string[] args) {
        configure_settings_schema (); 
        var application = new Application ();
        return application.run (args);
    }

    private static void configure_settings_schema () {
        var build_schema_dir = Path.build_filename (
            Environment.get_current_dir (),
            "build",
            "data"
        );
        var compiled_schema = Path.build_filename (build_schema_dir, "gschemas.compiled");

        if (FileUtils.test (compiled_schema, FileTest.IS_REGULAR)) {
            Environment.set_variable ("GSETTINGS_SCHEMA_DIR", build_schema_dir, true);
        }
    }
}