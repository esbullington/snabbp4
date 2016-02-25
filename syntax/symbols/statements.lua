local class      = require("snabbp4.syntax.middleclass")
local utils      = require("snabbp4.syntax.utils")
-- base symbol
local base       = require("snabbp4.syntax.symbols.base")
local BaseSymbol = base.BaseSymbol
-- precedence values
local precedence = require("snabbp4.syntax.precedence")


local MetadataInstance = class("MetadataInstance", BaseSymbol)
function MetadataInstance:initialize(token,parser)
	self.token = token
	self.parser = parser
end
function MetadataInstance:std()
	self:match_token("metadata")
	local header_type = self:ret_token()
	local header_name = self:ret_token()
	self:match_token('{')
	local stmts = {}
	while self.parser.current_symbol.token.value ~= "}" do
		local t = {}
		t.field_name = self:ret_token()
		self:match_token(':')
		t.field_value = self:ret_token()
		self:match_token(';')
		s[#s+1] = t
	end
	self:match_token('}')
	return {node="metadata_instance", node_type=header_type, node_name=header_name, statements=stmts}
end

local Length = class("Length", BaseSymbol)
function Length:initialize(token,parser)
	self.token = token
	self.parser = parser
end
function Length:std()
	self:match("Length")
	self:match("Colon")
	local e = self.parser:expression()
	self:match("Semicolon")
	return {node="length", expression=e}
end

local FieldDeclaration = class("FieldDeclaration", BaseSymbol)
function FieldDeclaration:initialize(token,parser)
	self.token = token
	self.parser = parser
end
function FieldDeclaration:std()
	self:match("FieldDeclaration")
	self:match("LBrace")
	local stmts = self.parser:statements()
	self:match("RBrace")
	return {node='field_declaration', statements=stmts}
end

return {
		Length                    = Length,
		HeaderType                = HeaderType,
		FieldDeclaration          = FieldDeclaration,
		HeaderInstance            = HeaderInstance,
		MetadataInstance          = MetadataInstance,
}
