; extends

(
  (comment content: _ @_comment
    (#injection_comment? @_comment )
    (#injection_comment! @_comment )
  )
  (return_statement
    (template_string content: _ @injections.language)
  )
)
