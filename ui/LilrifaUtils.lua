EnableGlobals()

-- Additional functions on UIElements
-- Args = Element, StateTable, StateTableToMergeWith
LUI.UIElement.clearAndSetStateConditions = function(Element, StateTable)
    for index,conditionTable in ipairs(StateTable) do
        table.insert(Element.stateConditions, LUI.ShallowCopy(conditionTable))
    end
end

LUI.UIElement.mergeStateConditionsOriginal = function(Element, StateTable, StateTableToMergeWith)
    local function GetStateIndex(stateName)
        for index,conditionTable in ipairs(Element.stateConditions) do
            if conditionTable.stateName == stateName then
                return key
            end
        end

        return nil
    end
    
    if not StateTableToMergeWith then
        if not Element.stateConditions then
            Element.stateConditions = {}
        end
    end

    for index,conditionTable in ipairs(StateTable) do
        local stateIndex = GetStateIndex(conditionTable.stateName)
        if not stateIndex then
            table.insert(Element.stateConditions, LUI.ShallowCopy(conditionTable))
        else
            Element.stateConditions[stateIndex] = LUI.ShallowCopy(conditionTable)
        end
    end
end



Lilrifa = {}

-- Preload an image
function CacheImage(imageName)
    if not Lilrifa.CachedImages then
        Lilrifa.CachedImages = {}
    end

    if not Lilrifa.CachedImages[imageName] then
        Lilrifa.CachedImages[imageName] = RegisterImage(imageName)
    end
end

-- Retrieve preloaded image
function GetCachedImage(imageName)
    CacheImage(imageName)

    return Lilrifa.CachedImages[imageName]
end

function GetZombiePlayerNameFromPlayerIcon(playerIcon)
    if playerIcon == "uie_t7_zm_hud_score_char4" or playerIcon == "uie_t7_zm_hud_score_char4_old" then
        return "Richtofen"
    elseif playerIcon == "uie_t7_zm_hud_score_char3" or playerIcon == "uie_t7_zm_hud_score_char3_old" then
        return "Dempsey"
    elseif playerIcon == "uie_t7_zm_hud_score_char1" or playerIcon == "uie_t7_zm_hud_score_char1_old" then
        return "Nikolai"
    elseif playerIcon == "uie_t7_zm_hud_score_char2" or playerIcon == "uie_t7_zm_hud_score_char2_old" then
        return "Takeo"
    elseif playerIcon == "uie_s1_zm_hud_score_stuh" then
        return "Stuhlinger"
    elseif playerIcon == "uie_s1_zm_hud_score_misty" then
        return "Misty"
    elseif playerIcon == "uie_s1_zm_hud_score_russman" then
        return "Russman"
    elseif playerIcon == "uie_s1_zm_hud_score_marlton" then
        return "Marlton"
    elseif Engine.GetCurrentMap() ~= "zm_alcatraz_island" and playerIcon == "arlington_head_img" then
        return "Weasel"
    elseif Engine.GetCurrentMap() ~= "zm_alcatraz_island" and playerIcon == "deluca_head_img" then
        return "Sal"
    elseif Engine.GetCurrentMap() ~= "zm_alcatraz_island" and playerIcon == "handsome_head_img" then
        return "Billy"
    elseif Engine.GetCurrentMap() ~= "zm_alcatraz_island" and playerIcon == "oleary_head_img" then
        return "Finn"
    end
    
    return ""
end