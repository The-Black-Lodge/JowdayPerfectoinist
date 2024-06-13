---@meta _
---@diagnostic disable

function public.drawPerfectPlugin()
    local mods = rom.mods
    local mod = mods['Jowday-BoonBuddy']

    rom.ImGui.Text("Perfectoinist")
    rom.ImGui.PushStyleColor(rom.ImGuiCol.Text, 0.62, 1, 1, 1)
    value, selected = rom.ImGui.SliderInt("Perfect", config.PerfectChance, 0, config.MaxPerfectChance, '%d%%')
    if selected then
        config.PerfectChance = value
        mod.adjustRarityValues()
    end
    rom.ImGui.PopStyleColor()

    value, checked = rom.ImGui.Checkbox("Allow Heroic boons to upgrade to Perfect (Sacrifice)",
        config.AllowPerfectSacrifice)
    if checked then
        config.AllowPerfectSacrifice = value
        mod.adjustRarityValues()
    end
end
