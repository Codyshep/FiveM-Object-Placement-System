config = {
    props = {
        {name = 'box', prop = 'prop_cs_rub_box_01', pheight = 0.27},
        {name = 'box2', prop = 'prop_cs_cardbox_01', pheight = 0.175},
        {name = 'walllight', prop = 'prop_wall_light_14b'},
        {name = 'walllight2', prop = 'apa_mp_stilts_a_stairs_light003'},
        {name = 'cabinet', prop = 'v_corp_lowcabdark01'},
        {name = 'floorlight', prop = 'ba_work_light_clutter001'},
        {name = 'storage', prop = 'v_ret_ml_liqshelfd', pheight = 1},
        {name = 'table', prop = 'prop_picnictable_02'}
    }
}

--[[

name = spawn code for the command /p, for example "/p [PlayerID] [spawn code]"

prop = the prop that will be getting spawned, you can find prop spawn names here https://forge.plebmasters.de/objects

pheight = sometimes the objects holograms before the placements will be shown in the ground even though they arent, 
adjusting the height will make the object hologram appear higher ultimately removing the phasing through the ground look.

NOTE: keep in mind you only need [name] & [prop] the other variables don't need to be added unless you want to adjust values
or enable a feature.

]]--


return config