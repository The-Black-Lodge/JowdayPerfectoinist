---@meta _
---@diagnostic disable

---@diagnostic disable-next-line: undefined-global
local mods = rom.mods

---@module 'SGG_Modding-ENVY-auto'
mods['SGG_Modding-ENVY'].auto()

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

public.config = config

local function on_ready()
    -- what to do when we are ready, but not re-do on reload.
    if config.enabled == false then return end

    game.Keywords["Perfect"] = "Boon_Perfect"

    import 'sjson.lua'
    import 'wrap.lua'
end

local function on_reload()
    game.Color.BoonPatchPerfect = { 97, 230, 255, 255 }
    game.ScreenData.UpgradeChoice.RarityBackingAnimations.Perfect = "BoonSlotPerfect"

    public.DefaultPerfectChance = 0.01

    import 'multipliers.lua'
    import 'imgui.lua'
end

-- this allows us to limit certain functions to not be reloaded.
local loader = reload.auto_single()

-- this runs only when modutil and the game's lua is ready
modutil.once_loaded.game(function()
    loader.load(on_ready, on_reload)
end)
