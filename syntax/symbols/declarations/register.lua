local class      = require("snabbp4.syntax.middleclass")
-- base symbol
local base       = require("snabbp4.syntax.symbols.base")
local BaseSymbol = base.BaseSymbol


local RegisterDeclaration = class("RegisterDeclaration", BaseSymbol)
function RegisterDeclaration:std()
  self:match_token("register")
	local identifier = self:ret_token()
	self:match_token("{")
	local stmts = self.parser:statements()
	self:match_token("}")
	return {node="register_declaration", node_identifier=identifier, statements=stmts}
end

local WidthDeclaration = class("WidthDeclaration", BaseSymbol)
function WidthDeclaration:std()
  self:match_token("width")
	local node_value = self.parser:expression()
	self:match_token(";")
	return {node="width_declaration", node_value=node_value}
end

local LayoutDeclaration = class("LayoutDeclaration", BaseSymbol)
function LayoutDeclaration:std()
  self:match_token("layout")
	local node_value = self.parser:expression()
	self:match_token(";")
	return {node="layout_declaration", node_value=node_value}
end


return {
	RegisterDeclaration = RegisterDeclaration,
	WidthDeclaration    = WidthDeclaration,
	LayoutDeclaration   = LayoutDeclaration,
}
