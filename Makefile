

run:
	luajit main.lua spec/p4/simple_router.p4

test:
	busted

lint:
	luacheck parser.lua syntax/ --exclude-files syntax/dsl
