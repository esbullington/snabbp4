

insulate("Extern type declaration", function()
	local parser = require("snabbp4.syntax.parser")
	local config = {preprocess = true}
	local input = [[
		extern_type some_type {
			method some_method(in bit<4> some_param);
			attribute some_attribute {
				type: int<4>;
				optional;
			}
		}
	]]
	local statements = parser.parse(input, config)
	it("should parse extern type declaration node", function()
		assert.is_equal(statements[1].node, "extern_type_declaration")
	end)
end)

