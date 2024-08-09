(call_expression
  function: (member_expression
    object: (identifier)+ @_obj (#eq? @_obj "python")
    property: (property_identifier) @_fn (#any-of? @_fn "eval" "exec"))
  arguments: [
    (arguments (template_string (string_fragment) @injection.content
      (#set! injection.language "python")))
    (arguments (string (string_fragment) @injection.content
      (#set! injection.language "python")))])
