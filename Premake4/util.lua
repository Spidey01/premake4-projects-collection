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

if not premake4_util_lua then
    premake4_util_lua = 1

    --
    -- The missing string.join function!
    --
    -- @usage
    --      s = join({1,2,3,4,5}, ":")  -- s = "1 2 3 4 5"
    --
    -- @param items An array of data to join.
    -- @param on What to join strings on, default is " ".
    -- @returns A string with items joined by on.
    --
    -- @todo add support for an optional 'max' parameter.
    --
    function string.join(items, on)
        if not on then on = " " end

        local s = items[1]
        for elem=2, #items do
            s = string.format("%s%s%s", s, on, items[elem])
        end
        return s
    end

    --
    -- Calls func for each member of the table.
    --
    -- @param func The function to call. func can signal an error by returning
    --        nil or false
    --
    -- @param t Table of values to map func to.
    --
    function map(func, seq)
        for elem=1, #seq do
            if not func(seq[elem]) then
                --error("aborting")
            end
        end
    end

    --
    -- Binds a table of known arguments to func before other arguments
    --
    -- @param func Function to bind
    -- @param kown Table of known arguments
    -- @returns A function that calls func with each argument in known, plus
    --          any arguments passed to it.
    --
    function bind1st(func, ...)
        local known = arg

        return function (...)
          func(unpack(known), unpack(arg))
        end
    end

    --
    -- Binds a table of known arguments to func after other arguments
    --
    -- @param func Function to bind
    -- @param kown Table of known arguments
    -- @returns A function that calls func with any arguments passed to it,
    --          plus .each argument in known.
    --
    function bind2nd(func, ...)
        local known = arg

        return function (...)
          func(unpack(arg), unpack(known))
        end
    end

end
