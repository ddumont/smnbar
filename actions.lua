require 'timer';
local util = require 'util';
local petactions = require 'petactions';

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

function actions:GetPetActions()
  if (not util:HasPet()) then return end
  local mgr = AshitaCore:GetResourceManager();
  local player = AshitaCore:GetDataManager():GetPlayer();
  local pet = util:PetEntity().Name:lower();
  local pactions = petactions[pet];
  local npactions = #pactions;

  local actions = {};
  for i = 1, npactions do
    -- always use pactions[i] here to avoid pointer drift through the loop.
    -- if you set a var outside the loop it will always be the last action.

    local rank = 1;
    for x = pactions[i].ranks, 1, -1 do
      local ability;
      if (x == 1) then
        ability = pactions[i].action;
      else
        ability = mgr:GetAbilityByName(pactions[i].action.Name[2] .. ' ' .. ('i'):rep(x), 2);
      end
      if (player:HasAbility(ability.Id)) then
        rank = x;
        break;
      end
    end

    actions[i] = {
      action = function()
        if (rank == 1) then
          AshitaCore:GetChatManager():QueueCommand('/pet "' .. pactions[i].action.Name[2] .. '" ' .. pactions[i].target, -1);
        else
          AshitaCore:GetChatManager():QueueCommand('/pet "' .. pactions[i].action.Name[2] .. ' ' .. ('i'):rep(rank) .. '" ' .. pactions[i].target, -1);
        end
      end,
      name = pactions[i].action.Name[2];
    };
  end
  return actions;
end

return actions;
