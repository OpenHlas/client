reponame = meson.project_name().split('.')[3]

gnome.compile_schemas()

resources = gnome.compile_resources(
    'resources',
    meson.project_name() + '.gresource.xml',
    source_dir: [meson.current_source_dir(), meson.project_build_root()],
    dependencies: [blueprint_ui, header_ui, chat_area_ui, message_entry_ui]
)

install_subdir(
    'icons/hicolor',
    install_dir : join_paths(get_option('prefix'), get_option('datadir'), 'icons'),
    strip_directory : false
)


#Translate and install our .desktop file
i18n.merge_file(
    input: meson.project_name() + '.desktop.in',
    output: meson.project_name() + '.desktop',
    po_dir: meson.project_source_root() / 'po',
    type: 'desktop',
    install: true,
    install_dir: get_option('datadir') / 'applications'
)

#Translate and install our .metainfo file
i18n.merge_file(
    input:  meson.project_name() + '.metainfo.xml.in',
    output: meson.project_name() + '.metainfo.xml',
    po_dir: meson.project_source_root() / 'po',
    install: true,
    install_dir: get_option('datadir') / 'metainfo'
)