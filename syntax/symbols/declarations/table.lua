local class      = require("snabbp4.syntax.utils.middleclass")
-- base symbol
local base       = require("snabbp4.syntax.symbols.base")
local BaseSymbol = base.BaseSymbol


local TableDeclaration = class("TableDeclaration", BaseSymbol)
function TableDeclaration:std()
  self:match_token("table")
	local identifier = self:ret_token()
	self:match_token("{")
	local stmts = self.parser:statements()
	self:match_token("}")
	return {node="table_declaration", node_identifier=identifier, statements=stmts}
end

local Reads = class("Reads", BaseSymbol)
function Reads:std()
  self:match_token("reads")
	self:match_token("{")
	local stmts = self.parser:statements()
	self:match_token("}")
	return {node="reads", statements=stmts}
end

local MinSize = class("MinSize", BaseSymbol)
function MinSize:std()
  self:match_token("min_size")
	self:match_token(":")
	local node_value = self.parser:expression()
	self:match_token(";")
	return {node="min_size", node_value=node_value}
end

local MaxSize = class("MaxSize", BaseSymbol)
function MaxSize:std()
  self:match_token("max_size")
	self:match_token(":")
	local node_value = self.parser:expression()
	self:match_token(";")
	return {node="max_size", node_value=node_value}
end

local SupportTimeout = class("SupportTimeout", BaseSymbol)
function SupportTimeout:std()
  self:match_token("support_timeout")
	self:match_token(":")
	local node_value = self.parser:expression()
	self:match_token(";")
	return {node="support_timeout", node_value=node_value}
end

local ActionProfile = class("ActionProfile", BaseSymbol)
function ActionProfile:std()
	self:match_token("action_profile")
	self:match_token(":")
  local identifier = self:ret_token()
	self:match_token(";")
	return {node="action_profile", node_identifier=identifier}
end


return {
	TableDeclaration = TableDeclaration,
	Reads            = Reads,
	MinSize          = MinSize,
	MaxSize          = MaxSize,
	SupportTimeout   = SupportTimeout,
	ActionProfile    = ActionProfile,
}
