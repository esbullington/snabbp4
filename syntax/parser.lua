local lexer      = require("snabbp4.syntax.lexer")
local utils      = require("snabbp4.syntax.utils")
local class      = require("snabbp4.syntax.middleclass")
local symbols    = require("snabbp4.syntax.symbols")
local assertions = require("snabbp4.syntax.assertions")
-- precedence values
local precedence = require("snabbp4.syntax.precedence")

local M = {}

local dispatcher = function(token,parser)
  --print("TOKENIZING VALUE: " .. (token.value or "none") .. ", TYPE: " ..token.token_type)
	if token.token_type == "decimal_value" or
		token.token_type == "binary_value" or
		token.token_type == "hexadecimal_value" then
		assertions.check_post_literal(parser)
		return symbols.UnsignedValue(token,parser)
	elseif token.token_type == "constant_value" then
		assertions.check_post_literal(parser)
		return symbols.ConstantValue(token,parser)
	elseif token.token_type == "data_type" then
		return symbols.DataType(token,parser)
	elseif token.token_type == "identifier" then
		return symbols.Identifier(token,parser)
	elseif token.token_type == "punctuator" then
		if token.value == ';' then
			return symbols.Semicolon(token,parser)
		elseif token.value == ':' then
			return symbols.Colon(token,parser)
		elseif token.value == ',' then
			return symbols.Comma(token,parser)
		elseif token.value == '{' then
			return symbols.LBrace(token,parser)
		elseif token.value == '}' then
			assertions.check_post_rbrace(parser)
			return symbols.RBrace(token,parser)
		elseif token.value == '(' then
			return symbols.LParen(token,parser)
		elseif token.value == ')' then
			assertions.check_post_rparen(parser)
			return symbols.RParen(token,parser)
		else
			return error("Unknown punctuator: " .. token.value)
		end
	elseif token.token_type == "op" then
		if token.value == '+' then
			return symbols.Add(token,parser)
		elseif token.value == '-' then
			return symbols.Subtract(token,parser)
		elseif token.value == '*' then
			return symbols.Multiply(token,parser)
		elseif token.value == '<<' then
			return symbols.LShift(token,parser)
		elseif token.value == '>>' then
			return symbols.RShift(token,parser)
		elseif token.value == '.' then
			return symbols.Accessor(token,parser)
		else
			return error("Unknown op: " .. token.value)
		end
	elseif token.token_type == "keyword" then
		if token.value == "header_type" then
			return symbols.HeaderType(token,parser)
		elseif token.value == "fields" then
			return symbols.FieldDeclaration(token,parser)
		elseif token.value == "header" then
			return symbols.HeaderInstance(token,parser)
		elseif token.value == "metadata" then
			return symbols.MetadataInstance(token,parser)
		elseif token.value == "parser" then
			return symbols.ParserFunctionDeclaration(token,parser)
		elseif token.value == "set_metadata" then
			return symbols.SetStatement(token,parser)
		elseif token.value == "extract" then
			return symbols.ExtractStatement(token,parser)
		elseif token.value == "return" then
			return symbols.ReturnStatement(token,parser)
		elseif token.value == "action" then
			return symbols.ActionFunctionDeclaration(token,parser)
		elseif token.value == "primitive_action" then
			return symbols.PrimitiveActionDeclaration(token,parser)
		elseif token.value == "action_profile" then
			return symbols.ActionProfileDeclaration(token,parser)
		elseif token.value == "dynamic_action_selection" then
			return symbols.DynamicActionSelection(token,parser)
		elseif token.value == "actions" then
			return symbols.ActionSpecification(token,parser)
		elseif token.value == "size" then
			return symbols.Size(token,parser)
		elseif token.value == "field_list" then
			return symbols.FieldListDeclaration(token,parser)
		elseif token.value == "field_list_calculation" then
			return symbols.FieldListCalculationDeclaration(token,parser)
		elseif token.value == "calculated_field" then
			return symbols.CalculatedFieldDeclaration(token,parser)
		elseif token.value == "update" or token.value == "verify" then
			return symbols.UpdateVerifySpec(token,parser)
		elseif token.value == "parser_value_set" then
			return symbols.ValueSetDeclaration(token,parser)
		elseif token.value == "parser_exception" then
			return symbols.ParserExceptionDeclaration(token,parser)
		elseif token.value == "parser_drop" then
			return symbols.ReturnOrDrop(token,parser)
		elseif token.value == "meter" then
			return symbols.MeterDeclaration(token,parser)
		elseif token.value == "control" then
			return symbols.ControlFunctionDeclaration(token,parser)
		elseif token.value == "apply" then
			return symbols.ApplyCall(token,parser)
		elseif token.value == "hit" then
			return symbols.Hit(token,parser)
		elseif token.value == "miss" then
			return symbols.Miss(token,parser)
		elseif token.value == "result" then
			return symbols.Result(token,parser)
		elseif token.value == "register" then
			return symbols.RegisterDeclaration(token,parser)
		-- table declaration
		elseif token.value == "table" then
			return symbols.TableDeclaration(token,parser)
		elseif token.value == "reads" then
			return symbols.Reads(token,parser)
		elseif token.value == "min_size" then
			return symbols.MinSize(token,parser)
		elseif token.value == "max_size" then
			return symbols.MaxSize(token,parser)
		elseif token.value == "support_timeout" then
			return symbols.SupportTimeout(token,parser)
		-- end table declaration
		-- extern declaration
		elseif token.value == "extern_type" then
			return symbols.ExternTypeDeclaration(token,parser)
		elseif token.value == "method" then
			return symbols.MethodDeclaration(token,parser)
		elseif token.value == "attribute" then
			return symbols.AttributeDeclaration(token,parser)
		elseif token.value == "extern" then
			return symbols.ExternInstanceDeclaration(token,parser)
		elseif token.value == "optional" then
			return symbols.Optional(token,parser)
		-- end extern declaration
		elseif token.value == "width" then
			return symbols.WidthDeclaration(token,parser)
		elseif token.value == "layout" then
			return symbols.LayoutDeclaration(token,parser)
		elseif token.value == "if" then
			return symbols.IfCond(token,parser)
		elseif token.value == "counter" then
			return symbols.CounterDeclaration(token,parser)
		elseif token.value == "type" then
			return symbols.TypeStatement(token,parser)
		elseif token.value == "static" or token.value == "direct" then
			return symbols.DirectOrStatic(token,parser)
		elseif token.value == "instance_count" then
			return symbols.InstanceCount(token,parser)
		elseif token.value == "min_width" then
			return symbols.MinWidth(token,parser)
		elseif token.value == "saturating" then
			return symbols.Saturating(token,parser)
		elseif token.value == "bytes" or token.value == "packets" then
			return symbols.CounterType(token,parser)
		elseif token.value == "valid" then
			return symbols.Valid(token,parser)
		elseif token.value == "input" then
			return symbols.Input(token,parser)
		elseif token.value == "algorithm" then
			return symbols.Algorithm(token,parser)
		elseif token.value == "output_width" then
			return symbols.OutputWidth(token,parser)
		elseif token.value == "select" then
			return symbols.SelectStatement(token,parser)
		elseif token.value == "in" or token.value == "inout" then
			return symbols.ParamQualifier(token,parser)
		elseif token.value == "length" then
			return symbols.Length(token,parser)
		elseif token.value == "latest" then
			return symbols.Latest(token,parser)
		elseif token.value == "next" then
			return symbols.Next(token,parser)
		elseif token.value == "and" then
			return symbols.LogicalAnd(token,parser)
		elseif token.value == "or" then
			return symbols.LogicalOr(token,parser)
		elseif token.value == "true" or token.value == "false" then
			return symbols.BooleanValue(token,parser)
		elseif token.value == "parser_error" then
			return symbols.ParserError(token,parser)
		elseif token.value == "default" then
			return symbols.Default(token,parser)
		else
			return error("Unknown keyword: " .. token.value)
		end
	else
		return symbols.EndToken(token,parser)
	end
