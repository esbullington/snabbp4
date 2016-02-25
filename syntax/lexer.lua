-- Lua p4 lexer
-- 
-- Inspired by ANSI C lexer by David Manura, 2007, public domain.

local lpeg = require("lpeg")
-- lcpp for preprocessing
local lcpp = require("snabbp4.syntax.lcpp");
local utils = require("snabbp4.syntax.utils")
local P, R, S, C, Ct =
  lpeg.P, lpeg.R, lpeg.S, lpeg.C, lpeg.Ct

-- For line position captures
local I = lpeg.Cp()

-- Table for lexer tokens
local t = {}
  
local whitespace = S' \t\v\f\r\n'
local digit = R'09'
local letter = R('az', 'AZ') + P'_'
local alphanum = letter + digit
local width_spec = digit^1 * S'Ww'
local hex = R('af', 'AF', '09')
local bin = S('01')

local decimal_digits = digit^1
local binary_digits = P'0' * S'bB' * bin^1
local hexadecimal_digits = P'0' * S'xX' * hex^1
local constant_digits = C(decimal_digits) * S'wW' * C(decimal_digits + binary_digits + hexadecimal_digits)

local constant_value = Ct(I * constant_digits) /
	function(cap) 
		local token_table = {}
		token_table.token_type = "constant_value"
		token_table.pos = cap[1]
		token_table.width_spec = cap[2]
		token_table.value = cap[3]
		t[#t+1] = token_table
	end

-- Terminals
local decimal_value = Ct(I * C(decimal_digits)) /
	function(cap) 
		local token_table = {}
		token_table.token_type = "decimal_value"
		token_table.pos = cap[1]
		token_table.value = cap[2]
		t[#t+1] = token_table
	end

local binary_value = Ct(I * C(binary_digits)) /
	function(cap) 
		local token_table = {}
		token_table.token_type = "binary_value"
		token_table.pos = cap[1]
		token_table.value = cap[2]
		t[#t+1] = token_table
	end


local hexadecimal_value = Ct(I * C(hexadecimal_digits)) /
	function(cap) 
		local token_table = {}
		token_table.token_type = "hexadecimal_value"
		token_table.pos = cap[1]
		token_table.value = cap[2]
		t[#t+1] = token_table
	end

local literal = constant_value + hexadecimal_value + binary_value + decimal_value

local data_type = Ct(I * ((C(P"bit" + P"int" + P"varbit") * "<" * C(decimal_digits) * P">" ) + C(P"bit"))) /
	function(cap) 
		local token_table = {}
		token_table.token_type = "data_type"
		token_table.pos = cap[1]
		token_table.data_type = cap[2]
		token_table.length = cap[3]
		t[#t+1] = token_table
	end

local ccomment = P'/*' * (1 - P'*/')^0 * P'*/'
local newcomment = P'//' * (1 - P'\n')^0
local comment = (ccomment + newcomment)

-- local literal = lpeg.Ct(I * C( unsigned_value))

local keyword = lpeg.Ct(I * C(
  P"dynamic_action_selection" +
  P"field_list_calculation" +
  P"packets_and_bytes" +
  P"header_token_type" +
  P"primitive_action" +
  P"parser_value_set" +
  P"parser_exception" +
  P"calculated_field" +
  P"action_selector" +
  P"instance_count" +
  P"action_profile" +
  P"set_metadata" +
  P"output_width" +
  P"parser_drop" +
  P"parse_error" +
  P"header_type" +
	P"extern_type" +
  P"token_type" +
  P"saturating" +
  P"max_length" +
  P"field_list" +
  P"attributes" +
  P"min_width" +
  P"attribute" +
  P"algorithm" +
  P"optional" +
  P"register" +
  P"min_size" +
  P"metadata" +
  P"max_size" +
  P"payload" +
  P"packets" +
  P"extract" +
  P"default" +
  P"current" +
  P"counter" +
  P"control" +
  P"actions" +
  P"verify" +
  P"update" +
  P"static" +
  P"signed" +
  P"select" +
  P"return" +
  P"result" +
  P"parser" +
  P"method" +
  P"length" +
  P"layout" +
  P"latest" +
  P"header" +
  P"fields" +
	P"extern" +
  P"direct" +
  P"action" +
  P"width" +
  P"valid" +
  P"type" + 
  P"table" +
  P"reads" +
  P"meter" +
  P"input" +
  P"false" +
  P"bytes" +
  P"apply" +
  P"true" +
  P"size" +
  P"next" +
  P"miss" +
  P"mask" +
  P"last" +
  P"else" +
  P"out" +
  P"in" + 
  P"hit" +
  P"and" +
  P"or" +
  P"not" +
  P"if"
) ) / 
		function(cap) 
			local token_table = {}
			token_table.token_type = "keyword"
			token_table.pos = cap[1]
			token_table.value = cap[2]
			t[#t+1] = token_table
		end

local identifier = lpeg.Ct(I * C(letter * alphanum^0 - keyword * (-alphanum))) /
		function(cap) 
			local token_table = {}
			token_table.token_type = "identifier"
			token_table.pos = cap[1]
			token_table.value = cap[2]
			t[#t+1] = token_table
		end

local shiftOps = P">>" + P"<<"

local op = lpeg.Ct(I * C(
-- First match the multi-char items
  ((shiftOps + S("<>=!")) * P"=") +
  shiftOps +
  S(".&~-+*/%<>^|")
)) / 
		function(cap) 
			local token_table = {}
			token_table.token_type = "op"
			token_table.pos = cap[1]
			token_table.value = cap[2]
			t[#t+1] = token_table
		end

local punctuator = lpeg.Ct(I * C(S";{}()[]:,")) /
		function(cap) 
			local token_table = {}
			token_table.token_type = "punctuator"
			token_table.pos = cap[1]
			token_table.value = cap[2]
			t[#t+1] = token_table
		end
	
local M = {}

-- Translates character offset to line number
function get_lines(input)
	local count = 1
	local lines = {}
	input:gsub(".", 
		function(c)
			if lpeg.match(P("\n"), c) then
				count = count + 1
			end
			lines[#lines+1] = count
		end
	)
	return lines
end

M.lex = function(input, config)
	if config.preprocess then
		input = lcpp.compile(input)
	end
	local lines = get_lines(input)
	-- Various PEG building blocks
	local tokens = (comment + data_type + literal + identifier + keyword +
									op + punctuator + whitespace)^0
	lpeg.match(tokens, input)
	for i=1, #t do
		local pos = t[i]["pos"]
		local new_position = lines[pos]
		t[i]["pos"] = new_position
	end
	return t
end

return M
