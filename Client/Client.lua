
local QBCore = exports['qb-core']:GetCoreObject()

local PlayerMoney = nil
local PlayerJob = nil

local open = false
RegisterCommand('openSetting', function()
    OpenPauseMenu()
end)

RegisterKeyMapping('openSetting', 'Open Settings Menu', 'keyboard', 'ESCAPE')


function OpenPauseMenu()
    if not open and not IsPauseMenuActive() then 
        SetNuiFocus(true,true)
        SendNUIMessage({
            action = 'show',
        })
        open = true
        CreationCamHead()
        GetDataFromServer()
        GetJobs()
    end
end

RegisterNUICallback('Getcolor', function(data, cb)
    SendNUIMessage({
        action = 'color',
        color = Config.MainColor
    })
end)

function GetDataFromServer()
    QBCore.Functions.TriggerCallback("Roda_PauseMenu:GetPlayerCount", function(max, current)
		SendNUIMessage({action = "UpdateData", key = "bank", value = tonumber(PlayerMoney["bank"])})
		SendNUIMessage({action = "UpdateData", key = "crypto", value = tonumber(PlayerMoney["crypto"])})
        SendNUIMessage({action = "UpdateData", key = "cash", value = tonumber(PlayerMoney["cash"])})
		SendNUIMessage({action = "UpdateData", key = "job", value = PlayerJob.label.." - "..PlayerJob.grade.name})
        SendNUIMessage({action = 'updatePlayers', max = max, total = current})
	end)
end


function GetJobs()
    QBCore.Functions.TriggerCallback("Roda_PauseMenu:GetOnlineJobs", function(jobs) 
        for k,v in pairs(jobs) do 
            SendNUIMessage({
                action = 'updateJobs',
                label = v.label,
                value = v.count
            })
        end
	end)
end

CreateThread(function()
    while true do 
        SetPauseMenuActive(false) 
        Wait(10)
    end
end)

RegisterNUICallback('exit', function(data, cb)
  SetNuiFocus(false, false)
  open = false
  DestroyCamera()
end)

RegisterNUICallback('SendAction', function(data, cb)
    if data.action == 'settings' then 
        DestroyCamera()
        SetFrontendActive(true)
        ActivateFrontendMenu(GetHashKey('FE_MENU_VERSION_LANDING_MENU'),0,-1) 
        SetNuiFocus(false, false)
    elseif data.action == 'map' then 
        DestroyCamera()
        SetFrontendActive(true)
        ActivateFrontendMenu(GetHashKey('FE_MENU_VERSION_MP_PAUSE'),0,-1) 
        SetNuiFocus(false, false)
    end

end)

local function LoadPlayerData()
    local playerData = QBCore.Functions.GetPlayerData()
    PlayerMoney = playerData.money
    PlayerJob = playerData.job
end

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        LoadPlayerData()
    end
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    LoadPlayerData()
end)

RegisterNetEvent('hud:client:OnMoneyChange', function(moneyType)
    PlayerMoney = QBCore.Functions.GetPlayerData().money
    SendNUIMessage({action = "UpdateData", key = moneyType, value = tonumber(PlayerMoney[moneyType])})
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
    SendNUIMessage({
        action = "UpdateData", 
        key = "job", 
        value = PlayerJob.label.." - "..PlayerJob.grade.name
    })
end)
