local class      = require("snabbp4.syntax.middleclass")
-- base symbol
local base       = require("snabbp4.syntax.symbols.base")
local BaseSymbol = base.BaseSymbol


local MeterDeclaration = class("MeterDeclaration", BaseSymbol)
function MeterDeclaration:std()
  self:match_token("meter")
	local identifier = self:ret_token()
	self:match_token("{")
	local stmts = self.parser:statements()
	self:match_token("}")
	return {node="meter_declaration", node_identifier=identifier, statements=stmts}
end

local Result = class("Result", BaseSymbol)
function Result:std()
	self:match_token("result")
	self:match_token(":")
	local val = self:expression()
	self:match_token(";")
	return {node="result", node_value=val}
end


return {
	MeterDeclaration = MeterDeclaration,
	Result           = Result,
}
