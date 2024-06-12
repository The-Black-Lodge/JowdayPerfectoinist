---@meta _
---@diagnostic disable

function public.drawPerfectPlugin()
    local mods = rom.mods
    local mod = mods['Jowday-BoonBuddy']

        rom.ImGui.Text("Perfectoinist")
        rom.ImGui.PushStyleColor(rom.ImGuiCol.Text, 0.62, 1, 1, 1)
        value, selected = rom.ImGui.SliderInt("% Perfect", config.PerfectChance, 0, 5)
        if selected then
            config.PerfectChance = value
            mod.adjustRarityValues()
        end
        rom.ImGui.PopStyleColor()
end