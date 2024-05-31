local function getcurve(id, t, reverse)
    local modname = "curve_editor"
    if not package.loaded[modname] then
        package.preload[modname]=package.loadlib(modname .. ".auf","luaopen_" .. modname)
        require(modname)
        package.preload[modname]=nil
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

return {
    getcurve=getcurve,
}
