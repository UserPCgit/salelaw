local playerLoaded = false
local currentProfile = nil
local currentDepartment = nil
local currentSelectionMode = "first_time"

local function notify(message)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(message)
    DrawNotification(false, false)
end

local function showHelpText(message)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(message)
    EndTextCommandDisplayHelp(0, false, true, -1)
end

local function getNode(selection)
    if not selection then return nil end
    local faction = Config.Factions[selection.faction]
    if not faction then return nil end

    local category, department
    if faction.categories then
        category = faction.categories[selection.category]
        if not category then return nil end
        department = category.departments and category.departments[selection.department]
    else
        department = faction.departments and faction.departments[selection.department]
    end
    if not department then return nil end

    return { faction = faction, category = category, department = department }
end

local function getDepartmentFromProfile(profile)
    local nodes = getNode(profile)
    return nodes and nodes.department or nil
end

local function sanitizeFactions()
    local out = {}
    for factionKey, faction in pairs(Config.Factions) do
        out[factionKey] = { label = faction.label, description = faction.description, active = faction.active, status = faction.status }

        if faction.categories then
            out[factionKey].categories = {}
            for categoryKey, category in pairs(faction.categories) do
                out[factionKey].categories[categoryKey] = { label = category.label, description = category.description, active = category.active, status = category.status, departments = {} }
                for departmentKey, department in pairs(category.departments or {}) do
                    local deptOut = { label = department.label, short = department.short, active = department.active, status = department.status }
                    if department.divisions then
                        deptOut.divisions = {}
                        for divisionKey, division in pairs(department.divisions) do
                            deptOut.divisions[divisionKey] = { label = division.label, active = division.active, status = division.status }
                            if division.specializations then
                                deptOut.divisions[divisionKey].specializations = {}
                                for specKey, spec in pairs(division.specializations) do
                                    deptOut.divisions[divisionKey].specializations[specKey] = { label = spec.label, active = spec.active, status = spec.status }
                                end
                            end
                        end
                    end
                    out[factionKey].categories[categoryKey].departments[departmentKey] = deptOut
                end
            end
        end

        if faction.departments then
            out[factionKey].departments = {}
            for departmentKey, department in pairs(faction.departments) do
                out[factionKey].departments[departmentKey] = { label = department.label, short = department.short, active = department.active, status = department.status }
            end
        end
    end
    return out
end

local function closeNui()
    SetNuiFocus(false, false)
    SendNUIMessage({ type = "close" })
end

local function openSelection(mode, profile)
    currentSelectionMode = mode or "first_time"
    SetNuiFocus(true, true)
    SendNUIMessage({ type = "openSelection", mode = currentSelectionMode, factions = sanitizeFactions(), profile = profile })
end

local function showChecklist(profile)
    SendNUIMessage({ type = "showChecklist", profile = profile })
end

local function fadeTeleport(spawn)
    if not spawn then return end
    DoScreenFadeOut(650)
    while not IsScreenFadedOut() do Wait(0) end

    local ped = PlayerPedId()
    RequestCollisionAtCoord(spawn.x, spawn.y, spawn.z)
    SetEntityCoords(ped, spawn.x, spawn.y, spawn.z, false, false, false, true)
    SetEntityHeading(ped, spawn.w or 0.0)
    Wait(800)
    DoScreenFadeIn(650)
end

local function applyProfile(profile, fullChecklist)
    currentProfile = profile
    currentDepartment = getDepartmentFromProfile(profile)
    if currentDepartment and currentDepartment.spawn then fadeTeleport(currentDepartment.spawn) end
    if profile and profile.labels then notify(("Assigned: %s"):format(profile.labels.department or "Unknown")) end
    if fullChecklist then showChecklist(profile) end
end

local function giveLoadout()
    if not currentDepartment or not currentDepartment.loadout then notify("No loadout configured.") return end
    local ped = PlayerPedId()
    for _, weaponName in ipairs(currentDepartment.loadout) do
        GiveWeaponToPed(ped, joaat(weaponName), 120, false, false)
    end
    notify("Duty gear issued.")
end

local function openGarage()
    if not currentDepartment or not currentDepartment.vehicles then notify("No garage vehicles configured.") return end
    SetNuiFocus(true, true)
    SendNUIMessage({ type = "openGarage", vehicles = currentDepartment.vehicles, department = currentProfile and currentProfile.labels or nil })
end

