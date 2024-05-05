

RegisterCommand('p', function(source, args)
    TriggerClientEvent('PlaceProp', args[1], "xm_prop_base_computer_01")
end, 'group.admin')