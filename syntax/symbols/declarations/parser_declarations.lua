local class      = require("snabbp4.syntax.utils.middleclass")
local utils      = require("snabbp4.syntax.utils.debug")
-- base symbol
local base       = require("snabbp4.syntax.symbols.base")
local BaseSymbol = base.BaseSymbol
-- precedence values
local precedence = require("snabbp4.syntax.precedence")


local ParserFunctionDeclaration = class("ParserFunctionDeclaration", BaseSymbol)
function ParserFunctionDeclaration:std()
	self:match_token("parser")
	local identifier = self:ret_token()
	self:match_token("{")
	local stmts = self.parser:statements()
	self:match_token("}")
	return {node="parser_function_declaration", node_identifier=identifier, statements=stmts}
end

local ParserExceptionDeclaration = class("ParserExceptionDeclaration", BaseSymbol)
function ParserExceptionDeclaration:std()
	self:match_token("parser_exception")
	local identifier = self:ret_token()
	self:match_token("{")
	local stmts = self.parser:statements()
	self:match_token("}")
	return {node="parser_exception_declaration", node_identifier=identifier, statements=stmts}
end

local ReturnOrDrop = class("ReturnOrDrop", BaseSymbol)
function ReturnOrDrop:std()
	self:match_token("parser_drop")
	self:match_token(";")
	return {node="parser_drop"}
end

local SetStatement = class("SetStatement", BaseSymbol)
function SetStatement:std(token,parser)
	self:match_token("set_metadata")
	self:match_token("(")
	local field_ref = self.parser:expression()
	self:match_token(",")
	local general_expr = self.parser:expression()
	self:match_token(")")
	self:match_token(";")
	return {node="set_statement", expression=field_ref, expression=general_expr}
end

local ExtractStatement = class("ExtractStatement", BaseSymbol)
function ExtractStatement:std()
	self:match_token("extract")
	self:match_token("(")
	local id = self:ret_token()
	if self:check_token("[") then
		self:match_token("[")
		local idx = self:ret_token()
		self:match_token("]")
		self:match_token(")")
		self:match_token(";")
		return {node="extract_self.parser:statement", {node="header_extract_reference", node_identifier=id, node_index=idx}}
	else
		self:match_token(")")
		self:match_token(";")
		return {node="extract_statement", {node="header_extract_reference", node_identifier=id}}
	end
end

local ReturnStatement = class("ReturnStatement", BaseSymbol)
function ReturnStatement:std()
	if self:check_token("return") then
		self:match_token("return")
		if self:check_token("select") then
			return {node="return_statement", statement=self.parser:statement()}
		end
		local id = self:ret_token()
		self:match_token(";")
		return {node="return_statement", node_identifier=id}
	elseif self:check_token("parser_error") then
		self:match_token("parser_error")
		local id = self:ret_token()
		self:match_token(";")
		return {node="parser_error", node_identifier=id}
	end
end

local SelectStatement = class("SelectStatement", BaseSymbol)
function SelectStatement:std()
	self:match_token("select")
	self:match_token("(")
	local id = self.parser:expression()
	self:match_token(")")
	self:match_token("{")
	local case_entries = {}
	while self.parser.current_symbol.token.value ~= "}" do
		local case_entry = self:case_entry()
		case_entries[#case_entries+1] = case_entry
	end
	self:match_token("}")
	return {node="select_statement", node_identifier=id, statements=case_entries}
end
function SelectStatement:case_entry()
	local value_list = self:ret().token
	self:match_token(":")
	if self:check_token("parser_error") then
		self:match_token("parser_error")
		local error_id = self:ret_token()
		return {"case_entry", {"parser_error", value_list, error_id}}
	end
	local id = self:ret_token()
	self:match_token(";")
	return {node="case_entry", expression=value_list, node_identifier=id}
end

return {
	ParserFunctionDeclaration  = ParserFunctionDeclaration,
	ReturnOrDrop               = ReturnOrDrop,
	ParserExceptionDeclaration = ParserExceptionDeclaration,
	SetStatement               = SetStatement,
	ExtractStatement           = ExtractStatement,
	ReturnStatement            = ReturnStatement,
	SelectStatement            = SelectStatement,
}
