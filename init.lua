castle = {}

-- Boilerplate to support localized strings if intllib mod is installed.
local S
if minetest.get_modpath("intllib") then
	S = intllib.Getter()
else
	S = function(s,a,...)
	if a==nil then 
		return s 
		end 
		a={a,...}
		return s:gsub("(@?)@(%(?)(%d+)(%)?)",
			function(e,o,n,c)
				if e==""then 
					return a[tonumber(n)]..(o==""and c or"")
					else 
						return"@"..o..n..c 
					end 
					end)
	end
end

castle.intllib = S

dofile(minetest.get_modpath("castle").."/pillars.lua")
dofile(minetest.get_modpath("castle").."/arrowslit.lua")
dofile(minetest.get_modpath("castle").."/tapestry.lua")
dofile(minetest.get_modpath("castle").."/jailbars.lua")
dofile(minetest.get_modpath("castle").."/town_item.lua")
dofile(minetest.get_modpath("castle").."/shields_decor.lua")
dofile(minetest.get_modpath("castle").."/murder_hole.lua")
dofile(minetest.get_modpath("castle").."/orbs.lua")
dofile(minetest.get_modpath("castle").."/rope.lua")

minetest.register_node("castle:stonewall", {
	description = S("Castle Wall"),
	tiles = {"castle_stonewall.png"},
	groups = {cracky=3},
	sounds = default.node_sound_stone_defaults(),
	
})

minetest.register_node("castle:rubble", {
	description = S("Castle Rubble"),
	tiles = {"castle_rubble.png"},
	groups = {crumbly=3,falling_node=1},
	sounds = default.node_sound_dirt_defaults({
		footstep = {name="default_gravel_footstep", gain=0.5},
		dug = {name="default_gravel_footstep", gain=1.0},
	}),
})

minetest.register_craft({
	output = "castle:stonewall",
	recipe = {
		{"default:cobble"},
		{"default:desert_stone"},
	}
})

minetest.register_craft({
	output = "castle:rubble",
	recipe = {
		{"castle:stonewall"},
	}
})

minetest.register_craft({
	output = "castle:rubble 2",
	recipe = {
		{"default:gravel"},
		{"default:desert_stone"},
	}
})

