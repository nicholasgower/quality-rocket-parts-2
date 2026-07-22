local ticks = settings.global["quality-rocket-parts-ticks"].value

-- Initilisation when a new game is started with this mod or when other settings have changed
for _, event_function in pairs{script.on_init, script.on_configuration_changed} do
	event_function(function()
		if ticks == 0 then
			storage.silos = nil -- We won't need this anymore
			return end

		storage.silos = {} -- foget any silos we previously recorded
		-- Record all the silos that have already been built
		for _, surface in pairs(game.surfaces) do
			for _, silo in pairs(surface.find_entities_filtered{name = "rocket-silo"}) do
				script.register_on_object_destroyed(silo)
				storage.silos[silo] = silo.rocket_parts end end end) end

if ticks > 0 then
	local event_filters = {{filter = "name", name = "rocket-silo"}}
	-- Listen for new silos being built (Important that we don't miss any!)
	for _, event_type in pairs{defines.events.on_built_entity, defines.events.on_robot_built_entity, defines.events.on_space_platform_built_entity} do
		script.on_event(event_type, function(event)
			storage.silos[event.entity] = 0 end, event_filters) end

	-- Listen for silos being destroyed (just saves some memory and processing time in on_nth_tick)
	for _, event_type in pairs{defines.events.on_entity_died, defines.events.on_player_mined_entity, defines.events.on_robot_mined_entity, defines.events.on_space_platform_mined_entity} do
		script.on_event(event_type, function(event)
			storage.silos[event.entity] = nil end, event_filters) end

	local science_pack = prototypes.item["automation-science-pack"]
	script.on_nth_tick(ticks, function(_)
		for silo, last_parts in pairs(storage.silos) do
			if not silo.valid then
				storage.silos[silo] = nil
				goto continue end
			local _, quality = silo.get_recipe()
			local diff = silo.rocket_parts - last_parts
			if diff < 0 then
				-- We're probably building a new rocket since last time we called update_silo
				-- So none rocket_parts hasn't been quality updated
				silo.rocket_parts = silo.rocket_parts*science_pack.get_durability(quality)
			else
				silo.rocket_parts = last_parts + diff*science_pack.get_durability(quality) end
			storage.silos[silo] = silo.rocket_parts
		::continue:: end end) end