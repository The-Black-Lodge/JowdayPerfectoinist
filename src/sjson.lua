---@meta _
---@diagnostic disable

local sjson = rom.mods['SGG_Modding-SJSON']

local perfectString = sjson.to_object({
    Id = "Boon_Perfect",
    DisplayName = "Perfect"
}, { "Id", "DisplayName" })
local screenTextPath = rom.path.combine(rom.paths.Content, 'Game/Text/en/ScreenText.en.sjson')
sjson.hook(screenTextPath, function(data)
    table.insert(data.Texts, perfectString)
end)

-- guianimations
local guiPath = rom.path.combine(rom.paths.Content, 'Game/Animations/GUI_Screens_VFX.sjson')

-- boon backing
local perfectBackPath = rom.path.combine(_PLUGIN.guid, 'BoonSlot_Perfect')
local perfectBack = sjson.to_object({
    Name = "BoonSlotPerfect",
    InheritFrom = "BoonSlotBase",
    FilePath = perfectBackPath,
}, { "Name", "InheritFrom", "FilePath" })
sjson.hook(guiPath, function(data)
    table.insert(data.Animations, perfectBack)
end)

-- button backing
local perfectIconFramePath = rom.path.combine(_PLUGIN.guid, 'perfect')
local perfectIcon = sjson.to_object({
    Name = "Frame_Boon_Menu_Perfect",
    InheritFrom = "Menu_Frame",
    FilePath = perfectIconFramePath,
    EndFrame = 1,
    StartFrame = 1,
    Scale = 2.0
}, { "Name", "InheritFrom", "FilePath", "EndFrame", "StartFrame", "Scale" })

sjson.hook(guiPath, function(data)
    for _, v in pairs(data.Animations) do
        if v.Name == 'Frame_Boon_Menu_Perfect' then
            v.FilePath = perfectIconFramePath
            v.Scale = 2.0
        end
    end
end)

local languages = {
    'en', 'es', 'fr', 'pt-BR', 'zh-CN', 'zh-TW', 'ja', 'ko', 
    'de', 'it', 'ru', 'pl', 'tr', 'uk', 'el'
}

for _, lang in ipairs(languages) do
    local traitTextPath = rom.path.combine(rom.paths.Content, 
        string.format('Game/Text/%s/TraitText.%s.sjson', lang, lang))
    
    sjson.hook(traitTextPath, function(data)
        for _, textEntry in ipairs(data.Texts or {}) do
            if textEntry.Id == "BoonDecayBoon" then
                if textEntry.Description then
                    textEntry.Description = string.gsub(
                        textEntry.Description, 
                        "{%$Keywords%.Heroic}", 
                        "{$Keywords.Perfect}"
                    )
                end
                break
            end
        end
    end)
end
