
invisibility = {}

minetest.register_privilege('stealth', "Allows you to disappear completely")

-- reset player invisibility if they go offline
minetest.register_on_leaveplayer(function(player)

	local name = player:get_player_name()

	if invisibility[name] then
		invisibility[name] = nil
	end
end)


-- invisibility function

invisible = function(player, toggle)

	if not player then return false end

	local name = player:get_player_name()

	invisibility[name] = toggle

	local prop

	if toggle == true then

		-- hide player and name tag
		prop = {
			visual_size = {x = 0, y = 0},
			collisionbox = {0, 0, 0, 0, 0, 0}
		}

		player:set_nametag_attributes({
			color = {a = 0, r = 255, g = 255, b = 255}
		})
	else
		-- show player and tag
		prop = {
			visual_size = {x = 1, y = 1},
			collisionbox = {-0.3, 0.0, -0.3, 0.3, 1.7, 0.3}
		}

		player:set_nametag_attributes({
			color = {a = 255, r = 255, g = 255, b = 255}
		})
	end

	player:set_properties(prop)

end

-- vanish command (admin only)

minetest.register_chatcommand("vanish", {
	params = "<name>",
	description = "Make player invisible",
	privs = {stealth = true},

	func = function(name, param)

		-- player online
		if param ~= ""
		and minetest.get_player_by_name(param) then

			name = param

		-- player not online
		elseif param ~= "" then

			return false, "Player " .. param .. " is not online!"
		end

		local player = minetest.get_player_by_name(name)

		-- hide / show player
		if invisibility[name] then

			invisible(player, nil)
		else
			invisible(player, true)
		end

	end
})

-- Log
if minetest.settings:get_bool("log_mods") then
minetest.log("action", "[MOD] Invisibility loaded")
end		
