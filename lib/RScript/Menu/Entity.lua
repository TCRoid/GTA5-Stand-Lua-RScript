-----------------------------------
------------ 世界实体选项 -----------
-----------------------------------

local Entity_options = menu.list(menu.my_root(), "世界实体选项", {}, "")


--#region Entity Quick Action

-------------------------
-- 实体快捷操作
-------------------------
local Entity_Quick_Action = menu.list(Entity_options, "实体快捷操作", {}, "")

local ent_quick_action = {
    ped_select = 1,
    weak_ped = {
        select = 1,
        time_delay = 2000,
        toggle = {
            health = false,
            weapon_damage = true,
            vehicle_weapon = false,
        },
    },
}


------ NPC选项 ------
local Entity_Quick_Ped = menu.list(Entity_Quick_Action, "NPC选项", {}, "")

menu.divider(Entity_Quick_Ped, "全部NPC")
menu.list_select(Entity_Quick_Ped, "NPC类型", {}, "", {
    { "全部NPC(排除友好)", {}, "" },
    { "敌对NPC", {}, "" },
    { "全部NPC", {}, "" },
}, 1, function(value)
    ent_quick_action.ped_select = value
end)

menu.action(Entity_Quick_Ped, "删除", { "delete_ped" }, "", function()
    for _, ent in pairs(entities.get_all_peds_as_handles()) do
        if not is_player_ped(ent) then
            local ped = nil

            if ent_quick_action.ped_select == 1 then
                if not is_friendly_ped(ent) then
                    ped = ent
                end
            elseif ent_quick_action.ped_select == 2 then
                if is_hostile_ped(ent) then
                    ped = ent
                end
            else
                ped = ent
            end

            if ped ~= nil then
                entities.delete(ped)
            end
        end
    end
end)
menu.action(Entity_Quick_Ped, "死亡", { "dead_ped" }, "", function()
    for _, ent in pairs(entities.get_all_peds_as_handles()) do
        if not ENTITY.IS_ENTITY_DEAD(ent) and not is_player_ped(ent) then
            local ped = nil

            if ent_quick_action.ped_select == 1 then
                if not is_friendly_ped(ent) then
                    ped = ent
                end
            elseif ent_quick_action.ped_select == 2 then
                if is_hostile_ped(ent) then
                    ped = ent
                end
            else
                ped = ent
            end

            if ped ~= nil then
                SET_ENTITY_HEALTH(ped, 0)
            end
        end
    end
end)
menu.action(Entity_Quick_Ped, "爆头击杀", { "kill_ped" }, "", function()
    local weaponHash = util.joaat("WEAPON_APPISTOL")
    for _, ent in pairs(entities.get_all_peds_as_handles()) do
        if not ENTITY.IS_ENTITY_DEAD(ent) and not is_player_ped(ent) then
            local ped = nil

            if ent_quick_action.ped_select == 1 then
                if not is_friendly_ped(ent) then
                    ped = ent
                end
            elseif ent_quick_action.ped_select == 2 then
                if is_hostile_ped(ent) then
                    ped = ent
                end
            else
                ped = ent
            end

            if ped ~= nil then
                shoot_ped_head(ped, weaponHash, players.user_ped())
            end
        end
    end
end)

menu.divider(Entity_Quick_Ped, "警察和特警")
menu.toggle_loop(Entity_Quick_Ped, "删除", { "delete_cop" }, "", function()
    for _, ent in pairs(entities.get_all_peds_as_handles()) do
        local hash = ENTITY.GET_ENTITY_MODEL(ent)
        if hash == 1581098148 or hash == -1320879687 or hash == -1920001264 then
            entities.delete(ent)
        end
    end
end)
menu.toggle_loop(Entity_Quick_Ped, "死亡", { "dead_cop" }, "", function()
    for _, ent in pairs(entities.get_all_peds_as_handles()) do
        local hash = ENTITY.GET_ENTITY_MODEL(ent)
        if hash == 1581098148 or hash == -1320879687 or hash == -1920001264 then
            SET_ENTITY_HEALTH(ent, 0)
        end
    end
end)

menu.divider(Entity_Quick_Ped, "友方NPC")
menu.action(Entity_Quick_Ped, "无敌强化", { "strong_ped_friendly" }, "", function()
    for _, ent in pairs(entities.get_all_peds_as_handles()) do
        if not ENTITY.IS_ENTITY_DEAD(ent) and not is_player_ped(ent) then
            local rel = PED.GET_RELATIONSHIP_BETWEEN_PEDS(ent, players.user_ped())
            if rel == 0 or rel == 1 then -- Respect or Like
                increase_ped_combat_ability(ent, true)
                increase_ped_combat_attributes(ent)
            end
        end
    end
end)
menu.list_action(Entity_Quick_Ped, "给予武器", {}, "", Weapon_Common.ListItem, function(value)
    local weaponHash = util.joaat(Weapon_Common.ModelList[value])

    for _, ent in pairs(entities.get_all_peds_as_handles()) do
        if not ENTITY.IS_ENTITY_DEAD(ent) and not is_player_ped(ent) then
            local rel = PED.GET_RELATIONSHIP_BETWEEN_PEDS(ent, players.user_ped())
            if rel == 0 or rel == 1 then -- Respect or Like
                WEAPON.GIVE_WEAPON_TO_PED(ent, weaponHash, 9999, false, true)
                WEAPON.SET_CURRENT_PED_WEAPON(ent, weaponHash, false)
            end
        end
    end
end)


------ 弱化NPC选项 ------
local Entity_Quick_WeakPed = menu.list(Entity_Quick_Action, "弱化NPC选项", {}, "")

menu.list_select(Entity_Quick_WeakPed, "NPC类型", {}, "", {
    { "全部NPC(排除友好)", {}, "" },
    { "敌对NPC", {}, "" },
    { "全部NPC", {}, "" },
}, 1, function(value)
    ent_quick_action.weak_ped.select = value
end)

menu.toggle_loop(Entity_Quick_WeakPed, "弱化", { "weak_ped" }, "", function()
    local weak_health = 100
    local weak_weapon_damage = 0.01

    for _, ent in pairs(entities.get_all_peds_as_handles()) do
        if not ENTITY.IS_ENTITY_DEAD(ent) and not is_player_ped(ent) then
            local ped = nil

            if ent_quick_action.weak_ped.select == 1 then
                if not is_friendly_ped(ent) then
                    ped = ent
                end
            elseif ent_quick_action.weak_ped.select == 2 then
                if is_hostile_ped(ent) then
                    ped = ent
                end
            else
                ped = ent
            end

            if ped ~= nil then
                if ent_quick_action.weak_ped.toggle.health then
                    if ENTITY.GET_ENTITY_HEALTH(ped) > weak_health then
                        SET_ENTITY_HEALTH(ped, weak_health)
                    end
                end

                if ent_quick_action.weak_ped.toggle.weapon_damage then
                    PED.SET_COMBAT_FLOAT(ped, 29, weak_weapon_damage) -- WEAPON_DAMAGE_MODIFIER
                end

                PED.SET_PED_SHOOT_RATE(ped, 0)
                PED.SET_PED_ACCURACY(ped, 0)
                PED.SET_COMBAT_FLOAT(ped, 6, 0.0) -- WEAPON_ACCURACY
                PED.SET_PED_COMBAT_ABILITY(ped, 0)

                PED.STOP_PED_WEAPON_FIRING_WHEN_DROPPED(ped)
                PED.DISABLE_PED_INJURED_ON_GROUND_BEHAVIOUR(ped)

                if ent_quick_action.weak_ped.toggle.vehicle_weapon then
                    if PED.IS_PED_IN_ANY_VEHICLE(ped, false) then
                        local ped_veh = PED.GET_VEHICLE_PED_IS_IN(ped, false)
                        if VEHICLE.DOES_VEHICLE_HAVE_WEAPONS(ped_veh) then
                            local veh_weapon_hash = get_ped_vehicle_weapon(ped)
                            if veh_weapon_hash ~= 0 then
                                VEHICLE.DISABLE_VEHICLE_WEAPON(true, veh_weapon_hash, ped_veh, ped)
                            end
                        end
                    end
                end
            end
        end
    end

    util.yield(ent_quick_action.weak_ped.time_delay)
end)

menu.divider(Entity_Quick_WeakPed, "设置")

menu.toggle(Entity_Quick_WeakPed, "弱化血量", {}, "修改血量为: 100", function(toggle)
    ent_quick_action.weak_ped.toggle.health = toggle
end)
menu.toggle(Entity_Quick_WeakPed, "弱化武器伤害", {}, "修改武器伤害为: 0.01", function(toggle)
    ent_quick_action.weak_ped.toggle.weapon_damage = toggle
end, true)
menu.toggle(Entity_Quick_WeakPed, "禁用载具武器", {}, "", function(toggle)
    ent_quick_action.weak_ped.toggle.vehicle_weapon = toggle
end)
menu.slider(Entity_Quick_WeakPed, "循环间隔", { "setting_weak_ped_time_delay" }, "单位: 毫秒", 0, 5000, 2000, 100,
    function(value)
        ent_quick_action.weak_ped.time_delay = value
    end)

menu.divider(Entity_Quick_WeakPed, "其它(默认设置)")
menu.readonly(Entity_Quick_WeakPed, "射击频率", "0")
menu.readonly(Entity_Quick_WeakPed, "精准度", "0")
menu.readonly(Entity_Quick_WeakPed, "作战技能", "弱")
menu.readonly(Entity_Quick_WeakPed, "禁止武器掉落时走火", "是")
menu.readonly(Entity_Quick_WeakPed, "禁止受伤倒地时的行为", "是")



------ 摄像头和门 ------
local Entity_Quick_Object = menu.list(Entity_Quick_Action, "摄像头和门", {}, "")

menu.divider(Entity_Quick_Object, "摄像头选项")
local Cams = {
    548760764,   --prop_cctv_cam_01a
    -354221800,  --prop_cctv_cam_01b
    -1159421424, --prop_cctv_cam_02a
    1449155105,  --prop_cctv_cam_03a
    -1095296451, --prop_cctv_cam_04a
    -1884701657, --prop_cctv_cam_04c
    -173206916,  --prop_cctv_cam_05a
    168901740,   --prop_cctv_cam_06a
    -1340405475, --prop_cctv_cam_07a
    2090203758,  --prop_cs_cctv
    289451089,   --p_cctv_s
    -1007354661, --hei_prop_bank_cctv_01
    -1842407088, --hei_prop_bank_cctv_02
    -1233322078, --ch_prop_ch_cctv_cam_02a
    -247409812,  --xm_prop_x17_server_farm_cctv_01
    2135655372   --prop_cctv_pole_04
}
local Cams2 = {
    1919058329, --prop_cctv_cam_04b
    1849991131  --prop_snow_cam_03a
}
menu.action(Entity_Quick_Object, "删除", { "delete_cam" }, "", function()
    for _, ent in pairs(entities.get_all_objects_as_handles()) do
        local EntityModel = ENTITY.GET_ENTITY_MODEL(ent)
        for i = 1, #Cams do
            if EntityModel == Cams[i] then
                entities.delete(ent)
            end
        end
    end
end)
menu.click_slider(Entity_Quick_Object, "上下移动", { "move_cam" }, "易导致bug",
    -30, 30, 0, 1, function(value)
        for _, ent in pairs(entities.get_all_objects_as_handles()) do
            local EntityModel = ENTITY.GET_ENTITY_MODEL(ent)
            for i = 1, #Cams do
                if EntityModel == Cams[i] then
                    SET_ENTITY_MOVE(ent, 0.0, 0.0, value)
                end
            end
        end
    end)

menu.divider(Entity_Quick_Object, "佩里科岛的门（本地有效）")
local Perico_Doors = {
    --豪宅内 各种铁门
    -1052729812,                 --h4_prop_h4_gate_l_01a
    1866987242,                  --h4_prop_h4_gate_r_01a
    -1360938964,                 --h4_prop_h4_gate_02a
    -2058786200,                 --h4_prop_h4_gate_03a
    -630812075,                  --h4_prop_h4_gate_05a
    --豪宅内 电梯门
    -1240156945,                 --v_ilev_garageliftdoor
    -576022807,                  --h4_prop_office_elevator_door_01
    --豪宅大门
    -1574151574,                 --h4_prop_h4_gate_r_03a
    1215477734,                  --h4_prop_h4_gate_l_03a
    --豪宅外 铁门
    227019171,                   --prop_fnclink_02gate6_r
    1526539404,                  --prop_fnclink_02gate6_l
    141297241,                   --h4_prop_h4_garage_door_01a
    -1156020871                  --prop_fnclink_03gate5
}
local Perico_Doors2 = -607013269 --h4_prop_h4_door_01a 豪宅内的库房门

menu.action(Entity_Quick_Object, "删除门", { "delete_perico_door" }, "", function()
    for _, ent in pairs(entities.get_all_objects_as_handles()) do
        local EntityModel = ENTITY.GET_ENTITY_MODEL(ent)
        for i = 1, #Perico_Doors do
            if EntityModel == Perico_Doors[i] then
                entities.delete(ent)
            end
        end
    end
end)
menu.action(Entity_Quick_Object, "开启无碰撞", {}, "可以直接穿过门，包括库房门", function()
    for _, ent in pairs(entities.get_all_objects_as_handles()) do
        local EntityModel = ENTITY.GET_ENTITY_MODEL(ent)
        if EntityModel == Perico_Doors2 then
            ENTITY.SET_ENTITY_COLLISION(ent, false, true)
        else
            for i = 1, #Perico_Doors do
                if EntityModel == Perico_Doors[i] then
                    ENTITY.SET_ENTITY_COLLISION(ent, false, true)
                end
            end
        end
    end
end)
menu.action(Entity_Quick_Object, "关闭无碰撞", {}, "", function()
    for _, ent in pairs(entities.get_all_objects_as_handles()) do
        local EntityModel = ENTITY.GET_ENTITY_MODEL(ent)
        if EntityModel == Perico_Doors2 then
            ENTITY.SET_ENTITY_COLLISION(ent, true, true)
        else
            for i = 1, #Perico_Doors do
                if EntityModel == Perico_Doors[i] then
                    ENTITY.SET_ENTITY_COLLISION(ent, true, true)
                end
            end
        end
    end
end)



------ 任务拾取物/收集物 ------
local Entity_Quick_Pickup = menu.list(Entity_Quick_Action, "任务拾取物/收集物", {}, "")

local ent_quick_pickup = {
    ent_data = {
        { type = "pickup", mission = true, hash = {} },
        { type = "pickup", mission = true, hash = { 1932904700, -299426222, -1229859060, -1096615886 } },
        { type = "object", mission = true, hash = { -2092739441 } },
        { type = "pickup", mission = true, hash = { 1002246134, -2122380018 } },
        { type = "pickup", mission = true, hash = { 1188944846 } },
    },
    select_list_item = {
        { "全部 任务拾取物" },
        { "ULP: 情报 FIB硬件" },
        { "ULP: 清场 保险丝" },
        { "最后一搏: 内藏玄机 手办" },
        { "第一剂3: 致命侵袭 冰毒" },
    },

    select_value = 1,
    entity_list = {}, -- 实体 list

    -- 传送到我
    tp_to_me = {
        x = 0.0,
        y = 2.0,
        z = 0.0,
        delay = 500,
        collect_in_vehicle = false,
    },
    -- 连线显示
    draw_line = {
        draw_ar = true,
        draw_distance = false,
    },
    screen_x = memory.alloc(8),
    screen_y = memory.alloc(8),
    -- 添加标记点
    add_blip = {
        blip_name = "",
        show_number = false,
    },

}

function ent_quick_pickup.init()
    ent_quick_pickup.entity_list = {} -- 实体 list
    ent_quick_pickup.entity_count = 0 -- 实体 数量
    -- ent_quick_pickup.entity_menu_list = {} -- 实体的 menu.list

    local commands = menu.get_children(ent_quick_pickup.menu_list)
    for k, command in pairs(commands) do
        if menu.is_ref_valid(command) then
            menu.delete(command)
        end
    end

    menu.set_menu_name(ent_quick_pickup.menu_list, "查看实体列表")
end

function ent_quick_pickup.generate_command(ent, menu_parent, index)
    local hash = ENTITY.GET_ENTITY_MODEL(ent)
    local model = util.reverse_joaat(hash)

    local menu_name = ""
    if model ~= "NULL" then
        menu_name = index .. ". " .. model
    else
        menu_name = index .. ". " .. hash
    end

    local menu_list = menu.list(menu_parent, menu_name, {}, "")

    ----- 传送 -----
    local menu_teleport = menu.divider(menu_list, "传送")

    local tp = {
        x = 0.0,
        y = 2.0,
        z = 0.0,
    }

    menu.slider_float(menu_list, "前/后", { "ent_quick" .. index .. "_tp_x" }, "", -5000, 5000, 200, 50,
        function(value)
            tp.y = value * 0.01
        end)
    menu.slider_float(menu_list, "上/下", { "ent_quick" .. index .. "_tp_y" }, "", -5000, 5000, 0, 50,
        function(value)
            tp.z = value * 0.01
        end)
    menu.slider_float(menu_list, "左/右", { "ent_quick" .. index .. "_tp_z" }, "", -5000, 5000, 0, 50,
        function(value)
            tp.x = value * 0.01
        end)

    menu.action(menu_list, "传送到实体", {}, "", function()
        if ENTITY.DOES_ENTITY_EXIST(ent) then
            TP_TO_ENTITY(ent, tp.x, tp.y, tp.z)
        else
            util.toast("实体已经不存在")
        end
    end)
    menu.action(menu_list, "传送到我", {}, "", function()
        if ENTITY.DOES_ENTITY_EXIST(ent) then
            RequestControl(ent)
            TP_TO_ME(ent, tp.x, tp.y, tp.z)
        else
            util.toast("实体已经不存在")
        end
    end)

    menu.divider(menu_list, "拾取物设置")
    menu.click_slider(menu_list, "最大携带数量", {}, "", 1, 20, 8, 1, function(value)
        OBJECT.SET_MAX_NUM_PORTABLE_PICKUPS_CARRIED_BY_PLAYER(hash, value)
    end)




    ----------
    menu.on_tick_in_viewport(menu_teleport, function()
        if ENTITY.DOES_ENTITY_EXIST(ent) then
            DRAW_LINE_TO_ENTITY(ent)
            util.draw_ar_beacon(ENTITY.GET_ENTITY_COORDS(ent))
        end
    end)
