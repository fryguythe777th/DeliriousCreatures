local mod = RegisterMod("DeliriousEnemies", 1)

require("scripts.enemies.blipcode")

local IsInVoid = false
local VoidRoomClearCount = 0
local rng = RNG()

local function voidCheck(_)
  local level = Game():GetLevel()
  local floor = level.GetStage(level)
  if floor == LevelStage.STAGE7 then
    IsInVoid = true
    VoidRoomClearCount = 0
    --local player = Isaac.GetPlayer()

    --player:AddCoins(1)
  end
end

local function enterVoidRoom(_)
  --local level = Game():GetLevel()
  --local floor = level.GetStage(level)
  if IsInVoid then
    VoidRoomClearCount = VoidRoomClearCount + 1
    local player = Isaac.GetPlayer()

    player:AddCoins(VoidRoomClearCount)
  end

  return nil
end

local function replaceWithDelirious(_, type, variant, subtype, position, velocity, spawner, seed)
  Isaac.DebugString("check2")

  if IsInVoid then
    Isaac.DebugString(tostring(type))

    if type == 13 then --if it's a fly
      Isaac.DebugString("check4")

      --replacement math
      local rand = math.random(100)
      local replaceChance = (VoidRoomClearCount / 15) * 100

      if rand < replaceChance or rand == replaceChance then
        return {17, 0, 0, seed}
      end
    end
  end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, voidCheck)
mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, enterVoidRoom)
mod:AddCallback(ModCallbacks.MC_PRE_ENTITY_SPAWN, replaceWithDelirious)