end


local Parser = class("ListIter")
function Parser:initialize(t)
	self.t = t
	self.i = 0
	self.n = table.getn(t)
	self.current_symbol = nil
	self.current_pos = nil
	self.prior_symbol = nil
end
function Parser:advance()
	self.i = self.i + 1
	if self.i <= self.n then
		local current_simple_token = self.t[self.i]
		self.current_pos = current_simple_token.pos
		self.prior_symbol = self.current_symbol
		self.current_symbol = dispatcher(current_simple_token, self)
		return self.current_symbol
	end
end
-- match function for symbols, throw error if no match
-- consume symbol that is matched
function Parser:match(sym)
	local sym = sym or nil
	if sym and (sym ~= self.current_symbol.class.name) then
			error('Expected ' .. sym .. ' received ' .. self.current_symbol.class.name)
	end
	self:advance()
end
function Parser:peek_token()
	local i = self.i + 1
	return self.t[i]
end
function Parser:expression(rbp)
	local rbp = rbp or 0
	self:advance()
	assert(type(self.current_symbol) == "table", "Missing switch entry for token.")
	local left = self.prior_symbol:nud()
	assert(type(rbp) == "number", "Passed in rbp for class '" .. self.current_symbol.class.name .. "' is not a number")
	assert(type(self.current_symbol.lbp) == "number", "lbp for class '" .. self.current_symbol.class.name .. "' is not a number")
	while rbp < self.current_symbol.lbp and self.current_symbol.class.name ~= "Semicolon" do
		self:advance()
		left = self.prior_symbol:led(left)
	end
	return left
end
function Parser:statement()
	local n = self.current_symbol
	if (n.std) then
			return n:std()
	end
	local v = self:expression()
	self:match('Semicolon')
	return v
end
function Parser:statements()
	local a = {}
	while true do
		if self.current_symbol.class.name == "RBrace" or self.current_symbol.class.name == "EndToken" then
			break
		end
		local s = self:statement()
		if (s) then
			a[#a+1] = s
		end
	end
	if #a == 0 then
		return nil
	else
		return a
	end
end


M.parse = function(input, config)
	local t = lexer.lex(input, config)
	-- Add EOF token for dispatcher
	t[#t+1] = {token_type="EOF", value="eof"}
	local parser = Parser(t)
	parser:advance()
	return parser:statements()
end

-- Testing
-- local config = {preprocess = true}
-- local input = "int<4> some_int"
-- local t = lexer.lex(input, config)
-- -- Add EOF token for dispatcher
-- t[#t+1] = {token_type="EOF", value="eof"}
-- local parser = Parser(t)
-- parser:advance()
-- local expr = parser:expression()
-- local utils = require("snabbp4.syntax.utils")
-- utils.print_r(expr)

return M

