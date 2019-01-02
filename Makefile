LUA ?= lua

test:
	$(LUA) test.lua

testall:
	lua5.1 test.lua
	lua5.2 test.lua
	lua5.3 test.lua
	luajit test.lua

luacheck:
	luacheck fennel.lua fennel test.lua

count:
	cloc fennel.lua

# Precompile fennel libraries
%.fnl.lua: %.fnl fennel fennel.lua
	./fennel --compile $< > $@


%.o: %.lua 
	luajit -b $< $@

fennelview.o: fennelview.fnl.lua 
	luajit -b $< $@

fennelcli.o: fennel
	luajit -b fennel fennelcli.o

jit:: fennelview.o fennel.o fennelcli.o


clean::
	rm -f *.o
#	rm -f *.fnl.lua # not until fennelview.fnl.lua is removed from git

pre-compile: fennelview.fnl.lua

ci: luacheck testall count pre-compile
