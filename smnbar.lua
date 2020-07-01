_addon.author   = 'siete';
_addon.name     = 'smnbar';
_addon.version  = '0.1';

require 'common';
require 'd3d8';
local textures = require 'textures';

local FRAME_PADDING_W = 2;
local FRAME_PADDING_H = 2;
local ITEM_SPACING_W = 2;
local ITEM_SPACING_H = 2;
local ITEM_INNER_SPACING_W = 2;
local ITEM_INNER_SPACING_H = 2;

local BUTTONS = #textures:buttons();
local DRAG_W = 15;
local BUTTON_W = 64;
local BUTTON_H = BUTTON_W;
local BUTTONBAR_W = (BUTTON_W + ITEM_SPACING_W * 2) * BUTTONS; -- 2 layers of padding in the buttons
local BUTTONBAR_H = BUTTON_H + ITEM_SPACING_H * 2 + FRAME_PADDING_H * 2; -- 2 layers of padding in the buttons
local FRAME_W = DRAG_W + BUTTONBAR_W + FRAME_PADDING_W * 2;
local FRAME_H = BUTTONBAR_H + FRAME_PADDING_H * 2;

local FRAME_FLAGS = bit.bor(
  ImGuiWindowFlags_NoTitleBar,
  ImGuiWindowFlags_NoResize,
  ImGuiWindowFlags_NoScrollbar,
  ImGuiWindowFlags_NoScrollWithMouse,
  ImGuiWindowFlags_ShowBorders,
  ImGuiWindowFlags_NoFocusOnAppearing
);

ashita.register_event('load', function()
  textures:load();
end);

ashita.register_event('render', function()
  local buttons = textures:buttons();
  imgui.PushStyleVar(ImGuiStyleVar_FramePadding, FRAME_PADDING_W, FRAME_PADDING_H);
  imgui.PushStyleVar(ImGuiStyleVar_ItemSpacing, ITEM_SPACING_W, ITEM_SPACING_H);
  imgui.PushStyleVar(ImGuiStyleVar_ItemInnerSpacing, ITEM_INNER_SPACING_W, ITEM_INNER_SPACING_H);
  imgui.SetNextWindowSize(FRAME_W, FRAME_H, ImGuiSetCond_Always);
  if (not imgui.Begin('smnbar', true, FRAME_FLAGS)) then return imgui.End() end
  imgui.BeginChild('buttonbar', nil, BUTTONBAR_H, true);
  imgui.Indent(DRAG_W);
  for i = 1, BUTTONS do
    if (i > 1) then imgui.SameLine(); end
    if (imgui.ImageButton(buttons[i].ptr, BUTTON_W, BUTTON_H)) then

    end
  end
  imgui.EndChild();
  imgui.Unindent(DRAG_W);
  imgui.End();
  imgui.PopStyleVar(3);
end);

ashita.register_event('unload', function()
  textures:unload();
end);
