local priv = minetest.settings:get("ts_police.priv") or "ban"

local function is_allowed(player, pos)
	local name = player:get_player_name()
	if minetest.check_player_privs(name, priv) then
		return true
	end
	if minetest.is_protected(pos) and not minetest.is_protected(pos, name) then
		return true
	end
	minetest.chat_send_player(name, "This is a restricted item. You may only use it on your private property.")
end

ts_skins.register_clothing("jacket_police", {
	type = "jacket",
	description = "Server Police Jacket",
	skin = "ts_police_jacket.png",
	inventory_image = "ts_police_jacket_inv.png",
	recipe = {
		{ "wool:blue", "", "wool:blue" },
		{ "wool:blue", "default:gold_ingot", "wool:blue" },
		{ "wool:blue", "wool:blue", "wool:blue" },
	}
})

ts_skins.register_clothing("cap_police", {
	type = "hat",
	description = "Server Police Cap",
	skin = "ts_police_cap.png",
	inventory_image = "ts_police_cap_inv.png",
	recipe = {
		{ "wool:white", "wool:white", "wool:white" },
		{ "wool:blue", "default:gold_ingot", "wool:blue" },
	}
})

ts_skins.register_clothing("trousers_police", {
	type = "trousers",
	description = "Server Police Trousers",
	skin = "ts_police_trousers.png",
	inventory_image = "ts_police_trousers_inv.png",
	recipe = {
		{ "wool:dark_grey", "wool:dark_grey", "wool:dark_grey" },
		{ "wool:yellow", "", "wool:dark_grey" },
		{ "wool:dark_grey", "", "wool:dark_grey" },
	}
})

armor:register_armor("ts_police:shield", {
	description = "Server Police Shield",
	inventory_image = "ts_police_shield_inv.png",
	groups = {armor_shield=1, armor_heal=12, armor_use=200},
	armor_groups = {fleshy=15},
	damage_groups = {cracky=2, snappy=1, choppy=1, level=3},
	reciprocate_damage = true,
})

armor:register_armor("ts_police:helmet", {
	description = "Server Police Helmet",
	inventory_image = "ts_police_helmet_inv.png",
	groups = {armor_head=1, armor_heal=12, armor_use=200},
	armor_groups = {fleshy=15},
	damage_groups = {cracky=2, snappy=1, choppy=1, level=3},
})

armor:register_armor("ts_police:chestplate", {
	description = "Server Police Chestplate",
	inventory_image = "3d_armor_inv_chestplate_steel.png^[multiply:#444444",
	texture = "(3d_armor_chestplate_steel.png^[multiply:#444444)^3d_armor_trans.png",
	preview = "(3d_armor_chestplate_steel_preview.png^[multiply:#444444)^3d_armor_trans.png",
	groups = {armor_torso=1, armor_heal=12, armor_use=200},
	armor_groups = {fleshy=20},
	damage_groups = {cracky=2, snappy=1, choppy=1, level=3},
})

armor:register_armor("ts_police:leggings", {
	description = "Server Police Leggings",
	inventory_image = "3d_armor_inv_leggings_steel.png^[multiply:#444444",
	texture = "(3d_armor_leggings_steel.png^[multiply:#444444)^3d_armor_trans.png",
	preview = "(3d_armor_leggings_steel_preview.png^[multiply:#444444)^3d_armor_trans.png",
	groups = {armor_legs=1, armor_heal=12, armor_use=200},
	armor_groups = {fleshy=20},
	damage_groups = {cracky=2, snappy=1, choppy=1, level=3},
})

armor:register_armor("ts_police:boots", {
	description = "Server Police Boots",
	inventory_image = "3d_armor_inv_boots_steel.png^[multiply:#444444",
	texture = "(3d_armor_boots_steel.png^[multiply:#444444)^3d_armor_trans.png",
	preview = "(3d_armor_boots_steel_preview.png^[multiply:#444444)^3d_armor_trans.png",
	groups = {armor_feet=1, armor_heal=12, armor_use=200},
	armor_groups = {fleshy=15},
	damage_groups = {cracky=2, snappy=1, choppy=1, level=3},
})

minetest.register_craft({
	output = "ts_police:shield",
	recipe = {
		{ "techage:ta4_carbon_fiber", "techage:ta4_carbon_fiber", "techage:ta4_carbon_fiber" },
		{ "techage:ta4_carbon_fiber", "default:obsidian_glass", "techage:ta4_carbon_fiber" },
		{ "", "techage:ta4_carbon_fiber", "" },
	},
})

minetest.register_craft({
	output = "ts_police:helmet",
	recipe = {
		{ "techage:ta4_carbon_fiber", "techage:ta4_carbon_fiber", "techage:ta4_carbon_fiber" },
		{ "techage:ta4_carbon_fiber", "", "techage:ta4_carbon_fiber" },
	},
})

minetest.register_craft({
	output = "ts_police:chestplate",
	recipe = {
		{ "techage:ta4_carbon_fiber", "", "techage:ta4_carbon_fiber" },
		{ "techage:ta4_carbon_fiber", "techage:ta4_carbon_fiber", "techage:ta4_carbon_fiber" },
		{ "techage:ta4_carbon_fiber", "techage:ta4_carbon_fiber", "techage:ta4_carbon_fiber" },
	},
})

