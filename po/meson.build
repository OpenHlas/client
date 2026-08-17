i18n = import('i18n')

i18n.gettext(meson.project_name(),
    args: [
        '--directory=' + meson.project_source_root(),
        '--keyword=_',
        '--from-code=UTF-8'
    ],
    preset: 'glib',
)