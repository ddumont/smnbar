require 'timer';

local function do_summon(thing)
  local target = '<me>';
  if (thing:lower() == 'atomos') then
    target = '<t>'
  end
  AshitaCore:GetChatManager():QueueCommand('/ma "' .. thing .. '" ' .. target, -1);
end

local function summon(thing)
  local player = GetPlayerEntity();
  if (player == nil) then return nil; end
  local petidx = player.PetTargetIndex;
  if (petidx ~= 0) then -- already has a pet, release first.
    local pet = GetEntity(petidx);
    if (pet.Name:lower() ~= thing:lower()) then
      AshitaCore:GetChatManager():QueueCommand('/pet release <me>', -1);
      ashita.timer.once(2, function()
        do_summon(thing);
      end);
    end
  else
    do_summon(thing);
  end;
end

local actions = {};

function actions:Get(thing)
  return function()
    summon(thing);
  end;
end

return actions;