minetest.register_craft({
	output = "ts_police:leggings",
	recipe = {
		{ "techage:ta4_carbon_fiber", "techage:ta4_carbon_fiber", "techage:ta4_carbon_fiber" },
		{ "techage:ta4_carbon_fiber", "", "techage:ta4_carbon_fiber" },
		{ "techage:ta4_carbon_fiber", "", "techage:ta4_carbon_fiber" },
	},
})

minetest.register_craft({
	output = "ts_police:boots",
	recipe = {
		{ "techage:ta4_carbon_fiber", "", "techage:ta4_carbon_fiber" },
		{ "techage:ta4_carbon_fiber", "", "techage:ta4_carbon_fiber" },
	},
})

local function truncheon (itemstack, user, pointed_thing, damage)
	if not is_allowed(user, user:get_pos()) then
		return
	end
	if pointed_thing.type == "object" then
		local player = pointed_thing.ref
		if player and player:is_player() and player ~= user then
			local p1 = vector.add(user:get_pos(), user:get_eye_offset())
			p1.y = p1.y + user:get_properties().eye_height
			local p2 = vector.add(player:get_pos(), player:get_eye_offset())
			p2.y = p2.y + player:get_properties().eye_height
			local dist = vector.distance(p1, p2)
			local mult = 15 / math.max(dist, 1)
			local dir = vector.direction(p1, p2)
			player:add_player_velocity(vector.multiply(dir, mult))
			if damage then
				player:set_hp(player:get_hp() - 5)
			end
		end
	end
	itemstack:add_wear(100)
	return itemstack
end

minetest.register_tool("ts_police:truncheon", {
	description = "Truncheon (left click to hit and right click to push back)",
	inventory_image = "ts_police_truncheon.png",
	wield_image = "ts_police_truncheon.png",
	on_use = function (itemstack, user, pointed_thing, damage)
		return truncheon(itemstack, user, pointed_thing, true)
	end,
	on_secondary_use = function (itemstack, user, pointed_thing, damage)
		return truncheon(itemstack, user, pointed_thing, false)
	end,
	groups = { wieldview_transform = 7 },
})

minetest.register_tool("ts_police:pepperspray", {
	description = "Pepper Spray",
	inventory_image = "ts_police_pepperspray.png",
	wield_image = "ts_police_pepperspray.png",
	on_use = function(itemstack, user, pointed_thing)
		if not is_allowed(user, user:get_pos()) then
			return
		end
		if pointed_thing.type == "object" then
			local player = pointed_thing.ref
			if player and player:is_player() and player ~= user then
				local p1 = vector.add(user:get_pos(), user:get_eye_offset())
				p1.y = p1.y + user:get_properties().eye_height
				local p2 = vector.add(player:get_pos(), player:get_eye_offset())
				p2.y = p2.y + player:get_properties().eye_height
				local dist = vector.distance(p1, p2)
				local mult = 20 / math.max(math.sqrt(dist), 1)
				local dir = vector.direction(p1, p2)
				player:add_player_velocity(vector.multiply(dir, mult))
				player:set_hp(math.max(player:get_hp() - 1, 3))
			end
		end
		minetest.add_particlespawner({
			amount = 10,
			time = 0.1,
			minpos = {x=0.25, y=1.3, z=0.1},
			maxpos = {x=0.25, y=1.3, z=0.1},
			minvel = {x=-1, y=-0.3, z=2},
			maxvel = {x=0.5, y=0.3, z=5},
			minacc = {x=-0.5, y=-0.1, z=-0.1},
			maxacc = {x=0.5, y=0.1, z=0.1},
			minexptime = 0.4,
			maxexptime = 0.5,
			minsize = 0.2,
			maxsize = 0.8,
			collisiondetection = true,
			collision_removal = true,
			object_collision = false,
			attached = user,
			texture = "tnt_smoke.png",
		})
		itemstack:add_wear(3000)
		return itemstack
	end
})

minetest.register_craft({
	output = "ts_police:pepperspray",
	recipe = {
		{ "basic_materials:plastic_sheet", "basic_materials:plastic_sheet", "basic_materials:plastic_sheet" },
		{ "basic_materials:plastic_sheet", "farming:pepper_ground", "basic_materials:plastic_sheet" },
		{ "basic_materials:plastic_sheet", "basic_materials:plastic_sheet", "basic_materials:plastic_sheet" },
	},
	replacements = {{"farming:pepper_ground", "vessels:glass_bottle"}},
})

local craft_function = function(itemstack, player, old_craft_grid, craft_inv)
	local itemname = itemstack:get_name()
	if itemname == "ts_skins:clothing_jacket_police"
		or itemname == "ts_skins:clothing_cap_police"
		or itemname == "ts_skins:clothing_trousers_police"
		or itemname == "ts_police:shield"
		or itemname == "ts_police:helmet"
		or itemname == "ts_police:chestplate"
		or itemname == "ts_police:leggings"
		or itemname == "ts_police:boots"
	then
		local playername = player:get_player_name()
		if not minetest.check_player_privs(playername, priv) then
			minetest.chat_send_player(playername, minetest.colorize("#ff8800", "Only Server Police Staff can craft this item."))
			return ItemStack()
		end
	end
	return itemstack
end

minetest.register_on_craft(craft_function)
minetest.register_craft_predict(craft_function)