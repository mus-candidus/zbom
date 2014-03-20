local map = ...
local game = map:get_game()

----------------------------------------------------------------------
-- Outside World G14 (Ordon Village) - Obstacle Course and Overlook --
----------------------------------------------------------------------

if game:get_value("i1910")==nil then game:set_value("i1910", 0) end --Ordona

local function random_walk(npc)
  local m = sol.movement.create("random_path")
  m:set_speed(32)
  m:start(npc)
  npc:get_sprite():set_animation("walking")
end

local function are_all_torches_on()
 return torch_1 ~= nil 
    and torch_1:get_sprite():get_animation() == "lit"
    and torch_2:get_sprite():get_animation() == "lit"
    and torch_3:get_sprite():get_animation() == "lit"
    and torch_4:get_sprite():get_animation() == "lit"
    and torch_5:get_sprite():get_animation() == "lit"
    and game:get_value("i1028") == 3
end

local function end_race_lost()
  sol.audio.play_sound("wrong");
  game:set_value("i1028", 4);
  torch_1:get_sprite():set_animation("unlit")
  torch_2:get_sprite():set_animation("unlit")
  torch_3:get_sprite():set_animation("unlit")
  torch_4:get_sprite():set_animation("unlit")
  torch_5:get_sprite():set_animation("unlit")
end

local function end_race_won()
  sol.timer.stop_all(map)
  sol.audio.play_sound("secret")
  game:set_value("i1027", 3)
  game:set_value("i1028", 5)
  npc_tristan:get_sprite():set_direction(0)
  game:start_dialog("tristan.0.festival_won", game:get_player_name(), function()
    if game:get_value("i1027") < 4 then
      sol.timer.start(1000, function()
        hero:freeze()
        torch_overlay = sol.surface.create("entities/dark.png")
        game:start_dialog("ordona.0.festival", game:get_player_name(), function()
          torch_overlay:fade_out(50)
          hero:unfreeze()
          game:set_value("i1027", 4)
          game:set_value("i1910", game:get_value("i1910")+1)
        end)
      end)
    end
  end)
end

function map:on_started(destination)
  if game:get_value("i1028") >= 1 and game:get_value("i1028") <= 3 then
    race_timer = sol.timer.start(80000, end_race_lost);
    race_timer:set_with_sound(true)
  elseif game:get_value("i1027") == 4 then
    npc_tristan:remove()
  elseif game:get_value("i1027") >= 5 then
    random_walk(npc_tristan)
    torch_1:remove()
    torch_2:remove()
    torch_3:remove()
    torch_4:remove()
    torch_5:remove()
  end
end

function npc_tristan:on_interaction()
  if game:get_value("i1028") == 5 then
    if game:has_item("shield") then
      game:start_dialog("tristan.0.festival_shield", game:get_player_name())
    else
      game:start_dialog("tristan.0.festival_won", game:get_player_name())
    end
  elseif game:get_value("i1028") > 0 and game:get_value("i1028") < 4 then
    game:start_dialog("tristan.0.festival_underway")
  elseif game:get_value("i1028") == 0 then
    game:start_dialog("tristan.0.festival_rules")
  end
end

function map:on_update()
  if are_all_torches_on() then
    end_race_won()
  end
end

function game:on_map_changed(map)
  function map:on_draw(dst_surface)
    if map:get_id() == "12" and torch_overlay then
      local torch = map:get_entity("torch_5")
      local screen_width, screen_height = dst_surface:get_size()
      local cx, cy = map:get_camera_position()
      local tx, ty = torch:get_center_position()
      local x = 320 - tx + cx
      local y = 240 - ty + cy
      torch_overlay:draw_region(x, y, screen_width, screen_height, dst_surface)
    end
  end
end

function torch_1:on_interaction()
  map:get_game():start_dialog("torch.need_lamp")
end
function torch_1:on_interaction_item(lamp)
  torch_1:get_sprite():set_animation("lit")
end

function torch_2:on_interaction()
  map:get_game():start_dialog("torch.need_lamp")
end
function torch_2:on_interaction_item(lamp)
  torch_2:get_sprite():set_animation("lit")
end

function torch_3:on_interaction()
  map:get_game():start_dialog("torch.need_lamp")
end
function torch_3:on_interaction_item(lamp)
  torch_3:get_sprite():set_animation("lit")
end

function torch_4:on_interaction()
  map:get_game():start_dialog("torch.need_lamp")
end
function torch_4:on_interaction_item(lamp)
  torch_4:get_sprite():set_animation("lit")
end

function torch_5:on_interaction()
  map:get_game():start_dialog("torch.need_lamp")
end
function torch_5:on_interaction_item(lamp)
  torch_5:get_sprite():set_animation("lit")
end