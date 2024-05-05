local isPlacingObject = false
local objectHologram = nil
local rotationSpeed = 5.0  -- Adjust the rotation speed as needed
local objectHeading = 0

local function clearLocalPlacingData()
    objectHologram = nil
    isPlacingObject = false
end

-- Function to start object placement loop
local function StartObjectPlacement(ObjectModel)
    local ObjectModel = ObjectModel
    local ObjectHash = GetHashKey(ObjectModel)
    print('Started Placing Model With Hash Of: '..ObjectHash)
    
    -- Create the hologram object
    objectHologram = CreateObject(ObjectHash, 0.0, 0.0, 0.0, false, true, true)
    SetEntityAlpha(objectHologram, 200, true)  -- Make the object fully visible
    SetEntityCollision(objectHologram, false, true)
    
    while isPlacingObject do
        Citizen.Wait(0)
        local hit, _, endCoords = lib.raycast.cam(511, 4, 10)
        local hitCoords = endCoords
        
        if hitCoords ~= vec3(0, 0, 0) then
            -- Update hologram position
            SetEntityCoordsNoOffset(objectHologram, hitCoords.x, hitCoords.y, hitCoords.z, true, true, true)
            SetEntityHeading(objectHologram, objectHeading)
            
            -- Rotate the hologram object using scroll wheel input
            if IsControlPressed(0, 15) then -- Arrow Up | Controller: DPAD UP
                objectHeading = objectHeading + rotationSpeed
            elseif IsControlPressed(0, 14) then -- Arrow Down | Controller: DPAD DOWN
                objectHeading = objectHeading - rotationSpeed
            elseif IsControlPressed(0, 191) then -- Key: E | Controller: A
                -- Finalize placement
                local placedObject = CreateObject(ObjectHash, hitCoords.x, hitCoords.y, hitCoords.z, true, true, true)
                if placedObject then
                    print("Placed Object: "..ObjectModel.." With A Hash Of: "..ObjectHash)
                    SetEntityCollision(placedObject, true, true)
                    ResetEntityAlpha(placedObject)  -- Make the object fully visible
                    SetEntityHeading(placedObject, objectHeading) -- Sets Object Heading
                    FreezeEntityPosition(placedObject, true)  -- Freeze the object in place
                    DeleteEntity(objectHologram) -- Delete hologram after placing object
                else
                    print("Failed To Place Server")
                end
                break
            elseif IsControlPressed(0, 44) then -- Key: Q
                -- Cancel placement
                print("Placement Canceled")
                DeleteEntity(objectHologram)
                clearLocalPlacingData()
                break
            end
        end
    end
    
    -- Clear placement data
    clearLocalPlacingData()
end

-- Event handler to trigger object placement
RegisterNetEvent('PlaceProp')
AddEventHandler('PlaceProp', function(ObjectModel)
    local ObjectModel = ObjectModel
    if not isPlacingObject then
        isPlacingObject = true
        StartObjectPlacement(ObjectModel)
    end
end)
