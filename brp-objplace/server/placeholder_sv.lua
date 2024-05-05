propOptions = {}

RegisterCommand('p', function(source, args)
    for _, prop in ipairs(config.props) do 
        table.insert(propOptions, prop.name)
        print(json.encode(prop.name))
    end
    
    for index, propName in ipairs(propOptions) do
        if args[2] == propName then
            local prop = config.props[index]
            print(json.encode(prop.prop))
            TriggerClientEvent('PlaceProp', args[1], prop.prop)
            break 
        end
    end
end, 'group.admin')
