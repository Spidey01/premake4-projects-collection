-- Copyright (c) 2010-current, Terry Matthew Poulin.
-- 
-- Redistribution and use in source and binary forms, with or without
-- modification, are permitted provided that the following conditions are met:
-- 
--   * Redistributions of source code must retain the above copyright notice,
--     this list of conditions and the following disclaimer.
-- 
--   * Redistributions in binary form must reproduce the above copyright
--     notice, this list of conditions and the following disclaimer in the
--     documentation and/or other materials provided with the distribution.
-- 
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
-- AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
-- IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
-- ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
-- LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
-- CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
-- SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
-- INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
-- CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
-- ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
-- POSSIBILITY OF SUCH DAMAGE.
-- 

include "../Premake4"
dofile "../Premake4/extensions.lua"
dofile "../Premake4/util.lua"

project "lua"
    version "5.1.4"
    language "C"

    sourcedir(path.join(string.join({"lua", version()}, "-"), "src"))
    sources {
        "lapi.c", "lcode.c", "ldebug.c", "ldo.c", "ldump.c",
        "lfunc.c", "lgc.c", "llex.c", "lmem.c", "lobject.c",
        "lopcodes.c", "lparser.c", "lstate.c", "lstring.c",
        "ltable.c", "ltm.c", "lundump.c", "lvm.c", "lzio.c",
        "lauxlib.c", "lbaselib.c", "ldblib.c", "liolib.c",
        "lmathlib.c", "loslib.c", "ltablib.c", "lstrlib.c",
        "loadlib.c", "linit.c"
    }
    headers { "lua.h", "luaconf.h", "lualib.h" }

    mirror("http://www.lua.org/ftp/" ..
           "lua" .. "-" .. version() .. ".tar.gz")

    includedirs { sourcedir() }

    setkinds()
    setflags()
