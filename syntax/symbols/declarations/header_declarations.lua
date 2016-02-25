local class      = require("snabbp4.syntax.middleclass")
-- base symbol
local base       = require("snabbp4.syntax.symbols.base")
local BaseSymbol = base.BaseSymbol
-- precedence values
local precedence = require("snabbp4.syntax.precedence")


local HeaderType = class("HeaderType", BaseSymbol)
function HeaderType:std()
  self:match("HeaderType")
  local identifier = self.parser.current_symbol.token
	self:match("Identifier")
	self:match("LBrace")
	local s = self.parser:statements()
	self:match("RBrace")
	return {node="header_type", node_identifier=identifier, statements=s}
end

local HeaderInstance = class("HeaderInstance", BaseSymbol)
function HeaderInstance:std()
	self:match_token("header")
	local header_type = self:ret_token()
	local header_name = self:ret_token()
	if self:check_token(";") then
		self.parser:advance()
		return {node="header_instance", expression={node="scalar_instance", node_type=header_type, node_identifier=header_name}}
	elseif self:check_token("[") then
		self:match_token('[')
		local idx = self.parser.current_symbol.token.value
		self.parser:advance()
		self:match_token(']')
		self:match_token(';')
		return {node="header_instance",
			expression={node="array_instance", node_type=header_type, node_identifier=header_name, node_index=idx}
		}
	end
end

return {
	HeaderType     = HeaderType,
	HeaderInstance = HeaderInstance
}
