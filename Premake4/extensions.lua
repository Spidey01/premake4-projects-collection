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

    function sources(t)
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

        --
        -- This needs to run for each configuration because (for consistency)
        -- headers get installed into a configuration specific path along with
        -- the associated binaries. BREAK JUDICIOUSLY!
        --
        local cfgs = configurations()
        for c=1, #cfgs do
            local cfg = cfgs[c]
            incdir = path.join(DIST_DIR, path.join(cfg, "include"))

            if _ACTION == "clean" then
                local t = {}
                local function rm(f)
                    if os.isfile(f) then os.remove(f)
                    elseif os.isdir(f) then os.rmdir(f)
                    -- else ignore it silently
                    end
                end
                for i=1, #headers do
                    rm(path.join(incdir, headers[i]))
                end
            elseif _ACTION then
                if not os.isdir(incdir) then os.mkdir(incdir) end
                local t = {}
                for i=1, #headers do
                    header = path.join(sourcedir(), headers[i])
                    dest = path.join(incdir, path.getname(header))
                    if os.isfile(header) then
                        os.copyfile(header, dest)
                    elseif os.isdir(header) then
                        error("headers() doesn't do directories yet, sorry chap!")
                    else
                        error("You can't use headers() to copy a " ..
                               type(header))
                    end
                end
            end
        end
    end
end