minetest.register_node("castle:stonewall_corner", {
	paramtype2 = "facedir",
	description = S("Castle Corner"),
	tiles = {"castle_stonewall.png", 
	                  "castle_stonewall.png",
			"castle_corner_stonewall1.png", 
			"castle_stonewall.png", 
			"castle_stonewall.png", 
			"castle_corner_stonewall2.png"},
	groups = {cracky=3},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_craft({
	output = "castle:stonewall_corner",
	recipe = {
		{"", "castle:stonewall"},
		{"castle:stonewall", "default:sandstone"},
	}
})

minetest.register_node("castle:roofslate", {
	drawtype = "raillike",
	description = S("Roof Slates"),
	inventory_image = "castle_slate.png",
	wield_image = "castle_slate.png",
	paramtype = "light",
	walkable = false,
	tiles = {'castle_slate.png'},
	climbable = true,
	selection_box = {
		type = "fixed",
                fixed = {-1/2, -1/2, -1/2, 1/2, -1/2+1/16, 1/2},
	},
	groups = {cracky=3,attached_node=1},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("castle:hides", {
	drawtype = "signlike",
	description = S("Hides"),
	inventory_image = "castle_hide.png",
	wield_image = "castle_hide.png",
	paramtype = "light",
	walkable = false,
	tiles = {'castle_hide.png'},
	paramtype2 = "wallmounted",
	legacy_wallmounted = true,
	groups = {dig_immediate=2},
	selection_box = {
		type = "wallmounted",
	},
	sounds = default.node_sound_defaults(),
})


minetest.register_craft({
	output = "castle:hides",
	recipe = {
		{"wool:white"},
		{"bucket:bucket_water"},
	}
})


minetest.register_craft( {
         type = "shapeless",
         output = "castle:hides 6",
         recipe = { "wool:white" , "bucket:bucket_water" },
         replacements = {
             { 'bucket:bucket_water', 'bucket:bucket_empty' }
         }
} )

local mod_building_blocks = minetest.get_modpath("building_blocks") 
local mod_streets = minetest.get_modpath("streets") or minetest.get_modpath("asphalt")

if mod_building_blocks then
	minetest.register_craft( {
         output = "castle:roofslate 4",
         recipe = { 
			{ "building_blocks:Tar" , "default:gravel" },
			{ "default:gravel",       "building_blocks:Tar" }
		}
	})

	minetest.register_craft( {
         output = "castle:roofslate 4",
         recipe = { 
			{ "default:gravel",       "building_blocks:Tar" },
			{ "building_blocks:Tar" , "default:gravel" }
		}
	})
end

if mod_streets then
		minetest.register_craft( {
         output = "castle:roofslate 4",
         recipe = { 
			{ "streets:asphalt" , "default:gravel" },
			{ "default:gravel",   "streets:asphalt" }
		}
	})

	minetest.register_craft( {
         output = "castle:roofslate 4",
         recipe = { 
			{ "default:gravel",   "streets:asphalt" },
			{ "streets:asphalt" , "default:gravel" }
		}
	})
end

if not (mod_building_blocks or mod_streets) then
	minetest.register_craft({
		type = "cooking",
		output = "castle:roofslate",
		recipe = "default:gravel",
	})

end

stairs.register_stair_and_slab("stonewall", "castle:stonewall",
		{cracky=3},
		{"castle_stonewall.png"},
		S("Castle Wall Stair"),
		S("Castle Wall Slab"),
		default.node_sound_stone_defaults())

minetest.register_craft({
	output = "stairs:stair_stonewall 4",
	recipe = {
		{"castle:stonewall","",""},
		{"castle:stonewall","castle:stonewall",""},
		{"castle:stonewall","castle:stonewall","castle:stonewall"},
	}
})

minetest.register_craft({
	output = "stairs:stair_stonewall 4",
	recipe = {
		{"","","castle:stonewall"},
		{"","castle:stonewall","castle:stonewall"},
		{"castle:stonewall","castle:stonewall","castle:stonewall"},
	}
})

minetest.register_craft({
	output = "stairs:slab_stonewall 6",
	recipe = {
		{"castle:stonewall","castle:stonewall","castle:stonewall"},
	}
})

doors.register_door("castle:oak_door", {
	description = S("Oak Door"),
	inventory_image = "castle_oak_door_inv.png",
	groups = {choppy=2,door=1},
	tiles_bottom = {"castle_oak_door_bottom.png", "door_oak.png"},
	tiles_top = {"castle_oak_door_top.png", "door_oak.png"},
	only_placer_can_open = true,
	sounds = default.node_sound_wood_defaults(),
	sunlight = false,
})

doors.register_door("castle:jail_door", {
	description = S("Jail Door"),
	inventory_image = "castle_jail_door_inv.png",
	groups = {cracky=2,door=1},
	tiles_bottom = {"castle_jail_door_bottom.png", "door_jail.png"},
	tiles_top = {"castle_jail_door_top.png", "door_jail.png"},
	only_placer_can_open = true,
	sounds = default.node_sound_wood_defaults(),
	sunlight = true,
})

minetest.register_craft({
	output = "castle:oak_door",
	recipe = {
		{"default:tree", "default:tree"},
		{"default:tree", "default:tree"},
		{"default:tree", "default:tree"}
	}
})

minetest.register_craft({
	output = "castle:jail_door",
	recipe = {
		{"castle:jailbars", "castle:jailbars"},
		{"castle:jailbars", "castle:jailbars"},
		{"castle:jailbars", "castle:jailbars"}
	}
})

function default.get_ironbound_chest_formspec(pos)
	local spos = pos.x .. "," .. pos.y .. "," ..pos.z
	local formspec =
		"size[8,9]"..
		"list[nodemeta:".. spos .. ";main;0,0;8,4;]"..
		"list[current_player;main;0,5;8,4;]"
	return formspec
end

local function has_ironbound_chest_privilege(meta, player)
	if player:get_player_name() ~= meta:get_string("owner") then
		return false
	end
	return true
end

minetest.register_node("castle:ironbound_chest",{
	drawtype = "nodebox",
	description = S("Ironbound Chest"),
	tiles = {"castle_ironbound_chest_top.png",
	                  "castle_ironbound_chest_top.png",
			"castle_ironbound_chest_side.png",
			"castle_ironbound_chest_side.png",
			"castle_ironbound_chest_back.png",
			"castle_ironbound_chest_front.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {cracky=2},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.500000,-0.500000,-0.312500,0.500000,-0.062500,0.312500},
			{-0.500000,-0.062500,-0.250000,0.500000,0.000000,0.250000}, 
			{-0.500000,0.000000,-0.187500,0.500000,0.062500,0.187500},
			{-0.500000,0.062500,-0.062500,0.500000,0.125000,0.062500}, 
		},
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.5,-0.500000,-0.400000,0.5,0.200000,0.4},

		},		
	},
	sounds = default.node_sound_wood_defaults(),
	after_place_node = function(pos, placer)
		local meta = minetest.get_meta(pos)
		meta:set_string("owner", placer:get_player_name() or "")
		meta:set_string("infotext", S("Ironbound Chest (owned by @1)",
			meta:get_string("owner")))
	end,
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("infotext", S("Ironbound Chest"))
		meta:set_string("owner", "")
		local inv = meta:get_inventory()
		inv:set_size("main", 8*4)
	end,
	can_dig = function(pos,player)
		local meta = minetest.get_meta(pos);
		local inv = meta:get_inventory()
		return inv:is_empty("main") and has_ironbound_chest_privilege(meta, player)
	end,
	allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		local meta = minetest.get_meta(pos)
		if not has_ironbound_chest_privilege(meta, player) then
			minetest.log("action", S("@1 tried to access a locked chest belonging to @2 at @3",
					player:get_player_name(), meta:get_string("owner"), minetest.pos_to_string(pos)))
			return 0
		end
		return count
	end,
    allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		local meta = minetest.get_meta(pos)
		if not has_ironbound_chest_privilege(meta, player) then
			minetest.log("action", S("@1 tried to access a locked chest belonging to @2 at @3",
					player:get_player_name(), meta:get_string("owner"), minetest.pos_to_string(pos)))
			return 0
		end
		return stack:get_count()
	end,
    allow_metadata_inventory_take = function(pos, listname, index, stack, player)
		local meta = minetest.get_meta(pos)
		if not has_ironbound_chest_privilege(meta, player) then
			minetest.log("action", S("@1 tried to access a locked chest belonging to @2 at @3",
					player:get_player_name(), meta:get_string("owner"), minetest.pos_to_string(pos)))
			return 0
		end
		return stack:get_count()
	end,
	on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		minetest.log("action", S("@1 moves stuff in locked chest at @2",
			player:get_player_name(), minetest.pos_to_string(pos)))
	end,
    on_metadata_inventory_put = function(pos, listname, index, stack, player)
		minetest.log("action", S("@1 moves stuff to locked chest at @2",
			player:get_player_name(), minetest.pos_to_string(pos)))
	end,
    on_metadata_inventory_take = function(pos, listname, index, stack, player)
		minetest.log("action", S("@1 takes stuff from locked chest at @2",
			player:get_player_name(), minetest.pos_to_string(pos)))
	end,
	on_rightclick = function(pos, node, clicker)
		local meta = minetest.get_meta(pos)
		if has_ironbound_chest_privilege(meta, clicker) then
			minetest.show_formspec(
				clicker:get_player_name(),
				"castle:ironbound_chest",
				default.get_ironbound_chest_formspec(pos)
			)
		end
	end,
})

minetest.register_craft({
	output = "castle:ironbound_chest",
	recipe = {
		{"default:wood", "default:steel_ingot","default:wood"},
		{"default:wood", "default:steel_ingot","default:wood"}
	}
})

minetest.register_tool("castle:battleaxe", {
	description = S("Battleaxe"),
	inventory_image = "castle_battleaxe.png",
	tool_capabilities = {
		full_punch_interval = 2.0,
		max_drop_level=1,
		groupcaps={
			choppy={times={[1]=2.10, [2]=0.90, [3]=0.50}, uses=20, maxlevel=3},
			snappy={times={[1]=1.90, [2]=0.90, [3]=0.30}, uses=20, maxlevel=3},
		},
		damage_groups = {fleshy=7},
	},
})
minetest.register_craft({
	output = "castle:battleaxe",
	recipe = {
		{"default:steel_ingot", "default:steel_ingot","default:steel_ingot"},
		{"default:steel_ingot", "default:stick","default:steel_ingot"},
                  {"", "default:stick",""}
	}
})
