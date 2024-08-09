(call
  function: (attribute 
    object: (identifier) @_obj (#eq? @_obj "pm")
    attribute: (identifier) @_fn (#any-of? @_fn "eval" "exec"))
  arguments: (argument_list
               (string
                 (string_content) @injection.content)
                 ; (#offset! @injection.content 0 1 0 -1)
                 (#set! injection.language "javascript")))
