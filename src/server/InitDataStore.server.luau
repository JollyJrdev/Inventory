local Players = game.Players
local Rs = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local CreateInventoryData = require(script.Parent.CreateInventoryData)
local Manager = require(script.Parent.Manager)
local Template = require(script.Parent.Template)
local ProfileService = require(ServerScriptService.ServerPackages.ProfileService)

local ProfileStore = ProfileService.GetProfileStore("Test", Template)
local KickMessage = "Unexpected Error while loading youre Data. Try again."

local SendData = ReplicatedStorage.Remotes.SendData
local DataLoaded = ReplicatedStorage.Remotes.DataLoaded

local function PlayerAdded(player: Player)
	local profile = ProfileStore:LoadProfileAsync("Player_" .. player.UserId)
	
	if profile == nil then
		player:Kick(KickMessage)
		return
	end
	
	profile:AddUserId(player.UserId) -- GDPR compliance
	profile:Reconcile() -- Fill in missing variables from ProfileTemplate (optional)
	profile:ListenToRelease(function()
		Manager.Profiles[player] = nil	
		--ProfileStore:WipeProfileAsync("Player_"..player.UserId)
		player:Kick(KickMessage)
	end)
	if player:IsDescendantOf(Players) == true then
		Manager.Profiles[player] = profile
		CreateInventoryData(profile.Data)
		warn("Data loaded", profile.Data)
		DataLoaded:Fire(player)
		SendData:FireClient(player, profile.Data)
	else
		profile:Release()
	end
end

-- In case Players have joined the server earlier than this script ran:
for _, player in ipairs(Players:GetPlayers()) do
	task.spawn(PlayerAdded, player)
end

----- Connections -----

Players.PlayerAdded:Connect(PlayerAdded)

Players.PlayerRemoving:Connect(function(Player)
	local profile = Manager.Profiles[Player]
	if profile ~= nil then
		profile:Release()
	end
end)