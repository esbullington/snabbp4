local class      = require("snabbp4.syntax.utils.middleclass")
local utils      = require("snabbp4.syntax.utils.debug")

-- Base symbol shared by all symbols 
local BaseSymbol = class("BaseSymbol")
function BaseSymbol:initialize(token,parser)
	self.lbp = 0
	self.token = token
	self.parser = parser
end
function BaseSymbol:nud()
	error("Method 'nud' undefined for class " .. self.class.name)
end
function BaseSymbol:led(left)
	error("Missing 'led' operator for class " .. self.class.name)
end
-- match function for symbols, throw error if no match
-- consume symbol that is matched
function BaseSymbol:match(sym)
	local sym = sym or nil
	if sym and (sym ~= self.parser.current_symbol.class.name) then
			error('Expected ' .. sym .. ' received ' .. self.parser.current_symbol.class.name)
	end
	self.parser:advance()
end
-- check that symbol matches, but don't throw error, just return true/false
function BaseSymbol:check(sym)
	local sym = sym or nil
	if sym and (sym ~= self.parser.current_symbol.class.name) then
		return false
	end
	return true
end
-- get current symbol, consume it, and return it
function BaseSymbol:ret()
	local ret = self.parser.current_symbol
	self.parser:advance()
	return ret
end
-- match function for token, throw error if no match
-- consume token that is matched
function BaseSymbol:match_token(tok)
	local tok = tok or nil
	if tok and (tok ~= self.parser.current_symbol.token.value) then
			error('Expected ' .. tok .. ' received ' .. self.parser.current_symbol.token.value)
	end
	self.parser:advance()
end
-- check that token matches, but don't throw error, just return true/false
function BaseSymbol:check_token(tok)
	local tok = tok or nil
	if tok and (tok ~= self.parser.current_symbol.token.value) then
		return false
	end
	return true
end
-- get current symbol, consume it, and return it
function BaseSymbol:ret_token()
	local ret = self.parser.current_symbol.token.value
	self.parser:advance()
	return ret
end

return {
	BaseSymbol = BaseSymbol
}
