local class      = require("snabbp4.syntax.middleclass")
-- base symbol
local base       = require("snabbp4.syntax.symbols.base")
local BaseSymbol = base.BaseSymbol


local ValueSetDeclaration = class("ValueSetDeclaration", BaseSymbol)
function ValueSetDeclaration:initialize(token,parser)
	self.token = token
	self.parser = parser
end
function ValueSetDeclaration:std()
  self:match_token("parser_value_set")
	local identifier = self:ret_token()
	self:match_token(";")
	return {node="value_set_declaration", node_identifier=identifier}
end

return {
	ValueSetDeclaration = ValueSetDeclaration,
}
