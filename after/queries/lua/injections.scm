; extends

(
  (comment content: _ @_comment
    (#injection_comment? @_comment )
    (#injection_comment! @_comment )
  )
  .
  (variable_declaration
    (assignment_statement
      (expression_list
        value: (string content: _ @injections.language)
      )
    )
  )
)

(
  (comment content: _ @_comment
    (#injection_comment? @_comment )
    (#injection_comment! @_comment )
  )
  .
  (block
    (variable_declaration
      (assignment_statement
        (expression_list
          (function_call
            (method_index_expression
              (parenthesized_expression
                (string content: _ @injections.language)
              )
            )
          )
        )
      )
    )
  )
)
