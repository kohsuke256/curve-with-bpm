local function getbeat(f, bps, framerate, sync)
    if sync then
        local c, t = getbeat(f, bps, framerate, false)
        local sf = math.ceil(c * framerate / bps)
        local ef = math.ceil((c + 1) * framerate / bps) - 1
        return c, (f - sf) / (ef - sf)
    else
        return math.modf(f * bps / framerate)
    end
end

local function getbeat2(f, bps, framerate, m, sync)
    if sync then
        local c, t = getbeat(f, bps, framerate, false)
        local sf, ef
        if t < m then
            sf = math.ceil(c * framerate / bps)
            ef = math.ceil((c + m) * framerate / bps)
            return c, (f - sf) / (ef - sf) * m
        else
            sf = math.ceil((c + m) * framerate / bps)
            ef = math.ceil((c + 1) * framerate / bps)
            return c, (f - sf) / (ef - sf) * (1 - m) + m
        end
    else
        return math.modf(f * bps / framerate)
    end
end

local function getcurve(id, t, reverse)
    local modname = "curve_editor"
    if not package.loaded[modname] then
        package.preload[modname] = package.loadlib(modname .. ".auf","luaopen_" .. modname)
        require(modname)
        package.preload[modname] = nil
    end

    if id == -2 then
        return 0
    elseif id == -1 then
        return 1
    elseif id == 0 then
        return t
    else
        if reverse then
            return curve_editor.getcurve(1, id, 1 - t, 1.0, 0.0)
        else
            return curve_editor.getcurve(1, id, t, 0.0, 1.0)
        end
    end
end

local function getcurve2(id_s, id_e, t, m, reverse)
    if t < m then
        return getcurve(id_s, t / m, false)
    else
        return 1.0 - getcurve(id_e, (t - m) / (1.0 - m), reverse)
    end
end

return {
    getbeat = getbeat,
    getbeat2 = getbeat2,
    getcurve = getcurve,
    getcurve2 = getcurve2,
}
