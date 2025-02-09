-- FIXME: Test currently fails on Windows (and PPC64le too)
-- https://github.com/terralang/terra/issues/287
local ffi = require("ffi")
if ffi.os == "Windows" or ffi.arch == "ppc64le" then
    print("this test is not compatible with " .. ffi.os .. " " .. ffi.arch)
    os.exit()
end

function failit(match,fn)
	local success,msg = xpcall(fn,debug.traceback)
	if success then
		error("failed to fail.",2)
	elseif not string.match(msg,match) then
		error("failed wrong: "..msg,2)
	end
end
local test = require("test")
local erd = "Errors reported during"

terra foo()
end
foo:compile()
--failit("inlining",function() foo:setinlined(false) end)

terra bar :: int -> int
failit("is not defined",function()
bar:compile() end)

failit("expected a name",function()
    terralib.intrinsic("far","far")
end)

print((&int)[4])

struct A {
    a : int[4];
    b : &int;
    union { c : int; d : int};
    e : int -> int;
}
A:printpretty()

terra rv() return vector(1,2,3) end

terra varg(a : vector(int,3))

    return a[0] + a[1] + a[2]
end

assert (6 == varg(rv()))

local something = nil
failit(erd,function()
local terra a([something])
end
end)

failit(erd,function()
local terra what()
    var a = A { ee = 4 }
end
what:compile()
end)

A.metamethods.__getmethod = function(self,methodname)
    return 1
end

failit(erd,function()
local terra what()
    var a : A
    A.something()
end
what:compile()
end)

C = terralib.includec("stdio.h")

--TODO: __sputc isn't consistent across architectures, so this is a bad test
--failit("cannot import",function()
--local a = C.__sputc
--end)

failit("not found",function()
local a = C.nothing
end)

terra up() return unpackstruct(3) end
assert(3 == up())

failit(erd,function()
local terra aloads(a : &int)
    return terralib.attrload(a),terralib.attrload(nil,{3}),terralib.attrstore(a,nil)
end
aloads:compile()
end)

local f = terralib.overloadedfunction("f")

failit("expected terra global", function()
terralib.saveobj("err.o", { f = f})
end)

terra nop() end
terra nilcall(a : tuple(), b : int)
    return b,a
end
terra nilstuff()
    var a = nop()
    var c,b = nilcall(a,4)
    return c
end
assert(4 == nilstuff())

nilcall:disas()
