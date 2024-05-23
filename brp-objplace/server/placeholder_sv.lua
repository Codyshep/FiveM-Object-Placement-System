propOptions = {}

RegisterCommand('p', function(source, args)
    print('Prop List:\n')
    for _, prop in ipairs(config.props) do 
        table.insert(propOptions, prop.name)
        print(json.encode(prop.name))
    end
    
    for index, propName in ipairs(propOptions) do
        if args[2] == propName then
            local prop = config.props[index]
            print('\nPlacing: '..json.encode(prop.prop))
            
            local placementheight = prop.pheight

            if placementheight then
                print('has height')
                TriggerClientEvent('PlaceProp', args[1], prop.prop, placementheight)
            else
                print('no height')
                TriggerClientEvent('PlaceProp', args[1], prop.prop)
            end


            break 
        end
    end
end, 'group.owner')
