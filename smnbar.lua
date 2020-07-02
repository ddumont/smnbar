_addon.author   = 'siete';
_addon.name     = 'smnbar';
_addon.version  = '0.1';

require 'common';
require 'd3d8';
local textures = require 'textures';

local FRAME_PADDING_W = 2;
local FRAME_PADDING_H = 2;
local ITEM_SPACING_W = 4;
local ITEM_SPACING_H = 0;
local BUTTON_BORDER = 1; -- can't seem to change this.

local DRAG_W = 15;
local BUTTON_W = 54;
local BUTTON_H = BUTTON_W;

local FRAME_FLAGS = bit.bor(
  ImGuiWindowFlags_NoTitleBar,
  ImGuiWindowFlags_NoResize,
  ImGuiWindowFlags_NoScrollbar,
  ImGuiWindowFlags_NoScrollWithMouse,
  ImGuiWindowFlags_ShowBorders,
  ImGuiWindowFlags_NoFocusOnAppearing
);

ashita.register_event('load', function()
  textures:Load();
end);

local ctrl = false;

ashita.register_event('render', function()
  local buttons;
  if (ctrl) then
    buttons = textures:CtrlButtons();
  else
    buttons = textures:Buttons();
  end
  local BUTTONS = #buttons;
  local BETWEEN_BUTTONS = (BUTTONS - 1) * (ITEM_SPACING_W + BUTTON_BORDER);
  local BUTTONBAR_W = (BUTTON_W + FRAME_PADDING_W * 2) * BUTTONS + BETWEEN_BUTTONS;
  local BUTTONBAR_H = BUTTON_H + FRAME_PADDING_H * 2 + FRAME_PADDING_H * 2 + FRAME_PADDING_H * 2;
  local FRAME_W = DRAG_W + BUTTONBAR_W + FRAME_PADDING_W * 2 + FRAME_PADDING_W * 2;
  local FRAME_H = BUTTONBAR_H + FRAME_PADDING_H * 2 + FRAME_PADDING_H * 2;

  imgui.PushStyleVar(ImGuiStyleVar_FramePadding, FRAME_PADDING_W, FRAME_PADDING_H);
  imgui.SetNextWindowSize(FRAME_W, FRAME_H, ImGuiSetCond_Always);
  if (not imgui.Begin('smnbar', true, FRAME_FLAGS)) then return imgui.End() end
  imgui.Indent(DRAG_W);
  imgui.BeginChild('buttonbar', nil, BUTTONBAR_H, true);
  imgui.PushStyleVar(ImGuiStyleVar_ItemSpacing, ITEM_SPACING_W, ITEM_SPACING_H);
  for i = 1, BUTTONS do
    if (i > 1) then imgui.SameLine(); end
    if (imgui.ImageButton(buttons[i].ptr, BUTTON_W, BUTTON_H)) then

    end
  end
  imgui.PopStyleVar();
  imgui.EndChild();
  imgui.Unindent(DRAG_W);
  imgui.End();
  imgui.PopStyleVar();
end);

ashita.register_event('key', function(key, down, blocked)
  if (key == 0x1D or key == 0x9D) then -- ctrl
    if (down) then
      ctrl = true;
    else
      ctrl = false;
    end
  end
  return false;
end);

ashita.register_event('unload', function()
  textures:Unload();
end);