end

menu.list_select(Entity_Quick_Pickup, "选择", {}, "", ent_quick_pickup.select_list_item, 1, function(value)
    ent_quick_pickup.select_value = value
end)
menu.action(Entity_Quick_Pickup, "获取所有实体", {}, "要先获取实体才能进行操作", function()
    ent_quick_pickup.init()

    if ent_quick_pickup.select_value == 1 then
        -- 全部任务拾取物
        for key, pickup in pairs(entities.get_all_pickups_as_handles()) do
            if ENTITY.IS_ENTITY_A_MISSION_ENTITY(pickup) then
                table.insert(ent_quick_pickup.entity_list, pickup)

                ent_quick_pickup.generate_command(pickup, ent_quick_pickup.menu_list, key)

                ent_quick_pickup.entity_count = ent_quick_pickup.entity_count + 1
            end
        end

        if ent_quick_pickup.entity_count > 0 then
            menu.set_menu_name(ent_quick_pickup.menu_list, "查看实体列表 (" .. ent_quick_pickup.entity_count .. ")")
        end
    else
        local data = ent_quick_pickup.ent_data[ent_quick_pickup.select_value]
        local hash_list = data.hash
        for key, ent_ in pairs(get_all_entities(data.type)) do
            local ent = nil
            if data.mission then
                if ENTITY.IS_ENTITY_A_MISSION_ENTITY(ent_) then
                    ent = ent_
                end
            else
                ent = ent_
            end

            if ent ~= nil then
                local hash = ENTITY.GET_ENTITY_MODEL(ent)
                if isInTable(hash_list, hash) then
                    table.insert(ent_quick_pickup.entity_list, ent)

                    ent_quick_pickup.generate_command(ent, ent_quick_pickup.menu_list, key)

                    ent_quick_pickup.entity_count = ent_quick_pickup.entity_count + 1
                end
            end
        end

        if ent_quick_pickup.entity_count > 0 then
            menu.set_menu_name(ent_quick_pickup.menu_list, "查看实体列表 (" .. ent_quick_pickup.entity_count .. ")")
        end
    end
end)

menu.divider(Entity_Quick_Pickup, "选项")

ent_quick_pickup.menu_list = menu.list(Entity_Quick_Pickup, "查看实体列表", {}, "")

--- 传送到我 ---
ent_quick_pickup.menu_tp_to_me = menu.list(Entity_Quick_Pickup, "传送到我", {}, "")

menu.action(ent_quick_pickup.menu_tp_to_me, "传送到我", {}, "", function()
    if next(ent_quick_pickup.entity_list) ~= nil then
        local num_success, num_fail = 0, 0
        for key, ent in pairs(ent_quick_pickup.entity_list) do
            if ENTITY.DOES_ENTITY_EXIST(ent) then
                RequestControl(ent)
                if ent_quick_pickup.tp_to_me.collect_in_vehicle then
                    OBJECT.SET_PICKUP_OBJECT_COLLECTABLE_IN_VEHICLE(ent)
                end
                TP_TO_ME(ent, ent_quick_pickup.tp_to_me.x, ent_quick_pickup.tp_to_me.y, ent_quick_pickup.tp_to_me.z)

                if hasControl(ent) then
                    num_success = num_success + 1
                else
                    num_fail = num_fail + 1
                end
                util.yield(ent_quick_pickup.tp_to_me.delay)
            end
        end
        util.toast("传送完成！\n成功: " .. num_success .. "\n失败: " .. num_fail)
    end
end)

menu.divider(ent_quick_pickup.menu_tp_to_me, "设置")
menu.slider_float(ent_quick_pickup.menu_tp_to_me, "前/后", { "ent_quick_pickup_tp_x" }, "", -5000, 5000, 200, 50,
    function(value)
        ent_quick_pickup.tp_to_me.y = value * 0.01
    end)
menu.slider_float(ent_quick_pickup.menu_tp_to_me, "上/下", { "ent_quick_pickup_tp_y" }, "", -5000, 5000, 0, 50,
    function(value)
        ent_quick_pickup.tp_to_me.z = value * 0.01
    end)
menu.slider_float(ent_quick_pickup.menu_tp_to_me, "左/右", { "ent_quick_pickup_tp_z" }, "", -5000, 5000, 0, 50,
    function(value)
        ent_quick_pickup.tp_to_me.x = value * 0.01
    end)
menu.slider(ent_quick_pickup.menu_tp_to_me, "时间间隔", { "ent_quick_pickup_tp_delay" }, "单位: ms", 0, 5000, 500,
    100, function(value)
        ent_quick_pickup.tp_to_me.delay = value
    end)
menu.toggle(ent_quick_pickup.menu_tp_to_me, "在载具内也可收集", {}, "拾取物", function(toggle)
    ent_quick_pickup.tp_to_me.collect_in_vehicle = toggle
end)

--- 连线显示 ---
ent_quick_pickup.menu_draw_line = menu.list(Entity_Quick_Pickup, "连线显示", {}, "")

menu.toggle_loop(ent_quick_pickup.menu_draw_line, "连线显示", {}, "", function()
    if next(ent_quick_pickup.entity_list) ~= nil then
        local my_pos = ENTITY.GET_ENTITY_COORDS(players.user_ped())
        for key, ent in pairs(ent_quick_pickup.entity_list) do
            if ENTITY.DOES_ENTITY_EXIST(ent) then
                local ent_pos = ENTITY.GET_ENTITY_COORDS(ent)
                DRAW_LINE(my_pos, ent_pos)

                if ent_quick_pickup.draw_line.draw_ar then
                    util.draw_ar_beacon(ent_pos)
                end

                if ent_quick_pickup.draw_line.draw_distance then
                    if GRAPHICS.GET_SCREEN_COORD_FROM_WORLD_COORD(ent_pos.x, ent_pos.y, ent_pos.z,
                            ent_quick_pickup.screen_x, ent_quick_pickup.screen_y) then
                        local x = memory.read_float(ent_quick_pickup.screen_x)
                        local y = memory.read_float(ent_quick_pickup.screen_y)
                        local distance = v3.distance(my_pos, ent_pos)

                        directx.draw_text(x, y, round(distance, 2), ALIGN_TOP_LEFT, 0.8, Colors.purple)
                    end
                end
            end
        end
    end
end)

menu.divider(ent_quick_pickup.menu_draw_line, "设置")
menu.toggle(ent_quick_pickup.menu_draw_line, "绘制灯塔", {}, "", function(toggle)
    ent_quick_pickup.draw_line.draw_ar = toggle
end, true)
menu.toggle(ent_quick_pickup.menu_draw_line, "绘制距离", {}, "", function(toggle)
    ent_quick_pickup.draw_line.draw_distance = toggle
end)

--- 地图标记点 ---
ent_quick_pickup.menu_add_blip = menu.list(Entity_Quick_Pickup, "地图标记点", {}, "")

menu.action(ent_quick_pickup.menu_add_blip, "添加标记点", {}, "", function()
    if next(ent_quick_pickup.entity_list) ~= nil then
        for key, ent in pairs(ent_quick_pickup.entity_list) do
            if ENTITY.DOES_ENTITY_EXIST(ent) then
                local blip = HUD.GET_BLIP_FROM_ENTITY(ent)
                if not HUD.DOES_BLIP_EXIST(blip) then
                    blip = HUD.ADD_BLIP_FOR_ENTITY(ent)
                end
                HUD.SET_BLIP_SPRITE(blip, 271) -- radar_on_mission
                HUD.SET_BLIP_COLOUR(blip, 27)  -- Bright Purple
                HUD.SET_BLIP_SCALE(blip, 0.75)
                HUD.SET_BLIP_AS_SHORT_RANGE(blip, false)
                HUD.SHOW_HEIGHT_ON_BLIP(blip, true)
                HUD.SET_BLIP_DISPLAY(blip, 2) -- Shows on both main map and minimap. (Selectable on map)
            end
        end
    end
end)
menu.action(ent_quick_pickup.menu_add_blip, "移除标记点", {}, "", function()
    if next(ent_quick_pickup.entity_list) ~= nil then
        for key, ent in pairs(ent_quick_pickup.entity_list) do
            if ENTITY.DOES_ENTITY_EXIST(ent) then
                local blip = HUD.GET_BLIP_FROM_ENTITY(ent)
                if HUD.DOES_BLIP_EXIST(blip) then
                    util.remove_blip(blip)
                end
            end
        end
    end
end)
menu.toggle(ent_quick_pickup.menu_add_blip, "标记点上添加数字", {}, "", function(toggle)
    if next(ent_quick_pickup.entity_list) ~= nil then
        for key, ent in pairs(ent_quick_pickup.entity_list) do
            if ENTITY.DOES_ENTITY_EXIST(ent) then
                local blip = HUD.GET_BLIP_FROM_ENTITY(ent)
                if HUD.DOES_BLIP_EXIST(blip) then
                    if toggle then
                        HUD.SHOW_NUMBER_ON_BLIP(blip, key)
                    else
                        HUD.HIDE_NUMBER_ON_BLIP(blip)
                    end
                end
            end
        end
    end
end)
menu.toggle(ent_quick_pickup.menu_add_blip, "箭头标记", {}, "拾取物", function(toggle)
    if next(ent_quick_pickup.entity_list) ~= nil then
        for key, ent in pairs(ent_quick_pickup.entity_list) do
            if ENTITY.DOES_ENTITY_EXIST(ent) then
                OBJECT.SET_PICKUP_OBJECT_ARROW_MARKER(ent, toggle)
            end
        end
    end
end)


--#endregion Entity Quick Action





--#region Nearby Vehicle

---------------------------
--------- 附近载具 ---------
---------------------------

local Nearby_Vehicle = {
    can_handler_run = false,
    is_handler_runing = false,

    setting = {
        radius = 60.0,
        vehicle_select = 1,
        time_delay = 1000,
        exclude_player = true,
        exclude_mission = true,
        exclude_dead = true,
    },
    toggles = {},
    data = {
        forward_speed = 30,
        max_speed = 0,
        alpha = 0,
        force_field = 1.0,
        launch_height = 30.0,
    },
    callback = {},
}

function Nearby_Vehicle.check_vehicle(vehicle)
    -- 排除 玩家载具
    if Nearby_Vehicle.setting.exclude_player and is_player_vehicle(vehicle) then
        return false
    end
    -- 排除 任务载具
    if Nearby_Vehicle.setting.exclude_mission and ENTITY.IS_ENTITY_A_MISSION_ENTITY(vehicle) then
        return false
    end
    -- 排除 已死亡实体
    if Nearby_Vehicle.setting.exclude_dead and ENTITY.IS_ENTITY_DEAD(vehicle) then
        return false
    end
    -- NPC载具
    if Nearby_Vehicle.setting.vehicle_select == 2 then
        local driver = VEHICLE.GET_PED_IN_VEHICLE_SEAT(vehicle, -1, false)
        if not ENTITY.IS_ENTITY_A_PED(driver) then
            return false
        end
    end
    -- 敌对载具
    if Nearby_Vehicle.setting.vehicle_select == 3 and not IS_HOSTILE_ENTITY(vehicle) then
        return false
    end
    -- 空载具
    if Nearby_Vehicle.setting.vehicle_select == 4 and not VEHICLE.IS_VEHICLE_SEAT_FREE(vehicle, -1, false) then
        return false
    end

    return true
end

function Nearby_Vehicle.get_vehicles()
    local vehicles = {}
    local player_pos = ENTITY.GET_ENTITY_COORDS(players.user_ped())
    local radius = Nearby_Vehicle.setting.radius

    for k, ent in pairs(entities.get_all_vehicles_as_handles()) do
        local vehicle = 0

        local ent_pos = ENTITY.GET_ENTITY_COORDS(ent)
        if radius <= 0 then
            vehicle = ent
        elseif v3.distance(player_pos, ent_pos) <= radius then
            vehicle = ent
        end

        if vehicle ~= 0 and Nearby_Vehicle.check_vehicle(vehicle) then
            table.insert(vehicles, vehicle)
        end
    end

    return vehicles
end

function Nearby_Vehicle.toggle_changed(key, toggle)
    Nearby_Vehicle.toggles[key] = toggle

    Nearby_Vehicle.switch_tick_handler()
end

function Nearby_Vehicle.select_changed(key, value)
    if value == 1 then
        Nearby_Vehicle.toggles[key] = false
    else
        Nearby_Vehicle.toggles[key] = true
    end

    Nearby_Vehicle.switch_tick_handler()
end

function Nearby_Vehicle.switch_tick_handler()
    local is_all_false = true
    for key, bool in pairs(Nearby_Vehicle.toggles) do
        if bool then
            is_all_false = false
            break
        end
    end
    if is_all_false then
        Nearby_Vehicle.can_handler_run = false
    else
        if not Nearby_Vehicle.is_handler_running then
            Nearby_Vehicle.can_handler_run = true
            Nearby_Vehicle.control_vehicles()
        end
    end
end

function Nearby_Vehicle.control_vehicles()
    util.create_tick_handler(function()
        if not Nearby_Vehicle.can_handler_run then
            Nearby_Vehicle.is_handler_running = false
            util.log("[RScript] Control Nearby Vehicles: Stop Tick Handler")
            return false
        end

        Nearby_Vehicle.is_handler_running = true

        for _, vehicle in pairs(Nearby_Vehicle.get_vehicles()) do
            RequestControl(vehicle)

            for key, bool in pairs(Nearby_Vehicle.toggles) do
                if bool then
                    if Nearby_Vehicle.callback[key] ~= nil then
                        Nearby_Vehicle.callback[key](vehicle)
                    end
                end
            end
        end

        util.yield(Nearby_Vehicle.setting.time_delay)
    end)
end

--------------
-- Menu
--------------
local Nearby_Vehicle_Options = menu.list(Entity_options, "管理附近载具", {}, "")

menu.slider_float(Nearby_Vehicle_Options, "范围半径", { "radius_nearby_vehicle" },
    "若半径是0, 则为全部范围", 0, 100000, 6000, 1000, function(value)
        Nearby_Vehicle.setting.radius = value * 0.01
    end)
menu.toggle_loop(Nearby_Vehicle_Options, "绘制范围", {}, "", function()
    local coords = ENTITY.GET_ENTITY_COORDS(players.user_ped())
    DRAW_MARKER_SPHERE(coords, Nearby_Vehicle.setting.radius)
end)

menu.list_select(Nearby_Vehicle_Options, "载具类型", {}, "", {
    { "全部载具", {}, "" },
    { "NPC载具", {}, "有NPC作为司机驾驶的载具" },
    { "敌对载具", {}, "有敌对地图标记点或敌对NPC驾驶的载具" },
    { "空载具", {}, "无人驾驶的载具" },
}, 1, function(value)
    Nearby_Vehicle.setting.vehicle_select = value
end)

local Nearby_Vehicle_Setting = menu.list(Nearby_Vehicle_Options, "设置", {}, "")

menu.slider(Nearby_Vehicle_Setting, "循环时间间隔", { "delay_nearby_vehicle" }, "单位: ms",
    0, 5000, 1000, 100, function(value)
        Nearby_Vehicle.setting.time_delay = value
    end)
menu.divider(Nearby_Vehicle_Setting, "排除")
menu.toggle(Nearby_Vehicle_Setting, "排除 玩家载具", {}, "", function(toggle)
    Nearby_Vehicle.setting.exclude_player = toggle
end, true)
menu.toggle(Nearby_Vehicle_Setting, "排除 任务载具", {}, "", function(toggle)
    Nearby_Vehicle.setting.exclude_mission = toggle
end, true)
menu.toggle(Nearby_Vehicle_Setting, "排除 已死亡实体", {}, "", function(toggle)
    Nearby_Vehicle.setting.exclude_dead = toggle
end, true)



