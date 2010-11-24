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

if not premake4_premake_lua then
    premake4_premake_lua = 1

    --
    -- Everything in the repository should build in each of these
    -- configurations.
    --
    configurations { 
        "ReleaseShared", 
        "ReleaseStatic", 
        "DebugShared",
        "DebugStatic",
    }


    --
    -- defaults for storing crap
    --
    --      stuff generated from a build goes in Build/config/
    --      stuff you need goes in Dist/config
    --      that's relative to the solution.
    --      See the wiki on GitHub for more details.
    --
    if not BUILD_DIR then
        BUILD_DIR = path.join(solution().basedir, "Build")
    end
    if not DIST_DIR then
        DIST_DIR = path.join(solution().basedir, "Dist")
    end

    location(BUILD_DIR)

    -- Some compilers need this.
    --      TODO what about _WIN64 ?
    if os.is("windows") then defines "_WIN32" end

    function setkinds()
        configuration "ReleaseShared or DebugShared"
            local k = "SharedLib"
            kind(k) 
            project().kind = k
        configuration "ReleaseStatic or DebugStatic"
            local k = "StaticLib"
            kind(k) 
            project().kind = k
    end

    function setflags()

        flags { "NoEditAndContinue" }

        configuration "Release*"
            flags { "Optimize" }
            defines { "NDEBUG" }
        configuration "Debug*"
            flags { "Symbols" }
        configuration "vs20*"
            defines { "_CRT_SECURE_NO_WARNINGS" }

        local cfgs = configurations()

        -- setup build directories accordingly for each configuration
        for c=1, #cfgs do
            local cfg = cfgs[c]
            configuration { cfg }
                includedirs(    path.join(DIST_DIR, path.join(cfg, "include")))
                libdirs(        path.join(DIST_DIR, path.join(cfg, "bin")))
                targetdir(      path.join(DIST_DIR, path.join(cfg, "bin")))
                implibdir(      path.join(DIST_DIR, path.join(cfg, "lib")))
                objdir(         path.join(BUILD_DIR, cfg))
        end
    end

end
