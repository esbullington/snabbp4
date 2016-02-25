local class      = require("snabbp4.syntax.middleclass")
-- base symbol
local base       = require("snabbp4.syntax.symbols.base")
local BaseSymbol = base.BaseSymbol
-- precedence values
local precedence = require("snabbp4.syntax.precedence")


local FieldListDeclaration = class("FieldListDeclaration", BaseSymbol)
function FieldListDeclaration:std()
  self:match_token("field_list")
	local identifier = self:ret_token()
	self:match_token("{")
	local stmts = self.parser:statements()
	self:match_token("}")
	return {node="field_list_declaration", node_identifier=identifier, statements=stmts}
end

local FieldListCalculationDeclaration = class("FieldListCalculationDeclaration", BaseSymbol)
function FieldListCalculationDeclaration:std()
  self:match_token("field_list_calculation")
	local identifier = self:ret_token()
	self:match_token("{")
	local stmts = self.parser:statements()
	self:match_token("}")
	return {node="field_list_calculation_declaration", node_identifier=identifier, stmts=stmts}
end

local Input = class("Input", BaseSymbol)
function Input:std()
	self:match_token("input")
	self:match_token("{")
	local stmts = self.parser:statements()
	self:match_token("}")
	return {node="input", statements=stmts}
end

local Algorithm = class("Algorithm", BaseSymbol)
function Algorithm:std()
	self:match_token("algorithm")
	self:match_token(":")
	local algorithm = self:ret_token()
	self:match_token(";")
	return {node="algorithm", node_value=algorithm}
end

local OutputWidth = class("OutputWidth", BaseSymbol)
function OutputWidth:std()
	self:match_token("output_width")
	self:match_token(":")
	local output_width = self.parser:expression()
	self:match_token(";")
	return {node="output_width", node_value=output_width}
end

return {
	FieldListDeclaration            = FieldListDeclaration,
	FieldListCalculationDeclaration = FieldListCalculationDeclaration,
	Input                           = Input,
	Algorithm                       = Algorithm,
	OutputWidth                     = OutputWidth,
}