------------------------
-- 附近载具 恶搞选项
------------------------
local Nearby_Vehicle_Trolling = menu.list(Nearby_Vehicle_Options, "恶搞选项", {}, "")
----------------------
-- Delay Loop
----------------------
menu.toggle(Nearby_Vehicle_Trolling, "移除无敌", {}, "", function(toggle)
    Nearby_Vehicle.toggle_changed("remove_godmode", toggle)

    Nearby_Vehicle.callback["remove_godmode"] = function(vehicle)
        set_entity_godmode(vehicle, false)
    end
end)
menu.list_select(Nearby_Vehicle_Trolling, "车门", {}, "", {
    "无操作", "打开", "拆下", "删除"
}, 1, function(value)
    Nearby_Vehicle.select_changed("door", value)

    if value == 2 then
        Nearby_Vehicle.callback["door"] = function(vehicle)
            for i = 0, 3 do
                if VEHICLE.GET_IS_DOOR_VALID(vehicle, i) then
                    VEHICLE.SET_VEHICLE_DOOR_OPEN(vehicle, i, false, false)
                end
            end
        end
    elseif value == 3 then
        Nearby_Vehicle.callback["door"] = function(vehicle)
            for i = 0, 3 do
                if VEHICLE.GET_IS_DOOR_VALID(vehicle, i) then
                    VEHICLE.SET_VEHICLE_DOOR_BROKEN(vehicle, i, false)
                end
            end
        end
    elseif value == 4 then
        Nearby_Vehicle.callback["door"] = function(vehicle)
            for i = 0, 3 do
                if VEHICLE.GET_IS_DOOR_VALID(vehicle, i) then
                    VEHICLE.SET_VEHICLE_DOOR_BROKEN(vehicle, i, true)
                end
            end
        end
    end
end)
menu.list_select(Nearby_Vehicle_Trolling, "车窗", {}, "", {
    "无操作", "删除", "破坏"
}, 1, function(value)
    Nearby_Vehicle.select_changed("window", value)

    if value == 2 then
        Nearby_Vehicle.callback["window"] = function(vehicle)
            for i = 0, 7 do
                VEHICLE.REMOVE_VEHICLE_WINDOW(vehicle, i)
            end
        end
    elseif value == 3 then
        Nearby_Vehicle.callback["window"] = function(vehicle)
            for i = 0, 7 do
                VEHICLE.SMASH_VEHICLE_WINDOW(vehicle, i)
            end
        end
    end
end)
menu.toggle(Nearby_Vehicle_Trolling, "破坏引擎", {}, "", function(toggle)
    Nearby_Vehicle.toggle_changed("kill_engine", toggle)

    Nearby_Vehicle.callback["kill_engine"] = function(vehicle)
        VEHICLE.SET_VEHICLE_ENGINE_HEALTH(vehicle, -4000)
    end
end)
menu.toggle(Nearby_Vehicle_Trolling, "爆胎", {}, "", function(toggle)
    Nearby_Vehicle.toggle_changed("burst_tyre", toggle)

    Nearby_Vehicle.callback["burst_tyre"] = function(vehicle)
        for i = 0, 5 do
            if not VEHICLE.IS_VEHICLE_TYRE_BURST(vehicle, i, true) then
                VEHICLE.SET_VEHICLE_TYRE_BURST(vehicle, i, true, 1000.0)
            end
        end
    end
end)
menu.toggle(Nearby_Vehicle_Trolling, "布满灰尘", {}, "", function(toggle)
    Nearby_Vehicle.toggle_changed("full_dirt", toggle)

    Nearby_Vehicle.callback["full_dirt"] = function(vehicle)
        VEHICLE.SET_VEHICLE_DIRT_LEVEL(vehicle, 15.0)
    end
end)
menu.toggle(Nearby_Vehicle_Trolling, "分离车轮", {}, "", function(toggle)
    Nearby_Vehicle.toggle_changed("detach_wheel", toggle)

    Nearby_Vehicle.callback["detach_wheel"] = function(vehicle)
        for i = 0, 5 do
            entities.detach_wheel(vehicle, i)
        end
    end
end)
menu.toggle(Nearby_Vehicle_Trolling, "司机跳出载具", {}, "", function(toggle)
    Nearby_Vehicle.toggle_changed("leave_vehicle", toggle)

    Nearby_Vehicle.callback["leave_vehicle"] = function(vehicle)
        local ped = VEHICLE.GET_PED_IN_VEHICLE_SEAT(vehicle, -1)
        if ped ~= 0 and not TASK.GET_IS_TASK_ACTIVE(ped, 176) then
            TASK.TASK_LEAVE_VEHICLE(ped, vehicle, 4160)
        end
    end
end)
menu.list_select(Nearby_Vehicle_Trolling, "爆炸", {}, "", {
    "无操作", "匿名爆炸", "署名爆炸"
}, 1, function(value)
    Nearby_Vehicle.select_changed("explosion", value)

    if value == 2 then
        Nearby_Vehicle.callback["explosion"] = function(vehicle)
            local pos = ENTITY.GET_ENTITY_COORDS(vehicle)
            add_explosion(pos)
        end
    elseif value == 3 then
        Nearby_Vehicle.callback["explosion"] = function(vehicle)
            local pos = ENTITY.GET_ENTITY_COORDS(vehicle)
            add_owned_explosion(players.user_ped(), pos)
        end
    end
end)

menu.slider(Nearby_Vehicle_Trolling, "加速度", { "nearby_veh_forward_speed" }, "",
    0, 1000, 30, 10, function(value)
        Nearby_Vehicle.data.forward_speed = value
    end)
menu.toggle(Nearby_Vehicle_Trolling, "设置向前加速", {}, "", function(toggle)
    Nearby_Vehicle.toggle_changed("forward_speed", toggle)

    Nearby_Vehicle.callback["forward_speed"] = function(vehicle)
        VEHICLE.SET_VEHICLE_FORWARD_SPEED(vehicle, Nearby_Vehicle.data.forward_speed)
    end
end)

menu.slider(Nearby_Vehicle_Trolling, "最大速度", { "nearby_veh_max_speed" }, "",
    0, 1000, 0, 10, function(value)
        Nearby_Vehicle.data.max_speed = value
    end)
menu.toggle(Nearby_Vehicle_Trolling, "设置实体最大速度", {}, "", function(toggle)
    Nearby_Vehicle.toggle_changed("max_speed", toggle)

    Nearby_Vehicle.callback["max_speed"] = function(vehicle)
        ENTITY.SET_ENTITY_MAX_SPEED(vehicle, Nearby_Vehicle.data.max_speed)
    end
end)

menu.slider(Nearby_Vehicle_Trolling, "透明度", { "nearby_veh_alpha" },
    "Ranging from 0 to 255 but chnages occur after every 20 percent (after every 51).", 0, 255, 0, 5, function(value)
        Nearby_Vehicle.data.alpha = value
    end)
menu.toggle(Nearby_Vehicle_Trolling, "设置透明度", {}, "", function(toggle)
    Nearby_Vehicle.toggle_changed("alpha", toggle)

    Nearby_Vehicle.callback["alpha"] = function(vehicle)
        ENTITY.SET_ENTITY_ALPHA(vehicle, Nearby_Vehicle.data.alpha, false)
    end
end)

----------------------
-- No Delay Loop
----------------------
menu.divider(Nearby_Vehicle_Trolling, "")

menu.toggle_loop(Nearby_Vehicle_Trolling, "强行停止", {}, "", function()
    for k, vehicle in pairs(Nearby_Vehicle.get_vehicles()) do
        VEHICLE.SET_VEHICLE_FORWARD_SPEED(vehicle, 0)
    end
end)

menu.slider_float(Nearby_Vehicle_Trolling, "力场强度", { "nearby_veh_forcefield" }, "",
    100, 10000, 100, 100, function(value)
        Nearby_Vehicle.data.force_field = value * 0.01
    end)
menu.toggle_loop(Nearby_Vehicle_Trolling, "力场 (推开)", {}, "", function()
    for k, vehicle in pairs(Nearby_Vehicle.get_vehicles()) do
        local force = ENTITY.GET_ENTITY_COORDS(vehicle)
        v3.sub(force, ENTITY.GET_ENTITY_COORDS(players.user_ped()))
        v3.normalise(force)
        v3.mul(force, Nearby_Vehicle.data.force_field)
        ENTITY.APPLY_FORCE_TO_ENTITY(vehicle,
            3,
            force.x, force.y, force.z,
            0, 0, 0.5,
            0,
            false, false, true, false, false)
    end
end)

----------------------
-- Once
----------------------
menu.divider(Nearby_Vehicle_Trolling, "")

menu.action(Nearby_Vehicle_Trolling, "颠倒", {}, "", function()
    for k, vehicle in pairs(Nearby_Vehicle.get_vehicles()) do
        ENTITY.APPLY_FORCE_TO_ENTITY(vehicle,
            1,
            0.0, 0.0, 5.0,
            5.0, 0.0, 0.0,
            0,
            false, true, true, true, true)
    end
end)
menu.action(Nearby_Vehicle_Trolling, "随机喷漆", {}, "", function()
    for k, vehicle in pairs(Nearby_Vehicle.get_vehicles()) do
        local primary, secundary = get_random_colour(), get_random_colour()
        VEHICLE.SET_VEHICLE_CUSTOM_PRIMARY_COLOUR(vehicle, primary.r, primary.g, primary.b)
        VEHICLE.SET_VEHICLE_CUSTOM_SECONDARY_COLOUR(vehicle, secundary.r, secundary.g, secundary.b)
    end
end)

menu.slider(Nearby_Vehicle_Trolling, "上天高度", { "nearby_veh_launch" }, "",
    0, 1000, 30, 10, function(value)
        Nearby_Vehicle.data.launch_height = value
    end)
menu.action(Nearby_Vehicle_Trolling, "发射上天", {}, "", function()
    for k, vehicle in pairs(Nearby_Vehicle.get_vehicles()) do
        ENTITY.APPLY_FORCE_TO_ENTITY(vehicle,
            1,
            0.0, 0.0, Nearby_Vehicle.data.launch_height,
            0.0, 0.0, 0.0,
            0,
            false, false, true, false, false)
    end
end)



------------------------
-- 附近载具 友好选项
------------------------
local Nearby_Vehicle_Friendly = menu.list(Nearby_Vehicle_Options, "友好选项", {}, "")
----------------------
-- Delay Loop
----------------------
menu.toggle(Nearby_Vehicle_Friendly, "给予无敌", {}, "", function(toggle)
    Nearby_Vehicle.toggle_changed("give_godmode", toggle)

    Nearby_Vehicle.callback["give_godmode"] = function(vehicle)
        set_entity_godmode(vehicle, true)
    end
end)
menu.toggle(Nearby_Vehicle_Friendly, "修复载具", {}, "", function(toggle)
    Nearby_Vehicle.toggle_changed("fix_vehicle", toggle)

    Nearby_Vehicle.callback["fix_vehicle"] = function(vehicle)
        fix_vehicle(vehicle)
    end
end)
menu.toggle(Nearby_Vehicle_Friendly, "修复引擎", {}, "", function(toggle)
    Nearby_Vehicle.toggle_changed("fix_engine", toggle)

    Nearby_Vehicle.callback["fix_engine"] = function(vehicle)
        VEHICLE.SET_VEHICLE_ENGINE_HEALTH(vehicle, 1000)
    end
end)
menu.toggle(Nearby_Vehicle_Friendly, "修复车胎", {}, "", function(toggle)
    Nearby_Vehicle.toggle_changed("fix_tyre", toggle)

    Nearby_Vehicle.callback["fix_tyre"] = function(vehicle)
        for i = 0, 5 do
            VEHICLE.SET_VEHICLE_TYRE_FIXED(vehicle, i)
        end
    end
end)
menu.toggle(Nearby_Vehicle_Friendly, "修复车窗", {}, "", function(toggle)
    Nearby_Vehicle.toggle_changed("fix_window", toggle)

    Nearby_Vehicle.callback["fix_window"] = function(vehicle)
        for i = 0, 7 do
            VEHICLE.FIX_VEHICLE_WINDOW(vehicle, i)
        end
    end
end)
menu.toggle(Nearby_Vehicle_Friendly, "清洁外观", {}, "", function(toggle)
    Nearby_Vehicle.toggle_changed("clean_dirt", toggle)

    Nearby_Vehicle.callback["clean_dirt"] = function(vehicle)
        VEHICLE.SET_VEHICLE_DIRT_LEVEL(vehicle, 0.0)
    end
end)
menu.toggle(Nearby_Vehicle_Friendly, "升级载具", {}, "", function(toggle)
    Nearby_Vehicle.toggle_changed("upgrade_vehicle", toggle)

    Nearby_Vehicle.callback["upgrade_vehicle"] = function(vehicle)
        upgrade_vehicle(vehicle)
    end
end)



----------------------
-- 全部范围
----------------------
menu.divider(Nearby_Vehicle_Options, "全部范围")

menu.action(Nearby_Vehicle_Options, "解锁车门和打开引擎", { "unlock_vehs_door" }, "", function()
    for k, vehicle in pairs(entities.get_all_vehicles_as_handles()) do
        unlock_vehicle_doors(vehicle)

        VEHICLE.SET_VEHICLE_IS_CONSIDERED_BY_PLAYER(vehicle, true)
        VEHICLE.SET_VEHICLE_UNDRIVEABLE(vehicle, false)
        VEHICLE.SET_VEHICLE_ENGINE_ON(vehicle, true, true, false)

        VEHICLE.SET_VEHICLE_IS_WANTED(vehicle, false)
        VEHICLE.SET_VEHICLE_INFLUENCES_WANTED_LEVEL(vehicle, false)
        VEHICLE.SET_VEHICLE_HAS_BEEN_OWNED_BY_PLAYER(vehicle, true)
        VEHICLE.SET_VEHICLE_IS_STOLEN(vehicle, false)
        VEHICLE.SET_POLICE_FOCUS_WILL_TRACK_VEHICLE(vehicle, false)

        ENTITY.FREEZE_ENTITY_POSITION(vehicle, false)
    end
end)
menu.action(Nearby_Vehicle_Options, "打开左右车门和引擎", { "open_vehs_door" }, "", function()
    for k, vehicle in pairs(entities.get_all_vehicles_as_handles()) do
        VEHICLE.SET_VEHICLE_ENGINE_ON(vehicle, true, true, false)
        VEHICLE.SET_VEHICLE_DOOR_OPEN(vehicle, 0, false, false)
        VEHICLE.SET_VEHICLE_DOOR_OPEN(vehicle, 1, false, false)
    end
end)
menu.action(Nearby_Vehicle_Options, "拆下左右车门和打开引擎", { "broken_vehs_door" }, "", function()
    for k, vehicle in pairs(entities.get_all_vehicles_as_handles()) do
        VEHICLE.SET_VEHICLE_ENGINE_ON(vehicle, true, true, false)
        VEHICLE.SET_VEHICLE_DOOR_BROKEN(vehicle, 0, false)
        VEHICLE.SET_VEHICLE_DOOR_BROKEN(vehicle, 1, false)
    end
end)

--#endregion Nearby Vehicle





--#region Nearby Ped

--------------------------
--------- 附近NPC ---------
--------------------------

local Nearby_Ped = {
    can_handler_run = false,
    is_handler_runing = false,

    setting = {
        radius = 60.0,
        ped_select = 1,
        time_delay = 1000,
        exclude_ped_in_vehicle = true,
        exclude_friendly = true,
        exclude_mission = true,
        exclude_dead = true,
    },
    toggles = {},
    data = {
        forward_degree = 30,
        drop_money_amount = 100,
        weapon_hash = 4130548542,
        launch_height = 30.0,
        force_field = {
            strength = 1.0,
            direction = 1,
            ragdoll = true,
        },
    },
    callback = {},
}

function Nearby_Ped.check_ped(ped)
    -- 排除 玩家
    if is_player_ped(ped) then
        return false
    end
    -- 排除 载具内NPC
    if Nearby_Ped.setting.exclude_ped_in_vehicle and PED.IS_PED_IN_ANY_VEHICLE(ped, false) then
        return false
    end
    -- 排除 友好NPC
    if Nearby_Ped.setting.exclude_friendly and is_friendly_ped(ped) then
        return false
    end
    -- 排除 任务NPC
    if Nearby_Ped.setting.exclude_mission and ENTITY.IS_ENTITY_A_MISSION_ENTITY(ped) then
        return false
    end
    -- 排除 已死亡实体
    if Nearby_Ped.setting.exclude_dead and ENTITY.IS_ENTITY_DEAD(ped) then
        return false
    end
    -- 敌对NPC
    if Nearby_Ped.setting.ped_select == 2 and not is_hostile_ped(ped) then
        return false
    end

    return true
end

function Nearby_Ped.get_peds()
    local peds = {}
    local player_pos = ENTITY.GET_ENTITY_COORDS(players.user_ped())
    local radius = Nearby_Ped.setting.radius

    for k, ent in pairs(entities.get_all_peds_as_handles()) do
        local ped = 0

        local ent_pos = ENTITY.GET_ENTITY_COORDS(ent)
        if radius <= 0 then
            ped = ent
        elseif v3.distance(player_pos, ent_pos) <= radius then
            ped = ent
        end

        if ped ~= 0 and Nearby_Ped.check_ped(ped) then
            table.insert(peds, ped)
        end
    end
    return peds
end

function Nearby_Ped.toggle_changed(key, toggle)
    Nearby_Ped.toggles[key] = toggle

    Nearby_Ped.switch_tick_handler()
end

function Nearby_Ped.switch_tick_handler()
    local is_all_false = true
    for key, bool in pairs(Nearby_Ped.toggles) do
        if bool then
            is_all_false = false
            break
        end
    end
    if is_all_false then
        Nearby_Ped.can_handler_run = false
    else
        if not Nearby_Ped.is_handler_running then
            Nearby_Ped.can_handler_run = true
            Nearby_Ped.control_peds()
        end
    end
end

function Nearby_Ped.control_peds()
    util.create_tick_handler(function()
        if not Nearby_Ped.can_handler_run then
            Nearby_Ped.is_handler_running = false
            util.log("[RScript] Control Nearby Peds: Stop Tick Handler")
            return false
        end

        Nearby_Ped.is_handler_runing = true

        for _, ped in pairs(Nearby_Ped.get_peds()) do
            RequestControl(ped)

            for key, bool in pairs(Nearby_Ped.toggles) do
                if bool then
                    if Nearby_Ped.callback[key] ~= nil then
                        Nearby_Ped.callback[key](ped)
                    end
                end
            end
        end

        util.yield(Nearby_Ped.setting.time_delay)
    end)
end

--------------
-- Menu
--------------
local Nearby_Ped_Options = menu.list(Entity_options, "管理附近NPC", {}, "")

menu.slider_float(Nearby_Ped_Options, "范围半径", { "radius_nearby_ped" },
    "若半径是0, 则为全部范围", 0, 100000, 6000, 1000, function(value)
        Nearby_Ped.setting.radius = value * 0.01
    end)
menu.toggle_loop(Nearby_Ped_Options, "绘制范围", {}, "", function()
    local coords = ENTITY.GET_ENTITY_COORDS(players.user_ped())
    DRAW_MARKER_SPHERE(coords, Nearby_Ped.setting.radius)
end)
menu.list_select(Nearby_Ped_Options, "NPC类型", {}, "", {
    { "全部NPC", {}, "" },
    { "敌对NPC", {}, "" },
}, 1, function(value)
    Nearby_Ped.setting.ped_select = value
end)

local Nearby_Ped_Setting = menu.list(Nearby_Ped_Options, "设置", {}, "")

menu.slider(Nearby_Ped_Setting, "循环时间间隔", { "delay_nearby_ped" }, "单位: ms",
    0, 5000, 1000, 100, function(value)
        Nearby_Ped.setting.time_delay = value
    end)
menu.divider(Nearby_Ped_Setting, "排除")
menu.toggle(Nearby_Ped_Setting, "排除 载具内NPC", {}, "", function(toggle)
    Nearby_Ped.setting.exclude_ped_in_vehicle = toggle
end, true)
menu.toggle(Nearby_Ped_Setting, "排除 友好NPC", {}, "", function(toggle)
    Nearby_Ped.setting.exclude_friendly = toggle
end, true)
menu.toggle(Nearby_Ped_Setting, "排除 任务NPC", {}, "", function(toggle)
    Nearby_Ped.setting.exclude_mission = toggle
end, true)
menu.toggle(Nearby_Ped_Setting, "排除 已死亡实体", {}, "", function(toggle)
    Nearby_Ped.setting.exclude_dead = toggle
end, true)



