local class      = require("snabbp4.syntax.utils.middleclass")
local utils      = require("snabbp4.syntax.utils.debug")
-- base symbol
local base       = require("snabbp4.syntax.symbols.base")
local BaseSymbol = base.BaseSymbol
-- precedence values
local precedence = require("snabbp4.syntax.precedence")


local UnsignedValue = class("UnsignedValue", BaseSymbol)
function UnsignedValue:initialize(token,parser)
	self.token = token
	self.parser = parser
end
function UnsignedValue:nud()
	return self.token
end

local ConstantValue = class("ConstantValue", BaseSymbol)
function ConstantValue:initialize(token)
	self.token = token
	self.parser = parser
end
function ConstantValue:nud()
	return self.token
end

local BooleanValue = class("BooleanValue", BaseSymbol)
function BooleanValue:initialize(token)
	self.token = token
	self.parser = parser
end
function BooleanValue:nud()
	return self.token
end

local DataType = class("DataType", BaseSymbol)
function DataType:initialize(token,parser)
	self.token = token
	self.parser = parser
end
function DataType:nud()
	return {node='type_declaration', node_type=self.token, node_identifier=self.parser:expression(precedence.datatype.nud)}
end

local Identifier = class("Identifier", BaseSymbol)
function Identifier:initialize(token,parser)
	self.lbp = precedence.identifier.lbp
	self.token = token
	self.parser = parser
end
function Identifier:nud()
	return self.token
end

local Latest = class("Length", BaseSymbol)
function Latest:initialize(token,parser)
	self.token = token
	self.parser = parser
end
function Latest:nud()
	return self.token
end

local Next = class("Next", BaseSymbol)
function Next:initialize(token,parser)
	self.token = token
	self.parser = parser
end
function Next:nud()
	return self.token
end

local ParserError = class("ParserError", BaseSymbol)
function ParserError:initialize(token,parser)
	self.token = token
	self.parser = parser
end
function ParserError:nud()
	return self.token
end

local Default = class("Default", BaseSymbol)
function Default:initialize(token,parser)
	self.token = token
	self.parser = parser
end
function Default:nud()
	return self.token
end

return {
	UnsignedValue = UnsignedValue,
	ConstantValue = ConstantValue,
	BooleanValue  = BooleanValue,
	DataType      = DataType,
	Identifier    = Identifier,
	Latest        = Latest,
	Next          = Next,
	ParserError   = ParserError,
	Default       = Default,
}
