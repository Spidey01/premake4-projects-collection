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

project "sqlite3"
    version "3070701"
    language "C"

    sourcedir("sqlite-amalgamation-" .. version())
    sources { "sqlite3.c" }
    headers { "sqlite3.h", "sqlite3ext.h" }

    mirror("http://www.sqlite.org/sqlite-amalgamation-" ..
           version() .. ".zip")

    includedirs { sourcedir() }

    defines {
        -- these are in the def's file they give in one of their MSVC packages
        -- so may as well enable them for all builds.
        "SQLITE_ENABLE_COLUMN_METADATA",
        "SQLITE_ENABLE_RTREE"
    }

    configuration "vs20*"
        -- ugh, between MS and SQLite3 we need a def's file.  Which is _NOT_ in
        -- the source package we're reccomended to use!
        linkoptions { 
            "/DEF:" .. '"' ..
              path.getdirectory(string.sub(debug.getinfo(1).source, 2)) .. 
              "/" .. "sqlite3.def" ..
            '"'
        }


    setkinds()
    setflags()