------------------------
--  附近NPC 恶搞选项
------------------------
local Nearby_Ped_Trolling = menu.list(Nearby_Ped_Options, "恶搞选项", {}, "")
--------------------
-- Delay Loop
--------------------
menu.slider(Nearby_Ped_Trolling, "推进程度", { "nearby_ped_forward_degree" }, "",
    0, 1000, 30, 10, function(value)
        Nearby_Ped.data.forward_speed = value
    end)
menu.toggle(Nearby_Ped_Trolling, "设置向前推进", {}, "", function(toggle)
    Nearby_Ped.toggle_changed("force_forward", toggle)

    Nearby_Ped.callback["force_forward"] = function(ped)
        ENTITY.SET_ENTITY_MAX_SPEED(ped, 99999)
        local vector = ENTITY.GET_ENTITY_FORWARD_VECTOR(ped)
        local force = Vector.mult(vector, Nearby_Ped.data.forward_degree)
        ENTITY.APPLY_FORCE_TO_ENTITY(ped,
            1,
            force.x, force.y, force.z,
            0.0, 0.0, 0.0,
            1,
            false, true, true, true, true)
    end
end)
menu.toggle(Nearby_Ped_Trolling, "丢弃武器", {}, "", function(toggle)
    Nearby_Ped.toggle_changed("drop_weapon", toggle)

    Nearby_Ped.callback["drop_weapon"] = function(ped)
        WEAPON.SET_PED_DROPS_WEAPONS_WHEN_DEAD(ped)
        WEAPON.SET_PED_AMMO_TO_DROP(ped, 9999)
        WEAPON.SET_PED_DROPS_WEAPON(ped)
    end
end)
menu.toggle(Nearby_Ped_Trolling, "爆头", {}, "", function(toggle)
    Nearby_Ped.toggle_changed("explode_head", toggle)

    Nearby_Ped.callback["explode_head"] = function(ped)
        local weaponHash = util.joaat("WEAPON_APPISTOL")
        PED.EXPLODE_PED_HEAD(ped, weaponHash)
    end
end)
menu.toggle(Nearby_Ped_Trolling, "摔倒", {}, "", function(toggle)
    Nearby_Ped.toggle_changed("ragdoll", toggle)

    Nearby_Ped.callback["ragdoll"] = function(ped)
        PED.SET_PED_TO_RAGDOLL(ped, 500, 500, 0, false, false, false)
    end
end)
menu.toggle(Nearby_Ped_Trolling, "忽略临时事件", {}, "", function(toggle)
    Nearby_Ped.toggle_changed("block_temporary", toggle)

    Nearby_Ped.callback["block_temporary"] = function(ped)
        PED.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(ped, true)
        TASK.TASK_SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(ped, true)
        PED.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS_FOR_AMBIENT_PEDS_THIS_FRAME(true)
    end
end)
menu.toggle(Nearby_Ped_Trolling, "清除任务", {}, "", function(toggle)
    Nearby_Ped.toggle_changed("clear_task", toggle)

    Nearby_Ped.callback["clear_task"] = function(ped)
        TASK.CLEAR_PED_TASKS(ped)
        TASK.CLEAR_DEFAULT_PRIMARY_TASK(ped)
        TASK.CLEAR_PED_SECONDARY_TASK(ped)
    end
end)
menu.toggle(Nearby_Ped_Trolling, "立即清除任务", {}, "", function(toggle)
    Nearby_Ped.toggle_changed("clear_task_immediately", toggle)

    Nearby_Ped.callback["clear_task_immediately"] = function(ped)
        TASK.CLEAR_PED_TASKS_IMMEDIATELY(ped)
    end
end)

--------------------
-- Once
--------------------
menu.divider(Nearby_Ped_Trolling, "")

menu.slider(Nearby_Ped_Trolling, "上天高度", { "nearby_ped_launch" }, "",
    0, 1000, 30, 10, function(value)
        Nearby_Ped.data.launch_height = value
    end)
menu.action(Nearby_Ped_Trolling, "发射上天", {}, "", function()
    for k, ped in pairs(Nearby_Ped.get_peds()) do
        ENTITY.APPLY_FORCE_TO_ENTITY(ped,
            1,
            0.0, 0.0, Nearby_Ped.data.launch_height,
            0.0, 0.0, 0.0,
            0,
            false, false, true, false, false)
    end
end)
menu.action(Nearby_Ped_Trolling, "坠落爆炸", {}, "", function()
    for k, ped in pairs(Nearby_Ped.get_peds()) do
        util.create_thread(function()
            fall_entity_explosion(ped)
        end)
    end
end)

--------------------
-- No Delay Loop
--------------------
menu.divider(Nearby_Ped_Trolling, "力场")

menu.slider_float(Nearby_Ped_Trolling, "强度", { "nearby_ped_forcefield_strength" }, "",
    100, 10000, 100, 100, function(value)
        Nearby_Ped.data.force_field.strength = value * 0.01
    end)
menu.textslider_stateful(Nearby_Ped_Trolling, "方向", {}, "", { "推开", "拉进" }, function(value)
    Nearby_Ped.data.force_field.direction = value
end)
menu.toggle(Nearby_Ped_Trolling, "摔倒", {}, "", function(toggle)
    Nearby_Ped.data.force_field.ragdoll = toggle
end, true)
menu.toggle_loop(Nearby_Ped_Trolling, "开启力场", {}, "", function()
    for k, ped in pairs(Nearby_Ped.get_peds()) do
        local force = ENTITY.GET_ENTITY_COORDS(ped)
        v3.sub(force, ENTITY.GET_ENTITY_COORDS(players.user_ped()))
        v3.normalise(force)
        v3.mul(force, Nearby_Ped.data.force_field.strength)

        if Nearby_Ped.data.force_field.direction == 2 then
            v3.mul(force, -1)
        end
        if Nearby_Ped.data.force_field.ragdoll then
            PED.SET_PED_TO_RAGDOLL(ped, 500, 500, 0, false, false, false)
        end
        ENTITY.APPLY_FORCE_TO_ENTITY(ped,
            3,
            force.x, force.y, force.z,
            0, 0, 0.5,
            0,
            false, false, true, false, false)
    end
end)



------------------------
--  附近NPC 友好选项
------------------------
local Nearby_Ped_Friendly = menu.list(Nearby_Ped_Options, "友好选项", {}, "")
--------------------
-- Delay Loop
--------------------
menu.slider(Nearby_Ped_Friendly, "现金数量", { "nearby_ped_drop_money_amonut" }, "",
    0, 2000, 100, 100, function(value)
        Nearby_Ped.data.drop_money_amount = value
    end)
menu.toggle(Nearby_Ped_Friendly, "设置掉落现金", {}, "", function(toggle)
    Nearby_Ped.toggle_changed("drop_money", toggle)

    Nearby_Ped.callback["drop_money"] = function(ped)
        PED.SET_PED_MONEY(ped, Nearby_Ped.data.drop_money_amount)
        PED.SET_AMBIENT_PEDS_DROP_MONEY(true)
    end
end)
menu.list_select(Nearby_Ped_Friendly, "武器", {}, "", Weapon_Common.ListItem, 1, function(value)
    Nearby_Ped.data.weapon_hash = util.joaat(Weapon_Common.ModelList[value])
end)
menu.toggle(Nearby_Ped_Friendly, "给予武器", {}, "", function(toggle)
    Nearby_Ped.toggle_changed("give_weapon", toggle)

    Nearby_Ped.callback["give_weapon"] = function(ped)
        WEAPON.GIVE_WEAPON_TO_PED(ped, Nearby_Ped.data.weapon_hash, -1, false, true)
        WEAPON.SET_CURRENT_PED_WEAPON(ped, Nearby_Ped.data.weapon_hash, false)
    end
end)



------------------------
--  附近NPC 作战能力
------------------------
local Nearby_Ped_Combat = menu.list(Nearby_Ped_Options, "作战能力", {}, "")

Nearby_Ped.Combat = {
    health = 100,
    investigate = 1,
    weapon = 1,
    ability = 1,
    range = 1,
    movement = 1,
    target_loss_response = 1,
    behavior = 1,
}

menu.toggle_loop(Nearby_Ped_Combat, "开启", {}, "", function()
    local combat_data = Nearby_Ped.Combat

    for k, ped in pairs(Nearby_Ped.get_peds()) do
        -- 生命值
        if combat_data.health >= 100 then
            SET_ENTITY_HEALTH(ped, combat_data.health)
        end
        -- 侦查能力
        if combat_data.investigate > 1 then
            if combat_data.investigate == 2 then
                -- 弱化
                PED.SET_PED_SEEING_RANGE(ped, 0)
                PED.SET_PED_HEARING_RANGE(ped, 0)
                PED.SET_PED_ID_RANGE(ped, 0)

                PED.SET_PED_VISUAL_FIELD_PERIPHERAL_RANGE(ped, 0)
                PED.SET_PED_VISUAL_FIELD_MIN_ANGLE(ped, 0)
                PED.SET_PED_VISUAL_FIELD_MAX_ANGLE(ped, 0)
                PED.SET_PED_VISUAL_FIELD_MIN_ELEVATION_ANGLE(ped, 0)
                PED.SET_PED_VISUAL_FIELD_MAX_ELEVATION_ANGLE(ped, 0)
                PED.SET_PED_VISUAL_FIELD_CENTER_ANGLE(ped, 0)

                PED.SET_PED_HIGHLY_PERCEPTIVE(ped, false)

                PED.SET_PED_COMBAT_ATTRIBUTES(ped, 14, false) -- CA_CAN_INVESTIGATE
                PED.SET_PED_COMBAT_ATTRIBUTES(ped, 79, false) -- CA_WILL_GENERATE_DEAD_PED_SEEN_SCRIPT_EVENTS
                PED.SET_PED_COMBAT_ATTRIBUTES(ped, 80, false) -- CA_USE_MAX_SENSE_RANGE_WHEN_RECEIVING_EVENTS

                PED.SET_COMBAT_FLOAT(ped, 14, 0)              -- CCF_BULLET_IMPACT_DETECTION_RANGE
                PED.SET_COMBAT_FLOAT(ped, 21, 0)              -- CCF_MAX_DISTANCE_TO_HEAR_EVENTS
                PED.SET_COMBAT_FLOAT(ped, 22, 0)              -- CCF_MAX_DISTANCE_TO_HEAR_EVENTS_USING_LOS

                PED.SET_PED_CONFIG_FLAG(ped, 213, false)      -- PCF_ListensToSoundEvents
                PED.SET_PED_CONFIG_FLAG(ped, 294, true)       -- PCF_DisableShockingEvents
                PED.SET_PED_CONFIG_FLAG(ped, 315, false)      -- PCF_CheckLoSForSoundEvents
            else
                -- 强化
                PED.SET_PED_SEEING_RANGE(ped, 500)
                PED.SET_PED_HEARING_RANGE(ped, 500)
                PED.SET_PED_ID_RANGE(ped, 500)

                PED.SET_PED_VISUAL_FIELD_PERIPHERAL_RANGE(ped, 100)
                PED.SET_PED_VISUAL_FIELD_MIN_ANGLE(ped, 90)
                PED.SET_PED_VISUAL_FIELD_MAX_ANGLE(ped, 90)
                PED.SET_PED_VISUAL_FIELD_MIN_ELEVATION_ANGLE(ped, 90)
                PED.SET_PED_VISUAL_FIELD_MAX_ELEVATION_ANGLE(ped, 90)
                PED.SET_PED_VISUAL_FIELD_CENTER_ANGLE(ped, 90)

                PED.SET_PED_HIGHLY_PERCEPTIVE(ped, true)

                PED.SET_PED_COMBAT_ATTRIBUTES(ped, 14, true) -- CA_CAN_INVESTIGATE
                PED.SET_PED_COMBAT_ATTRIBUTES(ped, 79, true) -- CA_WILL_GENERATE_DEAD_PED_SEEN_SCRIPT_EVENTS
                PED.SET_PED_COMBAT_ATTRIBUTES(ped, 80, true) -- CA_USE_MAX_SENSE_RANGE_WHEN_RECEIVING_EVENTS

                PED.SET_COMBAT_FLOAT(ped, 14, 100)           -- CCF_BULLET_IMPACT_DETECTION_RANGE
                PED.SET_COMBAT_FLOAT(ped, 21, 100)           -- CCF_MAX_DISTANCE_TO_HEAR_EVENTS
                PED.SET_COMBAT_FLOAT(ped, 22, 100)           -- CCF_MAX_DISTANCE_TO_HEAR_EVENTS_USING_LOS

                PED.SET_PED_CONFIG_FLAG(ped, 213, true)      -- PCF_ListensToSoundEvents
                PED.SET_PED_CONFIG_FLAG(ped, 294, false)     -- PCF_DisableShockingEvents
                PED.SET_PED_CONFIG_FLAG(ped, 315, true)      -- PCF_CheckLoSForSoundEvents
            end
        end
        -- 武器能力
        if combat_data.weapon > 1 then
            if combat_data.weapon == 2 then
                -- 弱化
                PED.SET_PED_ACCURACY(ped, 0)
                PED.SET_PED_SHOOT_RATE(ped, 0)
                PED.SET_PED_COMBAT_ATTRIBUTES(ped, 27, false) -- CA_PERFECT_ACCURACY
                PED.SET_COMBAT_FLOAT(ped, 6, 0)               -- CCF_WEAPON_ACCURACY
            else
                -- 强化
                PED.SET_PED_ACCURACY(ped, 100)
                PED.SET_PED_SHOOT_RATE(ped, 1000)
                PED.SET_PED_COMBAT_ATTRIBUTES(ped, 27, true) -- CA_PERFECT_ACCURACY
                PED.SET_COMBAT_FLOAT(ped, 6, 1.0)            -- CCF_WEAPON_ACCURACY
            end
        end
        -- 作战技能
        if combat_data.ability > 1 then
            PED.SET_PED_COMBAT_ABILITY(ped, combat_data.ability - 2)
        end
        -- 作战范围
        if combat_data.range > 1 then
            PED.SET_PED_COMBAT_RANGE(ped, combat_data.range - 2)
        end
        -- 作战走位
        if combat_data.movement > 1 then
            PED.SET_PED_COMBAT_MOVEMENT(ped, combat_data.movement - 2)
        end
        -- 失去目标时反应
        if combat_data.target_loss_response > 1 then
            PED.SET_PED_TARGET_LOSS_RESPONSE(ped, combat_data.target_loss_response - 2)
        end
        -- 其它行为
        if Nearby_Ped.Combat.behavior == 2 then
            PED.STOP_PED_WEAPON_FIRING_WHEN_DROPPED(ped)
            PED.DISABLE_PED_INJURED_ON_GROUND_BEHAVIOUR(ped)
            PED.REMOVE_PED_DEFENSIVE_AREA(ped, false)
        end
    end

    util.yield(Nearby_Ped.setting.time_delay)
end)

menu.divider(Nearby_Ped_Combat, "设置")
menu.slider(Nearby_Ped_Combat, "生命值", { "nearby_ped_combat_health" }, "数值低于100则不进行修改",
    0, 10000, 100, 100, function(value)
        Nearby_Ped.Combat.health = value
    end)
menu.list_select(Nearby_Ped_Combat, "侦查能力", {},
    "视力、听力、识别、锥形视野、视野角度、高度警觉性 等等", {
        { "无操作", {}, "" },
        { "弱化", {}, "" },
        { "强化", {}, "" },
    }, 1, function(value)
        Nearby_Ped.Combat.investigate = value
    end)
menu.list_select(Nearby_Ped_Combat, "武器能力", {},
    "精准度、射击频率", {
        { "无操作", {}, "" },
        { "弱化", {}, "" },
        { "强化", {}, "" },
    }, 1, function(value)
        Nearby_Ped.Combat.weapon = value
    end)
menu.list_select(Nearby_Ped_Combat, "作战技能", {}, "", {
    "无操作", "弱", "普通", "专业"
}, 1, function(value)
    Nearby_Ped.Combat.ability = value
end)
menu.list_select(Nearby_Ped_Combat, "作战范围", {}, "", {
    "无操作", "近", "中等", "远", "非常远"
}, 1, function(value)
    Nearby_Ped.Combat.range = value
end)
menu.list_select(Nearby_Ped_Combat, "作战走位", {}, "", {
    "无操作", "站立", "防卫", "会前进", "会后退"
}, 1, function(value)
    Nearby_Ped.Combat.movement = value
end)
menu.list_select(Nearby_Ped_Combat, "失去目标时反应", {}, "", {
    "无操作", "退出战斗", "从不失去目标", "寻找目标"
}, 1, function(value)
    Nearby_Ped.Combat.target_loss_response = value
end)
menu.list_select(Nearby_Ped_Combat, "其它行为", {},
    "武器掉落时走火、受伤时在地面打滚、防卫区域", {
        { "无操作", {}, "" },
        { "禁用", {}, "" },
    }, 1, function(value)
        Nearby_Ped.Combat.behavior = value
    end)


--#endregion Nearby Ped





--#region Nearby Area

------------------------
-------- 附近区域 --------
------------------------
local Nearby_Area_options = menu.list(Entity_options, "管理附近区域", {}, "")

local nearby_area = {
    radius = 100.0
}

menu.slider_float(Nearby_Area_options, "范围半径", { "radius_nearby_area" }, "", 0, 100000, 10000, 1000,
    function(value)
        nearby_area.radius = value * 0.01
    end)
menu.toggle_loop(Nearby_Area_options, "绘制范围", {}, "", function()
    local coords = ENTITY.GET_ENTITY_COORDS(players.user_ped())
    DRAW_MARKER_SPHERE(coords, nearby_area.radius)
end)


---------------
-- 清理区域
---------------
local Nearby_Area_Clear = menu.list(Nearby_Area_options, "清理区域", {}, "MISC::CLEAR_AREA")

