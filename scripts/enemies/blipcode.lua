local mod = Mod
local game = Game()
local btype = 950
LazerCounter = 0
BlipCounter = 0
DipCounter = 0
AttachmentCounter = 1

Isaac.DebugString("Loaded Blip Script")

local function onDeath(_, npc, type2)
    Isaac.DebugString(tostring(npc.Type))
    if npc.Type == btype and npc.Variant == 001 and npc.SubType == 001 then
        Isaac.DebugString("Death of a Blip")
        local creep = Isaac.Spawn(1000, 169, 0, npc.Position, Vector(0, 0), npc):ToEffect()
        creep.Scale = 2
        BlipCounter = BlipCounter - 1
    elseif npc.Type == 217 and npc.Variant == 0 and npc.SubType == 0 then
        DipCounter = DipCounter - 1
    end
end

local function blipLazers(_, npc)
    LazerCounter = LazerCounter + 1

    if npc.Type == btype and npc.Variant == 001 and npc.SubType == 001 then
        if LazerCounter == 600 then
            for _, entity in pairs(Isaac.FindByType(btype, 001, 001)) do
                local fellowBlip = entity.ToNPC(entity)

                --distance formula
                local hypotToBlip = math.sqrt((fellowBlip.Position.X - npc.Position.X) * (fellowBlip.Position.X - npc.Position.X) + (fellowBlip.Position.Y - npc.Position.Y) * (fellowBlip.Position.Y - npc.Position.Y))
                local legToBlip = fellowBlip.Position.X - npc.Position.X
                local velToBlip = Vector(1, 0).Rotated(Vector(1, 0), math.cos(legToBlip/hypotToBlip))

                local params = ProjectileParams()
                params.BulletFlags = params.BulletFlags | WeaponType.WEAPON_BRIMSTONE

                fellowBlip.FireProjectiles(fellowBlip, fellowBlip.Position, velToBlip, 0, params)
            end

            LazerCounter = 0
        end
    end
end

local function update(_, blip)
    if blip.Type == btype and blip.Variant == 001 and blip.SubType == 001 then
        blip.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        local deathBool = true
        for index, dip in ipairs(Isaac.GetRoomEntities()) do
            if dip.Type == 217 and dip.Variant == 0 and dip.SubType == 0 and dip:GetData().indice == blip:GetData().indice then
                local vec = dip.Position
                blip.Position = (vec - Vector(0, 20))
                deathBool = false
                break   
            end
        end
        if deathBool == true then
            blip:Die()
        end
    end
end

local function increment(_, type, variant, subtype, position, velocity, spawner, seed)
    if type == btype and variant == 001 and subtype == 001 then
        --BlipCounter = BlipCounter + 1
    elseif type == 217 and variant == 0 and subtype == 0 then
        DipCounter = DipCounter + 1
    end
end

local function blipdata(_, blip)
    if blip.Type == btype and blip.Variant == 001 and blip.SubType == 001 then
        local data = blip:GetData()
        if data.indice == nil then
            data.indice = BlipCounter + 1
        end
        BlipCounter = BlipCounter + 1

        for index, dip in ipairs(Isaac.GetRoomEntities()) do
            if dip.Type == 217 and dip.Variant == 0 and dip.SubType == 0 then
                if AttachmentCounter == blip:GetData().indice then
                    dip:GetData().indice = blip:GetData().indice
                else
                    AttachmentCounter = AttachmentCounter + 1
                end
            end
        end
        AttachmentCounter = 1
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, onDeath)
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, update)
mod:AddCallback(ModCallbacks.MC_PRE_ENTITY_SPAWN, increment)
mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, blipdata)