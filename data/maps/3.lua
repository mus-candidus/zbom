local map = ...
local game = map:get_game()

---------------------------------
-- Inside Zora/Septen/Subrosia --
---------------------------------

local function random_walk(npc)
  local m = sol.movement.create("random_path")
  m:set_speed(32)
  m:start(npc)
  npc:get_sprite():set_animation("walking")
end

function map:on_started()
  random_walk(npc_rito_4)

  -- Replace shop items if they're bought
  if game:get_value("i1823") >= 2 then --world map
    self:create_shop_treasure({
	name = "shop_shovel",
	layer = 0,
	x = 1392,
	y = 472,
	price = 100,
	dialog = "_item_description.shovel",
	treasure_name = "shovel",
	treasure_variant = 1
    })
  end
end

function npc_rito_4:on_interaction()
  if game:get_value("b1150") then
    game:start_dialog("rito_4.1.septen")
  else
    game:start_dialog("rito_4.0.septen")
  end
end

function npc_rito_5:on_interaction()
  if not game:get_value("b1150") then
    game:start_dialog("rito_5.0.septen")
  end
end

function npc_rito_trading:on_interaction()
  if game:get_value("b2032") then
    game:start_dialog("rito.0.trading", function(answer)
      if answer == 1 then
        -- give him the cookbook, get the feather
        game:start_dialog("rito.0.trading_yes", function()
          hero:start_treasure("trading", 13)
          game:set_value("b2033", true)
          game:set_value("b2032", false)
        end)
      else
        -- don't give him the cookbook
        game:start_dialog("rito.0.trading_no")
      end
    end)
  else
    game:start_dialog("rito.0.trading_hint")
  end
end

function npc_shopkeeper:on_interaction()
  game:start_dialog("shopkeep.0")
end

function shop_item_3:on_buying()
  if self:get_game():get_first_empty_bottle() == nil then
    game:start_dialog("shop.no_bottle")
    return false
  else
    hero:start_treasure("potion", 3)
    game:remove_money(200)
  end
end