local cls_broadcast = 0
menu.toggle_loop(Nearby_Area_Clear, "清理区域", { "cls_area" }, "清理区域内所有东西", function()
    local coords = ENTITY.GET_ENTITY_COORDS(players.user_ped())
    MISC.CLEAR_AREA(coords.x, coords.y, coords.z, nearby_area.radius, true, false, false, cls_broadcast)
end)
menu.toggle_loop(Nearby_Area_Clear, "清理载具", { "cls_veh" }, "清理区域内所有载具", function()
    local coords = ENTITY.GET_ENTITY_COORDS(players.user_ped())
    MISC.CLEAR_AREA_OF_VEHICLES(coords.x, coords.y, coords.z, nearby_area.radius, false, false, false, false,
        cls_broadcast, false, 0)
end)
menu.toggle_loop(Nearby_Area_Clear, "清理行人", { "cls_ped" }, "清理区域内所有行人", function()
    local coords = ENTITY.GET_ENTITY_COORDS(players.user_ped())
    MISC.CLEAR_AREA_OF_PEDS(coords.x, coords.y, coords.z, nearby_area.radius, cls_broadcast)
end)
menu.toggle_loop(Nearby_Area_Clear, "清理警察", { "cls_cop" }, "清理区域内所有警察", function()
    local coords = ENTITY.GET_ENTITY_COORDS(players.user_ped())
    MISC.CLEAR_AREA_OF_COPS(coords.x, coords.y, coords.z, nearby_area.radius, cls_broadcast)
end)
menu.toggle_loop(Nearby_Area_Clear, "清理物体", { "cls_obj" }, "清理区域内所有物体", function()
    local coords = ENTITY.GET_ENTITY_COORDS(players.user_ped())
    MISC.CLEAR_AREA_OF_OBJECTS(coords.x, coords.y, coords.z, nearby_area.radius, cls_broadcast)
end)
menu.toggle_loop(Nearby_Area_Clear, "清理投掷物", { "cls_proj" }, "清理区域内所有子弹、炮弹、投掷物等",
    function()
        local coords = ENTITY.GET_ENTITY_COORDS(players.user_ped())
        MISC.CLEAR_AREA_OF_PROJECTILES(coords.x, coords.y, coords.z, nearby_area.radius, cls_broadcast)
    end)
menu.divider(Nearby_Area_Clear, "设置")
menu.toggle(Nearby_Area_Clear, "同步到其它玩家", { "cls_broadcast" }, "", function(toggle)
    cls_broadcast = toggle and 1 or 0
    util.toast("清理区域 网络同步: " .. tostring(toggle and "开" or "关"))
end)


---------------
-- 射击区域
---------------
local Nearby_Area_Shoot = menu.list(Nearby_Area_options, "射击区域", {}, "若半径是0,则为全部范围")

local nearby_area_shoot = {
    -- 目标
    target = {
        ped = 2,
        ped_head = true,
        vehicle = 1,
        object = 1,
        except_dead = true,
    },
    -- 设置
    weapon_hash = "PLAYER_CURRENT_WEAPON",
    is_owned = true,
    damage = 1000,
    speed = 1000,
    is_audible = true,
    is_invisible = false,
    start_from_player = false,
    x = 0.0,
    y = 0.0,
    z = 0.1,
    delay = 1000,
}

--------
local Nearby_Area_Shoot_Target = menu.list(Nearby_Area_Shoot, "目标", {}, "")

menu.list_select(Nearby_Area_Shoot_Target, "NPC", {}, "", {
    { "关闭", },
    { "全部NPC (排除友好)", },
    { "敌对NPC", },
    { "步行NPC", },
    { "载具内NPC", },
    { "全部NPC", },
}, 2, function(value)
    nearby_area_shoot.target.ped = value
end)
menu.toggle(Nearby_Area_Shoot_Target, "射击NPC头部", {}, "", function(toggle)
    nearby_area_shoot.target.ped_head = toggle
end, true)
menu.list_select(Nearby_Area_Shoot_Target, "载具", {}, "默认排除玩家载具", {
    { "关闭", },
    { "全部载具", {}, "" },
    { "敌对载具", {}, "敌对NPC驾驶或者有敌对地图标识的载具" },
    { "NPC载具", {}, "有NPC作为司机驾驶的载具" },
    { "空载具", {}, "没有任何NPC驾驶的载具" },
}, 1, function(value)
    nearby_area_shoot.target.vehicle = value
end)
menu.list_select(Nearby_Area_Shoot_Target, "物体", {}, "", {
    { "关闭" },
    { "敌对物体", {}, "有敌对地图标记点的物体" },
    { "标记点物体", {}, "有地图标记点的物体" },
}, 1, function(value)
    nearby_area_shoot.target.object = value
end)
menu.toggle(Nearby_Area_Shoot_Target, "排除死亡实体", {}, "", function(toggle)
    nearby_area_shoot.target.except_dead = toggle
end, true)

--------
local Nearby_Area_Shoot_Setting = menu.list(Nearby_Area_Shoot, "设置", {}, "")

local Nearby_Area_Shoot_Weapon = rs_menu.all_weapons_without_melee(Nearby_Area_Shoot_Setting, "武器", {}, "",
    function(hash)
        nearby_area_shoot.weapon_hash = hash
    end, true)
rs_menu.current_weapon_action(Nearby_Area_Shoot_Weapon, "玩家当前使用的武器", function()
    nearby_area_shoot.weapon_hash = "PLAYER_CURRENT_WEAPON"
end, true)

menu.toggle(Nearby_Area_Shoot_Setting, "署名射击", {}, "以玩家名义", function(toggle)
    nearby_area_shoot.is_owned = toggle
end, true)
menu.slider(Nearby_Area_Shoot_Setting, "伤害", { "nearby_area_shoot_damage" }, "", 0, 10000, 1000, 100,
    function(value)
        nearby_area_shoot.damage = value
    end)
menu.slider(Nearby_Area_Shoot_Setting, "速度", { "nearby_area_shoot_speed" }, "", 0, 10000, 1000, 100,
    function(value)
        nearby_area_shoot.speed = value
    end)

menu.divider(Nearby_Area_Shoot_Setting, "起始射击位置偏移")
menu.toggle(Nearby_Area_Shoot_Setting, "从玩家位置起始射击", {},
    "如果关闭,则起始位置为目标位置+偏移\n如果开启,建议偏移Z>1.0", function(toggle)
        nearby_area_shoot.start_from_player = toggle
    end)
menu.slider_float(Nearby_Area_Shoot_Setting, "X", { "nearby_area_shoot_x" }, "", -10000, 10000, 0, 10,
    function(value)
        value = value * 0.01
        nearby_area_shoot.x = value
    end)
menu.slider_float(Nearby_Area_Shoot_Setting, "Y", { "nearby_area_shoot_y" }, "", -10000, 10000, 0, 10,
    function(value)
        value = value * 0.01
        nearby_area_shoot.y = value
    end)
menu.slider_float(Nearby_Area_Shoot_Setting, "Z", { "nearby_area_shoot_z" }, "", -10000, 10000, 10, 10,
    function(value)
        value = value * 0.01
        nearby_area_shoot.z = value
    end)

--------
function nearby_area_shoot.checkPed(ped)
    if nearby_area_shoot.target.except_dead and ENTITY.IS_ENTITY_DEAD(ped) then
        return false
    end

    if not is_player_ped(ped) then
        local target_select = nearby_area_shoot.target.ped
        if target_select == 2 and not is_friendly_ped(ped) then
            return true
        elseif target_select == 3 and is_hostile_ped(ped) then
            return true
        elseif target_select == 4 and not PED.IS_PED_IN_ANY_VEHICLE(ped, false) then
            return true
        elseif target_select == 5 and PED.IS_PED_IN_ANY_VEHICLE(ped, false) then
            return true
        elseif target_select == 6 then
            return true
        end
    end

    return false
end

function nearby_area_shoot.checkVehicle(vehicle)
    if nearby_area_shoot.target.except_dead and ENTITY.IS_ENTITY_DEAD(vehicle) then
        return false
    end

    if not is_player_vehicle(vehicle) then
        local target_select = nearby_area_shoot.target.vehicle
        if target_select == 2 then
            return true
        elseif target_select == 3 and IS_HOSTILE_ENTITY(vehicle) then
            return true
        elseif target_select == 4 and not VEHICLE.IS_VEHICLE_SEAT_FREE(vehicle, -1, false) then
            return true
        elseif target_select == 5 and VEHICLE.IS_VEHICLE_SEAT_FREE(vehicle, -1, false) then
            return true
        end
    end

    return false
end

function nearby_area_shoot.checkObject(object)
    if nearby_area_shoot.target.except_dead and ENTITY.IS_ENTITY_DEAD(object) then
        return false
    end

    local blip = HUD.GET_BLIP_FROM_ENTITY(object)
    if HUD.DOES_BLIP_EXIST(blip) then
        local target_select = nearby_area_shoot.target.object
        if target_select == 2 and IS_HOSTILE_ENTITY(object) then
            return true
        elseif target_select == 3 then
            return true
        end
    end

    return false
end

function nearby_area_shoot.Shoot(start_pos, end_pos, weaponHash)
    local owner = 0
    if nearby_area_shoot.is_owned then
        owner = players.user_ped()
    end

    local ignore_entity = players.user_ped()
    if PED.IS_PED_IN_ANY_VEHICLE(players.user_ped(), false) then
        ignore_entity = PED.GET_VEHICLE_PED_IS_IN(players.user_ped(), false)
    end

    MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS_IGNORE_ENTITY(
        start_pos.x, start_pos.y, start_pos.z,
        end_pos.x, end_pos.y, end_pos.z,
        nearby_area_shoot.damage,
        false,
        weaponHash,
        owner,
        nearby_area_shoot.is_audible,
        nearby_area_shoot.is_invisible,
        nearby_area_shoot.speed,
        ignore_entity,
        0)
end

function nearby_area_shoot.Handle(action)
    --if action == "shoot" then
    local weaponHash = nearby_area_shoot.weapon_hash
    if weaponHash == "PLAYER_CURRENT_WEAPON" then
        local pWeapon = memory.alloc_int()
        WEAPON.GET_CURRENT_PED_WEAPON(players.user_ped(), pWeapon, true)
        weaponHash = memory.read_int(pWeapon)
    end
    if not WEAPON.HAS_WEAPON_ASSET_LOADED(weaponHash) then
        request_weapon_asset(weaponHash)
    end
    --end

    --- PED ---
    if nearby_area_shoot.target.ped ~= 1 then
        for _, ent in pairs(GET_NEARBY_PEDS(players.user(), nearby_area.radius)) do
            if nearby_area_shoot.checkPed(ent) then
                local pos = ENTITY.GET_ENTITY_COORDS(ent)
                if nearby_area_shoot.target.ped_head then
                    pos = PED.GET_PED_BONE_COORDS(ent, 0x322c, 0, 0, 0)
                end

                local start_pos = {}
                if nearby_area_shoot.start_from_player then
                    local player_pos = ENTITY.GET_ENTITY_COORDS(players.user_ped())
                    start_pos.x = player_pos.x + nearby_area_shoot.x
                    start_pos.y = player_pos.y + nearby_area_shoot.y
                    start_pos.z = player_pos.z + nearby_area_shoot.z
                else
                    start_pos.x = pos.x + nearby_area_shoot.x
                    start_pos.y = pos.y + nearby_area_shoot.y
                    start_pos.z = pos.z + nearby_area_shoot.z
                end

                if action == "shoot" then
                    nearby_area_shoot.Shoot(start_pos, pos, weaponHash)
                elseif action == "drawline" then
                    DRAW_LINE(start_pos, pos)
                end
            end
        end
    end

    --- VEHICLE ---
    if nearby_area_shoot.target.vehicle ~= 1 then
        for _, ent in pairs(GET_NEARBY_VEHICLES(players.user(), nearby_area.radius)) do
            if nearby_area_shoot.checkVehicle(ent) then
                local pos = ENTITY.GET_ENTITY_COORDS(ent)

                local start_pos = {}
                if nearby_area_shoot.start_from_player then
                    local player_pos = ENTITY.GET_ENTITY_COORDS(players.user_ped())
                    start_pos.x = player_pos.x + nearby_area_shoot.x
                    start_pos.y = player_pos.y + nearby_area_shoot.y
                    start_pos.z = player_pos.z + nearby_area_shoot.z
                else
                    start_pos.x = pos.x + nearby_area_shoot.x
                    start_pos.y = pos.y + nearby_area_shoot.y
                    start_pos.z = pos.z + nearby_area_shoot.z
                end

                if action == "shoot" then
                    nearby_area_shoot.Shoot(start_pos, pos, weaponHash)
                elseif action == "drawline" then
                    DRAW_LINE(start_pos, pos)
                end
            end
        end
    end

    --- OBJECT ---
    if nearby_area_shoot.target.object ~= 1 then
        for _, ent in pairs(GET_NEARBY_OBJECTS(players.user(), nearby_area.radius)) do
            if nearby_area_shoot.checkObject(ent) then
                local pos = ENTITY.GET_ENTITY_COORDS(ent)

                local start_pos = {}
                if nearby_area_shoot.start_from_player then
                    local player_pos = ENTITY.GET_ENTITY_COORDS(players.user_ped())
                    start_pos.x = player_pos.x + nearby_area_shoot.x
                    start_pos.y = player_pos.y + nearby_area_shoot.y
                    start_pos.z = player_pos.z + nearby_area_shoot.z
                else
                    start_pos.x = pos.x + nearby_area_shoot.x
                    start_pos.y = pos.y + nearby_area_shoot.y
                    start_pos.z = pos.z + nearby_area_shoot.z
                end

                if action == "shoot" then
                    nearby_area_shoot.Shoot(start_pos, pos, weaponHash)
                elseif action == "drawline" then
                    DRAW_LINE(start_pos, pos)
                end
            end
        end
    end
end

menu.toggle_loop(Nearby_Area_Shoot, "绘制模拟射击连线", {}, "", function()
    nearby_area_shoot.Handle("drawline")
end)

menu.divider(Nearby_Area_Shoot, "")
menu.action(Nearby_Area_Shoot, "射击", { "shoot_area" }, "", function()
    nearby_area_shoot.Handle("shoot")
end)
menu.slider(Nearby_Area_Shoot, "循环延迟", { "nearby_area_shoot_delay" }, "单位: ms",
    0, 5000, 1000, 100, function(value)
        nearby_area_shoot.delay = value
    end)
menu.toggle_loop(Nearby_Area_Shoot, "循环射击", {}, "", function()
    nearby_area_shoot.Handle("shoot")
    util.yield(nearby_area_shoot.delay)
end)


---------------
-- 爆炸区域
---------------
local Nearby_Area_Explosion = menu.list(Nearby_Area_options, "爆炸区域", {}, "若半径是0,则为全部范围")

local nearby_area_explosion = {
    -- 目标
    target = {
        ped = 2,
        vehicle = 1,
        object = 1,
        except_dead = true,
    },
    -- 设置
    explosionType = 2,
    is_owned = true,
    damage = 1000,
    is_audible = true,
    is_invisible = false,
    camera_shake = 0.0,
    delay = 1000,
}

--------
local Nearby_Area_Explosion_Target = menu.list(Nearby_Area_Explosion, "目标", {}, "")

menu.list_select(Nearby_Area_Explosion_Target, "NPC", {}, "", {
    { "关闭", },
    { "全部NPC (排除友好)", },
    { "敌对NPC", },
    { "步行NPC", },
    { "载具内NPC", },
    { "全部NPC", },
}, 2, function(value)
    nearby_area_explosion.target.ped = value
end)
menu.list_select(Nearby_Area_Explosion_Target, "载具", {}, "默认排除玩家载具", {
    { "关闭", },
    { "全部载具", {}, "" },
    { "敌对载具", {}, "敌对NPC驾驶或者有敌对地图标识的载具" },
    { "NPC载具", {}, "有NPC作为司机驾驶的载具" },
    { "空载具", {}, "没有任何NPC驾驶的载具" },
}, 1, function(value)
    nearby_area_explosion.target.vehicle = value
end)
menu.list_select(Nearby_Area_Explosion_Target, "物体", {}, "", {
    { "关闭" },
    { "敌对物体", {}, "有敌对地图标记点的物体" },
    { "标记点物体", {}, "有地图标记点的物体" },
}, 1, function(value)
    nearby_area_explosion.target.object = value
end)
menu.toggle(Nearby_Area_Explosion_Target, "排除死亡实体", {}, "", function(toggle)
    nearby_area_explosion.target.except_dead = toggle
end, true)

--------
local Nearby_Area_Explosion_Setting = menu.list(Nearby_Area_Explosion, "设置", {}, "")

menu.list_select(Nearby_Area_Explosion_Setting, "爆炸类型", {}, "", ExplosionType_ListItem, 4, function(index)
    nearby_area_explosion.explosionType = index - 2
end)
menu.toggle(Nearby_Area_Explosion_Setting, "署名爆炸", {}, "以玩家名义", function(toggle)
    nearby_area_explosion.is_owned = toggle
end, true)
menu.slider(Nearby_Area_Explosion_Setting, "伤害", { "nearby_area_explosion_damage" }, "", 0, 10000, 1000, 100,
    function(value)
        nearby_area_explosion.damage = value
    end)
menu.toggle(Nearby_Area_Explosion_Setting, "可听见", {}, "", function(toggle)
    nearby_area_explosion.is_audible = toggle
end, true)
menu.toggle(Nearby_Area_Explosion_Setting, "不可见", {}, "", function(toggle)
    nearby_area_explosion.is_invisible = toggle
end)
menu.slider_float(Nearby_Area_Explosion_Setting, "镜头晃动", { "nearby_area_explosion_camera_shake" }, "",
    0, 1000, 0, 10, function(value)
        nearby_area_explosion.camera_shake = value * 0.01
    end)

--------
function nearby_area_explosion.checkPed(ped)
    if nearby_area_explosion.target.except_dead and ENTITY.IS_ENTITY_DEAD(ped) then
        return false
    end

    if not is_player_ped(ped) then
        local target_select = nearby_area_explosion.target.ped
        if target_select == 2 and not is_friendly_ped(ped) then
            return true
        elseif target_select == 3 and is_hostile_ped(ped) then
            return true
        elseif target_select == 4 and not PED.IS_PED_IN_ANY_VEHICLE(ped, false) then
            return true
        elseif target_select == 5 and PED.IS_PED_IN_ANY_VEHICLE(ped, false) then
            return true
        elseif target_select == 6 then
            return true
        end
    end

    return false
