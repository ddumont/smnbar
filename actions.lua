require 'timer';
local util = require 'util';
local mgr = AshitaCore:GetResourceManager();

local function do_summon(thing)
  local target = '<me>';
  if (thing:lower() == 'atomos') then
    target = '<t>'
  end
  AshitaCore:GetChatManager():QueueCommand('/ma "' .. thing .. '" ' .. target, -1);
end

local function summon(thing)
  local petEnt = util:PetEntity();
  if (petEnt ~= nil) then -- already has a pet, release first.
    if (petEnt.Name:lower() ~= thing:lower()) then
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

function actions:GetPetAction(action, ranks, target)
  local player = AshitaCore:GetDataManager():GetPlayer();
  local rank = 1;

  for rank = ranks, 1, -1 do
    local ability = nil;
    if (rank == 1) then
      ability = action;
    else
      ability = mgr:GetAbilityByName(action.Name[2] .. ' ' .. ('i'):rep(rank), 2);
    end
    if (player:HasAbility(ability.Id)) then
      return function()
        if (rank == 1) then
          AshitaCore:GetChatManager():QueueCommand('/pet "' .. action.Name[2] .. '" ' .. target, -1);
        else
          AshitaCore:GetChatManager():QueueCommand('/pet "' .. action.Name[2] .. ' ' .. ('i'):rep(rank) .. '" ' .. target, -1);
        end
        print(action.Description[2]);
      end
    end
  end
end

return actions;
