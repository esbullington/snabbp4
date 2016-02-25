
local M = {}

-- Like assert() but with support for a lazily-executed function argument
function xassert(a, f, ...)
  if a then return a, f, ... end
  if type(f) == "function" then
    error(f(...), 2)
  else
    error(f or "assertion failed!", 2)
  end
end

function string.concat(...)
  return table.concat({...})
end

-- Error checking functions
M.check_post_literal = function(parser)
	local next_token = parser:peek_token()
	xassert(next_token.token_type == "op" or next_token.value == ")" or next_token.value == ";" or next_token.value == ":",
		string.concat,
		"Illegal statement or expression following literal: '",
		next_token.value,
		"' at position ",
		parser.current_pos
	)
end

M.check_post_rbrace = function(parser)
	local next_token = parser:peek_token()
	local msg = "Illegal statement or expression following right brace: '"
	xassert(next_token.token_type == "keyword" or next_token.value == "}" or next_token.value == "eof",
		string.concat,
		msg,
		next_token.value,
		"' on line ",
		parser.current_pos
	)
end

M.check_post_rparen = function(parser)
	local next_token = parser:peek_token()
	local msg = "Illegal statement or expression following right parenthesis: '"
	xassert(next_token.token_type == "op" or next_token.value == ";" or next_token.value == "{" or next_token.value == ")", 
		string.concat,
		msg,
		next_token.value,
		"' on line ",
		parser.current_pos
	)
end

return M
