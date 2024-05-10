local isPlacingObject = false
local objectHologram = nil
local rotationSpeed = 5.0  -- Adjust the rotation speed as needed
local objectHeading = 0
local stepSize = 0.25  -- Adjust the step size as needed
local showing_placement_help = false -- Set this to true when you want to show the help text
local helpThread = nil -- Variable to hold the help thread

local function DisplayHelpText(message)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(message)
    EndTextCommandDisplayHelp(0, false, true, -1)
end

local function showPlacementHelp()
    showing_placement_help = true
    
    if helpThread == nil then -- Create the thread only if it's not already running
        helpThread = Citizen.CreateThread(function()
            local previous_input = IsInputDisabled(2) and 2 or 1 -- Keyboard is 2, Controller is 1
            local helpText = ""
            
            -- Show initial help text
            if previous_input == 2 then
                helpText = "Press Scroll Up/Down to Rotate\nPress Enter to Place Object\nPress Backspace to Cancel Placement"
            else
                helpText = "Use DPad Left/Right to Rotate\nPress A to Place Object\nPress B to Cancel Placement"
            end
            ClearAllHelpMessages() -- Clear existing help messages
            DisplayHelpText(helpText)
            
            while showing_placement_help do
                Citizen.Wait(0)
                local current_input = IsInputDisabled(2) and 2 or 1
                
                if current_input ~= previous_input then
                    previous_input = current_input
                    
                    if current_input == 2 then
                        helpText = "Press Scroll Up/Down to Rotate\nPress Enter to Place Object\nPress Backspace to Cancel Placement"
                    else
                        helpText = "Use DPad Left/Right to Rotate\nPress A to Place Object\nPress B to Cancel Placement"
                    end
                    
                    ClearAllHelpMessages() -- Clear existing help messages
                    DisplayHelpText(helpText)
                end
            end
        end)
    end
end

local function hidePlacementHelp()
    showing_placement_help = false
    ClearAllHelpMessages()
end

local function clearLocalPlacingData()
    objectHologram = nil
    isPlacingObject = false
end

-- Round a number to the nearest multiple of stepSize
local function roundToNearestStep(number, stepSize)
    return math.floor(number / stepSize + 0.5) * stepSize
end

local function handlePlacementControls()
    if IsControlPressed(0, 15) then -- Scroll Up | Controller: DPAD UP
        objectHeading = objectHeading + rotationSpeed
    elseif IsControlPressed(0, 14) then -- Scroll Down | Controller: DPAD DOWN
        objectHeading = objectHeading - rotationSpeed
    elseif IsControlPressed(0, 191) then -- Key: Enter | Controller: A
        return true -- Finalize placement
    elseif IsControlPressed(0, 177) then -- Key: Backspace | Controller: B
        return false -- Cancel placement
    end
    return nil
end

-- Function to start object placement loop
local function StartObjectPlacement(ObjectModel, PlacementHeight)
    local PlacementHeight = PlacementHeight or 0
    local snappedX, snappedY
    local player = PlayerPedId()
    local ObjectModel = ObjectModel
    local ObjectHash = GetHashKey(ObjectModel)
    print('Started Placing Model With Hash Of: '..ObjectHash)
    
    -- Create the hologram object
    objectHologram = CreateObject(ObjectHash, 0.0, 0.0, 0.0, false, true, true)
    SetEntityAlpha(objectHologram, 200, true)  -- Make the object fully visible
    SetEntityCollision(objectHologram, false, true)

    showPlacementHelp()

    while isPlacingObject do
        Citizen.Wait(0)
        
        local hit, _, endCoords = lib.raycast.cam(511, 4, 10)
        local hitCoords = endCoords
        
        if hitCoords ~= vec3(0, 0, 0) then
            -- Update hologram position
            snappedX = roundToNearestStep(hitCoords.x, stepSize)
            snappedY = roundToNearestStep(hitCoords.y, stepSize)
            SetEntityCoordsNoOffset(objectHologram, snappedX, snappedY, hitCoords.z + PlacementHeight, true, true, true)
            SetEntityHeading(objectHologram, objectHeading)
            
            local controlResult = handlePlacementControls()
            if controlResult ~= nil then
                if controlResult then
                    -- Finalize placement
                    local placedObject = CreateObject(ObjectHash, snappedX, snappedY, hitCoords.z, true, true, true)
                    PlaceObjectOnGroundProperly(ObjectHash)
                    if placedObject then
                        print("Placed Object: "..ObjectModel.." With A Hash Of: "..ObjectHash)
                        SetEntityCollision(placedObject, true, true)
                        ResetEntityAlpha(placedObject)  -- Make the object fully visible
                        SetEntityHeading(placedObject, objectHeading) -- Sets Object Heading
                        FreezeEntityPosition(placedObject, true)  -- Freeze the object in place
                        DeleteEntity(objectHologram) -- Delete hologram after placing object
                        hidePlacementHelp()
                        DisablePlayerFiring(player, false)-- Re-enable combat
                    else
                        print("Failed To Place")
                    end
                else
                    -- Cancel placement
                    print("Placement Canceled")
                    DeleteEntity(objectHologram)
                    clearLocalPlacingData()
                    hidePlacementHelp()
                    DisablePlayerFiring(player, false)-- Re-enable combat
                end
                break
            end
        end
    end
    -- Clear placement data
    clearLocalPlacingData()
end

-- Event handler to trigger object placement
RegisterNetEvent('PlaceProp')
AddEventHandler('PlaceProp', function(ObjectModel, PlacementHeight)
    if not isPlacingObject then
        isPlacingObject = true
        StartObjectPlacement(ObjectModel, PlacementHeight)
    end
end)

Citizen.CreateThread(function()
    local player = PlayerPedId()
    while isPlacingObject do
        Citizen.Wait(0)
        DisablePlayerFiring(player, true)
    end
end)