end

function nearby_area_explosion.checkVehicle(vehicle)
    if nearby_area_explosion.target.except_dead and ENTITY.IS_ENTITY_DEAD(vehicle) then
        return false
    end

    if not is_player_vehicle(vehicle) then
        local target_select = nearby_area_explosion.target.vehicle
        if target_select == 2 then
            return true
        elseif target_select == 3 and IS_HOSTILE_ENTITY(vehicle) then
            return true
        elseif target_select == 4 and not VEHICLE.IS_VEHICLE_SEAT_FREE(vehicle, -1, false) then
            return true
        elseif target_select == 5 and VEHICLE.IS_VEHICLE_SEAT_FREE(vehicle, -1, false) then
            return true
        end
    end

    return false
end

function nearby_area_explosion.checkObject(object)
    if nearby_area_explosion.target.except_dead and ENTITY.IS_ENTITY_DEAD(object) then
        return false
    end

    local blip = HUD.GET_BLIP_FROM_ENTITY(object)
    if HUD.DOES_BLIP_EXIST(blip) then
        local target_select = nearby_area_explosion.target.object
        if target_select == 2 and IS_HOSTILE_ENTITY(object) then
            return true
        elseif target_select == 3 then
            return true
        end
    end

    return false
end

function nearby_area_explosion.Explosion(pos)
    if nearby_area_explosion.is_owned then
        FIRE.ADD_OWNED_EXPLOSION(players.user_ped(),
            pos.x, pos.y, pos.z,
            nearby_area_explosion.explosionType,
            nearby_area_explosion.damage,
            nearby_area_explosion.is_audible,
            nearby_area_explosion.is_invisible,
            nearby_area_explosion.camera_shake)
    else
        FIRE.ADD_EXPLOSION(pos.x, pos.y, pos.z,
            nearby_area_explosion.explosionType,
            nearby_area_explosion.damage,
            nearby_area_explosion.is_audible,
            nearby_area_explosion.is_invisible,
            nearby_area_explosion.camera_shake,
            false)
    end
end

function nearby_area_explosion.Handle(action)
    --- PED ---
    if nearby_area_explosion.target.ped ~= 1 then
        for _, ent in pairs(GET_NEARBY_PEDS(players.user(), nearby_area.radius)) do
            if nearby_area_explosion.checkPed(ent) then
                if action == "explosion" then
                    local pos = ENTITY.GET_ENTITY_COORDS(ent)
                    nearby_area_explosion.Explosion(pos)
                elseif action == "drawline" then
                    DRAW_LINE_TO_ENTITY(ent)
                end
            end
        end
    end

    --- VEHICLE ---
    if nearby_area_explosion.target.vehicle ~= 1 then
        for _, ent in pairs(GET_NEARBY_VEHICLES(players.user(), nearby_area.radius)) do
            if nearby_area_explosion.checkVehicle(ent) then
                if action == "explosion" then
                    local pos = ENTITY.GET_ENTITY_COORDS(ent)
                    nearby_area_explosion.Explosion(pos)
                elseif action == "drawline" then
                    DRAW_LINE_TO_ENTITY(ent)
                end
            end
        end
    end

    --- OBJECT ---
    if nearby_area_explosion.target.object ~= 1 then
        for _, ent in pairs(GET_NEARBY_OBJECTS(players.user(), nearby_area.radius)) do
            if nearby_area_explosion.checkObject(ent) then
                if action == "explosion" then
                    local pos = ENTITY.GET_ENTITY_COORDS(ent)
                    nearby_area_explosion.Explosion(pos)
                elseif action == "drawline" then
                    DRAW_LINE_TO_ENTITY(ent)
                end
            end
        end
    end
end

menu.toggle_loop(Nearby_Area_Explosion, "连线指示实体", {}, "", function()
    nearby_area_explosion.Handle("drawline")
end)

menu.divider(Nearby_Area_Explosion, "")
menu.action(Nearby_Area_Explosion, "爆炸", { "explosion_area" }, "", function()
    nearby_area_explosion.Handle("explosion")
end)
menu.slider(Nearby_Area_Explosion, "循环延迟", { "nearby_area_explosion_delay" }, "单位: ms",
    0, 5000, 1000, 100, function(value)
        nearby_area_explosion.delay = value
    end)
menu.toggle_loop(Nearby_Area_Explosion, "循环爆炸", {}, "", function()
    nearby_area_explosion.Handle("explosion")
    util.yield(nearby_area_explosion.delay)
end)


--#endregion Nearby Area





--#region All Entity Manage

--------------------------
--------- 所有实体 ---------
--------------------------
local All_Entity_Manage = menu.list(Entity_options, "管理所有实体", {}, "")

----------------------
----- 所有任务实体 -----
----------------------
local Mission_Entity_All = menu.list(All_Entity_Manage, "所有任务实体", { "manage_all_entity" }, "")

local All_Mission_Entity = {
    Type = "Ped", -- 实体类型
    -- 筛选设置 --
    Filter = {
        mission = 2,
        distance = 0,
        blip = 1,
        move = 1,
        attached = 1,
        ped = {
            except_player = true,
            combat = 1,
            relationship = 1,
            state = 1,
            armed = 1,
        },
        vehicle = {
            driver = 1,
            type = 1,
        },
    },
    Sort_Method = 1, -- 排序方式
}

menu.list_select(Mission_Entity_All, "实体类型", {}, "", EntityType_ListItem, 1, function(value)
    All_Mission_Entity.Type = EntityType_ListItem[value][1]
end)

---------------
-- 筛选设置
---------------
local Mission_Entity_All_Filter = menu.list(Mission_Entity_All, "筛选设置", {}, "")

menu.list_select(Mission_Entity_All_Filter, "任务实体", {}, "",
    { { "关闭" }, { "是" }, { "否" } }, 2, function(value)
        All_Mission_Entity.Filter.mission = value
    end)
menu.slider_float(Mission_Entity_All_Filter, "范围", { "all_mission_entity_distance" }, "和玩家之间的距离是否在范围之内\n0表示全部范围",
    0, 100000, 0, 100, function(value)
        All_Mission_Entity.Filter.distance = value * 0.01
    end)
menu.list_select(Mission_Entity_All_Filter, "地图标记", {}, "",
    { { "关闭" }, { "有" }, { "没有" } }, 1, function(value)
        All_Mission_Entity.Filter.blip = value
    end)
menu.list_select(Mission_Entity_All_Filter, "移动状态", {}, "",
    { { "关闭" }, { "静止" }, { "正在移动" } }, 1, function(value)
        All_Mission_Entity.Filter.move = value
    end)
menu.list_select(Mission_Entity_All_Filter, "Attached", {}, "",
    { { "关闭" }, { "是" }, { "否" } }, 1, function(value)
        All_Mission_Entity.Filter.attached = value
    end)

menu.divider(Mission_Entity_All_Filter, "Ped")
menu.toggle(Mission_Entity_All_Filter, "排除玩家", {}, "", function(toggle)
    All_Mission_Entity.Filter.ped.except_player = toggle
end, true)
menu.list_select(Mission_Entity_All_Filter, "与玩家敌对", {}, "",
    { { "关闭" }, { "是" }, { "否" } }, 1, function(value)
        All_Mission_Entity.Filter.ped.combat = value
    end)
menu.list_select(Mission_Entity_All_Filter, "关系", {}, "",
    { { "关闭" }, { "尊重/喜欢" }, { "忽略" }, { "不喜欢/讨厌" }, { "通缉" }, { "无" } }, 1,
    function(value)
        All_Mission_Entity.Filter.ped.relationship = value
    end)
menu.list_select(Mission_Entity_All_Filter, "状态", {}, "",
    { { "关闭" }, { "步行" }, { "载具内" }, { "已死亡" }, { "正在射击" } }, 1, function(value)
        All_Mission_Entity.Filter.ped.state = value
    end)
menu.list_select(Mission_Entity_All_Filter, "装备武器", {}, "",
    { { "关闭" }, { "是" }, { "否" } }, 1, function(value)
        All_Mission_Entity.Filter.ped.armed = value
    end)

menu.divider(Mission_Entity_All_Filter, "Vehicle")
menu.list_select(Mission_Entity_All_Filter, "司机", {}, "",
    { { "关闭" }, { "没有" }, { "NPC" }, { "玩家" } }, 1, function(value)
        All_Mission_Entity.Filter.vehicle.driver = value
    end)
menu.list_select(Mission_Entity_All_Filter, "类型", {}, "",
    { { "关闭" }, { "Car" }, { "Bike" }, { "Bicycle" }, { "Heli" }, { "Plane" }, { "Boat" } }, 1, function(value)
        All_Mission_Entity.Filter.vehicle.type = value
    end)


----- 排序方式 -----
menu.list_select(Mission_Entity_All, "排序方式", {}, "", {
    { "无" }, { "距离 (近 -> 远)" }, { "速度 (快 -> 慢)" }
}, 1, function(value)
    All_Mission_Entity.Sort_Method = value
end)



-- 检查是否符合筛选条件
function All_Mission_Entity.Check_Match_Conditions(ent)
    local hash = ENTITY.GET_ENTITY_MODEL(ent)

    -- 任务实体
    if All_Mission_Entity.Filter.mission > 1 then
        if ENTITY.IS_ENTITY_A_MISSION_ENTITY(ent) then
            if All_Mission_Entity.Filter.mission ~= 2 then
                return false
            end
        else
            if All_Mission_Entity.Filter.mission ~= 3 then
                return false
            end
        end
    end
    -- 范围
    if All_Mission_Entity.Filter.distance > 0 then
        local my_pos = ENTITY.GET_ENTITY_COORDS(players.user_ped())
        local ent_pos = ENTITY.GET_ENTITY_COORDS(ent)
        if v3.distance(my_pos, ent_pos) > All_Mission_Entity.Filter.distance then
            return false
        end
    end
    -- 地图标记点
    if All_Mission_Entity.Filter.blip > 1 then
        if HUD.DOES_BLIP_EXIST(HUD.GET_BLIP_FROM_ENTITY(ent)) then
            if All_Mission_Entity.Filter.blip ~= 2 then
                return false
            end
        else
            if All_Mission_Entity.Filter.blip ~= 3 then
                return false
            end
        end
    end
    -- 移动状态
    if All_Mission_Entity.Filter.move > 1 then
        if ENTITY.GET_ENTITY_SPEED(ent) == 0 then
            if All_Mission_Entity.Filter.move ~= 2 then
                return false
            end
        else
            if All_Mission_Entity.Filter.move ~= 3 then
                return false
            end
        end
    end
    -- Attached
    if All_Mission_Entity.Filter.attached > 1 then
        if ENTITY.IS_ENTITY_ATTACHED(ent) then
            if All_Mission_Entity.Filter.attached ~= 2 then
                return false
            end
        else
            if All_Mission_Entity.Filter.attached ~= 3 then
                return false
            end
        end
    end

    ------ Ped ------
    if ENTITY.IS_ENTITY_A_PED(ent) then
        -- 排除玩家
        if All_Mission_Entity.Filter.ped.except_player and is_player_ped(ent) then
            return false
        end
        -- 与玩家敌对
        if All_Mission_Entity.Filter.ped.combat > 1 then
            if is_hostile_ped(ent) then
                if All_Mission_Entity.Filter.ped.combat ~= 2 then
                    return false
                end
            else
                if All_Mission_Entity.Filter.ped.combat ~= 3 then
                    return false
                end
            end
        end
        -- 关系
        if All_Mission_Entity.Filter.ped.relationship > 1 then
            local rel = PED.GET_RELATIONSHIP_BETWEEN_PEDS(ent, players.user_ped())
            if All_Mission_Entity.Filter.ped.relationship == 2 and (rel == 0 or rel == 1) then
            elseif All_Mission_Entity.Filter.ped.relationship == 3 and rel == 2 then
            elseif All_Mission_Entity.Filter.ped.relationship == 4 and (rel == 3 or rel == 5) then
            elseif All_Mission_Entity.Filter.ped.relationship == 5 and rel == 4 then
            elseif All_Mission_Entity.Filter.ped.relationship == 6 and rel == 255 then
            else
                return false
            end
        end
        -- 状态
        if All_Mission_Entity.Filter.ped.state > 1 then
            if All_Mission_Entity.Filter.ped.state == 2 and PED.IS_PED_ON_FOOT(ent) then
            elseif All_Mission_Entity.Filter.ped.state == 3 and PED.IS_PED_IN_ANY_VEHICLE(ent, false) then
            elseif All_Mission_Entity.Filter.ped.state == 4 and ENTITY.IS_ENTITY_DEAD(ent) then
            elseif All_Mission_Entity.Filter.ped.state == 5 and PED.IS_PED_SHOOTING(ent) then
            else
                return false
            end
        end
        -- 装备武器
        if All_Mission_Entity.Filter.ped.armed > 1 then
            if WEAPON.IS_PED_ARMED(ent, 7) then
                if All_Mission_Entity.Filter.ped.armed ~= 2 then
                    return false
                end
            else
                if All_Mission_Entity.Filter.ped.armed ~= 3 then
                    return false
                end
            end
        end
    end

    ------ Vehicle ------
    if ENTITY.IS_ENTITY_A_VEHICLE(ent) then
        -- 司机
        if All_Mission_Entity.Filter.vehicle.driver > 1 then
            if All_Mission_Entity.Filter.vehicle.driver == 2 and VEHICLE.IS_VEHICLE_SEAT_FREE(ent, -1, false) then
            elseif not VEHICLE.IS_VEHICLE_SEAT_FREE(ent, -1, false) then
                local driver = VEHICLE.GET_PED_IN_VEHICLE_SEAT(ent, -1)
                if All_Mission_Entity.Filter.vehicle.driver == 3 and not is_player_ped(driver) then
                elseif All_Mission_Entity.Filter.vehicle.driver == 4 and is_player_ped(driver) then
                else
                    return false
                end
            else
                return false
            end
        end
        -- 类型
        if All_Mission_Entity.Filter.vehicle.type > 1 then
            if All_Mission_Entity.Filter.vehicle.type == 2 and VEHICLE.IS_THIS_MODEL_A_CAR(hash) then
            elseif All_Mission_Entity.Filter.vehicle.type == 3 and VEHICLE.IS_THIS_MODEL_A_BIKE(hash) then
            elseif All_Mission_Entity.Filter.vehicle.type == 4 and VEHICLE.IS_THIS_MODEL_A_BICYCLE(hash) then
            elseif All_Mission_Entity.Filter.vehicle.type == 5 and VEHICLE.IS_THIS_MODEL_A_HELI(hash) then
            elseif All_Mission_Entity.Filter.vehicle.type == 6 and VEHICLE.IS_THIS_MODEL_A_PLANE(hash) then
            elseif All_Mission_Entity.Filter.vehicle.type == 7 and VEHICLE.IS_THIS_MODEL_A_BOAT(hash) then
            else
                return false
            end
        end
    end

    return true
end

-- 排序
function All_Mission_Entity.Sort(ent_list, method)
    -- 距离: 近 -> 远
    if method == 2 then
        table.sort(ent_list, function(a, b)
            local player_pos = ENTITY.GET_ENTITY_COORDS(players.user_ped())
            local distance_a = v3.distance(ENTITY.GET_ENTITY_COORDS(a), player_pos)
            local distance_b = v3.distance(ENTITY.GET_ENTITY_COORDS(b), player_pos)
            return distance_a < distance_b
        end)
        -- 速度: 快 -> 慢
    elseif method == 3 then
        table.sort(ent_list, function(a, b)
            local speed_a = ENTITY.GET_ENTITY_SPEED(a)
            local speed_b = ENTITY.GET_ENTITY_SPEED(b)
            return speed_a > speed_b
        end)
    end
end

-- 初始化数据
function All_Mission_Entity.Init_Entity_List_Data()
    -- 实体 list
    All_Mission_Entity.entity_list = {}
    -- 实体的 menu.list()
    All_Mission_Entity.entity_menu_list = {}
    -- 操作全部实体的 menu.list()
    All_Mission_Entity.all_entities_menu_list = {}
    -- 实体数量
    All_Mission_Entity.entity_count = 0
end

All_Mission_Entity.Init_Entity_List_Data()

-- 清理并初始化数据
function All_Mission_Entity.Clear_Entity_List_Data()
    -- 操作全部实体的 menu.list()
    if next(All_Mission_Entity.all_entities_menu_list) ~= nil then
        for i = 1, 2 do
            local v = All_Mission_Entity.all_entities_menu_list[i]
            if menu.is_ref_valid(v) then
                menu.delete(v)
            end
        end
    end
    -- 实体的 menu.list()
    for k, v in pairs(All_Mission_Entity.entity_menu_list) do
        if v ~= nil and menu.is_ref_valid(v) then
            menu.delete(v)
        end
    end
    -- 初始化
    All_Mission_Entity.Init_Entity_List_Data()
    menu.set_menu_name(All_Mission_Entity.count_divider, "实体列表")
end

menu.action(Mission_Entity_All, "获取实体列表", {}, "", function()
    All_Mission_Entity.Clear_Entity_List_Data()
    local all_ent = get_all_entities(All_Mission_Entity.Type)

    for _, ent in pairs(all_ent) do
        if All_Mission_Entity.Check_Match_Conditions(ent) then
            table.insert(All_Mission_Entity.entity_list, ent) -- 实体 list
        end
    end

    if next(All_Mission_Entity.entity_list) ~= nil then
        -- 排序
        if All_Mission_Entity.Sort_Method > 1 then
            All_Mission_Entity.Sort(All_Mission_Entity.entity_list, All_Mission_Entity.Sort_Method)
        end

        for k, ent in pairs(All_Mission_Entity.entity_list) do
            local menu_name, help_text = Entity_Control.get_menu_info(ent, k)

            -- 实体的 menu.list()
            local menu_list = menu.list(Mission_Entity_All, menu_name, {}, help_text, function()
                if not ENTITY.DOES_ENTITY_EXIST(ent) then
                    util.toast("该实体已经不存在")
                end
            end)
            table.insert(All_Mission_Entity.entity_menu_list, menu_list)

            -- 创建对应实体的menu操作
            local index = "a" .. k
            Entity_Control.generate_menu(menu_list, ent, index)

            -- 实体数量
            All_Mission_Entity.entity_count = All_Mission_Entity.entity_count + 1
        end
    end

    -- 全部实体
    if All_Mission_Entity.entity_count == 0 then
        menu.set_menu_name(All_Mission_Entity.count_divider, "实体列表")
    else
        menu.set_menu_name(All_Mission_Entity.count_divider, "实体列表 (" .. All_Mission_Entity.entity_count .. ")")

        All_Mission_Entity.all_entities_menu_list[1] = menu.divider(Mission_Entity_All, "")
        All_Mission_Entity.all_entities_menu_list[2] = menu.list(Mission_Entity_All, "全部实体管理", {}, "")
        Entity_Control.entities(All_Mission_Entity.all_entities_menu_list[2], All_Mission_Entity.entity_list)
    end
end)

