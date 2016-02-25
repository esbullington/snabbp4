local class      = require("snabbp4.syntax.middleclass")
-- base symbol
local base       = require("snabbp4.syntax.symbols.base")
local BaseSymbol = base.BaseSymbol


local CalculatedFieldDeclaration = class("CalculatedFieldDeclaration", BaseSymbol)
function CalculatedFieldDeclaration:std()
  self:match_token("calculated_field")
	local field_list_calculation_name = self.parser:expression()
	self:match_token("{")
	local stmts = self.parser:statements()
	self:match_token("}")
	return {node="calculated_field_declaration", field_list_calculation_name=field_list_calculation_name, statements=stmts}
end

local UpdateVerifySpec = class("UpdateVerifySpec", BaseSymbol)
function UpdateVerifySpec:std()
	if self:check_token("update") then
		local if_cond
		self:match_token("update")
		local field_list_calculation_name = self:ret_token()
		if self:check_token("if") then
			if_cond = self.parser:statement()
		end
		self:match_token(";")
		return {node="update", field_list_calculation_name=field_list_calculation_name, if_cond=if_cond}
	elseif self:check_token("verify") then
		local if_cond
		self:match_token("verify")
		local field_list_calculation_name = self:ret_token()
		if self:check_token("if") then
			if_cond = self.parser:statement()
		end
		self:match_token(";")
		return {node="verify", field_list_calculation_name=field_list_calculation_name, if_cond=if_cond}
	end
end

local IfCond = class("IfCond", BaseSymbol)
function IfCond:std()
	local condition
	self:match_token("if")
	self:match_token("(")
	if self:check_token("valid") then
		condition = self.parser:statement()
	else
		condition = self:ret_token()
	end
	self:match_token(")")
	return {node="if", calc_bool_cond=condition}
end

local Valid = class("Valid", BaseSymbol)
function Valid:std()
	self:match_token("valid")
	self:match_token("(")
	local param = self.parser:expression()
	self:match_token(")")
	return {node="valid", param=param}
end

return {
	CalculatedFieldDeclaration = CalculatedFieldDeclaration,
	UpdateVerifySpec           = UpdateVerifySpec,
	IfCond                     = IfCond,
	Valid                      = Valid,
}
