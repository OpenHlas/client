sources = files(
    'main.vala', 
)

subdir('app')
subdir('dialogs')
subdir('widgets')
subdir('utils')
subdir('windows')

# Create a new executable, list the files we want to compile, list the dependencies we need, and install
executable(
    reponame,
    resources,
    sources,
    dependencies: [
        dependency('gtk4'),
        dependency('glib-2.0'),
        dependency('gio-2.0'),
        dependency('gobject-2.0'),
        dependency('libarchive'),
        dependency('glib-2.0'),
        dependency('libsoup-3.0'),
        dependency('libadwaita-1', version: '>= 1.9'),
        meson.get_compiler('c').find_library('m', required : false),
        config_dep,
    ],
    include_directories : config_inc,
    vala_args: ['--pkg', 'libadwaita-1'],
    install: true
)