local quality_parts_count = {}

for quality_name,quality in pairs(data.raw.quality) do
	quality_parts_count[quality_name] = quality.level + 1
end

local rocket_parts_to_process = {}
for planet_name,recipe_name in pairs(data.raw["mod-data"]["Planetslib-planet-rocket-part-recipe"].data) do
	PlanetsLib.rro.soft_insert(rocket_parts_to_process,recipe_name)
end

for planet_name,recipe_name in pairs(rocket_parts_to_process) do
	local recipe = data.raw["recipe"][recipe_name]
	if recipe then
		recipe.raise_on_crafted = true
	end
	if not recipe.custom_tooltip_fields then
		recipe.custom_tooltip_fields = {}
	end
	local tooltip = {
		name = {"tooltip.rocket-parts"},
		value = "1",
		quality_values = {
			
		}
	}
	for _,quality in pairs(data.raw["quality"]) do
		tooltip.quality_values[quality.name] = tostring(quality.level + 1) --Rare use of an unlocalised string
	end

	table.insert(recipe.custom_tooltip_fields,tooltip)
	
	
end


for planet,lock_silo in pairs(data.raw["mod-data"]["Planetslib-planet-lock-rocket-silos"].data) do
	data.raw["mod-data"]["Planetslib-planet-lock-rocket-silos"].data[planet] = false --Unlocks the rocket silo on all surfaces
	
end

