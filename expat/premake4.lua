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

project "expat"
    version "2.0.1"
    language "C"

    sourcedir(path.join(string.join({"expat", version()}, "-"), "lib"))
    sources { "*.c" }
    headers { "expat.h", "expat_external.h" }

    mirror(sourceforge("expat", "expat/" .. version() ..
                                 "/" .. "expat-" .. version() .. ".tar.gz"))

    includedirs { sourcedir() }

    configuration "vs20*"
        defines {
            "COMPILED_FROM_DSP"     -- MSVC builds need this.
        }
        linkoptions { 
            --
            -- expat uses this for describing which functions for MSVC to
            -- export in a DLL the path must be relative to BUILD_DIR.
            --
            "/DEF:" .. path.getrelative(BUILD_DIR,
                                        path.join(sourcedir(), "libexpat.def"))
            -- >_>
        }

    setkinds()
    setflags()

