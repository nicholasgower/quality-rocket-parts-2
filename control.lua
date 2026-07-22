local quality_parts_count = {}

for quality_name,quality in pairs(prototypes.quality) do
	quality_parts_count[quality_name] = quality.level
end

local function on_crafted_function(event)
		event.entity.rocket_parts = event.entity.rocket_parts + quality_parts_count[event.recipe_quality]
	end

for _,recipe in pairs(prototypes.mod_data["Planetslib-planet-rocket-part-recipe"].data) do
	assert(prototypes.recipe[recipe].on_crafted_event,"Rocket part recipe ".. recipe .." lacks an on_crafted_event handler.")
	script.on_event(prototypes.recipe[recipe].on_crafted_event,on_crafted_function)
end