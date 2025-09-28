---@meta _
---@diagnostic disable

-- Track previous values to avoid unnecessary updates
local previousConfig = {
    PerfectChance = nil,
    AllowPerfectSacrifice = nil
}

function public.drawPerfectPlugin()
    local mods = rom.mods
    local mod = mods['Jowday-BoonBuddy']

    rom.ImGui.Text("Perfectoinist")
    rom.ImGui.PushStyleColor(rom.ImGuiCol.Text, 0.62, 1, 1, 1)
    value, selected = rom.ImGui.SliderInt("Perfect", config.PerfectChance, 0, config.MaxPerfectChance, '%d%%')
    if selected and value ~= previousConfig.PerfectChance then
        config.PerfectChance = value
        previousConfig.PerfectChance = value
        mod.adjustRarityValues()
    end
    rom.ImGui.PopStyleColor()

    value, checked = rom.ImGui.Checkbox("Allow Heroic upgrade to Perfect (Steady Growth, Sacrifice)",
        config.AllowPerfectSacrifice)
    if checked and value ~= previousConfig.AllowPerfectSacrifice then
        config.AllowPerfectSacrifice = value
        previousConfig.AllowPerfectSacrifice = value
        mod.adjustRarityValues()
    end
end
