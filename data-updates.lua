local silo = data.raw["rocket-silo"]["rocket-silo"]
silo.fixed_recipe = nil -- was "rocket-part"
silo.show_recipe_icon = nil -- was false

-- Removes the output slot shown in rocket silos
local recipe = data.raw["recipe"]["rocket-part"]
if recipe.results == nil or #recipe.results ~= 1 or recipe.results[1].type ~= "item" or recipe.results[1].name ~= "rocket-part" then
	-- Making the following code compatible in the general case will be hard, so I haven't bothered
	error("Someone has change the results of the rocket-part recipe! This mod needs to be modified to be compatible") end
recipe.results = {} -- was {{type="item", name="rocket-part", amount=1}}

-- Usually, some fields are copied from the main product (i.e. the rocket-part)
-- but as the above will remove all the products, I need to set these fields manually
local item = data.raw["item"]["rocket-part"]
if not recipe.icons and not recipe.icon then -- just in case a mod has manually specified these
	recipe.icons = item.icons -- nil in vanilla, but just in case
	recipe.icon = item.icon end -- "__base__/graphics/icons/rocket-part.png"
recipe.localised_name = recipe.localised_name or item.localised_name or {"item-name.rocket-part"} -- in vanilla, these are all nil, so use the default value
recipe.order = recipe.order or item.order -- "d[item]-o[infinity-pipe]" in vanilla
recipe.subgroup = recipe.subgroup or item.subgroup -- "other" in vanilla