local serde = require("@lune/serde")

local Config = {
    generator = {
        name = "dense",
        column_span = 9999999999,
    },

    rules = {
        -- "append_text_comment",
        "compute_expression",
        -- "convert_index_to_field",
        -- "convert_local_function_to_assign",
        -- "convert_require",
        -- "filter_after_early_return",
        -- "group_local_assignment",
        -- "inject_global_value",
        -- "remove_assertions",
        -- "remove_comments",
        -- "remove_compound_assignment",
        -- "remove_continue",
        -- "remove_debug_profiling",
        -- "remove_empty_do",
        -- "remove_floor_division",
        -- "remove_function_call_parens",
        -- "remove_if_expression",
        -- "remove_interpolated_string",
        -- "remove_method_definition",
        -- "remove_nil_declaration",
        -- "remove_spaces",
        -- "remove_types",
        -- "remove_unused_if_branch",
        -- "remove_unused_variable",
        -- "remove_unused_while",
        -- "rename_variables"
    }
}

return serde.encode("json", Config, false)
