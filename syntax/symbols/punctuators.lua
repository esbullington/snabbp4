local class      = require("snabbp4.syntax.utils.middleclass")
local utils      = require("snabbp4.syntax.utils.debug")
-- base symbol
local base       = require("snabbp4.syntax.symbols.base")
local BaseSymbol = base.BaseSymbol
-- precedence values
local precedence = require("snabbp4.syntax.precedence")


local Colon = class("Colon", BaseSymbol)
function Colon:initialize(token,parser)
	self.lbp = precedence.colon.lbp
	self.token = token
	self.parser = parser
end
function Colon:led(left)
	local right = self.parser:expression(precedence.colon.rbp)
	return {node="assignment", left=left, right=right}
end
function Colon:nud()
	local expr = self.parser:expression()
	return expr
end

local Comma = class("Comma", BaseSymbol)
function Comma:initialize(token,parser)
	self.lbp = precedence.comma.lbp
	self.token = token
	self.parser = parser
end

local LBrace = class("LBrace", BaseSymbol)
function LBrace:initialize(token,parser)
  self.lbp = precedence.lbrace.lbp
	self.token = token
	self.parser = parser
end
function LBrace:nud()
	local stmts = self.parser:statements()
  self:match('RBrace')
	return stmts
end

local Semicolon = class("Semicolon", BaseSymbol)
function Semicolon:initialize(token,parser)
  self.lbp = precedence.semicolon.lbp
	self.token = token
	self.parser = parser
end
function Semicolon:nud()
end

local RBrace = class("RBrace", BaseSymbol)
function RBrace:initialize(token,parser)
  self.lbp = precedence.rbrace.lbp
	self.token = token
	self.parser = parser
end
function RBrace:nud()
end

local LParen = class("LParen", BaseSymbol)
function LParen:initialize(token,parser)
  self.lbp = precedence.lparen.lbp
	self.token = token
	self.parser = parser
end
function LParen:led(left)
	local params = {}
	while not self:check_token(")") do
		local param = self.parser:expression(precedence.lparen.rbp)
		params[#params+1] = param
		if self:check_token(",") then
			self:match_token(",")
		end
	end
	self:match_token(")")
	return {node="call", node_identifier=left, params=params}
end
function LParen:nud()
	local expr = self.parser:expression(precedence.lparen.nud)
  self:match('RParen')
	return expr
end

local RParen = class("RParen", BaseSymbol)
function RParen:initialize(token,parser)
  self.lbp = precedence.rparen.lbp
	self.token = token
	self.parser = parser
end
local EndToken = class("EndToken", BaseSymbol)
function EndToken:initialize(token,parser)
  self.lbp = precedence.endtoken.lbp
	self.token = token
	self.parser = parser
end

return {
		Colon              = Colon,
		Comma              = Comma,
		LBrace             = LBrace,
		RBrace             = RBrace,
		LParen             = LParen,
		RParen             = RParen,
		Semicolon          = Semicolon,
		EndToken           = EndToken,
}
