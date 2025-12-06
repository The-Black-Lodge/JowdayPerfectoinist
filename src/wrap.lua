---@meta _
---@diagnostic disable

modutil.mod.Path.Wrap("SetupMap", function(base)
    local package = rom.path.combine(_PLUGIN.plugins_data_mod_folder_path, _PLUGIN.guid)
    game.LoadPackages({ Name = package })
    base()
end)

-- this is for BoonDecayBoon (Bridal Glow) - makes it upgrade to Perfect instead of Heroic
-- for future reference: HeraSuperchargeBoon calls this with a hard-coded TargetRarity = 4 (Heroic)
modutil.mod.Path.Wrap("AddRarityToTraits", function(base, source, args)
    args = args or {}

    if args.TargetRarity == 4 then
        local hasPerfectRarity = false
        for _, traitData in ipairs(game.CurrentRun.Hero.Traits) do
            if game.IsGodTrait(traitData.Name, { ForShop = true }) 
                and game.TraitData[traitData.Name] 
                and not traitData.BlockInRunRarify 
                and traitData.Rarity ~= nil 
                and (args.MaxRarity == nil or game.GetRarityValue(traitData.Rarity) <= args.MaxRarity)
                and (args.StackEligibleOnly == nil or (game.IsGodTrait(traitData.Name) and not traitData.BlockStacking))
            then
                local traitDef = game.TraitData[traitData.Name]
                if traitDef and traitDef.RarityLevels and traitDef.RarityLevels.Perfect then
                    hasPerfectRarity = true
                    break
                end
            end
        end

        if hasPerfectRarity then
            -- rather than TargetRarity (which uses array index), we're using TargetRarityName
            -- this is to hopefully avoid conflicts with other mods that may have modified the rarity array
            local modifiedArgs = game.ShallowCopyTable(args)
            modifiedArgs.TargetRarityName = "Perfect"
            modifiedArgs.TargetRarity = nil
            
            return base(source, modifiedArgs)
        end
    end

    return base(source, args)
end)

-- attempt to fix the altar of ashes conflict
local mods = rom.mods
local boonBuddy = mods['Jowday-BoonBuddy']
modutil.mod.Path.Context.Wrap.Static("GetReplacementTraits", function(traitNames, onlyFromLootName)
    modutil.mod.Path.Wrap("GetUpgradedRarity", function(base, baseRarity, rarityUpgradeOrder)
        return base(baseRarity, boonBuddy.BoonRarityUpgradeOrder)
    end)
end)
