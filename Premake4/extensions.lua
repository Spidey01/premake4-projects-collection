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

if not premake4_extensions_lua then
    premake4_extensions_lua = 1

    --
    -- Get/set the version number for the current project.
    --
    -- @param v String describing a version number.
    -- @returns The current project().version.
    --
    function version(v)
        local p = project()
        if v then p.version = v end
        return p.version
    end

    --
    -- Get/set the mirror for fetching the current projects source code.
    --
    -- @param site String describing the URL to fetch from.
    -- @returns the current project().mirror.
    --
    function mirror(site)
        local p  = project()
        if site then p.mirror = site end
        return p.mirror
    end

    --
    -- Get the download URL for a file from a project on SourceForge
    --
    -- @param unixname The projects unix name on SourceForge.
    -- @param filename The file name to download, including any folder names.
    -- @returns A string url to fetch the filename.
    --
    -- @usage sourceforge("foo", "foo/foo-1.2.3.tar.gz");
    --
    -- this function isn't really all that useful IMHO -- Spidey01
    --
    function sourceforge(unixname, filename)
        return "https://sourceforge.net/projects/" ..  unixname ..
               "/files/" .. filename
    end

    --
    -- Get/set the source directory for projects source code.
    --
    -- @param path File path referencing the projcets source directory.
    -- @returns the current project().sourcedir.
    --
    function sourcedir(path)
        local p = project()
        if path then p.sourcedir = path end
        return p.sourcedir
    end

    --
    -- Works like files() but paths are relative to sourcedir()
    --
    function sources(t)
        assert(project().sourcedir,
               "must set sourcedir() before using sources()")

        local f = {}
        local s = project().sourcedir

        for e=1, #t do
            f[e] = path.join(s, t[e]);
        end

        return files(f)
    end

    --
    -- Copies files in the given table to destination
    --
    -- @param t Table like { "file1", "file2", ... }.
    -- @param dest Path to copy them to.
    --
    function os.copyfiles(t, dest)
        print(os.getcwd())
        return map(bind2nd(os.copyfile, dest), t)
    end

    --
    -- handles header files to be installed/cleaned
    --
    -- @param t A table of filenames, relative to the projects premake4.lua
    --
    function headers(headers)
        local p = project()

        -- path.join() has a bug in it that causes it to fail if the second
        -- argument starts with a $, and that may happen here: so use this func
        -- instead.
        --
        local function join(a, b)
            return a .. "/" .. b
        end

        if _ACTION == "clean" then
            local function clean(cfg)
                local incdir = join(DIST_DIR, join(cfg, "include"))
                local t = {}
                local function rm(f)
                    if os.isfile(f) then os.remove(f)
                    elseif os.isdir(f) then os.rmdir(f)
                    -- else ignore it silently
                    end
                end
                for i=1, #headers do
                    rm(join(incdir, headers[i]))
                end
            end
            --
            -- This needs to run for each configuration because (for
            -- consistency) headers get installed into a configuration specific
            -- path along with the associated binaries, and premake4 clean
            -- works like this also. BREAK JUDICIOUSLY!
            --
            map(clean, configurations())
        elseif _ACTION then
            --
            -- setup pre-build-commands to get the job done.
            --
            -- XXX this needs to be done for each _ACTION we support.
            --     and we need to create the include directories for
            --     each configuration.
            --
            map(function (cfg)
                    os.mkdir(join(DIST_DIR, join(cfg, "include")))
                end, configurations())

            -- This must be set to a string suitable for use as
            -- string.format(copycmd, headerfile, foldername) to be passed on
            -- to prebuildcommands()
            --
            local copycmd = ""

            -- This must be set to the directory in DIST_DIR that headers are
            -- placed in for the current configuration, as accessible from the
            -- _ACTIONs prebuildcommands. I.e. allowing you to use gmake/vs20*
            -- macros and the like.
            --
            --
            -- $ must be entered as %$ to avoid a bug in premake.
            -- It is unescaped back to $ later in this function.
            --
            local incdir = ""

            if _ACTION == "gmake" then
                copycmd = "cp -R \"%s\" \"%s\""

                -- OBJDIR will be, e.g. ReleaseShared/<projectname>
                incdir = join("`dirname $(OBJDIR)`", "include")
            elseif string.match(_ACTION, "vs20*") then
                copycmd = "COPY \"%s\" \"%s\" /Y"
                incdir = join("%$(ConfigurationName)", "include")
            else
                error(_ACTION .. " is unsupported, patch me :-)")
            end

            -- paths here may contain stuff like $(macro) which breaks 
            -- incdir may contain $(stuff), which breaks premakes path.join(),
            -- so we have got to do it the manual way 8=)
            incdir = DIST_DIR .. "/" .. incdir

            local cmds = {}
            local srcdir = sourcedir()
            for i=1, #headers do
                local header = path.getrelative(BUILD_DIR,
                                                join(srcdir, headers[i]))
                local dest = path.getrelative(BUILD_DIR,
                                              join(incdir,
                                              path.getname(header))) 
                -- unescape %$ back to $
                dest = string.gsub(dest, "%%%$", "$")

                if string.match(_ACTION, "vs20*") then
                    -- convert paths for cmd :'(

                    header = string.gsub(header, "/", "\\")
                    dest = string.gsub(dest, "/", "\\")
                end

                cmds[i] = string.format(copycmd, header, dest)
            end
            prebuildcommands(cmds)
        end
    end
end
