local class      = require("snabbp4.syntax.middleclass")
-- base symbol
local base       = require("snabbp4.syntax.symbols.base")
local BaseSymbol = base.BaseSymbol


local CounterDeclaration = class("CounterDeclaration", BaseSymbol)
function CounterDeclaration:std()
  self:match_token("counter")
	local identifier = self:ret_token()
	self:match_token("{")
	local stmts = self.parser:statements()
	self:match_token("}")
	return {node="counter_declaration", node_identifier=identifier, statements=stmts}
end

local TypeStatement = class("TypeStatement", BaseSymbol)
-- This is the one parser special case, not sure how to 
-- hand it otherwise with a pratt parser:
-- for type statement, we handle the entire statement without
-- handing control back to the dispatcher, the reason for this
-- is that normally, any data type declaration is handled as a 
-- nud, and here that won't work
function TypeStatement:std()
	self:match_token("type")
	self:match_token(":")
	if self.parser.current_symbol.token.token_type == "data_type" then
		local data = self:ret()
		self:match_token(";")
		return {node="type_statement", node_type=data.token}
	end
	if self:check_token("bytes") then
		self:match_token("bytes")
		self:match_token(";")
		return {node="type_statement", expression={node="bytes"}}
	elseif self:check_token("packets") then
		self:match_token("packets")
		self:match_token(";")
		return {node="type_statement", expression={node="packets"}}
	end
end

local CounterType = class("CounterType", BaseSymbol)
function CounterType:nud()
	if self:check_token("bytes") then
		self:match_token("bytes")
		return {node="bytes"}
	elseif self:check_token("packets") then
		self:match_token("packets")
		return {node="packets"}
	end
end

local DirectOrStatic = class("DirectOrStatic", BaseSymbol)
function DirectOrStatic:std()
	if self:check_token("direct") then
		self:match_token("direct")
		self:match_token(":")
		local table_name = self:ret_token()
		self:match_token(";")
		return {node="direct", table_name=table_name}
	elseif self:check_token("static") then
		self:match_token("static")
		self:match_token(":")
		local table_name = self:ret_token()
		self:match_token(";")
		return {node="static", table_name=table_name}
	end
end

local InstanceCount = class("InstanceCount", BaseSymbol)
function InstanceCount:std()
	self:match_token("instance_count")
	self:match_token(":")
	local val = self.parser:expression()
	self:match_token(";")
	return {node="instance_count", node_value=val}
end

local MinWidth = class("MinWidth", BaseSymbol)
function MinWidth:std()
	self:match_token("min_width")
	self:match_token(":")
	local val = self:ret_token()
	self:match_token(";")
	return {node="min_width", node_value=val}
end

local Saturating = class("Saturating", BaseSymbol)
function Saturating:std()
	self:match_token("saturating")
	self:match_token(";")
	return {node="saturating"}
end

return {
	CounterDeclaration = CounterDeclaration,
	TypeStatement    = TypeStatement,
	CounterType        = CounterType,
	DirectOrStatic     = DirectOrStatic,
	InstanceCount      = InstanceCount,
	MinWidth           = MinWidth,
	Saturating         = Saturating,
}
