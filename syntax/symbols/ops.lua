local class      = require("snabbp4.syntax.utils.middleclass")
local utils      = require("snabbp4.syntax.utils.debug")
-- base symbol
local base       = require("snabbp4.syntax.symbols.base")
local BaseSymbol = base.BaseSymbol
-- precedence values
local precedence = require("snabbp4.syntax.precedence")

-- AST node creation convenience functions
local function make_binary(name, left, right)
	return {node=name, left=left, right=right}
end

local function make_unary(name, current_symbol)
	return {node=name, unary=current_symbol}
end

local Add = class("Add", BaseSymbol)
function Add:initialize(token,parser)
  self.lbp = precedence.add.lbp
	self.token = token
	self.parser = parser
end
function Add:nud()
	return self.parser:expression(precedence.add.nud)
end
function Add:led(left)
	local right = self.parser:expression(precedence.add.rbp)
	return make_binary("add", left, right)
end

local Subtract = class("Subtract", BaseSymbol)
function Subtract:initialize(token,parser)
  self.lbp = precedence.subtract.lbp
	self.token = token
	self.parser = parser
end
function Subtract:nud()
	return make_unary("negate", self.parser:expression(precedence.subtract.nud))
end
function Subtract:led(left)
	local right = self.parser:expression(precedence.subtract.rbp)
	return make_binary("subtract", left, right)
end

local Multiply = class("Multiply", BaseSymbol)
function Multiply:initialize(token,parser)
  self.lbp = precedence.multiply.lbp
	self.token = token
	self.parser = parser
end
function Multiply:led(left)
	local right = self.parser:expression(precedence.multiply.rbp)
	return make_binary("multiply", left, right)
end

local Divide = class("Divide", BaseSymbol)
function Divide:initialize(token,parser)
  self.lbp = precedence.divide.lbp
	self.token = token
	self.parser = parser
end
function Divide:led(left)
	local right = self.parser:expression(precedence.divide.rbp)
	return make_binary("divide", left, right)
end

local Accessor = class("Accessor", BaseSymbol)
function Accessor:initialize(token,parser)
  self.lbp = precedence.accessor.lbp
	self.token = token
	self.parser = parser
end
function Accessor:led(left)
	local right = self.parser:expression(precedence.accessor.rbp)
	return make_binary("accessor", left, right)
end

local LShift = class("LShift", BaseSymbol)
function LShift:initialize(token,parser)
  self.lbp = precedence.divide.lbp
	self.token = token
	self.parser = parser
end
function LShift:led(left)
	local right = self.parser:expression(precedence.lshift.rbp)
	return make_binary("lshift", left, right)
end

local RShift = class("RShift", BaseSymbol)
function RShift:initialize(token,parser)
  self.lbp = precedence.divide.lbp
	self.token = token
	self.parser = parser
end
function RShift:led(left)
	local right = self.parser:expression(precedence.rshift.rbp)
	return make_binary("rshift", left, right)
end

local BitwiseAnd = class("BitwiseAnd", BaseSymbol)
function BitwiseAnd:initialize(token,parser)
  self.lbp = precedence.band.lbp
	self.token = token
	self.parser = parser
end
function BitwiseAnd:led(left)
	local right = self.parser:expression(precedence.band.rbp)
	return make_binary("band", left, right)
end

local BitwiseOr = class("BitwiseOr", BaseSymbol)
function BitwiseOr:initialize(token,parser)
  self.lbp = precedence.btor.lbp
	self.token = token
	self.parser = parser
end
function BitwiseOr:led(left)
	local right = self.parser:expression(precedence.btor.rbp)
	return make_binary("btor", left, right)
end

local BitwiseExclusiveOr = class("BitwiseExclusiveOr", BaseSymbol)
function BitwiseExclusiveOr:initialize(token,parser)
  self.lbp = precedence.bxor.lbp
	self.token = token
	self.parser = parser
end
function BitwiseExclusiveOr:led(left)
	local right = self.parser:expression(precedence.bxor.rbp)
	return make_binary("bxor", left, right)
end

local LogicalAnd = class("LogicalAnd", BaseSymbol)
function LogicalAnd:initialize(token,parser)
  self.lbp = precedence.logicaland.lbp
	self.token = token
	self.parser = parser
end
function LogicalAnd:led(left)
	local right = self.parser:expression(precedence.logicaland.rbp)
	return make_binary("logicaland", left, right)
end

local LogicalOr = class("LogicalOr", BaseSymbol)
function LogicalOr:initialize(token,parser)
  self.lbp = precedence.logicalor.lbp
	self.token = token
	self.parser = parser
end
function LogicalOr:led(left)
	local right = self.parser:expression(precedence.logicalor.rbp)
	return make_binary("logicalor", left, right)
end

return {
		Add                = Add,
		Subtract           = Subtract,
		Multiply           = Multiply,
		Divide             = Divide,
		LShift             = LShift,
		RShift             = RShift,
		LogicalAnd         = LogicalAnd,
		LogicalOr          = LogicalOr,
		BitwiseAnd         = BitwiseAnd,
		BitwiseOr          = BitwiseOr,
		BitwiseExclusiveOr = BitwiseExclusiveOr,
		Accessor           = Accessor,
		Call               = Call,
}
