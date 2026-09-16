blueprint_compiler = find_program('blueprint-compiler', required: true)

blueprint_ui = custom_target(
    'window.ui',
    input: 'window.blp',
    output: 'window.ui',
    command: [blueprint_compiler, 'compile', '--output', '@OUTPUT@', '@INPUT@'],
    build_by_default: true,
)

header_ui = custom_target(
    'header.ui',
    input: 'header.blp',
    output: 'header.ui',
    command: [blueprint_compiler, 'compile', '--output', '@OUTPUT@', '@INPUT@'],
    build_by_default: true,
)

chat_area_ui = custom_target(
    'chat-area.ui',
    input: 'chat-area.blp',
    output: 'chat-area.ui',
    command: [blueprint_compiler, 'compile', '--output', '@OUTPUT@', '@INPUT@'],
    build_by_default: true,
)

message_entry_ui = custom_target(
    'message-entry.ui',
    input: 'message-entry.blp',
    output: 'message-entry.ui',
    command: [blueprint_compiler, 'compile', '--output', '@OUTPUT@', '@INPUT@'],
    build_by_default: true,
)