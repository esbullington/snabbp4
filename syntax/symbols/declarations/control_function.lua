local class      = require("snabbp4.syntax.middleclass")
-- base symbol
local base       = require("snabbp4.syntax.symbols.base")
local BaseSymbol = base.BaseSymbol

		-- control egress {
		-- 	// Check for unknown egress state or bad retagging with mTag.
		-- 	apply(egress_check);
		-- 	apply(egress_meter) {
		-- 		hit {
		-- 			apply(hysteresis_check);
		-- 			apply(meter_policy);
		-- 		}
		-- 	}
		-- }

local ControlFunctionDeclaration = class("ControlFunctionDeclaration", BaseSymbol)
function ControlFunctionDeclaration:std()
  self:match_token("control")
	local identifier = self:ret_token()
	self:match_token("{")
	local stmts = self.parser:statements()
	self:match_token("}")
	return {node="control_function_declaration", node_identifier=identifier, statements=stmts}
end

local ApplyCall = class("ApplyCall", BaseSymbol)
function ApplyCall:std()
  self:match_token("apply")
	self:match_token("(")
	local param = self:ret_token()
	self:match_token(")")
	if self:check_token("{") then
		self:match_token("{")
		local statements = self.parser:statements()
		self:match_token("}")
		return {node="apply_call", param=param, statements=statements}
	end
	self:match_token(";")
	return {node="apply_call", param=param}
end

local Hit = class("Hit", BaseSymbol)
function Hit:std()
	self:match_token("hit")
	self:match_token("{")
	local statements = self.parser:statements()
	self:match_token("}")
	return {node="hit", node_value=node_value, statements=statements}
end

local Miss = class("Miss", BaseSymbol)
function Miss:std()
	self:match_token("miss")
	self:match_token("{")
	local statements = self.parser:statements()
	self:match_token("}")
	return {node="miss", node_value=node_value, statements=statements}
end

return {
	ControlFunctionDeclaration = ControlFunctionDeclaration,
	ApplyCall                  = ApplyCall,
	Hit                        = Hit,
	Miss                       = Miss,
}
