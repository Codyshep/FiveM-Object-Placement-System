local isPlacingObject = false
local placingObject = nil
local rotationSpeed = 5.0  -- Adjust the rotation speed as needed
local objectHeading = 0

-- Function to start object placement loop
local function StartObjectPlacement(ObjectModel)
    local ObjectModel = ObjectModel
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            local hit, _, endCoords = lib.raycast.cam(511, 4, 10)
            local hitCoords = endCoords
            if hitCoords ~= vec3(0, 0, 0) then
                print("Hit coordinates:", hitCoords)

                -- Delete the previous object if it exists
                if placingObject ~= nil then
                    DeleteEntity(placingObject)
                end

                -- Spawn the new object at the hit coordinates
                placingObject = CreateObject(GetHashKey(ObjectModel), hitCoords.x, hitCoords.y, hitCoords.z, false, true, true)
                SetEntityCollision(placingObject, false, true)
                SetEntityAlpha(placingObject, 120, true)  -- Make the object fully visible
                
                -- Update the object's rotation based on the stored heading
                SetEntityHeading(placingObject, objectHeading)
                
                -- Rotate the object using scroll wheel input
                if IsControlPressed(0, 180) then -- Scroll Up
                    objectHeading = objectHeading + rotationSpeed
                elseif IsControlPressed(0, 181) then -- Scroll Down
                    objectHeading = objectHeading - rotationSpeed
                elseif IsControlPressed(0, 191) then -- Key: Enter
                    print("server placed")
                    DeleteEntity(placingObject)
                    local placedserver = CreateObject(GetHashKey(ObjectModel), hitCoords.x, hitCoords.y, hitCoords.z, true, true, true)
                    SetEntityCollision(placedserver, true, true)
                    SetEntityAlpha(placedserver, 255, true)  -- Make the object fully visible
                    SetEntityHeading(placedserver, objectHeading)
                    FreezeEntityPosition(placedserver, true)  -- Freeze the object in place
                    break
                elseif IsControlPressed(0, 44) then -- Key: Q
                    DeleteEntity(placingObject)
                    TaskExitCover()
                    break
                end
            else
                print("No hit detected.")
            end
        end
    end)
end

-- Event handler to trigger object placement
RegisterNetEvent('StartObjectPlacement')
AddEventHandler('StartObjectPlacement', function(ObjectModel)
    local ObjectModel = ObjectModel
    if not isPlacingObject then
        isPlacingObject = true
        TaskExitCover()
        StartObjectPlacement(ObjectModel)
    end
end)

-- server 1 "xm_base_cia_server_01"
--TriggerEvent('StartObjectPlacement', "xm_base_cia_server_01")
