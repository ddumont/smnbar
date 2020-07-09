local actions = require 'actions';
local util = require 'util';
local mgr = AshitaCore:GetResourceManager();
local textures = {};

local buttons = {
  { texture = nil, ptr = nil, action = nil, name = 'carbuncle', commands = {
    { texture = nil, ptr = nil, action = nil, command = mgr:GetAbilityByName('assault', 0),         target = '<stnpc>',   ranks = 1 },
    { texture = nil, ptr = nil, action = nil, command = mgr:GetAbilityByName('retreat', 0),         target = '<me>',   ranks = 1 },
    { texture = nil, ptr = nil, action = nil, command = mgr:GetAbilityByName('release', 0),         target = '<me>',   ranks = 1 },
    { texture = nil, ptr = nil, action = nil, command = mgr:GetAbilityByName('poison nails', 0),    target = '<stnpc>',    ranks = 1 },
    { texture = nil, ptr = nil, action = nil, command = mgr:GetAbilityByName('meteorite', 0),       target = '<stnpc>',    ranks = 1 },
    { texture = nil, ptr = nil, action = nil, command = mgr:GetAbilityByName('healing ruby', 0),    target = '<stpc>', ranks = 2 },
    { texture = nil, ptr = nil, action = nil, command = mgr:GetAbilityByName('shining ruby', 0),    target = '<stpc>', ranks = 1 },
    { texture = nil, ptr = nil, action = nil, command = mgr:GetAbilityByName('glittering ruby', 0), target = '<stpc>', ranks = 1 },
  } },
  { texture = nil, ptr = nil, action = nil, name = 'titan' },
  { texture = nil, ptr = nil, action = nil, name = 'leviathan' },
  { texture = nil, ptr = nil, action = nil, name = 'garuda' },
  { texture = nil, ptr = nil, action = nil, name = 'ifrit' },
  { texture = nil, ptr = nil, action = nil, name = 'shiva' },
  { texture = nil, ptr = nil, action = nil, name = 'ramuh' },
  { texture = nil, ptr = nil, action = nil, name = 'fenrir' },
  { texture = nil, ptr = nil, action = nil, name = 'diabolos' },
  { texture = nil, ptr = nil, action = nil, name = 'cait sith' },
  { texture = nil, ptr = nil, action = nil, name = 'atomos' },
  { texture = nil, ptr = nil, action = nil, name = 'siren' },
};

local ctrl_buttons = {
  { texture = nil, ptr = nil, actions = nil, name = 'light spirit' },
  { texture = nil, ptr = nil, actions = nil, name = 'earth spirit' },
  { texture = nil, ptr = nil, actions = nil, name = 'water spirit' },
  { texture = nil, ptr = nil, actions = nil, name = 'wind spirit' },
  { texture = nil, ptr = nil, actions = nil, name = 'fire spirit' },
  { texture = nil, ptr = nil, actions = nil, name = 'ice spirit' },
  { texture = nil, ptr = nil, actions = nil, name = 'thunder spirit' },
  { texture = nil, ptr = nil, actions = nil, name = 'dark spirit' },
};

local pet_buttons = nil; -- updated on pet change

local function load_texture(name, size)
  local path = string.format('%s/' .. size .. '/%s.png', _addon.path, name);

  local res, texture = ashita.d3dx.CreateTextureFromFileA(path);
  if (res ~= 0) then
    -- Get the error information..
    local _, err = ashita.d3dx.GetErrorStringA(res);
    print(string.format('[Error] Failed to load background texture for slot: %s - Error: (%08X) %s', name, res, err));
    return nil;
  end
  return texture;
end

function textures:Load()
  for _, textures in ipairs({ buttons, ctrl_buttons }) do
    for _, texture in ipairs(textures) do
      texture.texture = load_texture(texture.name, 64);
      texture.ptr = texture.texture:Get();
      texture.action = actions:Get(texture.name);

      for _, command in ipairs(texture.commands or {}) do
        command.texture = load_texture(command.command.Name[2]:lower(), 48);
        if (command.texture ~= nil) then
          command.ptr = command.texture:Get();
        end
      end
    end
  end
end

function textures:Unload()
  for _, textures in ipairs({ buttons, ctrl_buttons }) do
    for _, texture in ipairs(textures) do
      texture.texture:Release();
      texture.texture = nil;
      texture.ptr = nil;
      texture.action = nil;

      for _, command in ipairs(texture.commands) do
        if (command.texture ~= nil) then
          command.texture:Release();
          command.texture = nil;
        end
        command.ptr = nil;
        command.action = nil;
      end
    end
  end
end

function textures:Buttons()
  return buttons;
end

function textures:CtrlButtons()
  return ctrl_buttons;
end

function textures:PetButtons()
  if (not util:HasPet()) then
    pet_buttons = nil;
    return pet_buttons;
  end

  local pet, lastpet = util:PetName();
  if (pet == lastpet) then return pet_buttons end

  pet_buttons = {};
  local commands = nil;
  for _, button in ipairs(buttons) do
    if (button.name == pet:lower()) then
      commands = button.commands;
      break;
    end
  end
  if (commands == nil) then
    for _, button in ipairs(ctrl_buttons) do
      if (button.name == pet:lower()) then
        commands = button.commands;
        break;
      end
    end
  end

  commands = commands or {};
  for i, command in ipairs(commands) do
    local action = actions:GetPetAction(command.command, command.ranks, command.target);
    if (action ~= nil) then
      command.action = action;
      table.insert(pet_buttons, command);
    end
  end
end

return textures;
