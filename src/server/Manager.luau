local module = {}
module.Profiles = {}

function module.GetProfile(player)
	if module.Profiles[player] then
		return module.Profiles[player]
	else
		local Loaded = module.WaitforProfileService(player)
		if Loaded then
			return module.Profiles[player]
		end
	end
end

function module.WaitforProfileService(player)
	local Attempts = 0
	while not module.Profiles[player] do
		task.wait(2)
		Attempts += 1
		if Attempts > 10 then
			print("Couldnt find Data", player) --//
			return false
		end
	end
	--print(module.Profiles[player].Data)
	return true
end

return module