local QBCore = exports["qb-core"]:GetCoreObject()

QBCore.Functions.CreateCallback("Roda_PauseMenu:GetPlayerCount", function(src, cb)
    cb(GetConvarInt('sv_maxclients', 32), GetNumPlayerIndices())
end)


QBCore.Functions.CreateCallback("Roda_PauseMenu:GetOnlineJobs", function(src, cb)
    local jobs = {}
    for k,v in pairs(Config.JobsToShow) do
        jobs[#jobs +1] = {
            count = QBCore.Functions.GetDutyCount(v.job),
            label = v.icon,
            job = v.job
        }
    end
    table.sort(jobs, function(a, b)    return a.count > b.count end)
    cb(jobs)
end)

RegisterNetEvent('hospital:server:SetDeathStatus', function(isDead)
    local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	if Player then
		TriggerClientEvent('Roda_PauseMenu:CloseMenu', src, isDead)
	end
end)

RegisterNetEvent('hospital:server:SetLaststandStatus', function(inlaststand)
    local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	if Player then
		TriggerClientEvent('Roda_PauseMenu:CloseMenu', src, inlaststand)
	end
end)
