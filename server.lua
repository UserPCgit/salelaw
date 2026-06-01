local RESOURCE_NAME = GetCurrentResourceName()
local PROFILE_FILE = "data/profiles.json"
local profiles = {}

local function loadProfiles()
    local raw = LoadResourceFile(RESOURCE_NAME, PROFILE_FILE)
    if raw and raw ~= "" then
        profiles = json.decode(raw) or {}
    else
        profiles = {}
        SaveResourceFile(RESOURCE_NAME, PROFILE_FILE, json.encode(profiles, { indent = true }), -1)
    end
end

local function saveProfiles()
    SaveResourceFile(RESOURCE_NAME, PROFILE_FILE, json.encode(profiles, { indent = true }), -1)
end

local function getPrimaryIdentifier(src)
    local identifiers = GetPlayerIdentifiers(src)
    local fallback = nil
    for _, identifier in ipairs(identifiers) do
        if identifier:find("license:", 1, true) == 1 then return identifier end
        if not fallback and (identifier:find("fivem:", 1, true) == 1 or identifier:find("discord:", 1, true) == 1 or identifier:find("steam:", 1, true) == 1) then
            fallback = identifier
        end
    end
    return fallback
end

local function isActive(node)
    return node and node.active == true
end

local function validateSelection(selection)
    if type(selection) ~= "table" then return false, "Invalid selection" end

    local faction = Config.Factions[selection.faction]
    if not isActive(faction) then return false, "Faction is not active" end

    local category, department
    if faction.categories then
        category = faction.categories[selection.category]
        if not isActive(category) then return false, "Category is not active" end
        department = category.departments and category.departments[selection.department]
    else
        department = faction.departments and faction.departments[selection.department]
    end

    if not isActive(department) then return false, "Department is not active" end

    local division, specialization
    if department.divisions then
        division = department.divisions[selection.division]
        if not isActive(division) then return false, "Division is not active" end
        if division.specializations then
            specialization = division.specializations[selection.specialization or "general"]
            if not isActive(specialization) then return false, "Specialization is not active" end
        end
    end

    local labels = {
        faction = faction.label,
        category = category and category.label or nil,
        department = department.label,
        departmentShort = department.short,
        division = division and division.label or nil,
        specialization = specialization and specialization.label or nil
    }

    return true, nil, labels
end

local function getModeForProfile(profile, now)
    if not profile or profile.onboardingCompleted ~= true then return "first_time" end
    local lastJoinAt = tonumber(profile.lastJoinAt or 0) or 0
    if ((now - lastJoinAt) / 86400) >= Config.ReOnboardingAfterDays then return "welcome_back" end
    return "known"
end

AddEventHandler("onResourceStart", function(resourceName)
    if resourceName == RESOURCE_NAME then loadProfiles() end
end)

RegisterNetEvent("law_onboarding:requestProfile", function()
    local src = source
    local identifier = getPrimaryIdentifier(src)
    if not identifier then
        TriggerClientEvent("law_onboarding:profileResponse", src, { mode = "first_time", profile = nil, error = "No stable player identifier found." })
        return
    end

    local now = os.time()
    local profile = profiles[identifier]
    local mode = getModeForProfile(profile, now)

    if profile then
        profile.lastJoinAt = now
        profiles[identifier] = profile
        saveProfiles()
    end

    TriggerClientEvent("law_onboarding:profileResponse", src, { mode = mode, identifier = identifier, profile = profile })
end)

RegisterNetEvent("law_onboarding:saveSelection", function(selection, reason)
    local src = source
    local identifier = getPrimaryIdentifier(src)
    if not identifier then
        TriggerClientEvent("law_onboarding:saveResult", src, { ok = false, message = "No stable player identifier found." })
        return
    end

    local ok, err, labels = validateSelection(selection)
    if not ok then
        TriggerClientEvent("law_onboarding:saveResult", src, { ok = false, message = err or "Selection rejected." })
        return
    end

    local now = os.time()
    local existing = profiles[identifier] or {}

    profiles[identifier] = {
        identifier = identifier,
        faction = selection.faction,
        category = selection.category,
        department = selection.department,
        division = selection.division,
        specialization = selection.specialization or "general",
        labels = labels,
        onboardingCompleted = true,
        onboardingVersion = Config.OnboardingVersion,
        firstJoinAt = existing.firstJoinAt or now,
        lastJoinAt = now,
        lastOnboardingAt = now,
        lastChangeReason = reason or "unknown"
    }

    saveProfiles()
    TriggerClientEvent("law_onboarding:saveResult", src, { ok = true, message = "Assignment saved.", profile = profiles[identifier] })
end)

RegisterNetEvent("law_onboarding:resetProfile", function()
    local src = source
    local identifier = getPrimaryIdentifier(src)
    if not identifier then
        TriggerClientEvent("law_onboarding:resetResult", src, false, "No identifier found.")
        return
    end
    profiles[identifier] = nil
    saveProfiles()
    TriggerClientEvent("law_onboarding:resetResult", src, true, "Profile reset. Use /tutorial or reconnect.")
end)
