local class      = require("snabbp4.syntax.middleclass")
-- base symbol
local base       = require("snabbp4.syntax.symbols.base")
local BaseSymbol = base.BaseSymbol
local precedence = require("snabbp4.syntax.precedence")


local ExternTypeDeclaration = class("ExternTypeDeclaration", BaseSymbol)
function ExternTypeDeclaration:std()
  self:match_token("extern_type")
	local identifier = self:ret_token()
	self:match_token("{")
	local stmts = self.parser:statements()
	self:match_token("}")
	return {node="extern_type_declaration", node_identifier=identifier, statements=stmts}
end

local MethodDeclaration = class("MethodDeclaration", BaseSymbol)
function MethodDeclaration:std()
  self:match_token("method")
	local identifier = self:ret_token()
	self:match_token("(")
	local params = {}
	while not self:check_token(")") do
		local s = self.parser:expression()
		params[#params+1] = s
		if self:check_token(",") then
			self:match_token(",")
		end
	end
	self:match_token(")")
	self:match_token(";")
	return {node="method_declaration", node_identifier=identifier, params=params}
end

local AttributeDeclaration = class("AttributeDeclaration", BaseSymbol)
function AttributeDeclaration:std()
  self:match_token("attribute")
	local identifier = self:ret_token()
	self:match_token("{")
	local stmts = self.parser:statements()
	self:match_token("}")
	return {node="attribute_declaration", node_identifier=identifier, statements=stmts}
end

local Optional = class("Optional", BaseSymbol)
function Optional:std()
  self:match_token("optional")
	self:match_token(";")
	return {node="optional"}
end

local ExternInstanceDeclaration = class("ExternInstanceDeclaration", BaseSymbol)
function ExternInstanceDeclaration:std()
  self:match_token("extern")
	local identifier = self:ret_token()
	local type_name = self:ret_token()
	if self:check_token("{") then
		self:match_token("{")
		local stmts = self.parser:statements()
		self:match_token("}")
		return {node="extern_instance_declaration", node_identifier=identifier, type_name=type_name, statements=stmts}
	end
  self:match_token(";")
	return {node="extern_instance_declaration", node_identifier=identifier, type_name=type_name}
end


return {
	ExternTypeDeclaration     = ExternTypeDeclaration,
	ExternInstanceDeclaration = ExternInstanceDeclaration,
	AttributeDeclaration      = AttributeDeclaration,
	MethodDeclaration         = MethodDeclaration,
	Optional                  = Optional,
}
