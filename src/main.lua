---@meta _
---@diagnostic disable

-- grabbing our dependencies,
-- these funky (---@) comments are just there
--	 to help VS Code find the definitions of things

---@diagnostic disable-next-line: undefined-global
local mods = rom.mods

---@module 'SGG_Modding-ENVY-auto'
mods['SGG_Modding-ENVY'].auto()
-- ^ this gives us `public` and `import`, among others
--	and makes all globals we define private to this plugin.
---@diagnostic disable: lowercase-global

---@diagnostic disable-next-line: undefined-global
rom = rom
---@diagnostic disable-next-line: undefined-global
_PLUGIN = PLUGIN

---@module 'SGG_Modding-Hades2GameDef-Globals'
game = rom.game

---@module 'SGG_Modding-ModUtil'
modutil = mods['SGG_Modding-ModUtil']

---@module 'SGG_Modding-Chalk'
chalk = mods["SGG_Modding-Chalk"]
---@module 'SGG_Modding-ReLoad'
reload = mods['SGG_Modding-ReLoad']

---@module 'config'
config = chalk.auto()
-- ^ this updates our config.toml in the config folder!
public.config = config -- so other mods can access our config

local function on_ready()
    -- what to do when we are ready, but not re-do on reload.
    if config.enabled == false then return end

    local package = rom.path.combine(_PLUGIN.plugins_data_mod_folder_path, _PLUGIN.guid)
    modutil.mod.Path.Wrap("SetupMap", function(base)
        game.LoadPackages({ Name = package })
        base()
    end)

    local sjson = rom.mods['SGG_Modding-SJSON']

    local perfectString = sjson.to_object({
        Id = "Boon_Perfect",
        DisplayName = "Perfect"
    }, {"Id", "DisplayName"})
    local screenTextPath = rom.path.combine(rom.paths.Content, 'Game/Text/en/ScreenText.en.sjson')
    sjson.hook(screenTextPath, function(data)
        table.insert(data.Texts, perfectString)
    end)

    -- guianimations
    local guiPath = rom.path.combine(rom.paths.Content, 'Game/Animations/GUIAnimations.sjson')

    -- boon backing
    local perfectBackPath = rom.path.combine(_PLUGIN.guid, 'BoonSlot_Perfect')
    print(perfectBackPath)
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
    print(perfectIconFramePath)
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
end

local function on_reload()
    game.Color.BoonPatchPerfect = { 97, 230, 255, 255 }
    game.ScreenData.UpgradeChoice.RarityBackingAnimations.Perfect = "BoonSlotPerfect"

    game.TraitData.AphroditeWeaponBoon.RarityLevels.Perfect = {Multiplier = 2.25}
end

-- this allows us to limit certain functions to not be reloaded.
local loader = reload.auto_single()

-- this runs only when modutil and the game's lua is ready
modutil.once_loaded.game(function()
    loader.load(on_ready, on_reload)
end)
