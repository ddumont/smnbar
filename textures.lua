local actions = require 'actions';
local textures = {};

local buttons = {
  { texture = nil, actions = nil, name = 'carbuncle' },
  { texture = nil, actions = nil, name = 'titan' },
  { texture = nil, actions = nil, name = 'leviathan' },
  { texture = nil, actions = nil, name = 'garuda' },
  { texture = nil, actions = nil, name = 'ifrit' },
  { texture = nil, actions = nil, name = 'shiva' },
  { texture = nil, actions = nil, name = 'ramuh' },
  { texture = nil, actions = nil, name = 'fenrir' },
  { texture = nil, actions = nil, name = 'diabolos' },
  { texture = nil, actions = nil, name = 'cait sith' },
  { texture = nil, actions = nil, name = 'atomos' },
  { texture = nil, actions = nil, name = 'siren' },
};

local ctrl_buttons = {
  { texture = nil, actions = nil, name = 'light spirit' },
  { texture = nil, actions = nil, name = 'earth spirit' },
  { texture = nil, actions = nil, name = 'water spirit' },
  { texture = nil, actions = nil, name = 'wind spirit' },
  { texture = nil, actions = nil, name = 'fire spirit' },
  { texture = nil, actions = nil, name = 'ice spirit' },
  { texture = nil, actions = nil, name = 'thunder spirit' },
  { texture = nil, actions = nil, name = 'dark spirit' },
};

local function load_texture(name)
  local path = string.format('%s/64/%s.png', _addon.path, name);

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
    for i, texture in ipairs(textures) do
      texture.texture = load_texture(texture.name);
      texture.ptr = texture.texture:Get();
      texture.action = actions:Get(texture.name);
    end
  end
end

function textures:Unload()
  for _, textures in ipairs({ buttons, ctrl_buttons }) do
    for i, texture in ipairs(textures) do
      texture.texture:Release();
      texture.texture = nil;
      texture.ptr = nil;
      texture.action = nil;
    end
  end
end

function textures:Buttons()
  return buttons;
end

function textures:CtrlButtons()
  return ctrl_buttons;
end

return textures;
