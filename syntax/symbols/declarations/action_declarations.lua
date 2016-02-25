local class      = require("snabbp4.syntax.utils.middleclass")
-- base symbol
local base       = require("snabbp4.syntax.symbols.base")
local BaseSymbol = base.BaseSymbol
-- precedence values
local precedence = require("snabbp4.syntax.precedence")

local PrimitiveActionDeclaration = class("PrimitiveActionDeclaration", BaseSymbol)
function PrimitiveActionDeclaration:std()
  self:match_token("primitive_action")
  local action_name = self:ret_token()
	self:match_token("(")
	local params = {}
	while not self:check_token(")") do
		local param = self:ret_token()
		params[#params+1] = param
		self:match_token(",")
	end
	self:match_token(")")
	return {node="primitive_action_declaration", node_identifier=action_name, params=params}
end

local ActionFunctionDeclaration = class("ActionFunctionDeclaration", BaseSymbol)
function ActionFunctionDeclaration:std()
	self:match_token("action")
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
	self:match_token("{")
	local stmts = self.parser:statements()
	self:match_token("}")
	return {node="action_function_declaration", node_identifier=identifier, params=params, statements=stmts}
end

local ParamQualifier = class("ParamQualifier", BaseSymbol)
function ParamQualifier:nud()
	local id = self.parser:expression()
	return {node="param_qualifier", node_value=id}
end

local ActionProfileDeclaration = class("ActionProfileDeclaration", BaseSymbol)
function ActionProfileDeclaration:std()
	self:match_token("action_profile")
	if self:check_token(":") then
		self:match_token(":")
		local identifier = self:ret_token()
		self:match_token(";")
		return {node="action_profile", node_identifier=identifier}
	else
		local identifier = self:ret_token()
		self:match_token("{")
		local stmts = self.parser:statements()
		self:match_token("}")
		return {node="action_profile_declaration", node_identifier=identifier, statements=stmts}
	end
end

local ActionSpecification = class("ActionSpecification", BaseSymbol)
function ActionSpecification:std()
	self:match_token("actions")
	self:match_token("{")
	local actions = self.parser:statements()
	self:match_token("}")
	return {node="action_specification", actions=actions}
end

local Size = class("Size", BaseSymbol)
function Size:std()
	self:match_token("size")
	self:match_token(":")
	local size = self:ret_token()
	self:match_token(";")
	return {node="size", size=size}
end

local DynamicActionSelection = class("DynamicActionSelection", BaseSymbol)
function DynamicActionSelection:std()
	self:match_token("dynamic_action_selection")
	self:match_token(":")
	local selector_name = self:ret_token()
	self:match_token(";")
	return {node="dynamic_action_selection", selector_name=selector_name}
end

local ActionSelectorDeclaration = class("ActionSelectorDeclaration", BaseSymbol)
function ActionSelectorDeclaration:std()
	self:match_token("action_selector")
  local identifier = self:ret_token()
	self:match_token("{")
	local stmts = self.parser:statements()
	self:match_token("}")
	return {node="action_selector_declaration", node_identifier=identifier, params=params, statements=stmts}
end

return {
	PrimitiveActionDeclaration = PrimitiveActionDeclaration,
	ActionFunctionDeclaration  = ActionFunctionDeclaration,
	ParamQualifier                = ParamQualifier,
	ActionSelectorDeclaration  = ActionSelectorDeclaration,
	ActionProfileDeclaration   = ActionProfileDeclaration,
	ActionSpecification        = ActionSpecification,
	DynamicActionSelection     = DynamicActionSelection,
	Size                       = Size,
}
