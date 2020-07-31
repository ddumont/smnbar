_addon.author   = 'Yarbles - Asura';
_addon.name     = 'smnbar';
_addon.version  = '2.0.0';

require 'common';
local ui = require 'ui';
local textures = require 'textures';

ashita.register_event('load', function()
  ui:Load();
end);

local ctrlDown = false;
local altDown = false;
local shiftDown = false;
local winDown = false;
local keyDown = nil;

ashita.register_event('render', function()
  ui:MainBar(ctrlDown, altDown, shiftDown, winDown, keyDown);
  ui:PetBar(ctrlDown, altDown, shiftDown, winDown, keyDown);
  ui:JaBar(ctrlDown, altDown, shiftDown, winDown, keyDown);
end);

ashita.register_event('key', function(key, down, blocked)
  if (AshitaCore:GetChatManager():IsInputOpen()) then return false end;

  if (key == 0x1D or key == 0x9D) then -- ctrl
    ctrlDown = down;
  elseif (key == 0x38 or key == 0xB8) then -- alt
    altDown = down;
  elseif (key == 0x2A or key == 0x36) then -- shift
    shiftDown = down;
  elseif (key == 0xDB or key == 0xDC) then -- windows
    winDown = down;
  elseif (key == 0x29) then -- backtick
    keyDown = down and 1 or nil;
  elseif (key > 0x01 and key < 0x0E) then -- 1,2,3,4,5,6,7,8,9,0,-,=
    keyDown = down and key or nil;
  end

  if (not down and not shiftDown and not altDown and not ctrlDown and not winDown) then -- no modifiers
    local buttons = textures:PetButtons();
    if (not buttons) then return false end;
    if (key == 0x29) then -- backtick
      buttons[1].action();
    elseif (key > 0x01 and key < 0x0E and buttons[key] ~= nil) then -- 1,2,3,4,5,6,7,8,9,0,-,=
      -- It just so happens to line up.
      buttons[key].action();
    end
  elseif (not down and not shiftDown and not altDown and not ctrlDown and winDown) then -- win modifier
    local buttons = textures:JaButtons();
    if (key == 0x29) then -- backtick
      buttons[1].action();
    elseif (key > 0x01 and key < 0x0E and buttons[key] ~= nil) then -- 1,2,3,4,5,6,7,8,9,0,-,=
      -- It just so happens to line up.
      buttons[key].action();
    end
  end

  return false;
end);

ashita.register_event('unload', function()
  ui:Unload();
end);
