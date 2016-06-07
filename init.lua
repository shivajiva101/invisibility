
invisibility = {}

-- invisibility potion

minetest.register_node("invisibility:potion", {
	description = "Invisibility Potion",
	drawtype = "plantlike",
	tiles = {"invisibility_potion.png"},
	inventory_image = "invisibility_potion.png",
	wield_image = "invisibility_potion.png",
	paramtype = "light",
	stack_max = 1,
	is_ground_content = false,
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-0.25, -0.5, -0.25, 0.25, 0.3, 0.25}
	},
	groups = {vessel = 1, dig_immediate = 3, attached_node = 1},
	sounds = default.node_sound_glass_defaults(),

	on_use = function(itemstack, user)

		local pos = user:getpos()

		-- hide player
		invisible(user)

		minetest.sound_play("pop", {
			pos = pos,
			gain = 1.0,
			max_hear_distance = 5
		})

		-- show again 5 minutes later
		minetest.after(300, function()

			invisible(user)

			minetest.sound_play("pop", {
				pps = pos,
				gain = 1.0,
				max_hear_distance = 5
			})
		end)

		-- take item
		if not minetest.setting_getbool("creative_mode") then

			itemstack:take_item()

			return {name="vessels:glass_bottle"} -- itemstack
		end

	end,
})

minetest.register_craft( {
	output = "invisibility:potion",
	type = "shapeless",
	recipe = {"default:nyancat", "vessels:glass_bottle"},
})

-- invisibility function

invisible = function(player)

	if not player then return false end

	local name = player:get_player_name()

	invisibility[name] = not invisibility[name]

	local prop

	if invisibility[name] then

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
			collisionbox = {-0.35, -1, -0.35, 0.35, 1, 0.35}
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
	privs = {server = true},

	func = function(name, param)

		-- player online
		if param ~= ""
		and minetest.get_player_by_name(param) then

			name = param

		-- player not online
		elseif param ~= "" then

			return false, "Player " .. param .. " is not online!"
		end

		-- hide player entered (default to player using command if blank)
		invisible( minetest.get_player_by_name(name) )

	end
})
