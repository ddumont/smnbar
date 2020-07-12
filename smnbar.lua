_addon.author   = 'Yarbles - Asura';
_addon.name     = 'smnbar';
_addon.version  = '1.1.1';

require 'common';
local ui = require 'ui';

ashita.register_event('load', function()
  ui:Load();
end);

local ctrlDown = false;

ashita.register_event('render', function()
  ui:MainBar(ctrlDown);
  ui:PetBar(ctrlDown);
end);

ashita.register_event('key', function(key, down, blocked)
  if (key == 0x1D or key == 0x9D) then -- ctrl
    if (down) then
      ctrlDown = true;
    else
      ctrlDown = false;
    end
  end
  return false;
end);

ashita.register_event('unload', function()
  ui:Unload();
end);