menu.action(Mission_Entity_All, "清空列表", {}, "", function()
    All_Mission_Entity.Clear_Entity_List_Data()
end)
All_Mission_Entity.count_divider = menu.divider(Mission_Entity_All, "实体列表")



------------------------
--- 自定义 Model Hash ---
------------------------
local Mission_Entity_CustomHash = menu.list(All_Entity_Manage, "自定义 Model Hash", {}, "")

local Custom_Hash_Entity = {
    hash = 0,
    type = "Ped",
    is_mission = true,
}

menu.text_input(Mission_Entity_CustomHash, "Model Hash ", { "custom_model_hash" }, "", function(value)
    Custom_Hash_Entity.hash = tonumber(value)
end)
menu.action(Mission_Entity_CustomHash, "转换复制内容", {}, "删除Model Hash: \n自动填充到Hash输入框",
    function()
        local text = util.get_clipboard_text()
        local num = string.gsub(text, "Model Hash: ", "")
        menu.trigger_commands("custommodelhash " .. num)
    end)

Custom_Hash_Entity.menu_type =
    menu.list_select(Mission_Entity_CustomHash, "实体类型", {}, "", EntityType_ListItem,
        1, function(value)
            Custom_Hash_Entity.type = EntityType_ListItem[value][1]
        end)

Saved_Hash_List.Mission_Entity_CustomHash =
    menu.list_action(Mission_Entity_CustomHash, "已保存的 Hash", {}, "点击填充到Hash输入框和选择实体类型",
        Saved_Hash_List.get_list_item_data(), function(value)
            local Name = Saved_Hash_List.get_list()[value]
            local Hash, Type = Saved_Hash_List.read(Name)
            menu.trigger_commands("custommodelhash " .. Hash)
            menu.set_value(Custom_Hash_Entity.menu_type, GET_ENTITY_TYPE_INDEX(Type))
        end)

menu.toggle(Mission_Entity_CustomHash, "任务实体", {}, "是否为任务实体", function(toggle)
    Custom_Hash_Entity.is_mission = toggle
end, true)


-- 初始化数据
function Custom_Hash_Entity.Init_Entity_List_Data()
    -- 实体 list
    Custom_Hash_Entity.entity_list = {}
    -- 实体的 menu.list()
    Custom_Hash_Entity.entity_menu_list = {}
    -- 操作全部实体的 menu.list()
    Custom_Hash_Entity.all_entities_menu_list = {}
    -- 实体数量
    Custom_Hash_Entity.entity_count = 0
end

Custom_Hash_Entity.Init_Entity_List_Data()

-- 清理并初始化数据
function Custom_Hash_Entity.Clear_Entity_List_Data()
    -- 操作全部实体的 menu.list()
    if next(Custom_Hash_Entity.all_entities_menu_list) ~= nil then
        for i = 1, 2 do
            local v = Custom_Hash_Entity.all_entities_menu_list[i]
            if menu.is_ref_valid(v) then
                menu.delete(v)
            end
        end
    end
    -- 实体的 menu.list()
    for k, v in pairs(Custom_Hash_Entity.entity_menu_list) do
        if v ~= nil and menu.is_ref_valid(v) then
            menu.delete(v)
        end
    end
    -- 初始化
    Custom_Hash_Entity.Init_Entity_List_Data()
    menu.set_menu_name(Custom_Hash_Entity.count_divider, "实体列表")
end

menu.action(Mission_Entity_CustomHash, "获取实体列表", {}, "", function()
    Custom_Hash_Entity.Clear_Entity_List_Data()

    local all_entities = get_all_entities(Custom_Hash_Entity.type)
    local custom_hash = tonumber(Custom_Hash_Entity.hash)

    if custom_hash ~= nil and STREAMING.IS_MODEL_VALID(custom_hash) then
        for k, ent2 in pairs(all_entities) do
            local modelHash = ENTITY.GET_ENTITY_MODEL(ent2)
            if modelHash == custom_hash then
                local ent
                if Custom_Hash_Entity.is_mission then
                    if ENTITY.IS_ENTITY_A_MISSION_ENTITY(ent2) then
                        ent = ent2
                    end
                else
                    ent = ent2
                end
                -----
                if ent ~= nil then
                    table.insert(Custom_Hash_Entity.entity_list, ent) -- 实体 list

                    -- 实体的 menu.list()
                    local menu_name, help_text = Entity_Control.get_menu_info(ent, k)
                    local menu_list = menu.list(Mission_Entity_CustomHash, menu_name, {}, help_text)
                    table.insert(Custom_Hash_Entity.entity_menu_list, menu_list)

                    -- 创建对应实体的menu操作
                    local index = "c" .. k
                    Entity_Control.generate_menu(menu_list, ent, index)

                    -- 实体数量
                    Custom_Hash_Entity.entity_count = Custom_Hash_Entity.entity_count + 1
                end
            end
        end

        -- 全部实体
        if Custom_Hash_Entity.entity_count == 0 then
            menu.set_menu_name(Custom_Hash_Entity.count_divider, "实体列表")
            util.toast("未找到此Hash的实体")
        else
            menu.set_menu_name(Custom_Hash_Entity.count_divider, "实体列表 (" ..
                Custom_Hash_Entity.entity_count .. ")")

            Custom_Hash_Entity.all_entities_menu_list[1] = menu.divider(Mission_Entity_CustomHash, "")
            Custom_Hash_Entity.all_entities_menu_list[2] = menu.list(Mission_Entity_CustomHash, "全部实体管理", {},
                "")
            Entity_Control.entities(Custom_Hash_Entity.all_entities_menu_list[2], Custom_Hash_Entity.entity_list)
        end
    else
        util.toast("Hash值错误")
    end
end)

menu.action(Mission_Entity_CustomHash, "清空列表", {}, "", function()
    Custom_Hash_Entity.Clear_Entity_List_Data()
end)
Custom_Hash_Entity.count_divider = menu.divider(Mission_Entity_CustomHash, "实体列表")


----------------------
--- 保存的 Hash 列表 ---
----------------------
Saved_Hash_List.Manage_Hash_List_Menu = menu.list(All_Entity_Manage, "保存的 Hash 列表", {}, "")

--添加
local Manage_Hash_List_Menu_add = menu.list(Saved_Hash_List.Manage_Hash_List_Menu, "添加", {}, "")

local manage_hash_list_add = {
    name = "",
    hash = 0,
    type = "Ped"
}
menu.text_input(Manage_Hash_List_Menu_add, "名称", { "manage_hash_list_add_name" }, "", function(value)
    manage_hash_list_add.name = value
end)
menu.text_input(Manage_Hash_List_Menu_add, "Hash", { "manage_hash_list_add_hash" }, "", function(value)
    manage_hash_list_add.hash = value
end)
menu.list_select(Manage_Hash_List_Menu_add, "实体类型", {}, "", EntityType_ListItem, 1,
    function(value)
        value = EntityType_ListItem[value][1]
        manage_hash_list_add.type = value
    end)
menu.action(Manage_Hash_List_Menu_add, "添加", {}, "", function()
    if manage_hash_list_add.name ~= "" then
        if tonumber(manage_hash_list_add.hash) ~= nil and STREAMING.IS_MODEL_VALID(manage_hash_list_add.hash) then
            Saved_Hash_List.write(manage_hash_list_add.name, manage_hash_list_add.hash, manage_hash_list_add.type)
            util.toast("已添加")
        else
            util.toast("Hash值错误")
        end
    else
        util.toast("请输入名称")
    end
end)

menu.divider(Saved_Hash_List.Manage_Hash_List_Menu, "列表")
Saved_Hash_List.generate_menu_list(Saved_Hash_List.Manage_Hash_List_Menu)


--#endregion All Entity Manage





--#region Entity Info Gun

menu.divider(Entity_options, "")

---------------------------
-------- 实体信息枪 ---------
---------------------------

local Entity_Info_Gun = menu.list(Entity_options, "实体信息枪", {}, "获取瞄准射击的实体信息")

local entity_info = {
    is_showOnScreen = true, -- 显示在屏幕上
    item_data = {},         -- 实体信息 list action item data
    menu_show_info = nil,   -- 查看实体信息 list action
    menu_info_list = nil,
}

menu.toggle_loop(Entity_Info_Gun, "开启", { "info_gun" }, "", function()
    draw_point_in_center()
    local ent = get_entity_player_is_aiming_at(players.user())
    if ent ~= nil and IS_AN_ENTITY(ent) then
        entity_info.item_data = GetEntityInfo_ListItem(ent)
        if next(entity_info.item_data) ~= nil then
            menu.set_list_action_options(entity_info.menu_show_info, entity_info.item_data)

            --显示在屏幕上
            if entity_info.is_showOnScreen then
                local text = ""
                for _, info in pairs(entity_info.item_data) do
                    if info[1] ~= nil then
                        text = text .. info[1] .. "\n"
                    end
                end
                DrawString(text, 0.7)
                --directx.draw_text(0.5, 0.0, text, ALIGN_TOP_LEFT, 0.75, Colors.purple)
            end
        end
    end
end)

menu.toggle(Entity_Info_Gun, "显示在屏幕上", {}, "", function(toggle)
    entity_info.is_showOnScreen = toggle
end, true)

menu.divider(Entity_Info_Gun, "")
entity_info.menu_show_info = menu.list_action(Entity_Info_Gun, "查看实体信息", {}, "", entity_info.item_data,
    function(value)
        local name = entity_info.item_data[value][1]
        util.copy_to_clipboard(name, false)
        util.toast("Copied!\n" .. name)
    end)

menu.action(Entity_Info_Gun, "复制实体信息", {}, "", function()
    local text = ""
    for _, info in pairs(entity_info.item_data) do
        if info[1] ~= nil then
            text = text .. info[1] .. "\n"
        end
    end
    util.copy_to_clipboard(text, false)
    util.toast("完成")
end)
menu.action(Entity_Info_Gun, "保存实体信息到日志", {}, "", function()
    local text = ""
    for _, info in pairs(entity_info.item_data) do
        if info[1] ~= nil then
            text = text .. info[1] .. "\n"
        end
    end
    util.log(text)
    util.toast("完成")
end)




------------------------------
-------- 实体信息枪 2.0 --------
------------------------------

local Entity_Info_Gun2 = menu.list(Entity_options, "实体信息枪 2.0[TEST]", {}, "")

Entity_Info = {
    entity = 0,
}

function Entity_Info.get_entity_info(entity)
    if ENTITY.DOES_ENTITY_EXIST(entity) then
        Entity_Info.entity = entity

        -- 实体所有信息
        local entity_info = {
            entity = {},
            ped = {},
            vehicle = {},
        }

        entity_info.entity = Entity_Info.entity_info(entity)

        if ENTITY.IS_ENTITY_A_PED(entity) then
            entity_info.ped = Entity_Info.ped_info(entity)
        end

        if ENTITY.IS_ENTITY_A_VEHICLE(entity) then
            entity_info.vehicle = Entity_Info.vehicle_info(entity)
        end

        return entity_info
    end
end

function Entity_Info.entity_info(entity)
    local entity_info = {
        main = {},
        blip = {},
        attached = {},
        other = {},
    }

    local info = {} -- name, value
    local t = ""

    local model_hash = ENTITY.GET_ENTITY_MODEL(entity)

    -- Model Name
    local model_name = util.reverse_joaat(model_hash)
    if model_name ~= "" then
        info = { "Model Name", model_name }
        table.insert(entity_info.main, info)
    end

    -- Model Hash
    info = { "Model Hash", model_hash }
    table.insert(entity_info.main, info)

    -- Type
    local entity_type = GET_ENTITY_TYPE(entity)
    info = { "Entity Type", entity_type }
    table.insert(entity_info.main, info)

    -- Mission Entity
    if ENTITY.IS_ENTITY_A_MISSION_ENTITY(entity) then
        info = { "Mission Entity", "True" }
    else
        info = { "Mission Entity", "False" }
    end
    table.insert(entity_info.main, info)

    -- Health
    t = ENTITY.GET_ENTITY_HEALTH(entity) .. "/" .. ENTITY.GET_ENTITY_MAX_HEALTH(entity)
    info = { "Entity Health", t }
    table.insert(entity_info.main, info)

    -- Dead
    if ENTITY.IS_ENTITY_DEAD(entity) then
        info = { "Entity Dead", "True" }
        table.insert(entity_info.main, info)
    end

    -- Position
    local ent_pos = ENTITY.GET_ENTITY_COORDS(entity)
    t = round(ent_pos.x, 4) .. ", " ..
        round(ent_pos.y, 4) .. ", " ..
        round(ent_pos.z, 4)
    info = { "Coords", t }
    table.insert(entity_info.main, info)

    local my_pos = ENTITY.GET_ENTITY_COORDS(players.user_ped())

    -- Heading
    t = round(ENTITY.GET_ENTITY_HEADING(entity), 4)
    info = { "Entity Heading", t }
    table.insert(entity_info.main, info)

    t = round(ENTITY.GET_ENTITY_HEADING(players.user_ped()), 4)
    info = { "Player Heading", t }
    table.insert(entity_info.main, info)

    -- Distance
    local distance = Vector.dist(my_pos, ent_pos)
    info = { "Distance", round(distance, 4) }
    table.insert(entity_info.main, info)

    -- Subtract with player position
    local pos_sub = Vector.subtract(my_pos, ent_pos)
    t = round(pos_sub.x, 2) .. ", " ..
        round(pos_sub.y, 2) .. ", " ..
        round(pos_sub.z, 2)
    info = { "Subtract Coords", t }
    table.insert(entity_info.main, info)

    -- Speed
    local speed = ENTITY.GET_ENTITY_SPEED(entity)
    info = { "Entity Speed", round(speed, 2) }
    table.insert(entity_info.main, info)

    -- Networked Entity
    t = ""
    if NETWORK.NETWORK_GET_ENTITY_IS_LOCAL(entity) then
        t = "Local"
    end
    if NETWORK.NETWORK_GET_ENTITY_IS_NETWORKED(entity) then
        t = t .. " & Networked"
    end
    info = { "Networked Entity", t }
    table.insert(entity_info.main, info)

    -- Owner
    local owner = entities.get_owner(entity)
    info = { "Entity Owner", players.get_name(owner) }
    table.insert(entity_info.main, info)


    ----- Blip -----
    local blip = HUD.GET_BLIP_FROM_ENTITY(entity)
    if HUD.DOES_BLIP_EXIST(blip) then
        -- Sprite
        local blip_sprite = HUD.GET_BLIP_SPRITE(blip)
        info = { "Blip Sprite", blip_sprite }
        table.insert(entity_info.blip, info)

        -- Colour
        local blip_colour = HUD.GET_BLIP_COLOUR(blip)
        info = { "Blip Colour", blip_colour }
        table.insert(entity_info.blip, info)

        -- HUD Colour
        local blip_hud_colour = HUD.GET_BLIP_HUD_COLOUR(blip)
        info = { "Blip HUD Colour", blip_hud_colour }
        table.insert(entity_info.blip, info)

        -- Alpha
        local blip_alpha = HUD.GET_BLIP_ALPHA(blip)
        info = { "Blip Alpha", blip_alpha }
        table.insert(entity_info.blip, info)

        -- Rotation
        local blip_rotation = HUD.GET_BLIP_ROTATION(blip)
        info = { "Blip Rotation", blip_rotation }
        table.insert(entity_info.blip, info)

        -- Short Range
        if HUD.IS_BLIP_SHORT_RANGE(blip) then
            info = { "Short Range", "True" }
        else
            info = { "Short Range", "False" }
        end
        table.insert(entity_info.blip, info)

        -- Scale
        local blip_scale_x, blip_scale_y = memory_utils.get_blip_scale_2d(blip)
        info = { "Blip Scale X", blip_scale_x }
        table.insert(entity_info.blip, info)

        info = { "Blip Scale Y", blip_scale_y }
        table.insert(entity_info.blip, info)
    end


    ----- Attached -----
    if ENTITY.IS_ENTITY_ATTACHED(entity) then
        local attached_entity = ENTITY.GET_ENTITY_ATTACHED_TO(entity)
        local attached_hash = ENTITY.GET_ENTITY_MODEL(attached_entity)

        -- Model Name
        local attached_model_name = util.reverse_joaat(attached_hash)
        if attached_model_name ~= "" then
            info = { "Model Name", attached_model_name }
            table.insert(entity_info.attached, info)
        end

        -- Model Hash
        info = { "Model Hash", attached_hash }
        table.insert(entity_info.attached, info)

        -- Type
        info = { "Entity Type", GET_ENTITY_TYPE(attached_entity) }
        table.insert(entity_info.attached, info)
    end


    ----- Other -----

    -- Alpha
    local alpha = ENTITY.GET_ENTITY_ALPHA(entity)
    info = { "Alpha", round(alpha, 4) }
    table.insert(entity_info.other, info)

    -- Pitch
    local pitch = ENTITY.GET_ENTITY_PITCH(entity)
    info = { "Pitch", round(pitch, 4) }
    table.insert(entity_info.other, info)

    -- Roll
    local roll = ENTITY.GET_ENTITY_ROLL(entity)
    info = { "Roll", round(roll, 4) }
    table.insert(entity_info.other, info)

    -- Upright Value
    local upright_value = ENTITY.GET_ENTITY_UPRIGHT_VALUE(entity)
    info = { "Upright Value", round(upright_value, 4) }
    table.insert(entity_info.other, info)

    -- Height Above Ground
    local height_above_ground = ENTITY.GET_ENTITY_HEIGHT_ABOVE_GROUND(entity)
    info = { "Height Above Ground", round(height_above_ground, 4) }
    table.insert(entity_info.other, info)


    return entity_info