local function spawnVehicle(modelName)
    if not currentDepartment or not currentDepartment.garage then notify("No garage spawn configured.") return end
    local garage = currentDepartment.garage
    local model = joaat(modelName)

    if not IsModelInCdimage(model) then notify(("Vehicle model not found: %s"):format(modelName)) return end
    RequestModel(model)
    local timeout = GetGameTimer() + 6000
    while not HasModelLoaded(model) and GetGameTimer() < timeout do Wait(0) end
    if not HasModelLoaded(model) then notify(("Could not load vehicle: %s"):format(modelName)) return end

    local vehicle = CreateVehicle(model, garage.x, garage.y, garage.z, garage.w or 0.0, true, false)
    SetVehicleNumberPlateText(vehicle, "LEO")
    SetPedIntoVehicle(PlayerPedId(), vehicle, -1)
    SetVehicleEngineOn(vehicle, true, true, false)
    SetModelAsNoLongerNeeded(model)
    notify("Patrol vehicle ready.")
end

local function drawMarkerAt(coords)
    DrawMarker(Config.Marker.Type, coords.x, coords.y, coords.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Marker.Scale.x, Config.Marker.Scale.y, Config.Marker.Scale.z, Config.Marker.Color.r, Config.Marker.Color.g, Config.Marker.Color.b, Config.Marker.Color.a, false, true, 2, false, nil, nil, false)
end

local function handlePoint(label, coords, action)
    if not coords then return end
    local dist = #(GetEntityCoords(PlayerPedId()) - coords)
    if dist <= Config.Marker.DrawDistance then
        drawMarkerAt(coords)
        if dist <= Config.Marker.InteractDistance then
            showHelpText(("Press ~INPUT_CONTEXT~ - %s"):format(label))
            if IsControlJustPressed(0, Config.Keys.Interact) then action() end
        end
    end
end

RegisterNUICallback("close", function(_, cb) closeNui(); cb({ ok = true }) end)
RegisterNUICallback("selectAssignment", function(data, cb)
    if data and data.selection then TriggerServerEvent("law_onboarding:saveSelection", data.selection, currentSelectionMode) end
    cb({ ok = true })
end)
RegisterNUICallback("continueProfile", function(_, cb) closeNui(); if currentProfile then applyProfile(currentProfile, true) end; cb({ ok = true }) end)
RegisterNUICallback("openChangeAssignment", function(_, cb) openSelection("change", currentProfile); cb({ ok = true }) end)
RegisterNUICallback("spawnVehicle", function(data, cb) closeNui(); if data and data.model then spawnVehicle(data.model) end; cb({ ok = true }) end)

RegisterNetEvent("law_onboarding:profileResponse", function(response)
    if not response then return end
    currentProfile = response.profile
    if response.mode == "first_time" then openSelection("first_time", nil) return end
    if response.mode == "welcome_back" then
        SetNuiFocus(true, true)
        SendNUIMessage({ type = "welcomeBack", profile = currentProfile, days = Config.ReOnboardingAfterDays })
        return
    end
    if response.mode == "known" and currentProfile then
        if Config.TeleportReturningPlayers then applyProfile(currentProfile, false) end
        if currentProfile.labels then notify(("Welcome back. Assignment: %s"):format(currentProfile.labels.department or "Unknown")) end
    end
end)

RegisterNetEvent("law_onboarding:saveResult", function(result)
    if not result then return end
    if not result.ok then notify(result.message or "Assignment could not be saved.") return end
    closeNui()
    applyProfile(result.profile, true)
end)

RegisterNetEvent("law_onboarding:resetResult", function(ok, message) notify(message or (ok and "Profile reset." or "Profile reset failed.")) end)

AddEventHandler("playerSpawned", function()
    if playerLoaded then return end
    playerLoaded = true
    Wait(1500)
    TriggerServerEvent("law_onboarding:requestProfile")
end)

RegisterCommand(Config.Commands.OpenTutorial, function()
    if currentProfile then showChecklist(currentProfile) else openSelection("manual", nil) end
end, false)
RegisterCommand(Config.Commands.ChangeDepartment, function() openSelection("change", currentProfile) end, false)
RegisterCommand(Config.Commands.ResetOnboarding, function() TriggerServerEvent("law_onboarding:resetProfile") end, false)

CreateThread(function()
    while true do
        local waitTime = 750
        if currentDepartment then
            waitTime = 0
            handlePoint("Department Services", currentDepartment.departmentServices, function() openSelection("change", currentProfile) end)
            handlePoint("Duty Desk", currentDepartment.dutyDesk, function() notify("Go Locker -> Armory -> Garage, then press F11 for FivePD duty."); showChecklist(currentProfile) end)
            handlePoint("Locker Room", currentDepartment.locker, function() notify("Uniform presets/EUP support will be added in the next version.") end)
            handlePoint("Armory", currentDepartment.armory, giveLoadout)
            if currentDepartment.garage then handlePoint("Garage", vector3(currentDepartment.garage.x, currentDepartment.garage.y, currentDepartment.garage.z), openGarage) end
        end
        Wait(waitTime)
    end
end)