end

function Entity_Info.ped_info(ped)
    local ped_info = {
        main = {},
        dead = {},
        rel_group = {},
    }

    local info = {} -- name, value
    local t = ""

    -- Ped Type
    local ped_type = PED.GET_PED_TYPE(ped)
    info = { "Ped Type", enum_PedType[ped_type] }
    table.insert(ped_info.main, info)

    -- Money
    info = { "Money", PED.GET_PED_MONEY(ped) }
    table.insert(ped_info.main, info)

    -- Accuracy
    info = { "Accuracy", PED.GET_PED_ACCURACY(ped) }
    table.insert(ped_info.main, info)

    -- Combat Movement
    local combat_movement = PED.GET_PED_COMBAT_MOVEMENT(ped)
    info = { "Combat Movement", enum_CombatMovement[combat_movement] }
    table.insert(ped_info.main, info)

    -- Combat Range
    local combat_range = PED.GET_PED_COMBAT_RANGE(ped)
    info = { "Combat Range", enum_CombatRange[combat_range] }
    table.insert(ped_info.main, info)

    -- Alertness
    local alertness = PED.GET_PED_ALERTNESS(ped)
    info = { "Alertness", enum_Alertness[alertness] }
    table.insert(ped_info.main, info)


    ----- Dead -----
    if PED.IS_PED_DEAD_OR_DYING(ped, 1) then
        local cause_model_hash = PED.GET_PED_CAUSE_OF_DEATH(ped)

        --Cause of Death Model
        local cause_model_name = util.reverse_joaat(cause_model_hash)
        if cause_model_name ~= "" then
            info = { "Cause of Death Model", cause_model_name }
            table.insert(ped_info.dead, info)
        end

        --Cause of Death Hash
        info = { "Cause of Death Hash", cause_model_hash }
        table.insert(ped_info.dead, info)

        --Death Time
        info = { "Death Time", PED.GET_PED_TIME_OF_DEATH(ped) }
        table.insert(ped_info.dead, info)
    end


    ----- Relationship & Group -----

    -- Relationship
    local rel = PED.GET_RELATIONSHIP_BETWEEN_PEDS(ped, players.user_ped())
    info = { "Relationship", enum_RelationshipType[rel] }
    table.insert(ped_info.rel_group, info)

    -- Relationship Group Hash
    local rel_group_hash = PED.GET_PED_RELATIONSHIP_GROUP_HASH(ped)
    info = { "Relationship Group Hash", rel_group_hash }
    table.insert(ped_info.rel_group, info)

    -- Player Relationship Group Hash
    local my_rel_group_hash = PED.GET_PED_RELATIONSHIP_GROUP_HASH(players.user_ped())
    info = { "Player Relationship Group Hash", my_rel_group_hash }
    table.insert(ped_info.rel_group, info)

    -- Group Relationship
    local rel = PED.GET_RELATIONSHIP_BETWEEN_GROUPS(rel_group_hash, my_rel_group_hash)
    info = { "Group Relationship", enum_RelationshipType[rel] }
    table.insert(ped_info.rel_group, info)

    -- Group
    if PED.IS_PED_IN_GROUP(ped) then
        local group_id = PED.GET_PED_GROUP_INDEX(ped)
        info = { "Group Index", group_id }
        table.insert(ped_info.rel_group, info)
    end



    return ped_info
end

function Entity_Info.ped_combat_float(ped)
    local ped_info = {}

    local info = {} -- name, value

    for index, value in pairs(Ped_CombatFloat.List) do
        local name = value[1]
        local id = Ped_CombatFloat.ValueList[index]
        -- local comment = value[2]

        info = { name, PED.GET_COMBAT_FLOAT(ped, id) }
        table.insert(ped_info, info)
    end

    return ped_info
end

function Entity_Info.vehicle_info(vehicle)
    local vehicle_info = {
        main = {},
        heli = {},
    }

    local info = {} -- name, value
    local t = ""

    local model_hash = ENTITY.GET_ENTITY_MODEL(vehicle)

    -- Display Name
    local display_name = util.get_label_text(VEHICLE.GET_DISPLAY_NAME_FROM_VEHICLE_MODEL(model_hash))
    if display_name ~= "NULL" then
        info = { "Display Name", display_name }
        table.insert(vehicle_info.main, info)
    end

    -- Vehicle Class
    local vehicle_class = VEHICLE.GET_VEHICLE_CLASS(vehicle)
    t = util.get_label_text("VEH_CLASS_" .. vehicle_class)
    info = { "Vehicle Class", t }
    table.insert(vehicle_info.main, info)

    -- Dirt Level
    local dirt_level = VEHICLE.GET_VEHICLE_DIRT_LEVEL(vehicle)
    info = { "Dirt Level", string.format("%.2f", dirt_level) }
    table.insert(vehicle_info.main, info)

    -- Door Lock Status
    local door_lock_status = VEHICLE.GET_VEHICLE_DOOR_LOCK_STATUS(vehicle)
    info = { "Door Lock Status", enum_VehicleLockStatus[door_lock_status] }
    table.insert(vehicle_info.main, info)

    -- Engine Health
    info = { "Engine Health", VEHICLE.GET_VEHICLE_ENGINE_HEALTH(vehicle) }
    table.insert(vehicle_info.main, info)

    -- Petrol Tank Health
    info = { "Petrol Tank Health", VEHICLE.GET_VEHICLE_PETROL_TANK_HEALTH(vehicle) }
    table.insert(vehicle_info.main, info)

    -- Body Health
    info = { "Body Health", VEHICLE.GET_VEHICLE_BODY_HEALTH(vehicle) }
    table.insert(vehicle_info.main, info)


    ----- Heli -----
    if VEHICLE.IS_THIS_MODEL_A_HELI(model_hash) then
        -- Main Rotor Health
        info = { "Heli Main Rotor Health", VEHICLE.GET_HELI_MAIN_ROTOR_HEALTH(vehicle) }
        table.insert(vehicle_info.heli, info)

        -- Tail Rotor Health
        info = { "Heli Tail Rotor Health", VEHICLE.GET_HELI_TAIL_ROTOR_HEALTH(vehicle) }
        table.insert(vehicle_info.heli, info)

        -- Boom Rotor Health
        info = { "Heli Boom Rotor Health", VEHICLE.GET_HELI_TAIL_BOOM_HEALTH(vehicle) }
        table.insert(vehicle_info.heli, info)
    end


    return vehicle_info
end

function Entity_Info.vehicle_mod(vehicle)
    local vehicle_info = {
        color = {},
        kit = {},
    }

    local info = {} -- name, value
    local t = ""

    local enum_ModKitType = {
        [0] = "Standard",
        [1] = "Sport",
        [2] = "SUV",
        [3] = "Special"
    }
    local enum_ModColorType = {
        [0] = "Metallic",
        [1] = "Classic",
        [2] = "Pearlescent",
        [3] = "Matte",
        [4] = "Metals",
        [5] = "Chrome",
        [6] = "Chameleon",
        [7] = "None" -- if this is set, the vehicle doesn't use mod colors, it uses the regular color system
    }
    local enum_ModWheelType = {
        [-1] = "Invalid",
        [0] = "Sport",
        [1] = "Muscle",
        [2] = "Lowrider",
        [3] = "SUV",
        [4] = "Offroad",
        [5] = "Tuner",
        [6] = "Bike",
        [7] = "Hiend",
        [8] = "Super Mod 1",
        [9] = "Super Mod 2",
        [10] = "Super Mod 3",
        [11] = "Super Mod 4",
        [12] = "Super Mod 5"
    }
    local enum_ModType = {
        [0] = "Spoiler",
        [1] = "Bumper_F",
        [2] = "Bumper_R",
        [3] = "Skirt",
        [4] = "Exhaust",
        [5] = "Chassis",
        [6] = "Grill",
        [7] = "Bonnet",
        [8] = "Wing_L",
        [9] = "Wing_R",
        [10] = "Roof",

        [11] = "Engine",
        [12] = "Brakes",
        [13] = "Gearbox",
        [14] = "Horn",
        [15] = "Suspension",
        [16] = "Armour",

        [17] = "Toggle_Nitrous",
        [18] = "Toggle_Turbo",
        [19] = "Toggle_Subwoofer",
        [20] = "Toggle_Tyre_Smoke",
        [21] = "Toggle_Hydraulics",
        [22] = "Toggle_Xenon_Lights",

        [23] = "Wheels",
        [24] = "Rear_Wheels",

        [25] = "Pltholder",
        [26] = "Pltvanity",

        [27] = "Interior1",
        [28] = "Interior2",
        [29] = "Interior3",
        [30] = "Interior4",
        [31] = "Interior5",
        [32] = "Seats",
        [33] = "Steering",
        [34] = "Knob",
        [35] = "Plaque",
        [36] = "Ice",

        [37] = "Trunk",
        [38] = "Hydro",

        [39] = "Enginebay1",
        [40] = "Enginebay2",
        [41] = "Enginebay3",

        [42] = "Chassis2",
        [43] = "Chassis3",
        [44] = "Chassis4",
        [45] = "Chassis5",

        [46] = "Door_L",
        [47] = "Door_R",
        [48] = "Livery",
    }


    --#region Vehicle Colour

    local colorR, colorG, colorB = memory.alloc(1), memory.alloc(1), memory.alloc(1)

    -- Primary Colour
    if VEHICLE.GET_IS_VEHICLE_PRIMARY_COLOUR_CUSTOM(vehicle) then
        VEHICLE.GET_VEHICLE_CUSTOM_PRIMARY_COLOUR(vehicle, colorR, colorG, colorB)
        t = memory.read_ubyte(colorR) .. "," .. memory.read_ubyte(colorG) .. "," .. memory.read_ubyte(colorB)
        info = { "Primary Colour", t }
        table.insert(vehicle_info.color, info)
    end

    -- Secondary Colour
    if VEHICLE.GET_IS_VEHICLE_SECONDARY_COLOUR_CUSTOM(vehicle) then
        VEHICLE.GET_VEHICLE_CUSTOM_SECONDARY_COLOUR(vehicle, colorR, colorG, colorB)
        t = memory.read_ubyte(colorR) .. "," .. memory.read_ubyte(colorG) .. "," .. memory.read_ubyte(colorB)
        info = { "Secondary Colour", t }
        table.insert(vehicle_info.color, info)
    end

    -- Mod Color 1
    VEHICLE.GET_VEHICLE_MOD_COLOR_1(vehicle, colorR, colorG, colorB)
    t = memory.read_ubyte(colorR)
    if enum_ModColorType[t] ~= nil then
        t = enum_ModColorType[t]
    end
    info = { "Mod Color 1 color Type", t }
    table.insert(vehicle_info.color, info)

    info = { "Mod Color 1 base Col Index", memory.read_ubyte(colorG) }
    table.insert(vehicle_info.color, info)

    info = { "Mod Color 1 spec Col Index", memory.read_ubyte(colorB) }
    table.insert(vehicle_info.color, info)

    -- Mod Color 1 Name
    t = VEHICLE.GET_VEHICLE_MOD_COLOR_1_NAME(vehicle, 0)
    if t ~= nil then
        info = { "Mod Color 1 Name", t }
        table.insert(vehicle_info.color, info)
    end

    -- Mod Color 2
    VEHICLE.GET_VEHICLE_MOD_COLOR_2(vehicle, colorR, colorG)
    t = memory.read_ubyte(colorR)
    if enum_ModColorType[t] ~= nil then
        t = enum_ModColorType[t]
    end
    info = { "Mod Color 2 color Type", t }
    table.insert(vehicle_info.color, info)

    info = { "Mod Color 2 base Col Index", memory.read_ubyte(colorG) }
    table.insert(vehicle_info.color, info)

    -- Mod Color 2 Name
    t = VEHICLE.GET_VEHICLE_MOD_COLOR_2_NAME(vehicle)
    if t ~= nil then
        info = { "Mod Color 2 Name", t }
        table.insert(vehicle_info.color, info)
    end

    --#endregion


    --#region Vehicle Mod Kit

    -- Mod Kit Type
    local mod_kit_type = VEHICLE.GET_VEHICLE_MOD_KIT_TYPE(vehicle)
    info = { "Mod Kit Type", enum_ModKitType[mod_kit_type] }
    table.insert(vehicle_info.kit, info)

    for i = 0, 48 do
        local mod_value = VEHICLE.GET_VEHICLE_MOD(vehicle, i)
        if mod_value ~= -1 then
            info = { enum_ModType[i], mod_value }
            table.insert(vehicle_info.kit, info)
        end
    end

    -- Wheel Type
    local wheel_type = VEHICLE.GET_VEHICLE_WHEEL_TYPE(vehicle)
    info = { "Wheel Type", enum_ModWheelType[wheel_type] }
    table.insert(vehicle_info.kit, info)


    --#endregion

    return vehicle_info
end

function Entity_Info.clear_menu(menu_parent)
    for _, command_ref in pairs(menu.get_children(menu_parent)) do
        if menu.is_ref_valid(command_ref) then
            menu.delete(command_ref)
        end
    end
end

function Entity_Info.generate_menu(menu_parent, list_item_data)
    for k, item in pairs(list_item_data) do
        local name = item[1]
        local value = tostring(item[2])

        local menu_name = name .. ": " .. value
        menu.action(menu_parent, menu_name, {}, "", function()
            util.copy_to_clipboard(menu_name, false)
            util.toast("已复制\n" .. menu_name)
        end)
    end
end

local entity_info2 = {
    method_select = 1,
    info_data = {
        entity = {},
        ped = {},
        vehicle = {},
    },

    -- menu.list
    menu_entity = 0,
    menu_ped = 0,
    menu_vehicle = 0,
}

menu.toggle_loop(Entity_Info_Gun2, "开启", {}, "", function()
    draw_point_in_center()

    local ent = 0
    if entity_info2.method_select == 1 then
        ent = get_entity_player_is_aiming_at(players.user())
    else
        if PAD.IS_CONTROL_PRESSED(0, 51) then
            local result = get_raycast_result(1500, -1)
            if result.didHit then
                ent = result.hitEntity
            end
        end
    end

    if ent ~= nil and IS_AN_ENTITY(ent) then
        entity_info2.info_data = Entity_Info.get_entity_info(ent)
    end
end)

menu.list_select(Entity_Info_Gun2, "方式", {}, "", {
    { "武器瞄准(右键瞄准)" }, { "镜头瞄准(按E获取)" }
}, 1, function(value)
    entity_info2.method_select = value
end)

menu.divider(Entity_Info_Gun2, "实体信息")

entity_info2.menu_entity = menu.list(Entity_Info_Gun2, "Entity", {}, "", function()
    local menu_parent = entity_info2.menu_entity
    local data = entity_info2.info_data.entity

    -- clear old menu
    Entity_Info.clear_menu(menu_parent)

    -- generate new menu
    if next(data) == nil then
        return false
    end

    Entity_Info.generate_menu(menu_parent, data.main)

    if next(data.blip) ~= nil then
        local menu_blip = menu.list(menu_parent, "Entity Blip", {}, "")
        Entity_Info.generate_menu(menu_blip, data.blip)
    end

    if next(data.attached) ~= nil then
        local menu_attached = menu.list(menu_parent, "Attached Entity", {}, "")
        Entity_Info.generate_menu(menu_attached, data.attached)
    end

    local menu_other = menu.list(menu_parent, "Other", {}, "")
    Entity_Info.generate_menu(menu_other, data.other)
end)

entity_info2.menu_ped = menu.list(Entity_Info_Gun2, "Ped", {}, "", function()
    local menu_parent = entity_info2.menu_ped
    local data = entity_info2.info_data.ped

    -- clear old menu
    Entity_Info.clear_menu(menu_parent)

    -- generate new menu
    if next(data) == nil then
        return false
    end

    Entity_Info.generate_menu(menu_parent, data.main)

    if next(data.dead) ~= nil then
        local menu_dead = menu.list(menu_parent, "Dead", {}, "")
        Entity_Info.generate_menu(menu_dead, data.dead)
    end

    local menu_rel_group = menu.list(menu_parent, "Relationship & Group", {}, "")
    Entity_Info.generate_menu(menu_rel_group, data.rel_group)


    local ped = Entity_Info.entity

    local menu_combat_float
    menu_combat_float = menu.list(menu_parent, "Combat Float", {}, "", function()
        Entity_Info.clear_menu(menu_combat_float)

        if not ENTITY.DOES_ENTITY_EXIST(ped) then
            return false
        end

        Entity_Info.generate_menu(menu_combat_float, Entity_Info.ped_combat_float(ped))
    end)
end)

entity_info2.menu_vehicle = menu.list(Entity_Info_Gun2, "Vehicle", {}, "", function()
    local menu_parent = entity_info2.menu_vehicle
    local data = entity_info2.info_data.vehicle

    -- clear old menu
    Entity_Info.clear_menu(menu_parent)

    -- generate new menu
    if next(data) == nil then
        return false
    end

    Entity_Info.generate_menu(menu_parent, data.main)

    if next(data.heli) ~= nil then
        local menu_heli = menu.list(menu_parent, "Heli", {}, "")
        Entity_Info.generate_menu(menu_heli, data.heli)
    end


    local vehicle = Entity_Info.entity

    local menu_mod
    menu_mod = menu.list(menu_parent, "Mod", {}, "", function()
        Entity_Info.clear_menu(menu_mod)

        if not ENTITY.DOES_ENTITY_EXIST(vehicle) then
            return false
        end

        data.mod = Entity_Info.vehicle_mod(vehicle)

        local menu_mod_color = menu.list(menu_mod, "Mod Color", {}, "")
        Entity_Info.generate_menu(menu_mod_color, data.mod.color)

        local menu_mod_kit = menu.list(menu_mod, "Mod Kit", {}, "")
        Entity_Info.generate_menu(menu_mod_kit, data.mod.kit)
    end)
end)


--#endregion Entity Info Gun
