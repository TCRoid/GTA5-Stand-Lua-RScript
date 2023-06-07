-------------------------------
--- Author: Rostal#9913
-------------------------------

util.keep_running()
util.require_natives("1681379138")

local SCRIPT_VERSION <const> = "2023/6/7"

local SUPPORT_GTAO <const> = 1.66




------------------------------
--------- File & Dir ---------
------------------------------

-- Store
local StoreDir <const> = filesystem.store_dir() .. "RScript\\"
if not filesystem.exists(StoreDir) then
    filesystem.mkdir(StoreDir)
end

-- Resource
local ResourceDir <const> = filesystem.resources_dir() .. "RScript\\"
Texture = {
    file = {
        point = ResourceDir .. "point.png",
        crosshair = ResourceDir .. "crosshair.png",
    },
}
for _, file in pairs(Texture.file) do
    if not filesystem.exists(file) then
        util.toast("[RScript] 缺少文件: " .. file, TOAST_ALL)
        util.toast("脚本已停止运行")
        util.stop_script()
    end
end

Texture.point = directx.create_texture(Texture.file.point)
Texture.crosshair = directx.create_texture(Texture.file.crosshair)

-- Lib
local ScriptDir <const> = filesystem.scripts_dir()
local Required_Files <const> = {
    "lib\\RScript\\labels.lua",
    "lib\\RScript\\variables.lua",
    "lib\\RScript\\functions.lua",
    "lib\\RScript\\functions2.lua",
    "lib\\RScript\\Menu\\Entity.lua",
    "lib\\RScript\\Menu\\Mission.lua",
    "lib\\RScript\\Menu\\Online.lua",
    "lib\\RScript\\Menu\\Dev.lua",
    "lib\\RScript\\Menu\\Fun.lua",
    "lib\\RScript\\Menu\\Player.lua",
}
for _, file in pairs(Required_Files) do
    local file_path = ScriptDir .. file
    if not filesystem.exists(file_path) then
        util.toast("[RScript] 缺少文件: " .. file_path, TOAST_ALL)
        util.toast("脚本已停止运行")
        util.stop_script()
    end
end

-- Require
require "RScript.labels"
require "RScript.variables"
require "RScript.functions"
require "RScript.functions2"




---返回实体信息 list item data
function GetEntityInfo_ListItem(ent)
    if ent ~= nil and ENTITY.DOES_ENTITY_EXIST(ent) then
        local ent_info_item_data = {}
        local t = ""

        local model_hash = ENTITY.GET_ENTITY_MODEL(ent)

        --Model Name
        local model_name = util.reverse_joaat(model_hash)
        if model_name ~= "" then
            t = "Model Name: " .. model_name
        end
        table.insert(ent_info_item_data, newTableValue(1, t))

        --Hash
        t = "Model Hash: " .. model_hash
        table.insert(ent_info_item_data, newTableValue(1, t))

        --Type
        local entity_type = GET_ENTITY_TYPE(ent, 2)
        t = "Entity Type: " .. entity_type
        table.insert(ent_info_item_data, newTableValue(1, t))

        --Mission Entity
        if ENTITY.IS_ENTITY_A_MISSION_ENTITY(ent) then
            t = "Mission Entity: True"
        else
            t = "Mission Entity: False"
        end
        table.insert(ent_info_item_data, newTableValue(1, t))

        --Health
        t = "Entity Health: " .. ENTITY.GET_ENTITY_HEALTH(ent) .. "/" .. ENTITY.GET_ENTITY_MAX_HEALTH(ent)
        table.insert(ent_info_item_data, newTableValue(1, t))

        --Dead
        if ENTITY.IS_ENTITY_DEAD(ent) then
            t = "Entity Dead: True"
            ent_info = newTableValue(1, t)
            table.insert(ent_info_item_data, ent_info)
        end

        --Position
        local ent_pos = ENTITY.GET_ENTITY_COORDS(ent)
        t = "Coords: " ..
            string.format("%.4f", ent_pos.x) ..
            ", " .. string.format("%.4f", ent_pos.y) .. ", " .. string.format("%.4f", ent_pos.z)
        table.insert(ent_info_item_data, newTableValue(1, t))

        local my_pos = ENTITY.GET_ENTITY_COORDS(players.user_ped())
        -- t = "Your Coords: " ..
        --     string.format("%.4f", my_pos.x) ..
        --     ", " .. string.format("%.4f", my_pos.y) .. ", " .. string.format("%.4f", my_pos.z)
        -- ent_info = newTableValue(1, t)
        -- table.insert(ent_info_item_data, ent_info)

        --Heading
        t = "Entity Heading: " .. string.format("%.4f", ENTITY.GET_ENTITY_HEADING(ent))
        table.insert(ent_info_item_data, newTableValue(1, t))

        t = "Your Heading: " .. string.format("%.4f", ENTITY.GET_ENTITY_HEADING(players.user_ped()))
        table.insert(ent_info_item_data, newTableValue(1, t))

        --Distance
        local distance = Vector.dist(my_pos, ent_pos)
        t = "Distance: " .. string.format("%.4f", distance)
        table.insert(ent_info_item_data, newTableValue(1, t))

        --Subtract with your position
        local pos_sub = Vector.subtract(my_pos, ent_pos)
        t = "Subtract Coords X: " ..
            string.format("%.2f", pos_sub.x) ..
            ", Y: " .. string.format("%.2f", pos_sub.y) .. ", Z: " .. string.format("%.2f", pos_sub.z)
        table.insert(ent_info_item_data, newTableValue(1, t))

        --Speed
        local speed = ENTITY.GET_ENTITY_SPEED(ent)
        t = "Entity Speed: " .. string.format("%.4f", speed)
        table.insert(ent_info_item_data, newTableValue(1, t))

        --Blip
        local blip = HUD.GET_BLIP_FROM_ENTITY(ent)
        if HUD.DOES_BLIP_EXIST(blip) then
            local blip_id = HUD.GET_BLIP_SPRITE(blip)
            t = "Blip Sprite ID: " .. blip_id
            table.insert(ent_info_item_data, newTableValue(1, t))

            local blip_colour = HUD.GET_BLIP_COLOUR(blip)
            t = "Blip Colour: " .. blip_colour
            table.insert(ent_info_item_data, newTableValue(1, t))
        end

        --Networked
        t = "Networked Entity: "
        if NETWORK.NETWORK_GET_ENTITY_IS_LOCAL(ent) then
            t = t .. "Local"
        end
        if NETWORK.NETWORK_GET_ENTITY_IS_NETWORKED(ent) then
            t = t .. " & Networked"
        end
        table.insert(ent_info_item_data, newTableValue(1, t))

        --Owner
        local owner = entities.get_owner(ent)
        owner = players.get_name(owner)
        t = "Entity Owner: " .. owner
        table.insert(ent_info_item_data, newTableValue(1, t))

        ----- Attached Entity -----
        if ENTITY.IS_ENTITY_ATTACHED(ent) then
            ent_info = newTableValue(1, "\n-----  Attached Entity  -----")
            table.insert(ent_info_item_data, ent_info)

            local attached_entity = ENTITY.GET_ENTITY_ATTACHED_TO(ent)
            local attached_hash = ENTITY.GET_ENTITY_MODEL(attached_entity)

            --Model Name
            local attached_model_name = util.reverse_joaat(attached_hash)
            if attached_model_name ~= "" then
                t = "Model Name: " .. attached_model_name
                ent_info = newTableValue(1, t)
                table.insert(ent_info_item_data, ent_info)
            end

            --Hash
            t = "Model Hash: " .. attached_hash
            ent_info = newTableValue(1, t)
            table.insert(ent_info_item_data, ent_info)

            --Type
            t = "Entity Type: " .. GET_ENTITY_TYPE(attached_entity, 2)
            ent_info = newTableValue(1, t)
            table.insert(ent_info_item_data, ent_info)
        end

        ----- Ped -----
        if ENTITY.IS_ENTITY_A_PED(ent) then
            ent_info = newTableValue(1, "\n-----  Ped  -----")
            table.insert(ent_info_item_data, ent_info)

            --Ped Type
            local ped_type = PED.GET_PED_TYPE(ent)
            t = "Ped Type: " .. enum_PedType[ped_type]
            ent_info = newTableValue(1, t)
            table.insert(ent_info_item_data, ent_info)

            --Armour
            t = "Armour: " .. PED.GET_PED_ARMOUR(ent)
            ent_info = newTableValue(1, t)
            table.insert(ent_info_item_data, ent_info)

            --Money
            t = "Money: " .. PED.GET_PED_MONEY(ent)
            ent_info = newTableValue(1, t)
            table.insert(ent_info_item_data, ent_info)

            --Relationship
            local rel = PED.GET_RELATIONSHIP_BETWEEN_PEDS(ent, players.user_ped())
            t = "Relationship: " .. enum_RelationshipType[rel]
            ent_info = newTableValue(1, t)
            table.insert(ent_info_item_data, ent_info)

            --Visual Field Center Angle
            t = "Visual Field Center Angle: " .. PED.GET_PED_VISUAL_FIELD_CENTER_ANGLE(ent)
            ent_info = newTableValue(1, t)
            table.insert(ent_info_item_data, ent_info)

            --Accuracy
            t = "Accuracy: " .. PED.GET_PED_ACCURACY(ent)
            ent_info = newTableValue(1, t)
            table.insert(ent_info_item_data, ent_info)

            --Combat Movement
            local combat_movement = PED.GET_PED_COMBAT_MOVEMENT(ent)
            t = "Combat Movement: " .. enum_CombatMovement[combat_movement]
            ent_info = newTableValue(1, t)
            table.insert(ent_info_item_data, ent_info)

            --Combat Range
            local combat_range = PED.GET_PED_COMBAT_RANGE(ent)
            t = "Combat Range: " .. enum_CombatRange[combat_range]
            ent_info = newTableValue(1, t)
            table.insert(ent_info_item_data, ent_info)

            --Alertness
            local alertness = PED.GET_PED_ALERTNESS(ent)
            if alertness >= 0 then
                t = "Alertness: " .. enum_Alertness[alertness]
                ent_info = newTableValue(1, t)
                table.insert(ent_info_item_data, ent_info)
            end

            --Dead
            if PED.IS_PED_DEAD_OR_DYING(ent, 1) then
                ent_info = newTableValue(1, "\n-----  Dead Ped  -----")
                table.insert(ent_info_item_data, ent_info)

                local cause_model_hash = PED.GET_PED_CAUSE_OF_DEATH(ent)

                --Cause of Death Model
                local cause_model_name = util.reverse_joaat(cause_model_hash)
                if cause_model_name ~= "" then
                    t = "Cause of Death Model: " .. cause_model_name
                    ent_info = newTableValue(1, t)
                    table.insert(ent_info_item_data, ent_info)
                end

                --Cause of Death Hash
                t = "Cause of Death Hash: " .. cause_model_hash
                ent_info = newTableValue(1, t)
                table.insert(ent_info_item_data, ent_info)

                --Death Time
                t = "Death Time: " .. PED.GET_PED_TIME_OF_DEATH(ent)
                ent_info = newTableValue(1, t)
                table.insert(ent_info_item_data, ent_info)
            end
        end

        ----- Vehicle -----
        if ENTITY.IS_ENTITY_A_VEHICLE(ent) then
            ent_info = newTableValue(1, "\n-----  Vehicle  -----")
            table.insert(ent_info_item_data, ent_info)

            --Display Name
            local display_name = util.get_label_text(VEHICLE.GET_DISPLAY_NAME_FROM_VEHICLE_MODEL(model_hash))
            if display_name ~= "NULL" then
                t = "Display Name: " .. display_name
                ent_info = newTableValue(1, t)
                table.insert(ent_info_item_data, ent_info)
            end

            --Vehicle Class
            local vehicle_class = VEHICLE.GET_VEHICLE_CLASS(ent)
            t = "Vehicle Class: " .. util.get_label_text("VEH_CLASS_" .. vehicle_class)
            ent_info = newTableValue(1, t)
            table.insert(ent_info_item_data, ent_info)

            --Engine Health
            t = "Engine Health: " .. VEHICLE.GET_VEHICLE_ENGINE_HEALTH(ent)
            ent_info = newTableValue(1, t)
            table.insert(ent_info_item_data, ent_info)

            --Petrol Tank Health
            t = "Petrol Tank Health: " .. VEHICLE.GET_VEHICLE_PETROL_TANK_HEALTH(ent)
            ent_info = newTableValue(1, t)
            table.insert(ent_info_item_data, ent_info)

            --Body Health
            t = "Body Health: " .. VEHICLE.GET_VEHICLE_BODY_HEALTH(ent)
            ent_info = newTableValue(1, t)
            table.insert(ent_info_item_data, ent_info)

            --- HELI ---
            if VEHICLE.IS_THIS_MODEL_A_HELI(model_hash) then
                --Heli Main Rotor Health
                t = "Heli Main Rotor Health: " .. VEHICLE.GET_HELI_MAIN_ROTOR_HEALTH(ent)
                ent_info = newTableValue(1, t)
                table.insert(ent_info_item_data, ent_info)

                --Heli Tail Rotor Health
                t = "Heli Tail Rotor Health: " .. VEHICLE.GET_HELI_TAIL_ROTOR_HEALTH(ent)
                ent_info = newTableValue(1, t)
                table.insert(ent_info_item_data, ent_info)

                --Heli Boom Rotor Health
                t = "Heli Boom Rotor Health: " .. VEHICLE.GET_HELI_TAIL_BOOM_HEALTH(ent)
                ent_info = newTableValue(1, t)
                table.insert(ent_info_item_data, ent_info)
            end

            --Dirt Level
            local dirt_level = VEHICLE.GET_VEHICLE_DIRT_LEVEL(ent)
            t = "Dirt Level: " .. string.format("%.2f", dirt_level)
            ent_info = newTableValue(1, t)
            table.insert(ent_info_item_data, ent_info)

            --Door Lock Status
            local door_lock_status = VEHICLE.GET_VEHICLE_DOOR_LOCK_STATUS(ent)
            t = "Door Lock Status: " .. enum_VehicleLockStatus[door_lock_status]
            ent_info = newTableValue(1, t)
            table.insert(ent_info_item_data, ent_info)
        end

        return ent_info_item_data
    else
        local t = { "实体不存在" }
        return t
    end
end

tick_handler_data = {
    main = {
        draw_point_on_screen = false,
    },
    ------ 实体控制 ------
    control_ent = {
        show_info = {
            toggle = false,
            ent = 0,
        },
        draw_line = {
            toggle = false,
            ent = 0,
        },
        draw_bounding_box = {
            toggle = false,
            ent = 0,
        },
        tp_ent_to_me = {
            toggle = false,
            ent = 0,
            x = 0,
            y = 0,
            z = 0,
        },
        tp_to_ent = {
            toggle = false,
            ent = 0,
            x = 0,
            y = 0,
            z = 0,
        },
        preview_ent = {
            toggle = false,
            ent = 0,
            clone_ent = 0,
            has_cloned_ent = 0,
            camera_distance = 2.0,
        },
    },
}

function tick_handler_data.control_ent.clear()
    tick_handler_data.control_ent.show_info.toggle = false
    tick_handler_data.control_ent.draw_line.toggle = false
    tick_handler_data.control_ent.draw_bounding_box.toggle = false
    tick_handler_data.control_ent.tp_ent_to_me.toggle = false
    tick_handler_data.control_ent.tp_to_ent.toggle = false
    tick_handler_data.control_ent.preview_ent.toggle = false
end

util.create_tick_handler(function()
    if tick_handler_data.main.draw_point_on_screen then
        draw_point_in_center()
    end


    ------ 实体控制 ------

    local control_ent = tick_handler_data.control_ent

    --显示实体信息
    if control_ent.show_info.toggle then
        if not ENTITY.DOES_ENTITY_EXIST(control_ent.show_info.ent) then
            util.toast("该实体已经不存在")
            control_ent.show_info.toggle = false
        else
            local ent_info_item_data = GetEntityInfo_ListItem(control_ent.show_info.ent)
            local text = ""
            for _, info in pairs(ent_info_item_data) do
                if info[1] ~= nil then
                    text = text .. info[1] .. "\n"
                end
            end
            DrawString(text, 0.7)
        end
    end

    --和实体连线
    if control_ent.draw_line.toggle then
        if not ENTITY.DOES_ENTITY_EXIST(control_ent.draw_line.ent) then
            util.toast("该实体已经不存在")
            control_ent.draw_line.toggle = false
        else
            local pos1 = ENTITY.GET_ENTITY_COORDS(players.user_ped())
            local pos2 = ENTITY.GET_ENTITY_COORDS(control_ent.draw_line.ent)
            DRAW_LINE(pos1, pos2)
            util.draw_ar_beacon(pos2)
        end
    end

    --描绘实体边界框
    if control_ent.draw_bounding_box.toggle then
        if not ENTITY.DOES_ENTITY_EXIST(control_ent.draw_bounding_box.ent) then
            util.toast("该实体已经不存在")
            control_ent.draw_bounding_box.toggle = false
        else
            draw_bounding_box(control_ent.draw_bounding_box.ent)
        end
    end

    --锁定 实体传送到我
    if control_ent.tp_ent_to_me.toggle then
        if not ENTITY.DOES_ENTITY_EXIST(control_ent.tp_ent_to_me.ent) then
            util.toast("该实体已经不存在")
            control_ent.tp_ent_to_me.toggle = false
        else
            TP_TO_ME(control_ent.tp_ent_to_me.ent,
                control_ent.tp_ent_to_me.x,
                control_ent.tp_ent_to_me.y,
                control_ent.tp_ent_to_me.z)
        end
    end

    --锁定 传送到实体
    if control_ent.tp_to_ent.toggle then
        if not ENTITY.DOES_ENTITY_EXIST(control_ent.tp_to_ent.ent) then
            util.toast("该实体已经不存在")
            control_ent.tp_to_ent.toggle = false
        else
            TP_TO_ENTITY(control_ent.tp_to_ent.ent,
                control_ent.tp_to_ent.x,
                control_ent.tp_to_ent.y,
                control_ent.tp_to_ent.z)
        end
    end

    --预览实体
    if control_ent.preview_ent.toggle then
        local target_ent = control_ent.preview_ent.ent
        local clone_ent = control_ent.preview_ent.clone_ent
        if not ENTITY.DOES_ENTITY_EXIST(target_ent) then
            util.toast("该实体已经不存在")
            control_ent.preview_ent.toggle = false
        elseif control_ent.preview_ent.has_cloned_ent ~= target_ent and not ENTITY.DOES_ENTITY_EXIST(clone_ent) then
            -- 生成（克隆）预览实体
            local l, w, h = calculate_model_size(ENTITY.GET_ENTITY_MODEL(target_ent))
            control_ent.preview_ent.camera_distance = math.max(l, w, h) + 1.0
            local coords = get_offset_from_cam(control_ent.preview_ent.camera_distance)
            local heading = ENTITY.GET_ENTITY_HEADING(players.user_ped()) + 180.0

            if ENTITY.IS_ENTITY_A_PED(target_ent) then
                clone_ent = clone_target_ped(target_ent, coords, heading, false)
            elseif ENTITY.IS_ENTITY_A_VEHICLE(target_ent) then
                clone_ent = clone_target_vehicle(target_ent, coords, heading, false)
            elseif ENTITY.IS_ENTITY_AN_OBJECT(target_ent) then
                clone_ent = clone_target_object(target_ent, coords, false)
            end

            ENTITY.FREEZE_ENTITY_POSITION(clone_ent, true)
            ENTITY.SET_ENTITY_ALPHA(clone_ent, 206, false)
            ENTITY.SET_ENTITY_COMPLETELY_DISABLE_COLLISION(clone_ent, false, true)

            control_ent.preview_ent.clone_ent = clone_ent
            control_ent.preview_ent.has_cloned_ent = target_ent
        elseif control_ent.preview_ent.has_cloned_ent == target_ent and ENTITY.DOES_ENTITY_EXIST(clone_ent) then
            -- 旋转预览实体
            local coords = get_offset_from_cam(control_ent.preview_ent.camera_distance)
            local heading = ENTITY.GET_ENTITY_HEADING(clone_ent) + 0.5

            SET_ENTITY_COORDS(clone_ent, coords)
            ENTITY.SET_ENTITY_HEADING(clone_ent, heading)
        end
    elseif ENTITY.DOES_ENTITY_EXIST(control_ent.preview_ent.clone_ent) then
        entities.delete_by_handle(control_ent.preview_ent.clone_ent)
        control_ent.preview_ent.has_cloned_ent = 0
    end
end)



--#region Entity Control Functions

--------------------------------------
------ Entity Control Functions ------
--------------------------------------

Entity_Control = {}

-- 返回 menu_name, help_text
function Entity_Control.get_menu_info(ent, k)
    local modelHash = ENTITY.GET_ENTITY_MODEL(ent)
    local modelName = util.reverse_joaat(modelHash)
    local menu_name = k .. ". "
    if modelName ~= "" then
        menu_name = menu_name .. modelName
    else
        menu_name = menu_name .. modelHash
    end

    local help_text = ""

    if ENTITY.IS_ENTITY_A_VEHICLE(ent) then
        if ent == entities.get_user_personal_vehicle_as_handle() then
            menu_name = menu_name .. " (个人载具)"
        elseif ent == entities.get_user_vehicle_as_handle() then
            if PED.IS_PED_IN_ANY_VEHICLE(players.user_ped(), false) then
                menu_name = menu_name .. " (当前载具)"
            else
                menu_name = menu_name .. " (上一辆载具)"
            end
        end

        local display_name = util.get_label_text(VEHICLE.GET_DISPLAY_NAME_FROM_VEHICLE_MODEL(modelHash))
        if display_name ~= "NULL" then
            help_text = help_text .. "Display Name: " .. display_name .. "\n"
        end
    end

    local owner = entities.get_owner(ent)
    owner = players.get_name(owner)
    help_text = help_text .. "Hash: " .. modelHash .. "\nOwner: " .. owner

    return menu_name, help_text
end

-- 创建对应实体的menu操作
function Entity_Control.generate_menu(menu_parent, ent, index)
    Entity_Control.entity(menu_parent, ent, index)

    if ENTITY.IS_ENTITY_A_PED(ent) then
        Entity_Control.ped(menu_parent, ent, index)
    end

    if ENTITY.IS_ENTITY_A_VEHICLE(ent) then
        Entity_Control.vehicle(menu_parent, ent, index)
    end

    if IS_ENTITY_A_PICKUP(ent) then
        Entity_Control.pickup(menu_parent, ent, index)
    end
end

----------------
-- Entity
----------------

function Entity_Control.entity(menu_parent, ent, index)
    menu.divider(menu_parent, menu.get_menu_name(menu_parent))

    menu.toggle(menu_parent, "描绘实体连线", {}, "", function(toggle)
        if toggle then
            if tick_handler_data.control_ent.draw_line.toggle then
                util.toast("正在描绘连线其它的实体")
            else
                tick_handler_data.control_ent.draw_line.ent = ent
                tick_handler_data.control_ent.draw_line.toggle = true
            end
        else
            if tick_handler_data.control_ent.draw_line.toggle and tick_handler_data.control_ent.draw_line.ent ~= ent then
            else
                tick_handler_data.control_ent.draw_line.toggle = false
            end
        end
    end)
    menu.toggle(menu_parent, "显示实体信息", {}, "", function(toggle)
        if toggle then
            if tick_handler_data.control_ent.show_info.toggle then
                util.toast("正在显示其它的实体信息")
            else
                tick_handler_data.control_ent.show_info.ent = ent
                tick_handler_data.control_ent.show_info.toggle = true
            end
        else
            if tick_handler_data.control_ent.show_info.toggle and tick_handler_data.control_ent.show_info.ent ~= ent then
            else
                tick_handler_data.control_ent.show_info.toggle = false
            end
        end
    end)

    menu.toggle(menu_parent, "预览实体", {}, "", function(toggle)
        if toggle then
            if tick_handler_data.control_ent.preview_ent.toggle then
                util.toast("正在预览其它的实体")
            else
                tick_handler_data.control_ent.preview_ent.ent = ent
                tick_handler_data.control_ent.preview_ent.toggle = true
            end
        else
            if tick_handler_data.control_ent.preview_ent.toggle and tick_handler_data.control_ent.preview_ent.ent ~= ent then
            else
                tick_handler_data.control_ent.preview_ent.toggle = false
            end
        end
    end)


    ----- 实体信息 -----
    local ent_info = menu.list(menu_parent, "实体信息", {}, "")

    menu.readonly(ent_info, "实体 Index:", ent)
    menu.readonly(ent_info, "实体 Hash:", ENTITY.GET_ENTITY_MODEL(ent))

    menu.toggle(ent_info, "描绘实体边界框", {}, "", function(toggle)
        if toggle then
            if tick_handler_data.control_ent.draw_bounding_box.toggle then
                util.toast("正在描绘其它的实体")
            else
                tick_handler_data.control_ent.draw_bounding_box.ent = ent
                tick_handler_data.control_ent.draw_bounding_box.toggle = true
            end
        else
            if tick_handler_data.control_ent.draw_bounding_box.toggle and
                tick_handler_data.control_ent.draw_bounding_box.ent ~= ent then
            else
                tick_handler_data.control_ent.draw_bounding_box.toggle = false
            end
        end
    end)
    menu.action(ent_info, "复制实体信息", {}, "", function()
        local ent_info_item_data = GetEntityInfo_ListItem(ent)
        local text = ""
        for _, info in pairs(ent_info_item_data) do
            if info[1] ~= nil then
                text = text .. info[1] .. "\n"
            end
        end
        util.copy_to_clipboard(text, false)
        util.toast("完成")
    end)
    menu.action(ent_info, "保存实体信息到日志", {}, "", function()
        local ent_info_item_data = GetEntityInfo_ListItem(ent)
        local text = ""
        for _, info in pairs(ent_info_item_data) do
            if info[1] ~= nil then
                text = text .. info[1] .. "\n"
            end
        end
        util.log(text)
        util.toast("完成")
    end)

    local save_hash = menu.list(ent_info, "保存到 Hash 列表", {}, "")
    local save_ent_hash_name = util.reverse_joaat(ENTITY.GET_ENTITY_MODEL(ent))
    menu.text_input(save_hash, "名称", { "save_ent_hash" .. index }, "", function(value)
        save_ent_hash_name = value
    end, save_ent_hash_name)
    menu.action(save_hash, "保存", {}, "", function()
        Saved_Hash_List.save(save_ent_hash_name, ent)
    end)



    menu.click_slider(menu_parent, "请求控制实体", { "request_ctrl_ent" .. index }, "发送请求控制的次数",
        1, 100, 20, 1, function(value)
            if RequestControl(ent, value) then
                util.toast("请求控制成功！")
            else
                util.toast("请求控制失败")
            end
        end)



    ----- Entity 选项 -----
    local entity_options = menu.list(menu_parent, "Entity 选项", {}, "")

    menu.toggle(entity_options, "无敌", {}, "", function(toggle)
        ENTITY.SET_ENTITY_INVINCIBLE(ent, toggle)
        ENTITY.SET_ENTITY_PROOFS(ent, toggle, toggle, toggle, toggle, toggle, toggle, toggle, toggle)
    end)
    menu.toggle(entity_options, "冻结", {}, "", function(toggle)
        ENTITY.FREEZE_ENTITY_POSITION(ent, toggle)
    end)

    local explosion_type = 4
    menu.list_select(entity_options, "选择爆炸类型", {}, "", ExplosionType_ListItem, 6, function(value)
        explosion_type = value - 2
    end)
    menu.toggle_loop(entity_options, "爆炸", {}, "", function()
        local pos = ENTITY.GET_ENTITY_COORDS(ent)
        add_explosion(pos, explosion_type)

        util.yield(500)
    end)

    menu.toggle(entity_options, "无碰撞", {}, "可以直接穿过实体", function(toggle)
        ENTITY.SET_ENTITY_COLLISION(ent, not toggle, true)
    end)
    menu.toggle(entity_options, "隐形", {}, "将实体隐形", function(toggle)
        ENTITY.SET_ENTITY_VISIBLE(ent, not toggle, 0)
    end)
    menu.toggle(entity_options, "无重力", {}, "", function(toggle)
        ENTITY.SET_ENTITY_HAS_GRAVITY(ent, not toggle)
    end)
    menu.toggle(entity_options, "地图标记点", {}, "", function(toggle)
        if toggle then
            local blip = HUD.GET_BLIP_FROM_ENTITY(ent)
            --no blip
            if not HUD.DOES_BLIP_EXIST(blip) then
                local color = 27
                --ped combat
                if ENTITY.IS_ENTITY_A_PED(ent) then
                    if PED.IS_PED_IN_COMBAT(ent, players.user_ped()) then
                        color = 1
                    end
                end
                --vehicle combat
                if ENTITY.IS_ENTITY_A_VEHICLE(ent) then
                    local ped = VEHICLE.GET_PED_IN_VEHICLE_SEAT(ent, -1)
                    if ped ~= 0 then
                        if PED.IS_PED_IN_COMBAT(ped, players.user_ped()) then
                            color = 1
                        end
                    end
                end

                blip = HUD.ADD_BLIP_FOR_ENTITY(ent)
                HUD.SET_BLIP_COLOUR(blip, color)
            end
        else
            local blip = HUD.GET_BLIP_FROM_ENTITY(ent)
            if HUD.DOES_BLIP_EXIST(blip) then
                util.remove_blip(blip)
            end
        end
    end)
    menu.click_slider(entity_options, "设置透明度", { "ctrl_ent" .. index .. "_alpha" },
        "Ranging from 0 to 255 but chnages occur after every 20 percent (after every 51).",
        0, 255, 0, 5,
        function(value)
            ENTITY.SET_ENTITY_ALPHA(ent, value, false)
        end)
    menu.click_slider(entity_options, "设置最大速度", { "ctrl_ent" .. index .. "_max_speed" }, "",
        0, 1000, 0, 10,
        function(value)
            ENTITY.SET_ENTITY_MAX_SPEED(ent, value)
        end)

    menu.action(entity_options, "设置为任务实体", {}, "避免实体被自动清理", function()
        ENTITY.SET_ENTITY_AS_MISSION_ENTITY(ent, true, false)
        ENTITY.SET_ENTITY_SHOULD_FREEZE_WAITING_ON_COLLISION(ent, true)
        if ENTITY.IS_ENTITY_A_VEHICLE(ent) then
            VEHICLE.SET_VEHICLE_STAYS_FROZEN_WHEN_CLEANED_UP(ent, true)
            VEHICLE.SET_CLEAR_FREEZE_WAITING_ON_COLLISION_ONCE_PLAYER_ENTERS(ent, false)
        end
        util.toast(ENTITY.IS_ENTITY_A_MISSION_ENTITY(ent))
    end)
    menu.action(entity_options, "设置为网络实体", {}, "可将本地实体同步给其他玩家", function()
        util.toast(set_entity_networked(ent))
    end)
    menu.action(entity_options, "删除", {}, "", function()
        entities.delete_by_handle(ent)
    end)



    ----- Health 选项 -----
    local health_options = menu.list(menu_parent, "实体血量", {}, "")

    local readonly_ent_health = menu.readonly(health_options, "血量")
    menu.on_tick_in_viewport(readonly_ent_health, function()
        local health = ENTITY.GET_ENTITY_HEALTH(ent)
        local max_health = ENTITY.GET_ENTITY_MAX_HEALTH(ent)
        menu.set_value(readonly_ent_health, health .. "/" .. max_health)
    end)
    menu.divider(health_options, "设置血量")
    local ctrl_ent_health = 1000
    menu.slider(health_options, "血量", { "ctrl_ent" .. index .. "_health" }, "", 0, 100000, 1000, 100,
        function(value)
            ctrl_ent_health = value
        end)
    menu.action(health_options, "当前血量", {}, "", function()
        ENTITY.SET_ENTITY_HEALTH(ent, ctrl_ent_health)
    end)
    menu.action(health_options, "最大血量", {}, "", function()
        ENTITY.SET_ENTITY_MAX_HEALTH(ent, ctrl_ent_health)
    end)



    Entity_Control.teleport(menu_parent, ent, index)
    Entity_Control.movement(menu_parent, ent, index)
end

function Entity_Control.teleport(menu_parent, ent, index)
    ----- Teleport 选项 -----
    local teleport_options = menu.list(menu_parent, "传送 选项", {}, "")

    local tp = {
        x = 0.0,
        y = 2.0,
        z = 0.0,
    }
    menu.slider_float(teleport_options, "前/后", { "ctrl_ent" .. index .. "_tp_x" }, "", -5000, 5000, 200, 50,
        function(value)
            tp.y = value * 0.01
        end)
    menu.slider_float(teleport_options, "上/下", { "ctrl_ent" .. index .. "_tp_y" }, "", -5000, 5000, 0, 50,
        function(value)
            tp.z = value * 0.01
        end)
    menu.slider_float(teleport_options, "左/右", { "ctrl_ent" .. index .. "_tp_z" }, "", -5000, 5000, 0, 50,
        function(value)
            tp.x = value * 0.01
        end)

    menu.action(teleport_options, "传送到实体", {}, "", function()
        TP_TO_ENTITY(ent, tp.x, tp.y, tp.z)
    end)
    menu.action(teleport_options, "传送到我", {}, "", function()
        TP_TO_ME(ent, tp.x, tp.y, tp.z)
    end)
    menu.toggle(teleport_options, "锁定传送到我", {}, "如果更改了位移，需要重新开关此选项",
        function(toggle)
            if toggle then
                if tick_handler_data.control_ent.tp_ent_to_me.toggle or tick_handler_data.control_ent.tp_to_ent.toggle then
                    util.toast("正在锁定传送其它的实体")
                else
                    tick_handler_data.control_ent.tp_ent_to_me.ent = ent
                    tick_handler_data.control_ent.tp_ent_to_me.x = tp.x
                    tick_handler_data.control_ent.tp_ent_to_me.y = tp.y
                    tick_handler_data.control_ent.tp_ent_to_me.z = tp.z
                    tick_handler_data.control_ent.tp_ent_to_me.toggle = true
                end
            else
                if tick_handler_data.control_ent.tp_ent_to_me.toggle and tick_handler_data.control_ent.tp_ent_to_me.ent ~= ent then
                else
                    tick_handler_data.control_ent.tp_ent_to_me.toggle = false
                end
            end
        end)
    menu.toggle(teleport_options, "锁定传送到实体", {}, "如果更改了位移，需要重新开关此选项",
        function(toggle)
            if toggle then
                if tick_handler_data.control_ent.tp_ent_to_me.toggle or tick_handler_data.control_ent.tp_to_ent.toggle then
                    util.toast("正在锁定传送其它的实体")
                else
                    tick_handler_data.control_ent.tp_to_ent.ent = ent
                    tick_handler_data.control_ent.tp_to_ent.x = tp.x
                    tick_handler_data.control_ent.tp_to_ent.y = tp.y
                    tick_handler_data.control_ent.tp_to_ent.z = tp.z
                    tick_handler_data.control_ent.tp_to_ent.toggle = true
                end
            else
                if tick_handler_data.control_ent.tp_to_ent.toggle and tick_handler_data.control_ent.tp_to_ent.ent ~= ent then
                else
                    tick_handler_data.control_ent.tp_to_ent.toggle = false
                end
            end
        end)
end

function Entity_Control.movement(menu_parent, ent, index)
    ----- Movement 选项 -----
    local movement_options = menu.list(menu_parent, "移动 选项", {}, "")

    menu.click_slider_float(movement_options, "前/后 移动", { "ctrl_ent" .. index .. "_move_y" }, "",
        -10000, 10000, 0, 50, function(value)
            value = value * 0.01
            SET_ENTITY_MOVE(ent, 0.0, value, 0.0)
        end)
    menu.click_slider_float(movement_options, "左/右 移动", { "ctrl_ent" .. index .. "_move_x" }, "",
        -10000, 10000, 0, 50, function(value)
            value = value * 0.01
            SET_ENTITY_MOVE(ent, value, 0.0, 0.0)
        end)
    menu.click_slider_float(movement_options, "上/下 移动", { "ctrl_ent" .. index .. "_move_z" }, "",
        -10000, 10000, 0, 50, function(value)
            value = value * 0.01
            SET_ENTITY_MOVE(ent, 0.0, 0.0, value)
        end)
    menu.click_slider_float(movement_options, "朝向", { "ctrl_ent" .. index .. "_head" }, "",
        -36000, 36000, 0, 100,
        function(value)
            value = value * 0.01
            local head = ENTITY.GET_ENTITY_HEADING(ent)
            ENTITY.SET_ENTITY_HEADING(ent, head + value)
        end)

    menu.divider(movement_options, "坐标")
    menu.action(movement_options, "刷新坐标", {}, "", function()
        local coords = ENTITY.GET_ENTITY_COORDS(ent)
        local pos = {}
        pos.x = string.format("%.2f", coords.x)
        pos.y = string.format("%.2f", coords.y)
        pos.z = string.format("%.2f", coords.z)
        menu.trigger_commands("ctrlent" .. index .. "x " .. pos.x)
        menu.trigger_commands("ctrlent" .. index .. "y " .. pos.y)
        menu.trigger_commands("ctrlent" .. index .. "z " .. pos.z)
    end)

    local coords = ENTITY.GET_ENTITY_COORDS(ent)
    local pos = {}
    pos.x = string.format("%.2f", coords.x) * 100
    pos.y = string.format("%.2f", coords.y) * 100
    pos.z = string.format("%.2f", coords.z) * 100
    menu.slider_float(movement_options, "X:", { "ctrl_ent" .. index .. "_x" }, "",
        -1000000, 1000000, math.ceil(pos.x), 50, function(value)
            local coords = ENTITY.GET_ENTITY_COORDS(ent)
            coords.x = value * 0.01
            SET_ENTITY_COORDS(ent, coords)
        end)
    menu.slider_float(movement_options, "Y:", { "ctrl_ent" .. index .. "_y" }, "",
        -1000000, 1000000, math.ceil(pos.y), 50, function(value)
            local coords = ENTITY.GET_ENTITY_COORDS(ent)
            coords.y = value * 0.01
            SET_ENTITY_COORDS(ent, coords)
        end)
    menu.slider_float(movement_options, "Z:", { "ctrl_ent" .. index .. "_z" }, "",
        -1000000, 1000000, math.ceil(pos.z), 50, function(value)
            local coords = ENTITY.GET_ENTITY_COORDS(ent)
            coords.z = value * 0.01
            SET_ENTITY_COORDS(ent, coords)
        end)
end

----------------
-- Ped
----------------

function Entity_Control.ped(menu_parent, ped, index)
    ----- Ped 选项 -----
    local ped_options = menu.list(menu_parent, "Ped 选项", {}, "")

    menu.toggle(ped_options, "燃烧", {}, "", function(toggle)
        if toggle then
            FIRE.START_ENTITY_FIRE(ped)
        else
            FIRE.STOP_ENTITY_FIRE(ped)
        end
    end)
    menu.action(ped_options, "传送到我的载具", {}, "", function()
        local vehicle = PED.GET_VEHICLE_PED_IS_IN(players.user_ped(), false)
        if vehicle ~= 0 then
            if VEHICLE.ARE_ANY_VEHICLE_SEATS_FREE(vehicle) then
                PED.SET_PED_INTO_VEHICLE(ped, vehicle, -2)
            end
        end
    end)
    menu.list_action(ped_options, "给予武器", {}, "", Weapon_Common.ListItem, function(value)
        local weaponHash = util.joaat(Weapon_Common.ModelList[value])
        WEAPON.GIVE_WEAPON_TO_PED(ped, weaponHash, -1, false, true)
        WEAPON.SET_CURRENT_PED_WEAPON(ped, weaponHash, false)
    end)
    menu.action(ped_options, "移除全部武器", {}, "", function()
        WEAPON.REMOVE_ALL_PED_WEAPONS(ped)
    end)
    menu.action(ped_options, "克隆", {}, "", function()
        local model = ENTITY.GET_ENTITY_MODEL(ped)
        local coords = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(ped, 0.0, 0.0, 2.0)
        local ped_type = PED.GET_PED_TYPE(ped)
        local heading = ENTITY.GET_ENTITY_HEADING(ped)
        local clone_ped = Create_Network_Ped(ped_type, model, coords.x, coords.y, coords.z, heading)
        PED.CLONE_PED_TO_TARGET(ped, clone_ped)
    end)
    menu.action(ped_options, "随机变装", {}, "", function()
        PED.SET_PED_RANDOM_COMPONENT_VARIATION(ped, 0)
        PED.SET_PED_RANDOM_PROPS(ped)
    end)
    menu.action(ped_options, "与玩家友好", {}, "", function()
        local player_rel_hash = PED.GET_PED_RELATIONSHIP_GROUP_HASH(players.user_ped())
        PED.SET_RELATIONSHIP_BETWEEN_GROUPS(0, player_rel_hash, player_rel_hash)
        PED.SET_PED_RELATIONSHIP_GROUP_HASH(ped, player_rel_hash)
    end)
    menu.action(ped_options, "清理外观", {}, "", function()
        PED.RESET_PED_VISIBLE_DAMAGE(ped)
        PED.CLEAR_PED_LAST_DAMAGE_BONE(ped)
        PED.CLEAR_PED_BLOOD_DAMAGE(ped)
        PED.CLEAR_PED_WETNESS(ped)
        PED.CLEAR_PED_ENV_DIRT(ped)
    end)
    menu.action(ped_options, "复活", {}, "", function()
        PED.RESURRECT_PED(ped)
    end)



    Entity_Control.ped_attribute(menu_parent, ped, index)
    Entity_Control.ped_combat(menu_parent, ped, index)
    Entity_Control.ped_task(menu_parent, ped, index)
end

function Entity_Control.ped_attribute(menu_parent, ped, index)
    ----- Ped Attribute 选项 -----
    local ped_attribute_options = menu.list(menu_parent, "Ped Attribute 选项", {}, "")

    local Alive_Status = menu.list(ped_attribute_options, "Alive Status", {}, "")
    menu.toggle(Alive_Status, "DIES_WHEN_INJURED", {},
        "Sets the ped will die when injured.", function(toggle)
            PED.SET_PED_DIES_WHEN_INJURED(ped, toggle)
        end)
    menu.toggle(Alive_Status, "ENABLE_WEAPON_BLOCKING", {},
        "Allows this non-player ped to use weapon blocked behavior.", function(toggle)
            PED.SET_PED_ENABLE_WEAPON_BLOCKING(ped, toggle)
        end)
    menu.toggle(Alive_Status, "DIES_IN_VEHICLE", {},
        "Sets the ped to die in the vehicle or play a special anim outside the vehicle.", function(toggle)
            PED.SET_PED_DIES_IN_VEHICLE(ped, toggle)
        end)

    local Movment_Attribute = menu.list(ped_attribute_options, "Movment Attribute", {}, "")
    menu.toggle(Movment_Attribute, "ALLOWED_TO_DUCK", {},
        "Sets if the ped is allowed to duck.", function(toggle)
            PED.SET_PED_ALLOWED_TO_DUCK(ped, toggle)
        end)
    menu.toggle(Movment_Attribute, "DUCKING", {},
        "Sets a ped to a ducking pose. \nMake sure that SET_PED_ALLOWED_TO_DUCK is set true.", function(toggle)
            PED.SET_PED_DUCKING(ped, toggle)
        end)

    local Damage_Status = menu.list(ped_attribute_options, "Damage Status", {}, "")
    menu.toggle(Damage_Status, "STAY_IN_VEHICLE_WHEN_JACKED", {},
        "Sets a passenger ped will stay in the vehicle when jacked.", function(toggle)
            PED.SET_PED_STAY_IN_VEHICLE_WHEN_JACKED(ped, toggle)
        end)
    menu.toggle(Damage_Status, "SET_DISABLE_HIGH_FALL_DEATH", {},
        "Sets the ped to not be instantly killed when falling from above 10m.", function(toggle)
            PED.SET_DISABLE_HIGH_FALL_DEATH(ped, toggle)
        end)

    local Water_Status = menu.list(ped_attribute_options, "Water Status", {}, "")
    menu.toggle(Water_Status, "DIES_IN_WATER", {},
        "Sets whether a ped takes damage in deep water.", function(toggle)
            PED.SET_PED_DIES_IN_WATER(ped, toggle)
        end)
    menu.toggle(Water_Status, "DIES_IN_SINKING_VEHICLE", {},
        "Sets whether a ped takes damage in a sinking vehicle.", function(toggle)
            PED.SET_PED_DIES_IN_SINKING_VEHICLE(ped, toggle)
        end)
    menu.toggle(Water_Status, "DIES_INSTANTLY_IN_WATER", {},
        "Sets whether the ped will die instantly if it finds itself in a body of water.", function(toggle)
            PED.SET_PED_DIES_INSTANTLY_IN_WATER(ped, toggle)
        end)

    local Combat_Status = menu.list(ped_attribute_options, "Combat Status", {}, "")
    menu.toggle(Combat_Status, "SUFFERS_CRITICAL_HITS", {},
        "Sets if a healthy character can be killed by a single bullet (e.g. head shot).", function(toggle)
            PED.SET_PED_SUFFERS_CRITICAL_HITS(ped, toggle)
        end)
    menu.toggle(Combat_Status, "UPPER_BODY_DAMAGE_ONLY", {},
        "Don't allow full body damage (e.g. fall over anims).", function(toggle)
            PED.SET_PED_UPPER_BODY_DAMAGE_ONLY(ped, toggle)
        end)
    menu.toggle(Combat_Status, "CAN_BE_SHOT_IN_VEHICLE", {},
        "Sets if a character can be killed while in a vehicle.", function(toggle)
            PED.SET_PED_CAN_BE_SHOT_IN_VEHICLE(ped, toggle)
        end)
    menu.toggle(Combat_Status, "SET_TREAT_AS_AMBIENT_PED_FOR_DRIVER_LOCKON", {},
        "Treats ped as ambient ped for driver lock on tests (e.g. mission peds we don't want to lock on to)."
        , function(toggle)
            PED.SET_TREAT_AS_AMBIENT_PED_FOR_DRIVER_LOCKON(ped, toggle)
        end)
    menu.toggle(Combat_Status, "CAN_BE_TARGETTED", {},
        "Sets if a ped can be targetted.", function(toggle)
            PED.SET_PED_CAN_BE_TARGETTED(ped, toggle)
        end)
    menu.toggle(Combat_Status, "SET_ALLOW_LOCKON_TO_PED_IF_FRIENDLY", {},
        "Sets if a ped can be targetted.", function(toggle)
            PED.SET_ALLOW_LOCKON_TO_PED_IF_FRIENDLY(ped, toggle)
        end)
    menu.toggle(Combat_Status, "SET_ENABLE_HANDCUFFS", {},
        "Set whether hands should be cuffed when ragdolling.", function(toggle)
            PED.SET_ENABLE_HANDCUFFS(ped, toggle)
        end)
    menu.toggle(Combat_Status, "SET_ENABLE_BOUND_ANKLES", {},
        "Set whether ankles should be cuffed when ragdolling.", function(toggle)
            PED.SET_ENABLE_BOUND_ANKLES(ped, toggle)
        end)
    menu.toggle(Combat_Status, "SET_ENABLE_SCUBA", {},
        "Set whether scuba gear is equipped to adjust swimming behavior.", function(toggle)
            PED.SET_ENABLE_SCUBA(ped, toggle)
        end)
    menu.toggle(Combat_Status, "CAN_EVASIVE_DIVE", {},
        "Set if a ped steps or dives out of the way of running peds or moving vehicles.", function(toggle)
            PED.SET_PED_CAN_EVASIVE_DIVE(ped, toggle)
        end)
    menu.toggle(Combat_Status, "WILL_ONLY_ATTACK_WANTED_PLAYER", {},
        "Sets the ped will attack the player only is they have a wanted level.", function(toggle)
            PED.SET_PED_WILL_ONLY_ATTACK_WANTED_PLAYER(ped, toggle)
        end)
    menu.toggle(Combat_Status, "CAN_BE_TARGETED_WHEN_INJURED", {},
        "Sets an injured ped can be targetted.", function(toggle)
            PED.SET_PED_CAN_BE_TARGETED_WHEN_INJURED(ped, toggle)
        end)
    menu.toggle(Combat_Status, "CAN_PEEK_IN_COVER", {},
        "Sets the ped can peek whilst in cover.", function(toggle)
            PED.SET_PED_CAN_PEEK_IN_COVER(ped, toggle)
        end)
    menu.toggle(Combat_Status, "CAN_COWER_IN_COVER", {},
        "Sets the ped can cower whilst in cover.", function(toggle)
            PED.SET_PED_CAN_COWER_IN_COVER(ped, toggle)
        end)
    menu.toggle(Combat_Status, "CAN_BE_TARGETED_WITHOUT_LOS", {},
        "The ped can be targetted through walls.", function(toggle)
            PED.SET_PED_CAN_BE_TARGETED_WITHOUT_LOS(ped, toggle)
        end)
    menu.toggle(Combat_Status, "CAN_SWITCH_WEAPON", {},
        "Set if a ped can swap weapons.", function(toggle)
            PED.SET_PED_CAN_SWITCH_WEAPON(ped, toggle)
        end)
    menu.toggle(Combat_Status, "CAN_BE_DRAGGED_OUT", {},
        "Sets if a ped can be dragged out of a vehicle.", function(toggle)
            PED.SET_PED_CAN_BE_DRAGGED_OUT(ped, toggle)
        end)

    local Natural_Motion = menu.list(ped_attribute_options, "Natural Motion", {}, "")
    menu.toggle(Natural_Motion, "RAGDOLL_ON_COLLISION", {},
        "Set the ped to ragdoll on collision with geometry.", function(toggle)
            PED.SET_PED_RAGDOLL_ON_COLLISION(ped, toggle)
        end)
    menu.toggle(Natural_Motion, "CAN_RAGDOLL", {},
        "Sets if a ped can ragdoll. Ragdolls are swtiched on by default.", function(toggle)
            PED.SET_PED_CAN_RAGDOLL(ped, toggle)
        end)
    menu.toggle(Natural_Motion, "CAN_RAGDOLL_FROM_PLAYER_IMPACT", {},
        "Sets if the ped will ragdoll if the player collides with then.", function(toggle)
            PED.SET_PED_CAN_RAGDOLL_FROM_PLAYER_IMPACT(ped, toggle)
        end)

    local General = menu.list(ped_attribute_options, "General", {}, "")
    menu.toggle(General, "ALLOW_MINOR_REACTIONS_AS_MISSION_PED", {},
        "Sets a ped will react to minor events like the player crashing their car as a mission ped.", function(toggle)
            PED.SET_PED_ALLOW_MINOR_REACTIONS_AS_MISSION_PED(ped, toggle)
        end)
    menu.toggle(General, "GET_OUT_UPSIDE_DOWN_VEHICLE", {},
        "Sets the ped so that the police will always go after them if they drive past.", function(toggle)
            PED.SET_PED_GET_OUT_UPSIDE_DOWN_VEHICLE(ped, toggle)
        end)
    menu.toggle(General, "PLAYS_HEAD_ON_HORN_ANIM_WHEN_DIES_IN_VEHICLE", {},
        "Set ped playes head on horn anim when they die in a vehicle.", function(toggle)
            PED.SET_PED_PLAYS_HEAD_ON_HORN_ANIM_WHEN_DIES_IN_VEHICLE(ped, toggle)
        end)
end

function Entity_Control.ped_combat(menu_parent, ped, index)
    ----- Ped Combat 选项 -----
    local ped_combat_options = menu.list(menu_parent, "Ped Combat 选项", {}, "")

    menu.action(ped_combat_options, "一键无敌强化NPC", {}, "适用于友方NPC", function()
        increase_ped_combat_ability(ped, true, false)
        increase_ped_combat_attributes(ped)
        util.toast("完成！")
    end)
    menu.click_slider(ped_combat_options, "射击频率", {}, "", 0, 1000, 100, 10, function(value)
        PED.SET_PED_SHOOT_RATE(ped, value)
    end)
    menu.click_slider(ped_combat_options, "精准度", {}, "", 0, 100, 50, 10, function(value)
        PED.SET_PED_ACCURACY(ped, value)
    end)
    menu.slider_text(ped_combat_options, "战斗能力", {}, "", enum_CombatAbility, function(value)
        PED.SET_PED_COMBAT_ABILITY(ped, value)
    end)
    menu.slider_text(ped_combat_options, "战斗范围", {}, "", enum_CombatRange, function(value)
        PED.SET_PED_COMBAT_RANGE(ped, value)
    end)
    menu.slider_text(ped_combat_options, "战斗走位", {}, "", enum_CombatMovement, function(value)
        PED.SET_PED_COMBAT_MOVEMENT(ped, value)
    end)
    menu.slider_text(ped_combat_options, "警觉度", {}, "", enum_Alertness, function(value)
        PED.SET_PED_ALERTNESS(ped, value)
    end)
    menu.list_action(ped_combat_options, "射击模式", {}, "", Ped_FirePattern.ListItem, function(value)
        PED.SET_PED_FIRING_PATTERN(ped, Ped_FirePattern.ValueList[value])
    end)


    --- Ped Combat Attributes ---
    local combat_attributes_options = menu.list(ped_combat_options, "Ped Combat Attributes", {}, "")
    local combat_attributes_menus = {}
    menu.toggle(combat_attributes_options, "全部开/关", {}, "", function(toggle)
        for i, the_menu in pairs(combat_attributes_menus) do
            menu.set_value(the_menu, toggle)
        end
    end)
    for key, data in pairs(Ped_CombatAttributes.List) do
        local id = Ped_CombatAttributes.ValueList[key]
        combat_attributes_menus[key] = menu.toggle(combat_attributes_options, data[1], {}, data[2], function(toggle)
            PED.SET_PED_COMBAT_ATTRIBUTES(ped, id, toggle)
        end)
    end


    --- Ped Combat Float ---
    local combat_float_options = menu.list(ped_combat_options, "Ped Combat Float", {}, "")
    local combat_float_menus = {}
    for key, data in pairs(Ped_CombatFloat.List) do
        local default_num = string.format("%.2f", PED.GET_COMBAT_FLOAT(ped, id))
        default_num = tonumber(default_num) * 100
        if default_num > 50000 or default_num < -50000 then
            default_num = 0
        end
        local id = Ped_CombatFloat.ValueList[key]

        combat_float_menus[id] = menu.click_slider_float(combat_float_options, data[1], {}, data[2],
            -50000, 50000, math.floor(default_num), 10, function(value)
                PED.SET_COMBAT_FLOAT(ped, id, value * 0.01)
            end)
    end
end

function Entity_Control.ped_task(menu_parent, ped, index)
    ----- Ped Task 选项 -----
    local ped_task_options = menu.list(menu_parent, "Ped Task 选项", {}, "")

    menu.action(ped_task_options, "Clear Ped Tasks Immediately", {}, "", function()
        TASK.CLEAR_PED_TASKS_IMMEDIATELY(ped)
    end)
    menu.action(ped_task_options, "Clear Ped All Tasks", {}, "", function()
        clear_ped_all_tasks(ped)
    end)


    --- Ped Task Follow ---
    local task_follow = menu.list(ped_task_options, "NPC 跟随", {}, "")
    local ped_follow = {
        x = 0.0,
        y = -1.0,
        z = 0.0,
        movementSpeed = 7.0,
        timeout = -1,
        stoppingRange = 10.0,
        persistFollowing = true
    }
    menu.slider_float(task_follow, "左/右", { "task_ped" .. index .. "follow_x" }, "", -10000, 10000, 0, 100,
        function(value)
            ped_follow.x = value * 0.01
        end)
    menu.slider_float(task_follow, "前/后", { "task_ped" .. index .. "follow_y" }, "", -10000, 10000, -100, 100,
        function(value)
            ped_follow.y = value * 0.01
        end)
    menu.slider_float(task_follow, "上/下", { "task_ped" .. index .. "follow_z" }, "", -10000, 10000, 0, 100,
        function(value)
            ped_follow.z = value * 0.01
        end)
    menu.slider_float(task_follow, "移动速度", { "task_ped" .. index .. "follow_movementSpeed" }, "",
        0, 100000, 700, 100, function(value)
            ped_follow.movementSpeed = value * 0.01
        end)
    menu.slider(task_follow, "超时时间", { "task_ped" .. index .. "follow_timeout" }, "", -1, 10000, -1, 1,
        function(value)
            ped_follow.timeout = value
        end)
    menu.slider_float(task_follow, "停止跟随的最远距离", { "task_ped" .. index .. "follow_stoppingRange" }, "",
        0, 100000, 1000, 100, function(value)
            ped_follow.stoppingRange = value * 0.01
        end)
    menu.toggle(task_follow, "持续跟随", {}, "", function(toggle)
        ped_follow.persistFollowing = toggle
    end, true)
    menu.action(task_follow, "设置任务", {}, "", function()
        TASK.TASK_FOLLOW_TO_OFFSET_OF_ENTITY(ped, players.user_ped(), ped_follow.x, ped_follow.y, ped_follow.z,
            ped_follow.movementSpeed,
            ped_follow.timeout, ped_follow.stoppingRange, ped_follow.persistFollowing)
        util.toast("完成！")
    end)


    menu.action(ped_task_options, "躲在掩体处", {}, "", function()
        TASK.TASK_STAY_IN_COVER(ped)
    end)
    menu.toggle(ped_task_options, "朝向面对我", {}, "", function(toggle)
        if toggle then
            TASK.TASK_TURN_PED_TO_FACE_ENTITY(ped, players.user_ped(), -1)
        else
            TASK.TASK_TURN_PED_TO_FACE_ENTITY(ped, players.user_ped(), 0)
        end
    end)
    menu.click_slider_float(ped_task_options, "讨厌附近目标", { "task_ped" .. index .. "hated_around" }, "",
        0, 50000, 0, 10, function(value)
            TASK.TASK_COMBAT_HATED_TARGETS_AROUND_PED(ped, value * 0.01, 0)
        end)
end

----------------
-- Vehicle
----------------

function Entity_Control.vehicle(menu_parent, vehicle, index)
    ----- Vehicle 选项 -----
    local vehicle_options = menu.list(menu_parent, "Vehicle 选项", {}, "")

    menu.slider_text(vehicle_options, "传送到载具内", {}, "会将原座位的NPC传送出去",
        { "空座位", "驾驶位", "副驾驶位" }, function(value)
            if value == 1 then
                if VEHICLE.ARE_ANY_VEHICLE_SEATS_FREE(vehicle) then
                    PED.SET_PED_INTO_VEHICLE(players.user_ped(), vehicle, -2)
                else
                    util.toast("载具已无空座位")
                end
            elseif value == 2 then
                if VEHICLE.IS_VEHICLE_SEAT_FREE(vehicle, -1, false) then
                    PED.SET_PED_INTO_VEHICLE(players.user_ped(), vehicle, -1)
                else
                    local ped = VEHICLE.GET_PED_IN_VEHICLE_SEAT(vehicle, -1)
                    if ped ~= 0 then
                        SET_ENTITY_MOVE(ped, 0.0, 0.0, 3.0)
                        PED.SET_PED_INTO_VEHICLE(players.user_ped(), vehicle, -1)
                    end
                end
            elseif value == 3 then
                if VEHICLE.GET_VEHICLE_MAX_NUMBER_OF_PASSENGERS(vehicle) > 1 then
                    if VEHICLE.IS_VEHICLE_SEAT_FREE(vehicle, 0, false) then
                        PED.SET_PED_INTO_VEHICLE(players.user_ped(), vehicle, 0)
                    else
                        local ped = VEHICLE.GET_PED_IN_VEHICLE_SEAT(vehicle, 0)
                        if ped ~= 0 then
                            SET_ENTITY_MOVE(ped, 0.0, 0.0, 3.0)
                            PED.SET_PED_INTO_VEHICLE(players.user_ped(), vehicle, 0)
                        end
                    end
                else
                    util.toast("载具无副驾驶位")
                end
            end
        end)
    menu.action(vehicle_options, "清空载具", {}, "将NPC全部传送出去", function()
        local num, peds = get_vehicle_peds(vehicle)
        if num > 0 then
            for k, ped in pairs(peds) do
                SET_ENTITY_MOVE(ped, 0.0, 0.0, 3.0)
            end
        end
    end)

    menu.click_slider(vehicle_options, "向前加速", { "ctrl_veh" .. index .. "_forward_speed" },
        "", 0, 1000, 30, 10, function(value)
            VEHICLE.SET_VEHICLE_FORWARD_SPEED(vehicle, value)
        end)
    menu.click_slider(vehicle_options, "向前加速XY", { "ctrl_veh" .. index .. "_forward_speed_xy" },
        "if the vehicle is in the air this will only set the xy speed.", 0, 1000, 30, 10, function(value)
            VEHICLE.SET_VEHICLE_FORWARD_SPEED_XY(vehicle, value)
        end)

    menu.action(vehicle_options, "修复载具", {}, "", function()
        fix_vehicle(vehicle)
    end)
    menu.action(vehicle_options, "升级载具", {}, "", function()
        upgrade_vehicle(vehicle)
    end)
    menu.action(vehicle_options, "强化载具", {}, "", function()
        strong_vehicle(vehicle)
    end)

    menu.list_action(vehicle_options, "车窗", {}, "", {
        { "删除车窗" },
        { "摇下车窗" },
        { "摇上车窗" },
        { "粉碎车窗" },
        { "修复车窗" },
    }, function(value)
        if value == 1 then
            for i = 0, 7 do
                VEHICLE.REMOVE_VEHICLE_WINDOW(vehicle, i)
            end
        elseif value == 2 then
            for i = 0, 7 do
                VEHICLE.ROLL_DOWN_WINDOW(vehicle, i)
            end
        elseif value == 3 then
            for i = 0, 7 do
                VEHICLE.ROLL_UP_WINDOW(vehicle, i)
            end
        elseif value == 4 then
            for i = 0, 7 do
                VEHICLE.SMASH_VEHICLE_WINDOW(vehicle, i)
            end
        elseif value == 5 then
            for i = 0, 7 do
                VEHICLE.FIX_VEHICLE_WINDOW(vehicle, i)
            end
        end
    end)
    menu.list_action(vehicle_options, "车门", {}, "", {
        { "打开车门" },
        { "关闭车门" },
        { "拆下车门" },
        { "删除车门" },
    }, function(value)
        if value == 1 then
            for i = 0, 3 do
                VEHICLE.SET_VEHICLE_DOOR_OPEN(vehicle, i, false, false)
            end
        elseif value == 2 then
            VEHICLE.SET_VEHICLE_DOORS_SHUT(vehicle, false)
        elseif value == 3 then
            for i = 0, 3 do
                VEHICLE.SET_VEHICLE_DOOR_BROKEN(vehicle, i, false)
            end
        elseif value == 4 then
            for i = 0, 3 do
                VEHICLE.SET_VEHICLE_DOOR_BROKEN(vehicle, i, true)
            end
        end
    end)

    menu.slider_text(vehicle_options, "引擎", {}, "", { "打开", "关闭" }, function(value)
        if value == 1 then
            VEHICLE.SET_VEHICLE_ENGINE_ON(vehicle, true, true, false)
        elseif value == 2 then
            VEHICLE.SET_VEHICLE_ENGINE_ON(vehicle, false, true, false)
        end
    end)
    menu.slider_text(vehicle_options, "车门锁", {}, "", { "解锁", "上锁" }, function(value)
        VEHICLE.SET_VEHICLE_DOORS_LOCKED(vehicle, value)
    end)
    menu.slider_text(vehicle_options, "车胎", {}, "", { "爆胎", "修复" }, function(value)
        if value == 1 then
            for i = 0, 7 do
                VEHICLE.SET_VEHICLE_TYRE_BURST(vehicle, i, true, 1000.0)
            end
        elseif value == 2 then
            for i = 0, 7 do
                VEHICLE.SET_VEHICLE_TYRE_FIXED(vehicle, i)
            end
        end
    end)
    menu.action(vehicle_options, "分离车轮", {}, "", function(value)
        for i = 0, 7 do
            entities.detach_wheel(vehicle, i)
        end
    end)

    menu.click_slider(vehicle_options, "Modify Top Speed (%)", { "ctrl_veh" .. index .. "_top_speed" },
        "", -100, 100, 0, 10, function(value)
            VEHICLE.MODIFY_VEHICLE_TOP_SPEED(vehicle, value)
        end)
    menu.click_slider(vehicle_options, "Set Max Speed", { "ctrl_veh" .. index .. "_max_speed" },
        "", 0, 10000, 500, 50, function(value)
            VEHICLE.SET_VEHICLE_MAX_SPEED(vehicle, value)
        end)



    Entity_Control.vehicle_attribute(menu_parent, vehicle, index)
    Entity_Control.vehicle_health(menu_parent, vehicle, index)
    Entity_Control.vehicle_appearance(menu_parent, vehicle, index)
    Entity_Control.vehicle_task(menu_parent, vehicle, index)
end

function Entity_Control.vehicle_attribute(menu_parent, vehicle, index)
    ----- Vehicle Attribute 选项 -----
    local vehicle_attribute_options = menu.list(menu_parent, "Vehicle Attribute 选项", {}, "")

    menu.divider(vehicle_attribute_options, "SET_VEHICLE")
    menu.toggle(vehicle_attribute_options, "DISABLE_TOWING", {},
        "Stop a tow truck from automatically picking up a vehicle.", function(toggle)
            VEHICLE.SET_VEHICLE_DISABLE_TOWING(vehicle, toggle)
        end)
    menu.toggle(vehicle_attribute_options, "IS_RACING", {},
        "If set to true, vehicle will use more aggressive avoidance parameters when avoiding other vehicles that are also racing."
        , function(toggle)
            VEHICLE.SET_VEHICLE_IS_RACING(vehicle, toggle)
        end)
    menu.toggle(vehicle_attribute_options, "SET_CAN_RESPRAY_VEHICLE", {},
        "Set the vehicle can be resparyed.", function(toggle)
            VEHICLE.SET_CAN_RESPRAY_VEHICLE(vehicle, toggle)
        end)
    menu.toggle(vehicle_attribute_options, "SET_GOON_BOSS_VEHICLE", {},
        "Enable special enter/exit vehicle functionality. Only when holding enter input, the Boss will enter rear seat, while the Goon will not be able to leave or enter it."
        , function(toggle)
            VEHICLE.SET_GOON_BOSS_VEHICLE(vehicle, toggle)
        end)
    menu.toggle(vehicle_attribute_options, "SET_OPEN_REAR_DOORS_ON_EXPLOSION", {},
        "Prevents or allows the rear doors of the vehicle from opening from a sticky bomb explosion."
        , function(toggle)
            VEHICLE.SET_OPEN_REAR_DOORS_ON_EXPLOSION(vehicle, toggle)
        end)
    menu.toggle(vehicle_attribute_options, "UNDRIVEABLE", {},
        "Sets the vehicle to be undriveable (but still enterable).", function(toggle)
            VEHICLE.SET_VEHICLE_UNDRIVEABLE(vehicle, toggle)
        end)
    menu.toggle(vehicle_attribute_options, "PROVIDES_COVER", {},
        "Sets if a vehicle provides cover.", function(toggle)
            VEHICLE.SET_VEHICLE_PROVIDES_COVER(vehicle, toggle)
        end)
    menu.toggle(vehicle_attribute_options, "CAN_BE_TARGETTED", {},
        "Sets if a vehicle can be targetted.", function(toggle)
            VEHICLE.SET_VEHICLE_CAN_BE_TARGETTED(vehicle, toggle)
        end)
    menu.toggle(vehicle_attribute_options, "NEEDS_TO_BE_HOTWIRED", {},
        "Makes the player play the hotwire anim. \nSets the vehicle must be hotwired.", function(toggle)
            VEHICLE.SET_VEHICLE_NEEDS_TO_BE_HOTWIRED(vehicle, toggle)
        end)
    menu.toggle(vehicle_attribute_options, "IN_CAR_MOD_SHOP", {},
        "Set if a vehicle is in the car mod shop.", function(toggle)
            VEHICLE.SET_VEHICLE_IN_CAR_MOD_SHOP(vehicle, toggle)
        end)
    menu.toggle(vehicle_attribute_options, "IS_CONSIDERED_BY_PLAYER", {},
        "Passing FALSE to this command will make the player not consider this vehicle when pressing triangle(F) to enter a vehicle. The player will instead pick the next closest vehicle to steal/enter."
        , function(toggle)
            VEHICLE.SET_VEHICLE_IS_CONSIDERED_BY_PLAYER(vehicle, toggle)
        end)
    menu.toggle(vehicle_attribute_options, "LIMIT_SPEED_WHEN_PLAYER_INACTIVE", {},
        "Sets whether a player controlled vehicle will limit it's speed when the player's control is disabled (used in cutscenes etc). \nDefault is to limit. \nDisable the limiting of player vehicle speed when the player loses control."
        , function(toggle)
            VEHICLE.SET_VEHICLE_LIMIT_SPEED_WHEN_PLAYER_INACTIVE(vehicle, toggle)
        end)
    menu.toggle(vehicle_attribute_options, "STOP_INSTANTLY_WHEN_PLAYER_INACTIVE", {},
        "Sets whether a player controlled vehicle will stop instantly when the player's control is disabled (used in cutscenes etc). \nDefault is to stop instantly \nAllow/prevent the player vheicle loss all its velocity instantly when the player loses control."
        , function(toggle)
            VEHICLE.SET_VEHICLE_STOP_INSTANTLY_WHEN_PLAYER_INACTIVE(vehicle, toggle)
        end)
    menu.toggle(vehicle_attribute_options, "HAS_BEEN_OWNED_BY_PLAYER", {},
        "If vehicle has not been owned by player, the player will get a wanted level when entering (if spotted by police). \nIf the player has already owned a vehicle he is free to use it. (The game will set this flag to true first time the player drives a vehicle). \nMission vehicles will default to true. \nSets a vehicle owned by the player so he wont get a wanted level when entering it."
        , function(toggle)
            VEHICLE.SET_VEHICLE_HAS_BEEN_OWNED_BY_PLAYER(vehicle, toggle)
        end)
    menu.toggle(vehicle_attribute_options, "SET_POLICE_FOCUS_WILL_TRACK_VEHICLE", {},
        "If this is set to True the police focus circle is always focussed on the car. If this is False the player has a chance to escape police attention if undetected. \nBy default law enforcement vehicles have this bit set to true and all other cars have false. \nSets the police focus on the vehicle."
        , function(toggle)
            VEHICLE.SET_POLICE_FOCUS_WILL_TRACK_VEHICLE(vehicle, toggle)
        end)
    menu.toggle(vehicle_attribute_options, "INFLUENCES_WANTED_LEVEL", {},
        "Sets whether or not a vehicle has an effect on the wanted level if that vehicle is specified as the \"victim\"."
        , function(toggle)
            VEHICLE.SET_VEHICLE_INFLUENCES_WANTED_LEVEL(vehicle, toggle)
        end)
    menu.toggle(vehicle_attribute_options, "IS_WANTED", {},
        "Sets whether or not a vehicle is wanted. Cops can identify peds in wanted vehicles easier.", function(toggle)
            VEHICLE.SET_VEHICLE_IS_WANTED(vehicle, toggle)
        end)
    menu.toggle(vehicle_attribute_options, "NOT_STEALABLE_AMBIENTLY", {},
        "Sets a vehicle so that it can't be stealable by an ambient ped.", function(toggle)
            VEHICLE.SET_VEHICLE_NOT_STEALABLE_AMBIENTLY(vehicle, toggle)
        end)
    menu.toggle(vehicle_attribute_options, "IS_STOLEN", {},
        "Toggle whether a vehicle is considered stolen.", function(toggle)
            VEHICLE.SET_VEHICLE_IS_STOLEN(vehicle, toggle)
        end)
    menu.toggle(vehicle_attribute_options, "USED_FOR_PILOT_SCHOOL", {},
        "Mark the vehicle as used for pilot school.", function(toggle)
            VEHICLE.SET_VEHICLE_USED_FOR_PILOT_SCHOOL(vehicle, toggle)
        end)
    menu.toggle(vehicle_attribute_options, "CAN_BE_USED_BY_FLEEING_PEDS", {},
        "Allows the vehicle to be used by fleeing peds.", function(toggle)
            VEHICLE.SET_VEHICLE_CAN_BE_USED_BY_FLEEING_PEDS(vehicle, toggle)
        end)
    menu.toggle(vehicle_attribute_options, "KEEP_ENGINE_ON_WHEN_ABANDONED", {},
        "Flags the vehicle to keep the engine on after being abandoned.", function(toggle)
            VEHICLE.SET_VEHICLE_KEEP_ENGINE_ON_WHEN_ABANDONED(vehicle, toggle)
        end)
    menu.toggle(vehicle_attribute_options, "WHEELS_CAN_BREAK_OFF_WHEN_BLOW_UP", {},
        "Allow wheels breaking off when car blows up.", function(toggle)
            VEHICLE.SET_VEHICLE_WHEELS_CAN_BREAK_OFF_WHEN_BLOW_UP(vehicle, toggle)
        end)
    menu.toggle(vehicle_attribute_options, "NO_EXPLOSION_DAMAGE_FROM_DRIVER", {},
        "Don't allow vehicle to take explosion damage from explosions generated by owner.", function(toggle)
            VEHICLE.SET_VEHICLE_NO_EXPLOSION_DAMAGE_FROM_DRIVER(vehicle, toggle)
        end)
    menu.toggle(vehicle_attribute_options, "SET_DONT_PROCESS_VEHICLE_GLASS", {},
        "Stops vehicle glass from being processed - should enable this for vehicles with window protectors."
        , function(toggle)
            VEHICLE.SET_DONT_PROCESS_VEHICLE_GLASS(vehicle, toggle)
        end)
    menu.toggle(vehicle_attribute_options, "SET_INVERT_VEHICLE_CONTROLS", {},
        "Sets whether to invert the vehicle controls.", function(toggle)
            VEHICLE.SET_INVERT_VEHICLE_CONTROLS(vehicle, toggle)
        end)
    menu.toggle(vehicle_attribute_options, "SET_DISABLE_PED_STAND_ON_TOP", {},
        "Disables map collision on the vehicle.", function(toggle)
            VEHICLE.SET_DISABLE_PED_STAND_ON_TOP(vehicle, toggle)
        end)

    menu.divider(vehicle_attribute_options, "SET_BIKE")
    menu.toggle(vehicle_attribute_options, "EASY_TO_LAND", {},
        "Sets whether peds will stay on bikes after heavy landings.", function(toggle)
            VEHICLE.SET_BIKE_EASY_TO_LAND(vehicle, toggle)
        end)
end

function Entity_Control.vehicle_health(menu_parent, vehicle, index)
    ----- Vehicle Health 选项 -----
    local vehicle_health_options = menu.list(menu_parent, "Vehicle Health 选项", {}, "")

    local hash = ENTITY.GET_ENTITY_MODEL(vehicle)

    menu.click_slider(vehicle_health_options, "引擎血量", { "ctrl_veh" .. index .. "_engine_health" },
        "1000.0 = full, 0.0 = go on fire, -1000.0 = burnt out", -1000, 1000,
        1000, 100, function(value)
            VEHICLE.SET_VEHICLE_ENGINE_HEALTH(vehicle, value)
        end)
    menu.click_slider(vehicle_health_options, "油箱血量", { "ctrl_veh" .. index .. "_petrol_tank_health" },
        "1000.0 = full, 0.0 = go on fire, -1000.0 = burnt out", -1000, 1000,
        1000, 100, function(value)
            VEHICLE.SET_VEHICLE_PETROL_TANK_HEALTH(vehicle, value)
        end)
    menu.click_slider(vehicle_health_options, "外观血量", { "ctrl_veh" .. index .. "_body_health" },
        "1000.0 = full, 0.0 = damaged", -1000, 1000,
        1000, 100, function(value)
            VEHICLE.SET_VEHICLE_BODY_HEALTH(vehicle, value)
        end)

    if VEHICLE.IS_THIS_MODEL_A_PLANE(hash) then
        menu.click_slider(vehicle_health_options, "飞机引擎血量", { "ctrl_veh" .. index .. "_plane_engine_health" }
            ,
            "the same as the above function but it allows the engine health on planes to be set higher than the max health."
            , -1000, 10000, 1000, 100, function(value)
                VEHICLE.SET_PLANE_ENGINE_HEALTH(vehicle, value)
            end)
    end

    if VEHICLE.IS_THIS_MODEL_A_HELI(hash) then
        menu.click_slider(vehicle_health_options, "直升机主旋翼血量",
            { "ctrl_veh" .. index .. "_main_rotor_health" },
            "", -1000, 1000, 1000, 100, function(value)
                VEHICLE.SET_HELI_MAIN_ROTOR_HEALTH(vehicle, value)
            end)
        menu.click_slider(vehicle_health_options, "直升机尾旋翼血量",
            { "ctrl_veh" .. index .. "_tail_rotor_health" },
            "", -1000, 1000, 1000, 100, function(value)
                VEHICLE.SET_HELI_TAIL_ROTOR_HEALTH(vehicle, value)
            end)
    end


    local vehicle_other_attribute = menu.list(vehicle_health_options, "其它属性", {}, "")
    menu.toggle(vehicle_other_attribute, "强化载具", {},
        "Sets the vehicle so it only takes 25% of the normal damage when hit.", function(toggle)
            VEHICLE.SET_VEHICLE_STRONG(vehicle, toggle)
        end)
    menu.toggle(vehicle_other_attribute, "Strong Axles", {},
        "Sets so that axles don't break easily.", function(toggle)
            VEHICLE.SET_VEHICLE_HAS_STRONG_AXLES(vehicle, toggle)
        end)
    menu.toggle(vehicle_other_attribute, "禁止发动机故障失火", {}, "", function(toggle)
        VEHICLE.SET_VEHICLE_CAN_ENGINE_MISSFIRE(vehicle, not toggle)
    end)
    menu.toggle(vehicle_other_attribute, "禁止漏油", {}, "", function(toggle)
        VEHICLE.SET_VEHICLE_CAN_LEAK_OIL(vehicle, not toggle)
        VEHICLE.SET_VEHICLE_CAN_LEAK_PETROL(vehicle, not toggle)
    end)
    menu.toggle(vehicle_other_attribute, "禁止油箱起火", {}, "", function(toggle)
        VEHICLE.SET_DISABLE_VEHICLE_PETROL_TANK_FIRES(vehicle, toggle)
    end)
    menu.toggle(vehicle_other_attribute, "禁止油箱伤害", {}, "", function(toggle)
        VEHICLE.SET_DISABLE_VEHICLE_PETROL_TANK_DAMAGE(vehicle, toggle)
    end)
    menu.toggle(vehicle_other_attribute, "禁止发动机起火", {}, "", function(toggle)
        VEHICLE.SET_DISABLE_VEHICLE_ENGINE_FIRES(vehicle, toggle)
    end)
    menu.toggle(vehicle_other_attribute, "禁止因碰撞身体损坏而爆炸", {}, "", function(toggle)
        local value = 0
        if toggle then
            value = 1
        end
        VEHICLE.SET_DISABLE_EXPLODE_FROM_BODY_DAMAGE_ON_COLLISION(vehicle, value)
    end)
    menu.toggle(vehicle_other_attribute, "禁止载具部分分离", {}, "", function(toggle)
        VEHICLE.SET_VEHICLE_CAN_BREAK(vehicle, not toggle)
    end)
    menu.toggle(vehicle_other_attribute, "禁止爆胎", {}, "", function(toggle)
        VEHICLE.SET_VEHICLE_TYRES_CAN_BURST(vehicle, not toggle)
    end)
    menu.toggle(vehicle_other_attribute, "禁止车轮分离", {}, "", function(toggle)
        VEHICLE.SET_VEHICLE_WHEELS_CAN_BREAK(vehicle, not toggle)
    end)

    if VEHICLE.IS_THIS_MODEL_A_HELI(hash) then
        menu.toggle(vehicle_other_attribute, "禁止直升机尾翼损坏", {}, "", function(toggle)
            VEHICLE.SET_HELI_TAIL_BOOM_CAN_BREAK_OFF(vehicle, not toggle)
        end)
        menu.toggle(vehicle_other_attribute, "提高直升机防炸性", {},
            "(MP Only) Heli might survive from 2 or more explosions when set", function(toggle)
                VEHICLE.SET_HELI_RESIST_TO_EXPLOSION(vehicle, toggle)
            end)
        menu.toggle(vehicle_other_attribute, "禁止直升机身体损坏而爆炸", {}, "", function(toggle)
            VEHICLE.SET_DISABLE_HELI_EXPLODE_FROM_BODY_DAMAGE(vehicle, toggle)
        end)
    end

    if VEHICLE.IS_THIS_MODEL_A_PLANE(hash) then
        menu.toggle(vehicle_other_attribute, "提高飞机防炸性", {},
            "(MP Only) Plane might survive from 2 or more explosions when set", function(toggle)
                VEHICLE.SET_PLANE_RESIST_TO_EXPLOSION(vehicle, toggle)
            end)
    end
end

function Entity_Control.vehicle_appearance(menu_parent, vehicle, index)
    ----- Vehicle Appearance 选项 -----
    local vehicle_appearance_options = menu.list(menu_parent, "Vehicle Appearance 选项", {}, "")

    menu.action(vehicle_appearance_options, "修复外观", {}, "只修复外观，不修复受到的伤害",
        function()
            VEHICLE.SET_VEHICLE_DEFORMATION_FIXED(vehicle)
        end)
    menu.click_slider(vehicle_appearance_options, "灰尘程度", { "ctrl_veh" .. index .. "_dirt_level" },
        "", 0, 15, 0, 1, function(value)
            VEHICLE.SET_VEHICLE_DIRT_LEVEL(vehicle, value)
        end)

    menu.divider(vehicle_appearance_options, "颜色")
    menu.action(vehicle_appearance_options, "随机喷漆", {}, "", function()
        local primary, secundary = get_random_colour(), get_random_colour()
        VEHICLE.SET_VEHICLE_CUSTOM_PRIMARY_COLOUR(vehicle, primary.r, primary.g, primary.b)
        VEHICLE.SET_VEHICLE_CUSTOM_SECONDARY_COLOUR(vehicle, secundary.r, secundary.g, secundary.b)
    end)
    menu.colour(vehicle_appearance_options, "主色调", { "ctrl_veh" .. index .. "_primary_colour" }, "",
        0, 0, 0, 1, false, function(colour)
            local r = math.ceil(255 * colour.r)
            local g = math.ceil(255 * colour.g)
            local b = math.ceil(255 * colour.b)
            VEHICLE.SET_VEHICLE_CUSTOM_PRIMARY_COLOUR(vehicle, r, g, b)
        end)
    menu.colour(vehicle_appearance_options, "副色调", { "ctrl_veh" .. index .. "_secondary_colour" }, "",
        0, 0, 0, 1, false, function(colour)
            local r = math.ceil(255 * colour.r)
            local g = math.ceil(255 * colour.g)
            local b = math.ceil(255 * colour.b)
            VEHICLE.SET_VEHICLE_CUSTOM_SECONDARY_COLOUR(vehicle, r, g, b)
        end)
    menu.action(vehicle_appearance_options, "清除主色调", {}, "", function()
        VEHICLE.CLEAR_VEHICLE_CUSTOM_PRIMARY_COLOUR(vehicle)
    end)
    menu.action(vehicle_appearance_options, "清除副色调", {}, "", function()
        VEHICLE.CLEAR_VEHICLE_CUSTOM_SECONDARY_COLOUR(vehicle)
    end)
end

function Entity_Control.vehicle_task(menu_parent, vehicle, index)
    ----- Vehicle Task 选项 -----
    local ped = GET_PED_IN_VEHICLE_SEAT(vehicle, -1)
    if ped ~= 0 then
        local veh_task_options = menu.list(menu_parent, "Vehicle Task 选项", {}, "")

        menu.action(veh_task_options, "Clear Driver Tasks Immediately", {}, "", function()
            TASK.CLEAR_PED_TASKS_IMMEDIATELY(ped)
        end)
        menu.action(veh_task_options, "Clear Driver All Tasks", {}, "", function()
            clear_ped_all_tasks(ped)
        end)


        --- Vehicle Task Follow ---
        local task_follow = menu.list(veh_task_options, "载具 跟随", {}, "")
        local veh_follow = {
            speed = 30.0,
            drivingStyle = 786603,
            minDistance = 5.0
        }
        menu.slider_float(task_follow, "速度", { "task_veh" .. index .. "follow_speed" }, "",
            0, 100000, 3000, 100, function(value)
                veh_follow.speed = value * 0.01
            end)
        menu.list_select(task_follow, "驾驶风格", {}, "", Vehicle_DrivingStyle.ListItem, 1, function(value)
            veh_follow.drivingStyle = Vehicle_DrivingStyle.ValueList[value]
        end)
        menu.slider_float(task_follow, "最小跟随距离", { "task_veh" .. index .. "follow_minDistance" }, "",
            0, 100000, 500, 100, function(value)
                veh_follow.minDistance = value * 0.01
            end)
        menu.action(task_follow, "设置任务", {}, "", function()
            TASK.TASK_VEHICLE_FOLLOW(ped, vehicle, players.user_ped(), veh_follow.speed, veh_follow.drivingStyle,
                veh_follow.minDistance)
            util.toast("完成！")
        end)



        --- Vehicle Task Escort ---
        local task_escort = menu.list(veh_task_options, "载具 护送", {}, "")
        local veh_escort = {
            mode = -1,
            speed = 30.0,
            drivingStyle = 786603,
            minDistance = 5.0,
            minHeightAboveTerrain = 20,
            noRoadsDistance = 5.0
        }
        local task_veh_escort_mode_list = {
            { "后面" }, -- -1
            { "前面" }, -- 0
            { "左边" }, -- 1
            { "右边" }, -- 2
            { "后左边" }, -- 3
            { "后右边" }, -- 4
        }
        menu.list_select(task_escort, "护送模式", {},
            "The mode defines the relative position to the targetVehicle. The ped will try to position its vehicle there.",
            task_veh_escort_mode_list, 1, function(value)
                veh_escort.mode = value - 2
            end)
        menu.slider_float(task_escort, "速度", { "task_veh" .. index .. "escort_speed" }, "",
            0, 100000, 3000, 100, function(value)
                veh_escort.speed = value * 0.01
            end)
        menu.list_select(task_escort, "驾驶风格", {}, "", Vehicle_DrivingStyle.ListItem, 1, function(value)
            veh_escort.drivingStyle = Vehicle_DrivingStyle.ValueList[value]
        end)
        menu.slider_float(task_escort, "最小跟随距离", { "task_veh" .. index .. "escort_minDistance" },
            "minDistance is ignored if drivingstyle is avoiding traffic, but Rushed is fine.",
            0, 100000, 500, 100, function(value)
                veh_escort.minDistance = value * 0.01
            end)
        menu.slider(task_escort, "离地面最小高度", { "task_veh" .. index .. "escort_minHeightAboveTerrain" }, "",
            0, 1000, 20, 1, function(value)
                veh_escort.minHeightAboveTerrain = value
            end)
        menu.slider_float(task_escort, "No Roads Distance", { "task_veh" .. index .. "escort_noRoadsDistance" },
            "if the target is closer than noRoadsDistance, the driver will ignore pathing/roads and follow you directly.",
            0, 100000, 500, 100, function(value)
                veh_escort.noRoadsDistance = value * 0.01
            end)
        menu.action(task_escort, "设置任务", {},
            "Makes a ped follow the targetVehicle with <minDistance> in between.", function()
                if PED.IS_PED_IN_ANY_VEHICLE(players.user_ped(), false) then
                    local target_vehicle = PED.GET_VEHICLE_PED_IS_IN(players.user_ped(), false)
                    TASK.TASK_VEHICLE_ESCORT(ped, vehicle, target_vehicle, veh_escort.mode, veh_escort.speed,
                        veh_escort.drivingStyle, veh_escort.minDistance, veh_escort.minHeightAboveTerrain,
                        veh_escort.noRoadsDistance)
                    util.toast("完成！")
                else
                    util.toast("你需要先进入一辆载具后才能设置任务")
                end
            end)



        --- Vehicle Task Mission ---
        local task_mission = menu.list(veh_task_options, "载具 设置任务", {}, "")
        local veh_mission = {
            missionType = 7,
            maxSpeed = 500.0,
            drivingStyle = 786603,
            minDistance = 5.0,
            straightLineDistance = 0.0,
            DriveAgainstTraffic = true,
        }

        menu.list_select(task_mission, "任务类型", {}, "", Vehicle_MissionType.ListItem, 7, function(value)
            veh_mission.missionType = Vehicle_MissionType.ValueList[value]
        end)
        menu.slider(task_mission, "最大速度", { "task_veh" .. index .. "mission_maxSpeed" }, "", 0, 1000, 500, 10,
            function(value)
                veh_mission.maxSpeed = value
            end)
        menu.list_select(task_mission, "驾驶风格", {}, "", Vehicle_DrivingStyle.ListItem, 1, function(value)
            veh_mission.drivingStyle = Vehicle_DrivingStyle.ValueList[value]
        end)
        menu.slider_float(task_mission, "最小距离", { "task_veh" .. index .. "mission_minDistance" }, "",
            0, 100000, 500, 100, function(value)
                veh_mission.minDistance = value * 0.01
            end)
        menu.slider_float(task_mission, "直线距离", { "task_veh" .. index .. "mission_straightLineDistance" }, "",
            0, 100000, 0, 100, function(value)
                veh_mission.straightLineDistance = value * 0.01
            end)
        menu.toggle(task_mission, "DriveAgainstTraffic", {}, "", function(toggle)
            veh_mission.DriveAgainstTraffic = toggle
        end, true)
        menu.action(task_mission, "设置任务", {}, "", function()
            TASK.TASK_VEHICLE_MISSION_PED_TARGET(ped, vehicle, players.user_ped(), veh_mission.missionType,
                veh_mission.maxSpeed, veh_mission.drivingStyle,
                veh_mission.minDistance, veh_mission.straightLineDistance,
                veh_mission.DriveAgainstTraffic)
            util.toast("完成！")
        end)
    end
end

----------------
-- Pickup
----------------

function Entity_Control.pickup(menu_parent, pickup, index)
    local pickup_options = menu.list(menu_parent, "Pickup 选项", {}, "")
    local modelHash = ENTITY.GET_ENTITY_MODEL(pickup)

    menu.action(pickup_options, "是否被收集", {}, "", function()
        util.toast(OBJECT.HAS_PICKUP_BEEN_COLLECTED(pickup))
    end)
    menu.click_slider(pickup_options, "玩家最大携带量", { "ctrl_pickup" .. index .. "max_carried" },
        "If the local player is carrying some pickups when you call this, he will drop some if he has too many.",
        0, 1000, 1, 1, function(value)
            OBJECT.SET_MAX_NUM_PORTABLE_PICKUPS_CARRIED_BY_PLAYER(modelHash, value)
        end)
    menu.toggle(pickup_options, "不可收集", {}, "Sets a pickup as locally uncollectable.", function(toggle)
        OBJECT.SET_PICKUP_UNCOLLECTABLE(pickup, toggle)
    end)
    menu.action(pickup_options, "SET_PICKUP_OBJECT_COLLECTABLE_IN_VEHICLE", {}, "", function()
        OBJECT.SET_PICKUP_OBJECT_COLLECTABLE_IN_VEHICLE(pickup)
    end)
end

---------------------
-- All Entities
---------------------

function Entity_Control.entities(menu_parent, entity_list)
    menu.click_slider(menu_parent, "请求控制实体", { "request_ctrl_ents" }, "发送请求控制的次数",
        1, 100, 20, 1, function(value)
            local success_num = 0
            local fail_num = 0
            for k, ent in pairs(entity_list) do
                if ENTITY.DOES_ENTITY_EXIST(ent) then
                    if RequestControl(ent, value) then
                        success_num = success_num + 1
                    else
                        fail_num = fail_num + 1
                    end
                end
            end
            util.toast("完成！\n成功: " .. success_num .. "\n失败: " .. fail_num)
        end)
    menu.toggle(menu_parent, "无敌", {}, "", function(toggle)
        for k, ent in pairs(entity_list) do
            if ENTITY.DOES_ENTITY_EXIST(ent) then
                ENTITY.SET_ENTITY_INVINCIBLE(ent, toggle)
                ENTITY.SET_ENTITY_PROOFS(ent, toggle, toggle, toggle, toggle, toggle, toggle, toggle, toggle)
            end
        end
        util.toast("完成！")
    end)
    menu.toggle(menu_parent, "冻结", {}, "", function(toggle)
        for k, ent in pairs(entity_list) do
            if ENTITY.DOES_ENTITY_EXIST(ent) then
                ENTITY.FREEZE_ENTITY_POSITION(ent, toggle)
            end
        end
        util.toast("完成！")
    end)
    menu.toggle(menu_parent, "燃烧", {}, "", function(toggle)
        for k, ent in pairs(entity_list) do
            if ENTITY.DOES_ENTITY_EXIST(ent) then
                if toggle then
                    FIRE.START_ENTITY_FIRE(ent)
                else
                    FIRE.STOP_ENTITY_FIRE(ent)
                end
            end
        end
        util.toast("完成！")
    end)

    local explosion_type = 4
    menu.list_select(menu_parent, "选择爆炸类型", {}, "", ExplosionType_ListItem, 6, function(value)
        explosion_type = value - 2
    end)
    menu.toggle_loop(menu_parent, "爆炸", {}, "", function()
        for k, ent in pairs(entity_list) do
            if ENTITY.DOES_ENTITY_EXIST(ent) then
                local pos = ENTITY.GET_ENTITY_COORDS(ent)
                add_explosion(pos, explosion_type)
            end
        end
        util.yield(500)
    end)

    menu.click_slider(menu_parent, "设置实体血量", { "ctrl_ents_health" }, "", 0, 100000, 100, 100, function(value)
        for k, ent in pairs(entity_list) do
            if ENTITY.DOES_ENTITY_EXIST(ent) then
                ENTITY.SET_ENTITY_HEALTH(ent, value)
            end
        end
        util.toast("完成！")
    end)
    menu.click_slider(menu_parent, "设置最大速度", { "ctrl_ents_max_speed" }, "", 0.0, 1000.0, 0.0, 10.0,
        function(value)
            for k, ent in pairs(entity_list) do
                if ENTITY.DOES_ENTITY_EXIST(ent) then
                    ENTITY.SET_ENTITY_MAX_SPEED(ent, value)
                end
            end
            util.toast("完成！")
        end)
    menu.action(menu_parent, "删除", {}, "", function()
        for k, ent in pairs(entity_list) do
            if ENTITY.DOES_ENTITY_EXIST(ent) then
                entities.delete_by_handle(ent)
            end
        end
        util.toast("完成！")
    end)



    Entity_Control.entities_teleport(menu_parent, entity_list)
    Entity_Control.entities_movement(menu_parent, entity_list)
end

function Entity_Control.entities_teleport(menu_parent, entity_list)
    ----- Teleport 选项 -----
    local teleport_options = menu.list(menu_parent, "传送 选项", {}, "")
    local tp = {
        x = 0.0,
        y = 2.0,
        z = 0.0,
    }
    local tp_delay = 1000

    menu.slider_float(teleport_options, "前/后", { "ctrl_ents_tp_y" }, "", -5000, 5000, 200, 50,
        function(value)
            tp.y = value * 0.01
        end)
    menu.slider_float(teleport_options, "上/下", { "ctrl_ents_tp_z" }, "", -5000, 5000, 0, 50,
        function(value)
            tp.z = value * 0.01
        end)
    menu.slider_float(teleport_options, "左/右", { "ctrl_ents_tp_x" }, "", -5000, 5000, 0, 50,
        function(value)
            tp.x = value * 0.01
        end)
    menu.slider(teleport_options, "传送延时", { "ctrl_ents_tp_delay" }, "单位: ms", 0, 5000, 1000, 100,
        function(value)
            tp_delay = value
        end)

    menu.action(teleport_options, "传送到我", {}, "", function()
        for k, ent in pairs(entity_list) do
            if ENTITY.DOES_ENTITY_EXIST(ent) then
                TP_TO_ME(ent, tp.x, tp.y, tp.z)
                util.yield(tp_delay)
            end
        end
        util.toast("完成！")
    end)
end

function Entity_Control.entities_movement(menu_parent, entity_list)
    ----- Movement 选项 -----
    local movement_options = menu.list(menu_parent, "移动 选项", {}, "")

    menu.click_slider_float(movement_options, "前/后 移动", { "ctrl_ents_move_y" }, "",
        -10000, 10000, 0, 50, function(value)
            value = value * 0.01
            for k, ent in pairs(entity_list) do
                if ENTITY.DOES_ENTITY_EXIST(ent) then
                    SET_ENTITY_MOVE(ent, 0.0, value, 0.0)
                end
            end
            util.toast("完成！")
        end)
    menu.click_slider_float(movement_options, "左/右 移动", { "ctrl_ents_move_x" }, "",
        -10000, 10000, 0, 50, function(value)
            value = value * 0.01
            for k, ent in pairs(entity_list) do
                if ENTITY.DOES_ENTITY_EXIST(ent) then
                    SET_ENTITY_MOVE(ent, value, 0.0, 0.0)
                end
            end
            util.toast("完成！")
        end)
    menu.click_slider_float(movement_options, "上/下 移动", { "ctrl_ents_move_z" }, "",
        -10000, 10000, 0, 50, function(value)
            value = value * 0.01
            for k, ent in pairs(entity_list) do
                if ENTITY.DOES_ENTITY_EXIST(ent) then
                    SET_ENTITY_MOVE(ent, 0.0, 0.0, value)
                end
            end
            util.toast("完成！")
        end)
    menu.click_slider_float(movement_options, "朝向", { "ctrl_ents_head" }, "",
        -36000, 36000, 0, 100, function(value)
            value = value * 0.01
            for k, ent in pairs(entity_list) do
                if ENTITY.DOES_ENTITY_EXIST(ent) then
                    local head = ENTITY.GET_ENTITY_HEADING(ent)
                    ENTITY.SET_ENTITY_HEADING(ent, head + value)
                end
            end
            util.toast("完成！")
        end)
end

--#endregion



--#region Saved Hash List

------------------------------
------- 保存的 Hash 列表 -------
------------------------------

--- 格式 ---
-- name
-- hash \n type
Saved_Hash_List = {
    dir = StoreDir .. "Saved Hash List",
    Mission_Entity_custom = nil, --menu.list_action
    Manage_Hash_List_Menu = nil, --menu.list
}

if not filesystem.exists(Saved_Hash_List.dir) then
    filesystem.mkdir(Saved_Hash_List.dir)
end

---@return table
function Saved_Hash_List.get_list()
    local file_name_list = {}
    for i, path in pairs(filesystem.list_files(Saved_Hash_List.dir)) do
        if not filesystem.is_dir(path) then
            local filename, ext = string.match(path, '^.+\\(.+)%.(.+)$')

            table.insert(file_name_list, filename)
        end
    end
    return file_name_list
end

---@return table
function Saved_Hash_List.get_list_item_data()
    local list_item_data = {}
    for i, path in pairs(filesystem.list_files(Saved_Hash_List.dir)) do
        if not filesystem.is_dir(path) then
            local Name, ext = string.match(path, '^.+\\(.+)%.(.+)$')
            local Hash, Type = Saved_Hash_List.read(Name)

            local temp = { "", {}, "" }
            temp[1] = Name
            temp[3] = "Hash: " .. Hash .. "\nType: " .. Type
            table.insert(list_item_data, temp)
        end
    end
    return list_item_data
end

---@return table
function Saved_Hash_List.get_list_item_data2()
    local list_item_data = { { "无" }, { "刷新列表" } }
    for i, path in pairs(filesystem.list_files(Saved_Hash_List.dir)) do
        if not filesystem.is_dir(path) then
            local Name, ext = string.match(path, '^.+\\(.+)%.(.+)$')
            local Hash, Type = Saved_Hash_List.read(Name)

            local temp = { "", {}, "" }
            temp[1] = Name
            temp[3] = "Hash: " .. Hash .. "\nType: " .. Type
            table.insert(list_item_data, temp)
        end
    end
    return list_item_data
end

---return Hash, Type
---@param Name string
---@return string, string
function Saved_Hash_List.read(Name)
    local file = assert(io.open(Saved_Hash_List.dir .. "\\" .. Name .. ".txt", "r"))
    local content = { 0, "No Entity" }
    for line in file:lines() do
        --table.insert(content, line)
        if tonumber(line) ~= nil then
            content[1] = line
        else
            content[2] = line
        end
    end
    file:close()
    return content[1], content[2]
end

---@param Name string
---@param Hash string
---@param Type string
function Saved_Hash_List.write(Name, Hash, Type)
    if Name ~= "" then
        local file = assert(io.open(Saved_Hash_List.dir .. "\\" .. Name .. ".txt", "w+"))
        file:write(Hash .. "\n" .. Type)
        file:close()

        Saved_Hash_List.refresh()
    end
end

---@param Name string
function Saved_Hash_List.rename(old_Name, new_Name)
    if new_Name ~= "" and new_Name ~= old_Name then
        local old_path = Saved_Hash_List.dir .. "\\" .. old_Name .. ".txt"
        local new_path = Saved_Hash_List.dir .. "\\" .. new_Name .. ".txt"
        if not os.rename(old_path, new_path) then
            util.toast("重命名失败")
        else
            Saved_Hash_List.refresh()
        end
    end
end

---@param Name string
---@return boolean
function Saved_Hash_List.delete(Name)
    if Name ~= "" then
        if not os.remove(Saved_Hash_List.dir .. "\\" .. Name .. ".txt") then
            util.toast("删除失败")
        else
            Saved_Hash_List.refresh()
        end
    end
end

Manage_Saved_Hash_Menu_List = {} --每个 Hash 的 menu.list
function Saved_Hash_List.generate_menu_list(menu_parent)
    for k, v in pairs(Manage_Saved_Hash_Menu_List) do
        if v ~= nil and menu.is_ref_valid(v) then
            menu.delete(v)
        end
    end
    Manage_Saved_Hash_Menu_List = {}

    for i, path in pairs(filesystem.list_files(Saved_Hash_List.dir)) do
        if not filesystem.is_dir(path) then
            local Name, ext = string.match(path, '^.+\\(.+)%.(.+)$')
            local Hash, Type = Saved_Hash_List.read(Name)
            local help_text = "Hash: " .. Hash .. "\nType: " .. Type

            local menu_list = menu.list(menu_parent, Name, {}, help_text)
            table.insert(Manage_Saved_Hash_Menu_List, menu_list)

            menu.text_input(menu_list, "名称", { "saved_hash_name" .. Name }, "", function(value)
                Saved_Hash_List.rename(Name, value)
            end, Name)

            menu.text_input(menu_list, "Hash", { "saved_hash" .. Name }, "", function(value)
                if tonumber(value) ~= nil and STREAMING.IS_MODEL_VALID(value) then
                    local tHash, tType = Saved_Hash_List.read(Name)
                    Saved_Hash_List.write(Name, value, tType)
                else
                    util.toast("Wrong Hash !")
                end
            end, Hash)

            menu.list_select(menu_list, "实体类型", {}, "", EntityType_ListItem, GET_ENTITY_TYPE_INDEX(Type),
                function(value)
                    value = EntityType_ListItem[value][1]
                    local tHash, tType = Saved_Hash_List.read(Name)
                    Saved_Hash_List.write(Name, tHash, value)
                end)

            menu.action(menu_list, "删除", {}, "", function()
                Saved_Hash_List.delete(Name)
            end)
        end
    end
end

---@param Name string
---@param ent Entity
function Saved_Hash_List.save(Name, ent)
    if ENTITY.DOES_ENTITY_EXIST(ent) then
        if Name ~= "" then
            local Hash = ENTITY.GET_ENTITY_MODEL(ent)
            local Type = GET_ENTITY_TYPE(ent, 2)
            Saved_Hash_List.write(Name, Hash, Type)
            util.toast("已保存")
        else
            util.toast("请输入名称")
        end
    else
        util.toast("实体已经不存在")
    end
end

function Saved_Hash_List.refresh()
    if menu.is_ref_valid(Saved_Hash_List.Mission_Entity_custom) then
        menu.set_list_action_options(Saved_Hash_List.Mission_Entity_custom, Saved_Hash_List.get_list_item_data())
    end
    if menu.is_ref_valid(Saved_Hash_List.Manage_Hash_List_Menu) then
        Saved_Hash_List.generate_menu_list(Saved_Hash_List.Manage_Hash_List_Menu)
    end
end

--#endregion



------------------------
----- SCRIPT START -----
------------------------

if not SCRIPT_SILENT_START then
    local GTAO = tonumber(NETWORK.GET_ONLINE_VERSION())
    if SUPPORT_GTAO ~= GTAO then
        util.toast("支持的GTA线上版本: " .. SUPPORT_GTAO .. "\n当前GTA线上版本: " .. GTAO)
    end
end




menu.divider(menu.my_root(), "RScript")


--#region Self Options

--------------------------------
------------ 自我选项 ------------
--------------------------------
local Self_options = menu.list(menu.my_root(), "自我选项", {}, "")

--------------------
--- 自定义血量护甲 ---
--------------------
local Self_Custom_options = menu.list(Self_options, "自定义血量护甲", {}, "")

--- 自定义最大生命值 ---
menu.divider(Self_Custom_options, "生命")

local defaultHealth = ENTITY.GET_ENTITY_MAX_HEALTH(PLAYER.PLAYER_PED_ID())
local moddedHealth = defaultHealth
menu.slider(Self_Custom_options, "自定义最大生命值", { "set_max_health" }, "生命值将被修改为指定的数值"
, 50, 100000, defaultHealth, 50, function(value)
    moddedHealth = value
end)

menu.toggle_loop(Self_Custom_options, "开启", {}, "改变你的最大生命值。一些菜单会将你标记为作弊者。当它被禁用时，它会返回到默认的最大生命值。"
, function()
    if PED.GET_PED_MAX_HEALTH(PLAYER.PLAYER_PED_ID()) ~= moddedHealth then
        PED.SET_PED_MAX_HEALTH(PLAYER.PLAYER_PED_ID(), moddedHealth)
        ENTITY.SET_ENTITY_HEALTH(PLAYER.PLAYER_PED_ID(), moddedHealth)
    end
end, function()
    PED.SET_PED_MAX_HEALTH(PLAYER.PLAYER_PED_ID(), defaultHealth)
    ENTITY.SET_ENTITY_HEALTH(PLAYER.PLAYER_PED_ID(), defaultHealth)
end)

menu.click_slider(Self_Custom_options, "设置当前生命值", { "set_health" }, "", 0, 100000, defaultHealth, 50,
    function(value)
        ENTITY.SET_ENTITY_HEALTH(PLAYER.PLAYER_PED_ID(), value)
    end)

--- 自定义最大护甲 ---
menu.divider(Self_Custom_options, "护甲")

local defaultArmour = PLAYER.GET_PLAYER_MAX_ARMOUR(PLAYER.PLAYER_ID())
local moddedArmour = defaultArmour
menu.slider(Self_Custom_options, "自定义最大护甲值", { "set_max_armour" }, "护甲将被修改为指定的数值"
, 50, 100000, defaultArmour, 50, function(value)
    moddedArmour = value
end)

menu.toggle_loop(Self_Custom_options, "开启", {}, "改变你的最大护甲值。一些菜单会将你标记为作弊者。当它被禁用时，它会返回到默认的最大护甲值。"
, function()
    if PLAYER.GET_PLAYER_MAX_ARMOUR(PLAYER.PLAYER_ID()) ~= moddedArmour then
        PLAYER.SET_PLAYER_MAX_ARMOUR(PLAYER.PLAYER_ID(), moddedArmour)
        PED.SET_PED_ARMOUR(PLAYER.PLAYER_PED_ID(), moddedArmour)
    end
end, function()
    PLAYER.SET_PLAYER_MAX_ARMOUR(PLAYER.PLAYER_ID(), defaultArmour)
    PED.SET_PED_ARMOUR(PLAYER.PLAYER_PED_ID(), defaultArmour)
end)

menu.click_slider(Self_Custom_options, "设置当前护甲值", { "set_armour" }, "", 0, 100000, defaultArmour, 50,
    function(value)
        PED.SET_PED_ARMOUR(PLAYER.PLAYER_PED_ID(), value)
    end)


--------------------
--- 自定义生命恢复 ---
--------------------
local Self_Custom_recharge_options = menu.list(Self_options, "自定义生命恢复", {}, "")

local custom_recharge = {
    fast_limit = 1.0,
    fast_mult = 20.0,
    normal_limit = 0.5,
    normal_mult = 1.0,
    cover_limit = 0.5,
    cover_mult = 1.0,
    vehicle_limit = 0.5,
    vehicle_mult = 1.0,
}

menu.slider(Self_Custom_recharge_options, "恢复程度(%)", { "fast_recharge_limit" }, "恢复到血量的多少(%)",
    1, 100, 100, 10, function(value)
        custom_recharge.fast_limit = value * 0.01
    end)
menu.slider(Self_Custom_recharge_options, "恢复速度", { "fast_recharge_mult" }, "血量恢复的速度",
    1, 100, 20, 1, function(value)
        custom_recharge.fast_mult = value
    end)
menu.toggle_loop(Self_Custom_recharge_options, "快速恢复", { "enable_fast_recharge" }, "", function()
    if PLAYER.GET_PLAYER_HEALTH_RECHARGE_MAX_PERCENT(players.user()) ~= custom_recharge.fast_limit then
        PLAYER.SET_PLAYER_HEALTH_RECHARGE_MAX_PERCENT(players.user(), custom_recharge.fast_limit)
    end
    PLAYER.SET_PLAYER_HEALTH_RECHARGE_MULTIPLIER(players.user(), custom_recharge.fast_mult)
end, function()
    PLAYER.SET_PLAYER_HEALTH_RECHARGE_MAX_PERCENT(players.user(), 0.5)
    PLAYER.SET_PLAYER_HEALTH_RECHARGE_MULTIPLIER(players.user(), 1.0)
end)


menu.divider(Self_Custom_recharge_options, "不同状态")
menu.toggle_loop(Self_Custom_recharge_options, "开启", { "custom_recharge" }, "", function()
    if PED.IS_PED_IN_COVER(players.user_ped(), false) then
        PLAYER.SET_PLAYER_HEALTH_RECHARGE_MAX_PERCENT(players.user(), custom_recharge.cover_limit)
        PLAYER.SET_PLAYER_HEALTH_RECHARGE_MULTIPLIER(players.user(), custom_recharge.cover_mult)
    elseif PED.IS_PED_IN_ANY_VEHICLE(players.user_ped(), false) then
        PLAYER.SET_PLAYER_HEALTH_RECHARGE_MAX_PERCENT(players.user(), custom_recharge.vehicle_limit)
        PLAYER.SET_PLAYER_HEALTH_RECHARGE_MULTIPLIER(players.user(), custom_recharge.vehicle_mult)
    else
        PLAYER.SET_PLAYER_HEALTH_RECHARGE_MAX_PERCENT(players.user(), custom_recharge.normal_limit)
        PLAYER.SET_PLAYER_HEALTH_RECHARGE_MULTIPLIER(players.user(), custom_recharge.normal_mult)
    end
end, function()
    PLAYER.SET_PLAYER_HEALTH_RECHARGE_MAX_PERCENT(players.user(), 0.5)
    PLAYER.SET_PLAYER_HEALTH_RECHARGE_MULTIPLIER(players.user(), 1.0)
end)

local Self_Custom_recharge_setting = menu.list(Self_Custom_recharge_options, "自定义设置", {}, "")

menu.divider(Self_Custom_recharge_setting, "通用")
menu.slider(Self_Custom_recharge_setting, "恢复程度(%)", { "recharge_normal_limit" }, "",
    1, 100, 50, 10, function(value)
        custom_recharge.normal_limit = value * 0.01
    end)
menu.slider(Self_Custom_recharge_setting, "恢复速度", { "recharge_normal_mult" }, "",
    1, 100, 1, 1, function(value)
        custom_recharge.normal_mult = value
    end)

menu.divider(Self_Custom_recharge_setting, "掩体内")
menu.slider(Self_Custom_recharge_setting, "恢复程度(%)", { "recharge_cover_limit" }, "",
    1, 100, 50, 10, function(value)
        custom_recharge.cover_limit = value * 0.01
    end)
menu.slider(Self_Custom_recharge_setting, "恢复速度", { "recharge_cover_mult" }, "",
    1, 100, 1, 1, function(value)
        custom_recharge.cover_mult = value
    end)

menu.divider(Self_Custom_recharge_setting, "载具内")
menu.slider(Self_Custom_recharge_setting, "恢复程度(%)", { "recharge_vehicle_limit" }, "",
    1, 100, 50, 10, function(value)
        custom_recharge.vehicle_limit = value * 0.01
    end)
menu.slider(Self_Custom_recharge_setting, "恢复速度", { "recharge_vehicle_mult" }, "",
    1, 100, 1, 1, function(value)
        custom_recharge.vehicle_mult = value
    end)



--------------------
--- 自定义血量下限 ---
--------------------
local Self_Custom_low_limit = menu.list(Self_options, "自定义血量下限", {}, "")

local low_health_limit = 0.5
menu.slider(Self_Custom_low_limit, "设置血量下限(%)", { "low_health_limit" }, "可以到达的最低血量，单位%"
, 10, 100, 50, 10
, function(value)
    low_health_limit = value * 0.01
end)
menu.toggle_loop(Self_Custom_low_limit, "锁定血量", {}, "当你的血量到达你设置的血量下限值后，锁定你的血量，防不住爆炸"
, function()
    if not PLAYER.IS_PLAYER_DEAD(players.user()) then
        local maxHealth = ENTITY.GET_ENTITY_MAX_HEALTH(players.user_ped()) - 100
        local toLock_health = math.ceil(maxHealth * low_health_limit + 100)
        if ENTITY.GET_ENTITY_HEALTH(players.user_ped()) < toLock_health then
            ENTITY.SET_ENTITY_HEALTH(players.user_ped(), toLock_health)
        end
    end
end)
menu.toggle_loop(Self_Custom_low_limit, "补满血量", {}, "当你的血量到达你设置的血量下限值后，补满你的血量"
, function()
    if not PLAYER.IS_PLAYER_DEAD(players.user()) then
        local maxHealth = ENTITY.GET_ENTITY_MAX_HEALTH(players.user_ped()) - 100
        local toLock_health = math.ceil(maxHealth * low_health_limit + 100)
        if ENTITY.GET_ENTITY_HEALTH(players.user_ped()) < toLock_health then
            ENTITY.SET_ENTITY_HEALTH(players.user_ped(), maxHealth + 100)
        end
    end
end)



-------------------
----- 通缉选项 -----
-------------------
local Self_Wanted_options = menu.list(Self_options, "通缉选项", {}, "")

local self_wanted_level = {
    multiplier = 0.0,
    difficulty = 0.0,
}

menu.action(Self_Wanted_options, "Force Start Hidden Evasion", {},
    "Can be used at any point that police 'know' where the player is to force hidden evasion to start (i.e. flashing stars, cops use vision cones)"
    , function()
        PLAYER.FORCE_START_HIDDEN_EVASION(players.user())
    end)
menu.toggle_loop(Self_Wanted_options, "Suppress Crime", {},
    "Can be use to disable all instances of a crime type on this frame.", function()
        for i = 1, 50 do
            PLAYER.SUPPRESS_CRIME_THIS_FRAME(players.user(), i)
        end
    end)

menu.divider(Self_Wanted_options, "Multiplier")
menu.slider_float(Self_Wanted_options, "Wanted Level Multiplier", {},
    "If you set the wanted multiplier to a low value 0.01 and a cop see you shoot a ped in face you wil still get a wanted level. \n1.0f is the default value and it will automatically be reset when MISSION_HAS_FINISHED is called. \nA value of 2.0f means that the player's wanted level will go up twice as fast when he commits crimes."
    , 0, 1000, 0, 10, function(value)
        self_wanted_level.multiplier = value * 0.01
    end)
menu.toggle_loop(Self_Wanted_options, "Set Wanted Level Multiplier", {}, "", function()
    PLAYER.SET_WANTED_LEVEL_MULTIPLIER(self_wanted_level.multiplier)
end)

menu.divider(Self_Wanted_options, "Difficulty")
menu.slider_float(Self_Wanted_options, "Wanted Level Difficulty", {},
    "Sets the difficulty for the wanted system.", 0, 100, 0, 10, function(value)
        self_wanted_level.difficulty = value * 0.01
    end)
menu.toggle_loop(Self_Wanted_options, "Set Wanted Level Difficulty", {}, "", function()
    PLAYER.SET_WANTED_LEVEL_DIFFICULTY(players.user(), self_wanted_level.difficulty)
end)
menu.action(Self_Wanted_options, "Reset Wanted Level Difficulty", {}, "", function()
    PLAYER.RESET_WANTED_LEVEL_DIFFICULTY(players.user())
end)



-------------------
----- 跌落选项 -----
-------------------
local Self_Fall_options = menu.list(Self_options, "跌落选项", {}, "")

menu.toggle_loop(Self_Fall_options, "禁止高处跌落直接死亡", {}, "如果血量过低仍然会直接摔死",
    function()
        PED.SET_DISABLE_HIGH_FALL_DEATH(players.user_ped(), true)
    end, function()
        PED.SET_DISABLE_HIGH_FALL_DEATH(players.user_ped(), false)
    end)

local self_fall_distance = 8.0
menu.slider_float(Self_Fall_options, "触发跌落动作高度", { "self_fall_distance" }, "", 0, 10000, 800, 100,
    function(value)
        self_fall_distance = value * 0.01
    end)
menu.toggle_loop(Self_Fall_options, "设置触发跌落高度", {}, "", function()
    PLAYER.SET_PLAYER_FALL_DISTANCE_TO_TRIGGER_RAGDOLL_OVERRIDE(players.user(), self_fall_distance)
end)




----------------
menu.toggle_loop(Self_options, "显示血量和护甲", {}, "信息显示位置", function()
    local current_health = ENTITY.GET_ENTITY_HEALTH(PLAYER.PLAYER_PED_ID())
    local max_health = PED.GET_PED_MAX_HEALTH(PLAYER.PLAYER_PED_ID())
    local current_armour = PED.GET_PED_ARMOUR(PLAYER.PLAYER_PED_ID())
    local max_armour = PLAYER.GET_PLAYER_MAX_ARMOUR(PLAYER.PLAYER_ID())
    local text = "血量: " .. current_health .. "/" .. max_health ..
        "\n护甲: " .. current_armour .. "/" .. max_armour
    util.draw_debug_text(text)
end)
menu.toggle_loop(Self_options, "警察无视", {}, "", function()
    PLAYER.SET_POLICE_IGNORE_PLAYER(PLAYER.PLAYER_ID(), true)
end, function()
    PLAYER.SET_POLICE_IGNORE_PLAYER(PLAYER.PLAYER_ID(), false)
end)
menu.toggle_loop(Self_options, "所有人无视", {}, "", function()
    PLAYER.SET_EVERYONE_IGNORE_PLAYER(PLAYER.PLAYER_ID(), true)
end, function()
    PLAYER.SET_EVERYONE_IGNORE_PLAYER(PLAYER.PLAYER_ID(), false)
end)
menu.toggle_loop(Self_options, "行动无声", {}, "", function()
    PLAYER.SET_PLAYER_NOISE_MULTIPLIER(PLAYER.PLAYER_ID(), 0.0)
    PLAYER.SET_PLAYER_SNEAKING_NOISE_MULTIPLIER(PLAYER.PLAYER_ID(), 0.0)
end)
menu.toggle_loop(Self_options, "不会被帮派骚乱", {}, "", function()
    PLAYER.SET_PLAYER_CAN_BE_HASSLED_BY_GANGS(PLAYER.PLAYER_ID(), false)
end, function()
    PLAYER.SET_PLAYER_CAN_BE_HASSLED_BY_GANGS(PLAYER.PLAYER_ID(), true)
end)
menu.toggle_loop(Self_options, "禁止为玩家调度警察", { "disable_dispatch_cops" }, "不会一直刷出新的警察，最好在被通缉前开启"
, function()
    PLAYER.SET_DISPATCH_COPS_FOR_PLAYER(PLAYER.PLAYER_ID(), false)
end, function()
    PLAYER.SET_DISPATCH_COPS_FOR_PLAYER(PLAYER.PLAYER_ID(), true)
end)
menu.toggle_loop(Self_options, "载具内不可被射击", {}, "在载具内不会受伤", function()
    PED.SET_PED_CAN_BE_SHOT_IN_VEHICLE(PLAYER.PLAYER_PED_ID(), false)
end, function()
    PED.SET_PED_CAN_BE_SHOT_IN_VEHICLE(PLAYER.PLAYER_PED_ID(), true)
end)
menu.toggle_loop(Self_options, "禁用NPC伤害", { "disable_ai_damage" }, "", function()
    PED.SET_AI_WEAPON_DAMAGE_MODIFIER(0.0)
    PED.SET_AI_MELEE_WEAPON_DAMAGE_MODIFIER(0.0)
end, function()
    PED.RESET_AI_WEAPON_DAMAGE_MODIFIER()
    PED.RESET_AI_MELEE_WEAPON_DAMAGE_MODIFIER()
end)
menu.toggle_loop(Self_options, "只能被玩家伤害", {}, "不会被NPC伤害", function()
    ENTITY.SET_ENTITY_ONLY_DAMAGED_BY_PLAYER(players.user_ped(), true)
end, function()
    ENTITY.SET_ENTITY_ONLY_DAMAGED_BY_PLAYER(players.user_ped(), false)
end)

--#endregion Self Options





--#region Weapon Options

--------------------------------
------------ 武器选项 ------------
--------------------------------
local Weapon_options = menu.list(menu.my_root(), "武器选项", {}, "")

menu.toggle_loop(Weapon_options, "可以射击队友", {}, "", function()
    PED.SET_CAN_ATTACK_FRIENDLY(players.user_ped(), true, false)
end, function()
    PED.SET_CAN_ATTACK_FRIENDLY(players.user_ped(), false, false)
end)
menu.toggle_loop(Weapon_options, "无限弹夹", { "inf_clip" }, "锁定弹夹，无需换弹",
    function()
        WEAPON.SET_PED_INFINITE_AMMO_CLIP(players.user_ped(), true)
    end, function()
        WEAPON.SET_PED_INFINITE_AMMO_CLIP(players.user_ped(), false)
    end)
menu.toggle_loop(Weapon_options, "锁定最大弹药", { "lock_ammo" }, "锁定当前武器为最大弹药", function()
    local user_ped = players.user_ped()
    if PED.IS_PED_SHOOTING(user_ped) then
        local weaponHash = WEAPON.GET_SELECTED_PED_WEAPON(user_ped)
        -- WEAPON.SET_PED_AMMO(user_ped, weaponHash, 9999)
        WEAPON.ADD_AMMO_TO_PED(user_ped, weaponHash, 9999)

        -- local curAmmoMem = memory.alloc_int()
        -- local junk = WEAPON.GET_MAX_AMMO(players.user_ped(), curWeapon, curAmmoMem)
        -- local curAmmoMax = memory.read_int(curAmmoMem)
        -- memory.free(curAmmoMem)
    end
end)
menu.toggle_loop(Weapon_options, "无限载具武器弹药", { "inf_veh_ammo" }, "", function()
    local user_ped = players.user_ped()
    local vehicle = entities.get_user_vehicle_as_handle()
    if vehicle ~= 0 then
        if VEHICLE.DOES_VEHICLE_HAVE_WEAPONS(vehicle) then
            for i = 0, 3 do
                local ammo = VEHICLE.GET_VEHICLE_WEAPON_RESTRICTED_AMMO(vehicle, i)
                if ammo ~= -1 then
                    VEHICLE.SET_VEHICLE_WEAPON_RESTRICTED_AMMO(vehicle, i, -1)
                end
            end
        end
    end
end)
menu.toggle_loop(Weapon_options, "翻滚时自动换弹夹", {}, "做翻滚动作时自动更换弹夹", function()
    if TASK.GET_IS_TASK_ACTIVE(players.user_ped(), 4) and PAD.IS_CONTROL_PRESSED(2, 22) and
        not PED.IS_PED_SHOOTING(players.user_ped()) then
        --checking if player is rolling
        util.yield(900)
        WEAPON.REFILL_AMMO_INSTANTLY(players.user_ped())
    end
end)
menu.toggle_loop(Weapon_options, "快速装弹", {}, "换弹时加快动作", function()
    if PED.IS_PED_RELOADING(players.user_ped()) then
        PED.FORCE_PED_AI_AND_ANIMATION_UPDATE(players.user_ped())
    end
end)
menu.toggle_loop(Weapon_options, "快速更换武器", {}, "更换武器时加快动作", function()
    if PED.IS_PED_SWITCHING_WEAPON(players.user_ped()) then
        PED.FORCE_PED_AI_AND_ANIMATION_UPDATE(players.user_ped())
    end
end)
menu.action(Weapon_options, "移除黏弹和感应地雷", { "remove_projectiles" }, "用来清理扔错地方但又不能炸掉的投掷武器",
    function()
        local weaponHash = util.joaat("WEAPON_PROXMINE")
        WEAPON.REMOVE_ALL_PROJECTILES_OF_TYPE(weaponHash, false)
        weaponHash = util.joaat("WEAPON_STICKYBOMB")
        WEAPON.REMOVE_ALL_PROJECTILES_OF_TYPE(weaponHash, false)
    end)



------------------------
------- 视野工具枪 -------
------------------------
local Weapon_Cam_Gun = menu.list(Weapon_options, "视野工具枪", {}, "玩家镜头中心的位置")


local Cam_Gun = {
    select = 1,

}

--- Shoot ---
Cam_Gun.shoot_setting = {
    shoot_method = 1,
    delay = 100,
    weapon_select = 1,
    weapon_hash = "PLAYER_WEAPON",
    vehicle_weapon_hash = "VEHICLE_WEAPON",
    is_owned = false,
    CreateTraceVfx = true,
    AllowRumble = true,
    damage = 1000,
    speed = 1000,
    PerfectAccuracy = false,
    start_from_player = false,
    x = 0.0,
    y = 0.0,
    z = 2.0,
}

function Cam_Gun.Shoot_Pos(pos, state)
    local user_ped = players.user_ped()

    local weaponHash = Cam_Gun.shoot_setting.weapon_hash
    if Cam_Gun.shoot_setting.weapon_select == 2 then
        weaponHash = Cam_Gun.shoot_setting.vehicle_weapon_hash
    end

    if weaponHash == "PLAYER_WEAPON" then
        local pWeapon = memory.alloc_int()
        WEAPON.GET_CURRENT_PED_WEAPON(user_ped, pWeapon, true)
        weaponHash = memory.read_int(pWeapon)
    elseif weaponHash == "VEHICLE_WEAPON" then
        local pWeapon = memory.alloc_int()
        WEAPON.GET_CURRENT_PED_VEHICLE_WEAPON(user_ped, pWeapon)
        weaponHash = memory.read_int(pWeapon)
    end
    if not WEAPON.HAS_WEAPON_ASSET_LOADED(weaponHash) then
        request_weapon_asset(weaponHash)
    end

    local owner = 0
    if Cam_Gun.shoot_setting.is_owned then
        owner = user_ped
    end

    local start_pos = v3.new()
    if Cam_Gun.shoot_setting.start_from_player then
        local player_pos = ENTITY.GET_ENTITY_COORDS(user_ped)
        start_pos.x = player_pos.x + Cam_Gun.shoot_setting.x
        start_pos.y = player_pos.y + Cam_Gun.shoot_setting.y
        start_pos.z = player_pos.z + Cam_Gun.shoot_setting.z
    else
        start_pos.x = pos.x + Cam_Gun.shoot_setting.x
        start_pos.y = pos.y + Cam_Gun.shoot_setting.y
        start_pos.z = pos.z + Cam_Gun.shoot_setting.z
    end

    if state == "draw_line" then
        DRAW_LINE(start_pos, pos)
    elseif state == "shoot" then
        local ignore_entity = user_ped
        if PED.IS_PED_IN_ANY_VEHICLE(user_ped, false) then
            ignore_entity = PED.GET_VEHICLE_PED_IS_IN(user_ped, false)
        end

        MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS_IGNORE_ENTITY(start_pos.x, start_pos.y, start_pos.z,
            pos.x, pos.y, pos.z,
            Cam_Gun.shoot_setting.damage, Cam_Gun.shoot_setting.PerfectAccuracy, weaponHash, owner,
            Cam_Gun.shoot_setting.CreateTraceVfx, Cam_Gun.shoot_setting.AllowRumble, Cam_Gun.shoot_setting.speed,
            ignore_entity)
    end
end

function Cam_Gun.Shoot()
    local cam_pos
    if Cam_Gun.shoot_setting.shoot_method == 1 then
        local result = get_raycast_result(1500, -1)
        if result.didHit then
            cam_pos = result.endCoords
        end
    elseif Cam_Gun.shoot_setting.shoot_method == 2 then
        cam_pos = get_offset_from_cam(1500)
    end

    if cam_pos ~= nil then
        Cam_Gun.Shoot_Pos(cam_pos, "shoot")
        util.yield(Cam_Gun.shoot_setting.delay)
    end
end

--- Explosion ---
Cam_Gun.explosion_setting = {
    delay = 100,
    explosionType = 2,
    is_owned = false,
    damage = 1000,
    is_audible = true,
    is_invisible = false,
    camera_shake = 0.0,
}

function Cam_Gun.Explosion()
    local result = get_raycast_result(1500, -1)
    local cam_pos = result.endCoords
    if result.didHit and cam_pos ~= nil then
        if Cam_Gun.explosion_setting.is_owned then
            FIRE.ADD_OWNED_EXPLOSION(players.user_ped(), cam_pos.x, cam_pos.y, cam_pos.z,
                Cam_Gun.explosion_setting.explosionType, Cam_Gun.explosion_setting.damage,
                Cam_Gun.explosion_setting.is_audible, Cam_Gun.explosion_setting.is_invisible,
                Cam_Gun.explosion_setting.camera_shake)
        else
            FIRE.ADD_EXPLOSION(cam_pos.x, cam_pos.y, cam_pos.z, Cam_Gun.explosion_setting.explosionType,
                Cam_Gun.explosion_setting.damage, Cam_Gun.explosion_setting.is_audible,
                Cam_Gun.explosion_setting.is_invisible
                , Cam_Gun.explosion_setting.camera_shake, false)
        end
        util.yield(Cam_Gun.explosion_setting.delay)
    end
end

--- Fire ---
Cam_Gun.fire_setting = {
    fire_ids = {},
    maxChildren = 25,
    isGasFire = false,
}

function Cam_Gun.Fire()
    local result = get_raycast_result(1500, -1)
    local cam_pos = result.endCoords
    if result.didHit and cam_pos ~= nil then
        local fire_id = FIRE.START_SCRIPT_FIRE(cam_pos.x, cam_pos.y, cam_pos.z, Cam_Gun.fire_setting.maxChildren,
            Cam_Gun.fire_setting.isGasFire)
        table.insert(Cam_Gun.fire_setting.fire_ids, fire_id)
    end
end

menu.toggle_loop(Weapon_Cam_Gun, "开启[按住E键]", { "cam_gun" }, "", function()
    tick_handler_data.main.draw_point_on_screen = true
    if PAD.IS_CONTROL_PRESSED(0, 51) then
        if Cam_Gun.select == 1 then
            Cam_Gun.Shoot()
        elseif Cam_Gun.select == 2 then
            Cam_Gun.Explosion()
        elseif Cam_Gun.select == 3 then
            Cam_Gun.Fire()
        end
    end
end, function()
    tick_handler_data.main.draw_point_on_screen = false
end)

menu.list_select(Weapon_Cam_Gun, "选择操作", { "cam_gun_select" }, "", {
    { "射击", { "shoot" },     "" },
    { "爆炸", { "explosion" }, "" },
    { "燃烧", { "fire" },      "" },
}, 1, function(value)
    Cam_Gun.select = value
end)


menu.divider(Weapon_Cam_Gun, "设置")
----------------
-- 射击设置
----------------
local Cam_Gun_shoot = menu.list(Weapon_Cam_Gun, "射击", {}, "")

menu.toggle_loop(Cam_Gun_shoot, "绘制射击连线", {}, "", function()
    tick_handler_data.main.draw_point_on_screen = true

    local cam_pos
    if Cam_Gun.shoot_setting.shoot_method == 1 then
        local result = get_raycast_result(1500, -1)
        if result.didHit then
            cam_pos = result.endCoords
        end
    elseif Cam_Gun.shoot_setting.shoot_method == 2 then
        cam_pos = get_offset_from_cam(1500)
    end

    if cam_pos ~= nil then
        Cam_Gun.Shoot_Pos(cam_pos, "draw_line")
    end
end, function()
    tick_handler_data.main.draw_point_on_screen = false
end)

menu.list_select(Cam_Gun_shoot, "射击方式", {}, "", {
    { "方式1", {}, "射击的坐标更加准确，只能向实体或地面射击" },
    { "方式2", {}, "射击的坐标不是很准确，但可以向空中射击" }
}, 1, function(value)
    Cam_Gun.shoot_setting.shoot_method = value
end)
menu.slider(Cam_Gun_shoot, "循环延迟", { "cam_gun_shoot_delay" }, "单位: ms", 0, 5000, 100, 10,
    function(value)
        Cam_Gun.shoot_setting.delay = value
    end)

local Cam_Gun_shoot_weapon = menu.list(Cam_Gun_shoot, "武器", {}, "")
menu.list_select(Cam_Gun_shoot_weapon, "武器类型", {}, "", { { "手持武器" }, { "载具武器" } }, 1,
    function(value)
        Cam_Gun.shoot_setting.weapon_select = value
    end)
menu.list_select(Cam_Gun_shoot_weapon, "手持武器", {}, "", AllWeapons_NoMelee_ListItem, 1, function(value)
    Cam_Gun.shoot_setting.weapon_hash = AllWeapons_NoMelee_ListItem[value][3]
end)
menu.list_select(Cam_Gun_shoot_weapon, "载具武器", {}, "", All_VehicleWeapons_ListItem, 1, function(value)
    Cam_Gun.shoot_setting.vehicle_weapon_hash = All_VehicleWeapons_ListItem[value][3]
end)

menu.toggle(Cam_Gun_shoot, "署名射击", {}, "以玩家名义", function(toggle)
    Cam_Gun.shoot_setting.is_owned = toggle
end)
menu.slider(Cam_Gun_shoot, "伤害", { "cam_gun_shoot_damage" }, "", 0, 10000, 1000, 100,
    function(value)
        Cam_Gun.shoot_setting.damage = value
    end)
menu.slider(Cam_Gun_shoot, "速度", { "cam_gun_shoot_speed" }, "", 0, 10000, 1000, 100,
    function(value)
        Cam_Gun.shoot_setting.speed = value
    end)
menu.toggle(Cam_Gun_shoot, "Create Trace Vfx", {}, "", function(toggle)
    Cam_Gun.shoot_setting.CreateTraceVfx = toggle
end, true)
menu.toggle(Cam_Gun_shoot, "Allow Rumble", {}, "", function(toggle)
    Cam_Gun.shoot_setting.AllowRumble = toggle
end, true)
menu.toggle(Cam_Gun_shoot, "Perfect Accuracy", {}, "", function(toggle)
    Cam_Gun.shoot_setting.PerfectAccuracy = toggle
end)
menu.divider(Cam_Gun_shoot, "起始射击位置偏移")
menu.toggle(Cam_Gun_shoot, "从玩家位置起始射击", {}, "如果关闭，则起始位置为目标位置+偏移\n如果开启，建议偏移Z>1.0"
    ,
    function(toggle)
        Cam_Gun.shoot_setting.start_from_player = toggle
    end)
menu.slider_float(Cam_Gun_shoot, "X", { "cam_gun_shoot_x" }, "", -10000, 10000, 0, 10,
    function(value)
        value = value * 0.01
        Cam_Gun.shoot_setting.x = value
    end)
menu.slider_float(Cam_Gun_shoot, "Y", { "cam_gun_shoot_y" }, "", -10000, 10000, 0, 10,
    function(value)
        value = value * 0.01
        Cam_Gun.shoot_setting.y = value
    end)
menu.slider_float(Cam_Gun_shoot, "Z", { "cam_gun_shoot_z" }, "", -10000, 10000, 200, 10,
    function(value)
        value = value * 0.01
        Cam_Gun.shoot_setting.z = value
    end)

----------------
-- 爆炸设置
----------------
local Cam_Gun_explosion = menu.list(Weapon_Cam_Gun, "爆炸", {}, "")

menu.slider(Cam_Gun_explosion, "循环延迟", { "cam_gun_explosion_delay" }, "单位: ms", 0, 5000, 100, 10,
    function(value)
        Cam_Gun.explosion_setting.delay = value
    end)
menu.list_select(Cam_Gun_explosion, "爆炸类型", {}, "", ExplosionType_ListItem, 4, function(index)
    Cam_Gun.explosion_setting.explosionType = index - 2
end)
menu.toggle(Cam_Gun_explosion, "署名爆炸", {}, "以玩家名义", function(toggle)
    Cam_Gun.explosion_setting.is_owned = toggle
end)
menu.slider(Cam_Gun_explosion, "伤害", { "cam_gun_explosion_damage" }, "", 0, 10000, 1000, 100,
    function(value)
        Cam_Gun.explosion_setting.damage = value
    end)
menu.toggle(Cam_Gun_explosion, "可听见", {}, "", function(toggle)
    Cam_Gun.explosion_setting.is_audible = toggle
end, true)
menu.toggle(Cam_Gun_explosion, "不可见", {}, "", function(toggle)
    Cam_Gun.explosion_setting.is_invisible = toggle
end)
menu.slider_float(Cam_Gun_explosion, "镜头晃动", { "cam_gun_explosion_camera_shake" }, "", 0, 1000, 0, 10,
    function(value)
        value = value * 0.01
        Cam_Gun.explosion_setting.camera_shake = value
    end)

----------------
-- 燃烧设置
----------------
local Cam_Gun_fire = menu.list(Weapon_Cam_Gun, "燃烧", {}, "有火焰数量生成限制")

menu.slider(Cam_Gun_fire, "max Children", { "cam_gun_fire_maxChildren" },
    "The max amount of times a fire can spread to other objects.", 0, 25, 25, 1, function(value)
        Cam_Gun.fire_setting.maxChildren = value
    end)
menu.toggle(Cam_Gun_fire, "is Gas Fire", {}, "Whether or not the fire is powered by gasoline.", function(toggle)
    Cam_Gun.fire_setting.isGasFire = toggle
end)
menu.action(Cam_Gun_fire, "移除生成的火焰", {}, "", function()
    if next(Cam_Gun.fire_setting.fire_ids) ~= nil then
        for k, v in pairs(Cam_Gun.fire_setting.fire_ids) do
            FIRE.REMOVE_SCRIPT_FIRE(v)
        end
        Cam_Gun.fire_setting.fire_ids = {}
    end
end)




------------------------
------- 实体控制枪 -------
------------------------
local Entity_Control_Gun = menu.list(Weapon_options, "实体控制枪", {}, "控制你所瞄准的实体")

local entity_control_gun = {
    entity_type = "全部",
    method_select = 1,
}

function entity_control_gun.generate_menu_head(menu_parent, ent)
    menu.action(menu_parent, "检测该实体是否存在", {}, "", function()
        if ENTITY.DOES_ENTITY_EXIST(ent) then
            util.toast("实体存在")
        else
            util.toast("该实体已经不存在，请删除此条实体记录！")
        end
    end)

    menu.action(menu_parent, "删除此条实体记录", {}, "", function()
        menu.delete(menu_parent)
        clearTableValue(entity_control_gun.entity_menu_list, menu_parent)
        clearTableValue(entity_control_gun.entity_list, ent)

        entity_control_gun.entity_count = entity_control_gun.entity_count - 1
        if entity_control_gun.entity_count <= 0 then
            entity_control_gun.clear_entity_list_data()
        else
            menu.set_menu_name(entity_control_gun.count_divider, "实体列表 (" ..
                entity_control_gun.entity_count .. ")")
        end
    end)
end

-- 初始化数据
function entity_control_gun.init_entity_list_data()
    -- 实体 list
    entity_control_gun.entity_list = {}
    -- 实体的 menu.list()
    entity_control_gun.entity_menu_list = {}
    -- 实体索引
    entity_control_gun.entity_index = 1
    -- 实体数量
    entity_control_gun.entity_count = 0
end

entity_control_gun.init_entity_list_data()

-- 清理并初始化数据
function entity_control_gun.clear_entity_list_data()
    -- 实体的 menu.list()
    for k, v in pairs(entity_control_gun.entity_menu_list) do
        if v ~= nil and menu.is_ref_valid(v) then
            menu.delete(v)
        end
    end
    -- 初始化
    entity_control_gun.init_entity_list_data()
    menu.set_menu_name(entity_control_gun.count_divider, "实体列表")
end

menu.toggle_loop(Entity_Control_Gun, "开启[按E]", { "ctrl_gun" }, "", function()
    draw_point_in_center()

    local ent = 0
    if entity_control_gun.method_select == 1 then
        ent = get_entity_player_is_aiming_at(players.user())
    else
        local result = get_raycast_result(1500, -1)
        if result.didHit then
            ent = result.hitEntity
        end
    end

    if ent ~= nil and IS_AN_ENTITY(ent) then
        -- 实体类型判断
        local Type = entity_control_gun.entity_type
        if Type ~= "全部" then
            local ent_type = GET_ENTITY_TYPE(ent, 2)
            if Type ~= ent_type then
                return false
            end
        end

        -- 和实体连线
        local pos1 = ENTITY.GET_ENTITY_COORDS(players.user_ped())
        local pos2 = ENTITY.GET_ENTITY_COORDS(ent)
        DRAW_LINE(pos1, pos2)

        -- 记录实体
        if PAD.IS_CONTROL_PRESSED(0, 51) then
            if not isInTable(entity_control_gun.entity_list, ent) then
                table.insert(entity_control_gun.entity_list, ent) -- 实体 list

                local menu_name, help_text = Entity_Control.get_menu_info(ent, entity_control_gun.entity_index)
                util.toast(menu_name .. "\n" .. help_text)

                -- 实体的 menu.list()
                local menu_list = menu.list(Entity_Control_Gun, menu_name, {}, help_text)
                table.insert(entity_control_gun.entity_menu_list, menu_list)

                -- 创建对应实体的menu操作
                entity_control_gun.generate_menu_head(menu_list, ent)
                Entity_Control.generate_menu(menu_list, ent, entity_control_gun.entity_index)

                entity_control_gun.entity_index = entity_control_gun.entity_index + 1 -- 实体索引

                -- 实体数量
                entity_control_gun.entity_count = entity_control_gun.entity_count + 1
                if entity_control_gun.entity_count == 0 then
                    menu.set_menu_name(entity_control_gun.count_divider, "实体列表")
                else
                    menu.set_menu_name(entity_control_gun.count_divider,
                        "实体列表 (" .. entity_control_gun.entity_count .. ")")
                end
            end
        end
    end
end)

menu.list_select(Entity_Control_Gun, "方式", {}, "", {
    { "武器瞄准" }, { "镜头瞄准" }
}, 1, function(value)
    entity_control_gun.method_select = value
end)

menu.list_select(Entity_Control_Gun, "实体类型", {}, "", {
    { "全部",  {}, "全部类型实体" },
    { "Ped",     {}, "NPC" },
    { "Vehicle", {}, "载具" },
    { "Object",  {}, "物体" },
    { "Pickup",  {}, "拾取物" }
}, 1, function(index, name)
    entity_control_gun.entity_type = name
end)

menu.action(Entity_Control_Gun, "清空列表", {}, "", function()
    entity_control_gun.clear_entity_list_data()
end)
entity_control_gun.count_divider = menu.divider(Entity_Control_Gun, "实体列表")


--#endregion Weapon Options





--#region Vehicle Options

--------------------------------
------------ 载具选项 ------------
--------------------------------
local Vehicle_options = menu.list(menu.my_root(), "载具选项", {}, "")


------------------
--- 载具升级强化 ---
------------------
local Vehicle_Upgrade_options = menu.list(Vehicle_options, "载具升级强化", {}, "")

local vehicle_upgrade = {
    performance = true,
    turbo = true,
    ---
    bulletproof_tyre = true,
    unbreakable_door = true,
    unbreakable_light = true,
    unbreak = true,
    ---
    health_multiplier = 1,
    no_driver_explosion_damage = true,
    other_strong = true,
}

function vehicle_upgrade.upgrade(vehicle)
    -- 引擎、刹车、变速箱、防御
    if vehicle_upgrade.performance then
        for k, v in pairs({ 11, 12, 13, 16 }) do
            local mod_num = VEHICLE.GET_NUM_VEHICLE_MODS(vehicle, v)
            VEHICLE.SET_VEHICLE_MOD(vehicle, v, mod_num - 1, false)
        end
    end

    -- 涡轮增压
    if vehicle_upgrade.turbo then
        VEHICLE.TOGGLE_VEHICLE_MOD(vehicle, 18, true)
    end

    -- 防弹轮胎
    if vehicle_upgrade.bulletproof_tyre then
        if VEHICLE.GET_VEHICLE_TYRES_CAN_BURST(vehicle) then
            VEHICLE.SET_VEHICLE_TYRES_CAN_BURST(vehicle, false)
        end
    end

    -- 车门不可损坏
    if vehicle_upgrade.unbreakable_door then
        for i = 0, 5 do
            if VEHICLE.GET_IS_DOOR_VALID(vehicle, i) then
                VEHICLE.SET_DOOR_ALLOWED_TO_BE_BROKEN_OFF(vehicle, i, false)
            end
        end
    end

    -- 车灯不可损坏
    if vehicle_upgrade.unbreakable_light then
        VEHICLE.SET_VEHICLE_HAS_UNBREAKABLE_LIGHTS(vehicle, true)
    end

    -- 部件不可分离
    if vehicle_upgrade.unbreakable_light then
        VEHICLE.SET_VEHICLE_CAN_BREAK(vehicle, false)
    end

    -- 血量加倍
    if vehicle_upgrade.health_multiplier > 1 then
        local max_health = ENTITY.GET_ENTITY_MAX_HEALTH(vehicle) * vehicle_upgrade.health_multiplier
        ENTITY.SET_ENTITY_MAX_HEALTH(vehicle, max_health)
        ENTITY.SET_ENTITY_HEALTH(vehicle, max_health)
    end

    -- 无视载具司机的爆炸
    if vehicle_upgrade.no_driver_explosion_damage then
        VEHICLE.SET_VEHICLE_NO_EXPLOSION_DAMAGE_FROM_DRIVER(vehicle, true)
    end

    -- 其它属性增强
    if vehicle_upgrade.other_strong then
        VEHICLE.SET_VEHICLE_WHEELS_CAN_BREAK(vehicle, false)

        VEHICLE.SET_VEHICLE_CAN_ENGINE_MISSFIRE(vehicle, false)
        VEHICLE.SET_VEHICLE_CAN_LEAK_OIL(vehicle, false)
        VEHICLE.SET_VEHICLE_CAN_LEAK_PETROL(vehicle, false)

        VEHICLE.SET_DISABLE_VEHICLE_ENGINE_FIRES(vehicle, true)
        VEHICLE.SET_DISABLE_VEHICLE_PETROL_TANK_FIRES(vehicle, true)
        VEHICLE.SET_DISABLE_VEHICLE_PETROL_TANK_DAMAGE(vehicle, true)

        VEHICLE.SET_VEHICLE_STRONG(vehicle, true)
        VEHICLE.SET_VEHICLE_HAS_STRONG_AXLES(vehicle, true)

        --Damage
        VEHICLE.VEHICLE_SET_RAMP_AND_RAMMING_CARS_TAKE_DAMAGE(vehicle, false)
        VEHICLE.SET_INCREASE_WHEEL_CRUSH_DAMAGE(vehicle, false)
        VEHICLE.SET_DISABLE_DAMAGE_WITH_PICKED_UP_ENTITY(vehicle, true)
        VEHICLE.SET_VEHICLE_USES_MP_PLAYER_DAMAGE_MULTIPLIER(vehicle, true)

        --Explode
        VEHICLE.SET_DISABLE_EXPLODE_FROM_BODY_DAMAGE_ON_COLLISION(vehicle, 1)
        VEHICLE.SET_VEHICLE_EXPLODES_ON_HIGH_EXPLOSION_DAMAGE(vehicle, false)
        VEHICLE.SET_VEHICLE_EXPLODES_ON_EXPLOSION_DAMAGE_AT_ZERO_BODY_HEALTH(vehicle, false)

        --Heli
        VEHICLE.SET_HELI_TAIL_BOOM_CAN_BREAK_OFF(vehicle, false)
        VEHICLE.SET_DISABLE_HELI_EXPLODE_FROM_BODY_DAMAGE(vehicle, true)

        --MP Only
        VEHICLE.SET_PLANE_RESIST_TO_EXPLOSION(vehicle, true)
        VEHICLE.SET_HELI_RESIST_TO_EXPLOSION(vehicle, true)

        --Remove Check
        VEHICLE.REMOVE_VEHICLE_UPSIDEDOWN_CHECK(vehicle)
        VEHICLE.REMOVE_VEHICLE_STUCK_CHECK(vehicle)
    end
end

menu.action(Vehicle_Upgrade_options, "升级强化载具", { "strong_veh" }, "升级强化当前或上一辆载具",
    function()
        local vehicle = entities.get_user_vehicle_as_handle()
        if ENTITY.IS_ENTITY_A_VEHICLE(vehicle) then
            vehicle_upgrade.upgrade(vehicle)
            util.toast("载具升级强化完成!")
        else
            util.toast("请先进入载具:)")
        end
    end)
menu.toggle_loop(Vehicle_Upgrade_options, "自动升级强化载具", { "auto_strong_veh" },
    "自动升级强化正在进入驾驶位的载具", function()
        local user_ped = players.user_ped()
        if PED.IS_PED_GETTING_INTO_A_VEHICLE(user_ped) then
            local veh = PED.GET_VEHICLE_PED_IS_TRYING_TO_ENTER(user_ped)
            if ENTITY.IS_ENTITY_A_VEHICLE(veh) and PED.GET_SEAT_PED_IS_TRYING_TO_ENTER(user_ped) == -1 then
                RequestControl(veh)
                vehicle_upgrade.upgrade(veh)

                -- 通知
                local veh_name = get_vehicle_display_name(veh)
                local text = "进入载具: " .. veh_name
                if hasControl(veh) then
                    THEFEED_POST.TEXT(text .. "\n升级强化完成!")
                else
                    THEFEED_POST.TEXT(text .. "\n升级强化未完成: 未能成功控制载具")
                end

                util.yield(50)
            end
        end
    end)

menu.divider(Vehicle_Upgrade_options, "载具性能")
menu.toggle(Vehicle_Upgrade_options, "主要性能", {}, "引擎、刹车、变速箱、防御", function(toggle)
    vehicle_upgrade.performance = toggle
end, true)
menu.toggle(Vehicle_Upgrade_options, "涡轮增压", {}, "", function(toggle)
    vehicle_upgrade.turbo = toggle
end, true)

menu.divider(Vehicle_Upgrade_options, "载具部件")
menu.toggle(Vehicle_Upgrade_options, "防弹轮胎", {}, "", function(toggle)
    vehicle_upgrade.bulletproof_tyre = toggle
end, true)
menu.toggle(Vehicle_Upgrade_options, "车门不可损坏", {}, "全部车门", function(toggle)
    vehicle_upgrade.unbreakable_door = toggle
end, true)
menu.toggle(Vehicle_Upgrade_options, "车灯不可损坏", {}, "", function(toggle)
    vehicle_upgrade.unbreakable_light = toggle
end, true)
menu.toggle(Vehicle_Upgrade_options, "部件不可分离", {}, "", function(toggle)
    vehicle_upgrade.unbreak = toggle
end, true)

menu.divider(Vehicle_Upgrade_options, "载具生命")
menu.slider(Vehicle_Upgrade_options, "血量加倍", {}, "", 1, 20, 1, 1, function(value)
    vehicle_upgrade.health_multiplier = value
end)
menu.toggle(Vehicle_Upgrade_options, "无视载具司机的爆炸", {}, "司机投掷的炸弹不会对载具造成伤害",
    function(toggle)
        vehicle_upgrade.no_driver_explosion_damage = toggle
    end, true)
menu.toggle(Vehicle_Upgrade_options, "其它属性增强", {}, "其它属性的提高,可以提高防炸性等",
    function(toggle)
        vehicle_upgrade.other_strong = toggle
    end, true)



---------------
--- 载具车窗 ---
---------------
local Vehicle_Window_options = menu.list(Vehicle_options, "载具车窗", {}, "")

local vehicle_window = {
    window_toggles = {},
    toggle_menus = {},
    window_list = {
        -- index, name
        { 0, "前左车窗" }, -- SC_WINDOW_FRONT_LEFT = 0
        { 1, "前右车窗" }, -- SC_WINDOW_FRONT_RIGHT = 1
        { 2, "后左车窗" }, -- SC_WINDOW_REAR_LEFT = 2
        { 3, "后右车窗" }, -- SC_WINDOW_REAR_RIGHT = 3
        { 4, "中间左车窗" }, -- SC_WINDOW_MIDDLE_LEFT = 4
        { 5, "中间右车窗" }, -- SC_WINDOW_MIDDLE_RIGHT = 5
        { 6, "前挡风车窗" }, -- SC_WINDSCREEN_FRONT = 6
        { 7, "后挡风车窗" }, -- SC_WINDSCREEN_REAR = 7
    },
}

local Vehicle_Window_Select = menu.list(Vehicle_Window_options, "选择车窗", {}, "")

menu.toggle(Vehicle_Window_Select, "全部开/关", {}, "", function(toggle)
    for key, value in pairs(vehicle_window.toggle_menus) do
        if menu.is_ref_valid(value) then
            menu.set_value(value, toggle)
        end
    end
end, true)

for _, data in pairs(vehicle_window.window_list) do
    local index = data[1]
    local name = data[2]

    vehicle_window.window_toggles[index] = true
    vehicle_window.toggle_menus[index] = menu.toggle(Vehicle_Window_Select, name, {}, "", function(toggle)
        vehicle_window.window_toggles[index] = toggle
    end, true)
end

menu.toggle_loop(Vehicle_Window_options, "修复车窗", { "fix_veh_window" }, "", function()
    local vehicle = entities.get_user_vehicle_as_handle()
    if vehicle ~= 0 then
        for index, toggle in pairs(vehicle_window.window_toggles) do
            if toggle then
                VEHICLE.FIX_VEHICLE_WINDOW(vehicle, index)
            end
        end
    end
end)
menu.toggle_loop(Vehicle_Window_options, "摇上车窗", { "roll_up_veh_window" }, "", function()
    local vehicle = entities.get_user_vehicle_as_handle()
    if vehicle ~= 0 then
        for index, toggle in pairs(vehicle_window.window_toggles) do
            if toggle then
                VEHICLE.ROLL_UP_WINDOW(vehicle, index)
            end
        end
    end
end)
menu.toggle_loop(Vehicle_Window_options, "摇下车窗", { "roll_down_veh_window" }, "", function()
    local vehicle = entities.get_user_vehicle_as_handle()
    if vehicle ~= 0 then
        for index, toggle in pairs(vehicle_window.window_toggles) do
            if toggle then
                VEHICLE.ROLL_DOWN_WINDOW(vehicle, index)
            end
        end
    end
end)
menu.toggle_loop(Vehicle_Window_options, "粉碎车窗", { "smash_veh_window" }, "", function()
    local vehicle = entities.get_user_vehicle_as_handle()
    if vehicle ~= 0 then
        for index, toggle in pairs(vehicle_window.window_toggles) do
            if toggle then
                VEHICLE.SMASH_VEHICLE_WINDOW(vehicle, index)
            end
        end
    end
end)


---------------
--- 载具车门 ---
---------------
local Vehicle_Door_options = menu.list(Vehicle_options, "载具车门", {}, "")

local vehicle_door = {
    door_toggles = {},
    toggle_menus = {},
    door_list = {
        -- index, name
        { 0, "左前门" }, -- VEH_EXT_DOOR_DSIDE_F = 0
        { 1, "右前门" }, -- VEH_EXT_DOOR_DSIDE_R = 1
        { 2, "左后门" }, -- VEH_EXT_DOOR_PSIDE_F = 2
        { 3, "右后门" }, -- VEH_EXT_DOOR_PSIDE_R = 3
        { 4, "引擎盖" }, -- VEH_EXT_BONNET = 4
        { 5, "后备箱" } -- VEH_EXT_BOOT = 5
    },
}

local Vehicle_Door_Select = menu.list(Vehicle_Door_options, "选择车门", {}, "")

menu.toggle(Vehicle_Door_Select, "全部开/关", {}, "", function(toggle)
    for key, value in pairs(vehicle_door.toggle_menus) do
        if menu.is_ref_valid(value) then
            menu.set_value(value, toggle)
        end
    end
end, true)

for _, data in pairs(vehicle_door.door_list) do
    local index = data[1]
    local name = data[2]

    vehicle_door.door_toggles[index] = true
    vehicle_door.toggle_menus[index] = menu.toggle(Vehicle_Door_Select, name, {}, "", function(toggle)
        vehicle_door.door_toggles[index] = toggle
    end, true)
end

menu.toggle_loop(Vehicle_Door_options, "打开车门", { "open_veh_door" }, "", function()
    local vehicle = entities.get_user_vehicle_as_handle()
    if vehicle ~= 0 then
        for index, toggle in pairs(vehicle_door.door_toggles) do
            if toggle then
                VEHICLE.SET_VEHICLE_DOOR_OPEN(vehicle, index, false, false)
            end
        end
    end
end)
menu.action(Vehicle_Door_options, "关闭车门", { "close_veh_door" }, "", function()
    local vehicle = entities.get_user_vehicle_as_handle()
    if vehicle ~= 0 then
        for index, toggle in pairs(vehicle_door.door_toggles) do
            if toggle then
                VEHICLE.SET_VEHICLE_DOOR_SHUT(vehicle, index, false)
            end
        end
    end
end)
menu.toggle_loop(Vehicle_Door_options, "破坏车门", { "broken_veh_door" }, "", function()
    local vehicle = entities.get_user_vehicle_as_handle()
    if vehicle ~= 0 then
        for index, toggle in pairs(vehicle_door.door_toggles) do
            if toggle then
                VEHICLE.SET_VEHICLE_DOOR_BROKEN(vehicle, index, false)
            end
        end
    end
end)
menu.toggle_loop(Vehicle_Door_options, "删除车门", { "delete_veh_door" }, "", function()
    local vehicle = entities.get_user_vehicle_as_handle()
    if vehicle ~= 0 then
        for index, toggle in pairs(vehicle_door.door_toggles) do
            if toggle then
                VEHICLE.SET_VEHICLE_DOOR_BROKEN(vehicle, index, true)
            end
        end
    end
end)


---------------
--- 载具锁门 ---
---------------
local Vehicle_DoorLock_options = menu.list(Vehicle_options, "载具锁门", {}, "")

local VehicleDoorsLock_ListItem = {
    { "解锁" },                                 --VEHICLELOCK_UNLOCKED == 1
    { "上锁" },                                 --VEHICLELOCK_LOCKED
    { "LOCKOUT PLAYER ONLY",     {}, "只对玩家锁门？" }, --VEHICLELOCK_LOCKOUT_PLAYER_ONLY
    { "玩家锁定在里面" },                  --VEHICLELOCK_LOCKED_PLAYER_INSIDE
    { "LOCKED INITIALLY" },                       --VEHICLELOCK_LOCKED_INITIALLY
    { "强制关闭车门" },                     --VEHICLELOCK_FORCE_SHUT_DOORS
    { "上锁但可被破坏",   {}, "可以破开车窗开门" }, --VEHICLELOCK_LOCKED_BUT_CAN_BE_DAMAGED
    { "上锁但后备箱解锁" },               --VEHICLELOCK_LOCKED_BUT_BOOT_UNLOCKED
    { "上锁无乘客" },                        --VEHICLELOCK_LOCKED_NO_PASSENGERS
    { "不能进入",            {}, "按F无上车动作" } --VEHICLELOCK_CANNOT_ENTER
}
local vehicle_door_lock_select = 1                --选择的锁门类型
menu.list_select(Vehicle_DoorLock_options, "锁门类型", {}, "", VehicleDoorsLock_ListItem, 1, function(value)
    vehicle_door_lock_select = value
end)

menu.action(Vehicle_DoorLock_options, "设置载具锁门", {}, "", function()
    local vehicle = entities.get_user_vehicle_as_handle()
    if vehicle ~= 0 then
        VEHICLE.SET_VEHICLE_DOORS_LOCKED(vehicle, vehicle_door_lock_select)
    end
end)

menu.toggle(Vehicle_DoorLock_options, "对所有玩家锁门", {}, "", function(toggle)
    local vehicle = entities.get_user_vehicle_as_handle()
    if vehicle ~= 0 then
        VEHICLE.SET_VEHICLE_DOORS_LOCKED_FOR_ALL_PLAYERS(vehicle, toggle)
    end
end)
menu.toggle(Vehicle_DoorLock_options, "对所有团队锁门", {}, "", function(toggle)
    local vehicle = entities.get_user_vehicle_as_handle()
    if vehicle ~= 0 then
        VEHICLE.SET_VEHICLE_DOORS_LOCKED_FOR_ALL_TEAMS(vehicle, toggle)
    end
end)


---------------
--- 载具电台 ---
---------------
local Vehicle_Radio_options = menu.list(Vehicle_options, "载具电台", {}, "")

local vehicle_radio_station_select = 1
menu.list_select(Vehicle_Radio_options, "选择电台", {}, "", Vehicle_RadioStation.ListItem, 1, function(value)
    vehicle_radio_station_select = value
end)
menu.toggle_loop(Vehicle_Radio_options, "自动更改电台", { "auto_veh_radio" }, "自动更改正在进入驾驶位的载具的电台",
    function()
        if PED.IS_PED_GETTING_INTO_A_VEHICLE(players.user_ped()) then
            local veh = PED.GET_VEHICLE_PED_IS_ENTERING(players.user_ped())
            if ENTITY.IS_ENTITY_A_VEHICLE(veh) and PED.GET_SEAT_PED_IS_TRYING_TO_ENTER(players.user_ped()) == -1 then
                local stationName = Vehicle_RadioStation.LabelList[vehicle_radio_station_select]
                AUDIO.SET_VEH_RADIO_STATION(veh, stationName)
            end
        end
    end)
menu.toggle(Vehicle_Radio_options, "关闭电台", { "close_veh_radio" }, "当前或上一辆载具将无法选择更改电台",
    function(toggle)
        local vehicle = entities.get_user_vehicle_as_handle()
        if vehicle ~= 0 then
            AUDIO.SET_VEHICLE_RADIO_ENABLED(vehicle, not toggle)
        end
    end)


---------------
--- 载具武器 ---
---------------
local Vehicle_Weapon_options = menu.list(Vehicle_options, "载具武器", {}, "")

local veh_weapon_data = {
    delay = 100,
    direction = {
        [1] = true,  -- front
        [2] = false, -- rear
        [3] = false, -- left
        [4] = false, -- right
        [5] = false, -- up
        [6] = false, -- down
    },
    weapon_select = 1,
    weapon_hash = "PLAYER_WEAPON",
    vehicle_weapon_hash = "VEHICLE_WEAPON",
    is_owned = false,
    damage = 1000,
    speed = 1000,
    CreateTraceVfx = true,
    AllowRumble = true,
    PerfectAccuracy = false,
    start_offset = {
        -- front
        [1] = { x = 0.0, y = 1.0, z = 0.0 },
        -- rear
        [2] = { x = 0.0, y = -1.0, z = 0.0 },
        -- left
        [3] = { x = -1.0, y = 0.0, z = 0.0 },
        -- right
        [4] = { x = 1.0, y = 0.0, z = 0.0 },
        -- up
        [5] = { x = 0.0, y = 0.0, z = 2.5 },
        -- down
        [6] = { x = 0.0, y = 0.0, z = -2.5 },
    }
}

local function get_middle_num(a, b)
    local min = math.min(a, b)
    local max = math.max(a, b)
    local middle = min + (max - min) * 0.5
    return middle
end

local function Vehicle_Weapon_Shoot(vehicle, direction, state)
    local weaponHash = veh_weapon_data.weapon_hash
    if veh_weapon_data.weapon_select == 2 then
        weaponHash = veh_weapon_data.vehicle_weapon_hash
    end

    if weaponHash == "PLAYER_WEAPON" then
        local pWeapon = memory.alloc_int()
        WEAPON.GET_CURRENT_PED_WEAPON(user_ped, pWeapon, true)
        weaponHash = memory.read_int(pWeapon)
    elseif weaponHash == "VEHICLE_WEAPON" then
        local pWeapon = memory.alloc_int()
        WEAPON.GET_CURRENT_PED_VEHICLE_WEAPON(user_ped, pWeapon)
        weaponHash = memory.read_int(pWeapon)
    end
    if not WEAPON.HAS_WEAPON_ASSET_LOADED(weaponHash) then
        request_weapon_asset(weaponHash)
    end

    local owner = 0
    if veh_weapon_data.is_owned then
        owner = players.user_ped()
    end

    local min, max = v3.new(), v3.new()
    MISC.GET_MODEL_DIMENSIONS(ENTITY.GET_ENTITY_MODEL(vehicle), min, max)

    local offset_z = get_middle_num(min.z, max.z)
    local offsets = {}
    local start_offset, end_offset

    if direction == 1 then
        offsets[1] = v3.new(min.x, max.y, offset_z)
        offsets[2] = v3.new(get_middle_num(min.x, max.x), max.y, offset_z)
        offsets[3] = v3.new(max.x, max.y, offset_z)
        -- front
        end_offset = v3.new(0.0, 1.0, 0.0)
    elseif direction == 2 then
        offsets[1] = v3.new(min.x, min.y, offset_z)
        offsets[2] = v3.new(get_middle_num(min.x, max.x), min.y, offset_z)
        offsets[3] = v3.new(max.x, min.y, offset_z)
        -- rear
        end_offset = v3.new(0.0, -1.0, 0.0)
    elseif direction == 3 then
        offsets[1] = v3.new(min.x, max.y, offset_z)
        offsets[2] = v3.new(min.x, get_middle_num(min.y, max.y), offset_z)
        offsets[3] = v3.new(min.x, min.y, offset_z)
        -- left
        end_offset = v3.new(-1.0, 0.0, 0.0)
    elseif direction == 4 then
        offsets[1] = v3.new(max.x, max.y, offset_z)
        offsets[2] = v3.new(max.x, get_middle_num(min.y, max.y), offset_z)
        offsets[3] = v3.new(max.x, min.y, offset_z)
        -- right
        end_offset = v3.new(1.0, 0.0, 0.0)
    elseif direction == 5 then
        offsets[1] = v3.new(get_middle_num(min.x, max.x), max.y, offset_z)
        offsets[2] = v3.new(get_middle_num(min.x, max.x), get_middle_num(min.y, max.y), offset_z)
        offsets[3] = v3.new(get_middle_num(min.x, max.x), min.y, offset_z)
        -- up
        end_offset = v3.new(0.0, 0.0, 1.0)
    elseif direction == 6 then
        offsets[1] = v3.new(get_middle_num(min.x, max.x), max.y, offset_z)
        offsets[2] = v3.new(get_middle_num(min.x, max.x), get_middle_num(min.y, max.y), offset_z)
        offsets[3] = v3.new(get_middle_num(min.x, max.x), min.y, offset_z)
        -- down
        end_offset = v3.new(0.0, 0.0, -1.0)
    end

    start_offset = v3.new(veh_weapon_data.start_offset[direction])
    end_offset:mul(500.0)

    local start_pos, end_pos
    for k, offset in pairs(offsets) do
        offset:add(start_offset)
        start_pos = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(vehicle, offset.x, offset.y, offset.z)

        offset:add(end_offset)
        end_pos = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(vehicle, offset.x, offset.y, offset.z)

        if state == "draw_line" then
            DRAW_LINE(start_pos, end_pos)
        elseif state == "shoot" then
            MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS_IGNORE_ENTITY(start_pos.x, start_pos.y, start_pos.z,
                end_pos.x, end_pos.y, end_pos.z,
                veh_weapon_data.damage, veh_weapon_data.PerfectAccuracy, weaponHash, owner,
                veh_weapon_data.CreateTraceVfx, veh_weapon_data.AllowRumble, veh_weapon_data.speed,
                vehicle)
        end
    end
end

menu.toggle_loop(Vehicle_Weapon_options, "开启[按住E键]", { "veh_weapon" }, "", function()
    if PED.IS_PED_IN_ANY_VEHICLE(players.user_ped(), false) and PAD.IS_CONTROL_PRESSED(0, 51) then
        local vehicle = PED.GET_VEHICLE_PED_IS_IN(players.user_ped(), false)
        if vehicle ~= 0 then
            for k, v in pairs(veh_weapon_data.direction) do
                if v then
                    Vehicle_Weapon_Shoot(vehicle, k, "shoot")
                end
            end
            util.yield(veh_weapon_data.delay)
        end
    end
end)

menu.toggle_loop(Vehicle_Weapon_options, "绘制射击连线", {}, "", function()
    local vehicle = GET_VEHICLE_PED_IS_IN(players.user_ped())
    if vehicle ~= 0 then
        for k, v in pairs(veh_weapon_data.direction) do
            if v then
                Vehicle_Weapon_Shoot(vehicle, k, "draw_line")
            end
        end
    end
end)
menu.divider(Vehicle_Weapon_options, "设置")
menu.slider(Vehicle_Weapon_options, "循环延迟", { "veh_weapon_delay" }, "单位: ms", 0, 5000, 100, 10,
    function(value)
        veh_weapon_data.delay = value
    end)

local Vehicle_Weapon_direction = menu.list(Vehicle_Weapon_options, "方向", {}, "")
for k, v in pairs({ "前", "后", "左", "右", "上", "下" }) do
    menu.toggle(Vehicle_Weapon_direction, v, {}, "", function(toggle)
        veh_weapon_data.direction[k] = toggle
    end, veh_weapon_data.direction[k])
end

local Vehicle_Weapon_select = menu.list(Vehicle_Weapon_options, "武器", {}, "")
menu.list_select(Vehicle_Weapon_select, "武器类型", {}, "", { { "手持武器" }, { "载具武器" } }, 1,
    function(value)
        veh_weapon_data.weapon_select = value
    end)
menu.list_select(Vehicle_Weapon_select, "手持武器", {}, "", AllWeapons_NoMelee_ListItem, 1, function(value)
    veh_weapon_data.weapon_hash = AllWeapons_NoMelee_ListItem[value][3]
end)
menu.list_select(Vehicle_Weapon_select, "载具武器", {}, "", All_VehicleWeapons_ListItem, 1, function(value)
    veh_weapon_data.vehicle_weapon_hash = All_VehicleWeapons_ListItem[value][3]
end)

menu.toggle(Vehicle_Weapon_options, "署名射击", {}, "以玩家名义", function(toggle)
    veh_weapon_data.is_owned = toggle
end)
menu.slider(Vehicle_Weapon_options, "伤害", { "veh_weapon_damage" }, "", 0, 10000, 1000, 100,
    function(value)
        veh_weapon_data.damage = value
    end)
menu.slider(Vehicle_Weapon_options, "速度", { "veh_weapon_speed" }, "", 0, 10000, 1000, 100,
    function(value)
        veh_weapon_data.speed = value
    end)
menu.toggle(Vehicle_Weapon_options, "Create Trace Vfx", {}, "", function(toggle)
    veh_weapon_data.CreateTraceVfx = toggle
end, true)
menu.toggle(Vehicle_Weapon_options, "Allow Rumble", {}, "", function(toggle)
    veh_weapon_data.AllowRumble = toggle
end, true)
menu.toggle(Vehicle_Weapon_options, "Perfect Accuracy", {}, "", function(toggle)
    veh_weapon_data.PerfectAccuracy = toggle
end)
local Vehicle_Weapon_startOffset = menu.list(Vehicle_Weapon_options, "起始射击位置偏移", {}, "")
for k, v in pairs({ "前", "后", "左", "右", "上", "下" }) do
    local menu_list = menu.list(Vehicle_Weapon_startOffset, v, {}, "")

    menu.slider_float(menu_list, "X", { "veh_weapon_dir" .. k .. "_x" }, "", -10000, 10000,
        veh_weapon_data.start_offset[k].x * 100, 10,
        function(value)
            value = value * 0.01
            veh_weapon_data.start_offset[k].x = value
        end)
    menu.slider_float(menu_list, "Y", { "veh_weapon_dir" .. k .. "_y" }, "", -10000, 10000,
        veh_weapon_data.start_offset[k].y * 100, 10,
        function(value)
            value = value * 0.01
            veh_weapon_data.start_offset[k].y = value
        end)
    menu.slider_float(menu_list, "Z", { "veh_weapon_dir" .. k .. "_z" }, "", -10000, 10000,
        veh_weapon_data.start_offset[k].z * 100, 10,
        function(value)
            value = value * 0.01
            veh_weapon_data.start_offset[k].z = value
        end)
end


---------------
--- 个人载具 ---
---------------
local Vehicle_Personal_options = menu.list(Vehicle_options, "个人载具", {}, "")

menu.action(Vehicle_Personal_options, "开启载具引擎", { "veh_engine_on" },
    "个人载具和上一辆载具", function()
        local vehicle = entities.get_user_personal_vehicle_as_handle()
        if vehicle ~= 0 then
            VEHICLE.SET_VEHICLE_ENGINE_ON(vehicle, true, true, false)
        end

        local last_vehicle = entities.get_user_vehicle_as_handle()
        if last_vehicle ~= 0 and last_vehicle ~= vehicle then
            VEHICLE.SET_VEHICLE_ENGINE_ON(last_vehicle, true, true, false)
        end
    end)
menu.action(Vehicle_Personal_options, "打开引擎和左车门", {}, "", function()
    local vehicle = entities.get_user_personal_vehicle_as_handle()
    if vehicle ~= 0 then
        VEHICLE.SET_VEHICLE_ENGINE_ON(vehicle, true, true, false)
        VEHICLE.SET_VEHICLE_DOOR_OPEN(vehicle, 0, false, false)
    end
end)
menu.action(Vehicle_Personal_options, "打开左车门", {}, "", function()
    local vehicle = entities.get_user_personal_vehicle_as_handle()
    if vehicle ~= 0 then
        VEHICLE.SET_VEHICLE_DOOR_OPEN(vehicle, 0, false, false)
    end
end)
menu.action(Vehicle_Personal_options, "打开左右车门", {}, "", function()
    local vehicle = entities.get_user_personal_vehicle_as_handle()
    if vehicle ~= 0 then
        VEHICLE.SET_VEHICLE_DOOR_OPEN(vehicle, 0, false, false)
        VEHICLE.SET_VEHICLE_DOOR_OPEN(vehicle, 1, false, false)
    end
end)
menu.list_action(Vehicle_Personal_options, "传送到附近", { "veh_tp_near" }, "会传送在路边等位置", {
    { "上一辆载具", { "last" } },
    { "个人载具",    { "personal" } }
}, function(value)
    local vehicle = 0
    if not PED.IS_PED_IN_ANY_VEHICLE(players.user_ped(), false) then
        vehicle = PED.GET_VEHICLE_PED_IS_IN(players.user_ped(), true)
    end
    if value == 2 then
        vehicle = entities.get_user_personal_vehicle_as_handle()
    end
    if vehicle ~= 0 then
        local pos = ENTITY.GET_ENTITY_COORDS(players.user_ped())
        local bool, coords, heading = get_closest_vehicle_node(pos, 0)
        if bool then
            SET_ENTITY_COORDS(vehicle, coords)
            ENTITY.SET_ENTITY_HEADING(vehicle, heading)
            fix_vehicle(vehicle)
            VEHICLE.SET_VEHICLE_ON_GROUND_PROPERLY(vehicle, 5.0)
            VEHICLE.SET_VEHICLE_ENGINE_ON(vehicle, true, true, false)
            --show blip
            SHOW_BLIP_TIMER(vehicle, 225, 27, 5000)
        else
            util.toast("未找到合适位置")
        end
    end
end)
menu.toggle(Vehicle_Personal_options, "锁门", { "veh_lock" }, "", function(toggle)
    local vehicle = entities.get_user_personal_vehicle_as_handle()
    if vehicle ~= 0 then
        VEHICLE.SET_VEHICLE_DOORS_LOCKED_FOR_ALL_PLAYERS(vehicle, toggle)
        if toggle then
            VEHICLE.SET_VEHICLE_DOORS_LOCKED(vehicle, 2)
            util.toast("个人载具: 已上锁")
        else
            VEHICLE.SET_VEHICLE_DOORS_LOCKED(vehicle, 1)
            util.toast("个人载具: 已解锁")
        end
    end
end)


------------------
--- 载具水下行为 ---
------------------
local Vehicle_Water_options = menu.list(Vehicle_options, "载具水下行为", {}, "")

local vehicle_water = {
    water_height = memory.alloc(4),
    dow_block = 0,

    height_diff = 1.0,
    tp_height = 5.0,
    spawn_block = true,
}

menu.toggle_loop(Vehicle_Water_options, "传送到水面上", {}, "", function()
    if vehicle_water.spawn_block and not ENTITY.DOES_ENTITY_EXIST(vehicle_water.dow_block) then
        local hash = util.joaat("stt_prop_stunt_bblock_mdm3")
        vehicle_water.dow_block = create_object(hash, v3(0, 0, 0), false, false)
        -- ENTITY.SET_ENTITY_VISIBLE(vehicle_water.dow_block, false, 0)
    end

    local vehicle = entities.get_user_vehicle_as_handle()
    if vehicle ~= 0 then
        local coords = ENTITY.GET_ENTITY_COORDS(vehicle)
        if WATER.GET_WATER_HEIGHT(coords.x, coords.y, coords.z, vehicle_water.water_height) then
            local water_height_z = memory.read_float(vehicle_water.water_height)
            if water_height_z - coords.z > vehicle_water.height_diff then
                coords.z = water_height_z

                if vehicle_water.spawn_block and VEHICLE.GET_VEHICLE_CLASS(vehicle) ~= 14 then -- ignore boat
                    SET_ENTITY_COORDS(vehicle_water.dow_block, coords)
                    ENTITY.SET_ENTITY_HEADING(vehicle_water.dow_block, ENTITY.GET_ENTITY_HEADING(vehicle))
                end

                coords.z = coords.z + vehicle_water.tp_height
                SET_ENTITY_COORDS(vehicle, coords)
            end
        end
    else
        SET_ENTITY_COORDS(vehicle_water.dow_block, v3(0, 0, 0))
    end
end, function()
    if ENTITY.DOES_ENTITY_EXIST(vehicle_water.dow_block) then
        entities.delete_by_handle(vehicle_water.dow_block)
        vehicle_water.dow_block = 0
    end
end)

menu.divider(Vehicle_Water_options, "设置")
menu.slider_float(Vehicle_Water_options, "水面高度差", {}, "水下到水面的高度距离", 0, 2000, 100, 10,
    function(value)
        vehicle_water.height_diff = value * 0.01
    end)
menu.slider_float(Vehicle_Water_options, "传送的高度", {}, "", 0, 2000, 500, 50, function(value)
    vehicle_water.tp_height = value * 0.01
end)
menu.toggle(Vehicle_Water_options, "在水面生成平台", {}, "载具为船时不生成平台", function(toggle)
    vehicle_water.spawn_block = toggle
end, true)


------------------
--- 载具信息显示 ---
------------------
local Vehicle_Info_options = menu.list(Vehicle_options, "载具信息显示", {}, "")

local vehicle_info = {
    -- show setting --
    only_current_vehicle = true,
    x = 0.26,
    y = 0.80,
    scale = 0.65,
    color = Colors.white,
    -- show info --
    vehicle_name = true,
    entity_health = true,
    engine_health = false,
    petrol_tank_health = false,
    body_health = false,
}

menu.toggle_loop(Vehicle_Info_options, "开启", {}, "", function()
    if vehicle_info.only_current_vehicle and not PED.IS_PED_IN_ANY_VEHICLE(players.user_ped(), false) then
    else
        local veh = entities.get_user_vehicle_as_handle()
        if veh ~= 0 then
            local text = ""

            if vehicle_info.vehicle_name then
                text = text .. get_vehicle_display_name(veh) .. "\n"
            end
            if vehicle_info.entity_health then
                text = text .. "实体血量: " ..
                    ENTITY.GET_ENTITY_HEALTH(veh) .. "/" .. ENTITY.GET_ENTITY_MAX_HEALTH(veh) .. "\n"
            end
            if vehicle_info.engine_health then
                text = text .. "引擎血量: " .. math.ceil(VEHICLE.GET_VEHICLE_ENGINE_HEALTH(veh)) .. "\n"
            end
            if vehicle_info.petrol_tank_health then
                text = text .. "油箱血量: " .. math.ceil(VEHICLE.GET_VEHICLE_PETROL_TANK_HEALTH(veh)) .. "\n"
            end
            if vehicle_info.body_health then
                text = text .. "车身外观血量: " .. math.ceil(VEHICLE.GET_VEHICLE_BODY_HEALTH(veh)) .. "\n"
            end

            directx.draw_text(vehicle_info.x, vehicle_info.y, text, ALIGN_TOP_LEFT, vehicle_info.scale,
                vehicle_info.color)
        end
    end
end)

local Vehicle_Info_Show_Setting = menu.list(Vehicle_Info_options, "显示设置", {}, "")
menu.toggle(Vehicle_Info_Show_Setting, "只显示当前载具信息", {}, "", function(toggle)
    vehicle_info.only_current_vehicle = toggle
end, true)
menu.slider_float(Vehicle_Info_Show_Setting, "位置X", { "vehicle_info_x" }, "", 0, 100, 26, 1, function(value)
    vehicle_info.x = value * 0.01
end)
menu.slider_float(Vehicle_Info_Show_Setting, "位置Y", { "vehicle_info_y" }, "", 0, 100, 80, 1, function(value)
    vehicle_info.y = value * 0.01
end)
menu.slider_float(Vehicle_Info_Show_Setting, "文字大小", { "vehicle_info_scale" }, "",
    0, 1000, 65, 1, function(value)
        vehicle_info.scale = value * 0.01
    end)

menu.divider(Vehicle_Info_options, "显示的信息")
menu.toggle(Vehicle_Info_options, "载具名称", {}, "", function(toggle)
    vehicle_info.vehicle_name = toggle
end, true)
menu.toggle(Vehicle_Info_options, "实体血量", {}, "", function(toggle)
    vehicle_info.entity_health = toggle
end, true)
menu.toggle(Vehicle_Info_options, "引擎血量", {}, "", function(toggle)
    vehicle_info.engine_health = toggle
end)
menu.toggle(Vehicle_Info_options, "油箱血量", {}, "", function(toggle)
    vehicle_info.petrol_tank_health = toggle
end)
menu.toggle(Vehicle_Info_options, "车身外观血量", {}, "", function(toggle)
    vehicle_info.body_health = toggle
end)




----------------
menu.list_select(Vehicle_options, "设置车灯状态", {}, "", {
    { "正常" },           -- 0
    { "强制关灯", {}, "总是关灯" }, -- 1
    { "强制开灯", {}, "总是开灯" }, -- 2
    { "开灯" },           -- 3
    { "关灯" },           -- 4
}, 1, function(value)
    local vehicle = entities.get_user_vehicle_as_handle()
    if vehicle ~= 0 then
        VEHICLE.SET_VEHICLE_LIGHTS(vehicle, value - 1)
    end
end)
local veh_dirt_level = 0.0
menu.click_slider_float(Vehicle_options, "载具灰尘程度", { "veh_dirt_level" }, "载具全身灰尘程度",
    0, 1500, 0, 100, function(value)
        veh_dirt_level = value * 0.01
        local vehicle = entities.get_user_vehicle_as_handle()
        if vehicle ~= 0 then
            if VEHICLE.GET_VEHICLE_DIRT_LEVEL(vehicle) ~= veh_dirt_level then
                VEHICLE.SET_VEHICLE_DIRT_LEVEL(vehicle, veh_dirt_level)
            end
        end
    end)
menu.toggle_loop(Vehicle_options, "锁定载具灰尘程度", {}, "", function()
    local vehicle = entities.get_user_vehicle_as_handle()
    if vehicle ~= 0 then
        if VEHICLE.GET_VEHICLE_DIRT_LEVEL(vehicle) ~= veh_dirt_level then
            VEHICLE.SET_VEHICLE_DIRT_LEVEL(vehicle, veh_dirt_level)
        end
    end
end)
menu.toggle_loop(Vehicle_options, "自动开启载具引擎", {}, "自动开启正在进入驾驶位的载具的引擎",
    function()
        if PED.IS_PED_GETTING_INTO_A_VEHICLE(players.user_ped()) then
            local veh = PED.GET_VEHICLE_PED_IS_ENTERING(players.user_ped())
            if ENTITY.IS_ENTITY_A_VEHICLE(veh) and PED.GET_SEAT_PED_IS_TRYING_TO_ENTER(players.user_ped()) == -1 then
                VEHICLE.SET_VEHICLE_ENGINE_HEALTH(veh, 1000)
                VEHICLE.SET_VEHICLE_ENGINE_ON(veh, true, true, true)
            end
        end
    end)
menu.toggle_loop(Vehicle_options, "自动解锁载具车门", {}, "自动解锁正在进入的载具的车门",
    function()
        local vehicle = 0
        if PED.IS_PED_IN_ANY_VEHICLE(players.user_ped(), false) then
            vehicle = PED.GET_VEHICLE_PED_IS_IN(players.user_ped(), false)
        else
            vehicle = PED.GET_VEHICLE_PED_IS_TRYING_TO_ENTER(players.user_ped())
        end

        if vehicle ~= 0 then
            if RequestControl(vehicle) then
                unlock_vehicle_doors(vehicle)
                VEHICLE.SET_VEHICLE_IS_CONSIDERED_BY_PLAYER(vehicle, true)
                VEHICLE.SET_VEHICLE_UNDRIVEABLE(vehicle, false)
                ENTITY.FREEZE_ENTITY_POSITION(vehicle, false)
            else
                util.toast("请求控制失败，请重试")
            end
        end
    end)
menu.toggle_loop(Vehicle_options, "禁用载具喇叭", {}, "", function()
    local vehicle = entities.get_user_vehicle_as_handle()
    if vehicle ~= 0 then
        AUDIO.SET_HORN_ENABLED(vehicle, false)
    end
end, function()
    local vehicle = entities.get_user_vehicle_as_handle()
    if vehicle ~= 0 then
        AUDIO.SET_HORN_ENABLED(vehicle, true)
    end
end)

--#endregion  Vehicle Options





--#region Entity Options

-----------------------------------
------------ 世界实体选项 -----------
-----------------------------------
require "RScript.Menu.Entity"

--#endregion Entity Options





--#region Online Options

----------------------------------
------------- 线上选项 ------------
----------------------------------
require "RScript.Menu.Online"

--#endregion Online Options





--#region Mission Options

--------------------------------
------------ 任务选项 -----------
--------------------------------
require "RScript.Menu.Mission"

--#endregion Mission Options





--#region Session Options

--------------------------------
------------ 战局选项 ------------
--------------------------------
local Session_options = menu.list(menu.my_root(), "战局选项", {}, "")

----------------
-- 阻挡区域
----------------
local BlockArea_options = menu.list(Session_options, "阻挡区域", {}, "")

local block_area_data = {
    area_ListItem = {
        { "改车王" },
        { "武器店" },
        { "带靶场的武器店" },
        { "理发店" },
        { "服装店" },
        { "纹身店" },
        { "商店" },
    },
    object_ListItem = {
        { "UFO" },
    },
    object_ListData = {
        -- hash, type
        { 1241740398, "object" },
    },
    setting = {
        area = 1,
        obj = 1,
        visible = true,
        freeze = true,
        no_collision = false,
    },
}

local block_area_AreaData = {
    -- { x, y, z }
    {
        -- radar_car_mod_shop 72
        { 1174.7074,  2644.4497,  36.7552 },
        { 113.2615,   6624.2803,  30.7871 },
        { -354.5272,  -135.4011,  38.1850 },
        { 724.5240,   -1089.0811, 21.1692 },
        { -1147.3138, -1992.4344, 12.1803 },
    },
    {
        -- radar_gun_shop 110
        { 1697.9788,  3753.2002,  33.7053 },
        { -1111.2375, 2688.4626,  17.6131 },
        { 2569.6116,  302.5760,   107.7349 },
        { -325.8904,  6077.0264,  30.4548 },
        { 245.2711,   -45.8126,   68.9410 },
        { 844.1248,   -1025.5707, 27.1948 },
        { -1313.9485, -390.9637,  35.5920 },
        { -664.2178,  -943.3646,  20.8292 },
        { -3165.2307, 1082.8551,  19.8438 },
    },
    {
        -- radar_shootingrange_gunshop 313
        { 17.6804,  -1114.2880, 28.7970 },
        { 811.8699, -2149.1016, 28.6363 },
    },
    {
        -- radar_barber 71
        { 1933.1191,  3726.0791,  31.8444 },
        { -280.8165,  6231.7705,  30.6955 },
        { 1208.3335,  -470.9170,  65.2080 },
        { -30.7448,   -148.4921,  56.0765 },
        { -821.9946,  -187.1776,  36.5689 },
        { 133.5702,   -1710.9180, 28.2916 },
        { -1287.0822, -1116.5576, 5.9901 },
    },
    {
        -- radar_clothes_store 73
        { 80.6650,    -1391.6694, 28.3761 },
        { 419.5310,   -807.5787,  28.4896 },
        { -818.6218,  -1077.5330, 10.3282 },
        { -158.2199,  -304.9663,  38.7350 },
        { 126.6853,   -212.5027,  53.5578 },
        { -715.3598,  -155.7742,  36.4105 },
        { -1199.8092, -776.6886,  16.3237 },
        { -1455.0045, -233.1862,  48.7936 },
        { -3168.9663, 1055.2869,  19.8632 },
        { 618.1857,   2752.5667,  41.0881 },
        { -1094.0487, 2704.1707,  18.0873 },
        { 1197.9722,  2704.2205,  37.1572 },
        { 1687.8812,  4820.5498,  41.0096 },
        { -0.2361,    6516.0454,  30.8684 },
    },
    {
        -- radar_tattoo 75
        { -1153.9481, -1425.0186, 3.9544 },
        { 321.6098,   179.4165,   102.5865 },
        { 1322.4547,  -1651.1252, 51.1885 },
        { -3169.4204, 1074.7272,  19.8343 },
        { 1861.6853,  3750.0798,  32.0318 },
        { -290.1603,  6199.0947,  30.4871 },
    },
    {
        -- radar_crim_holdups 52
        { 1965.0542,  3740.5552,  31.3448 },
        { 1394.1692,  3599.8601,  34.0121 },
        { 2682.0034,  3282.5432,  54.2411 },
        { 1698.8085,  4929.1978,  41.0783 },
        { 1166.3920,  2703.5042,  37.1573 },
        { 544.2802,   2672.8113,  41.1566 },
        { 1731.2098,  6411.4033,  34.0372 },
        { 2559.2471,  385.5266,   107.6230 },
        { 376.6533,   323.6471,   102.5664 },
        { 1159.5421,  -326.6986,  67.9230 },
        { 1141.3596,  -980.8802,  45.4155 },
        { -1822.2866, 788.0060,   137.1859 },
        { -711.7210,  -916.6965,  18.2145 },
        { -1491.0565, -383.5728,  39.1706 },
        { 29.0641,    -1349.2128, 28.5036 },
        { -1226.4644, -902.5864,  11.2783 },
        { -53.1240,   -1756.4054, 28.4210 },
        { -3240.3169, 1004.4334,  11.8307 },
        { -3038.9082, 589.5187,   6.9048 },
        { -2973.2617, 390.8184,   14.0433 },
    }
}

menu.list_select(BlockArea_options, "选择区域", {}, "", block_area_data.area_ListItem, 1, function(value)
    block_area_data.setting.area = value
end)
menu.action(BlockArea_options, "阻挡", {}, "", function()
    local count = 0
    local hash = block_area_data.object_ListData[block_area_data.setting.obj][1]
    local Type = block_area_data.object_ListData[block_area_data.setting.obj][2]
    local ent = 0
    local area = block_area_AreaData[block_area_data.setting.area]

    request_model(hash)
    for k, pos in pairs(area) do
        if Type == "object" then
            ent = entities.create_object(hash, v3.new(pos[1], pos[2], pos[3] + 1.0))
        end

        if ENTITY.DOES_ENTITY_EXIST(ent) then
            ENTITY.FREEZE_ENTITY_POSITION(ent, block_area_data.setting.freeze)
            ENTITY.SET_ENTITY_VISIBLE(ent, block_area_data.setting.visible, 0)
            ENTITY.SET_ENTITY_AS_MISSION_ENTITY(ent, true, false)
            ENTITY.SET_ENTITY_INVINCIBLE(ent, true)
            set_entity_networked(ent, false)

            if block_area_data.setting.no_collision then
                ENTITY.SET_ENTITY_NO_COLLISION_ENTITY(ent, players.user_ped(), false)
                ENTITY.SET_ENTITY_NO_COLLISION_ENTITY(players.user_ped(), ent, false)
            end

            count = count + 1
        end
    end

    STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(hash)
    util.toast("阻挡完成！\n阻挡区域: " .. count .. " 个")
end)

-----
menu.divider(BlockArea_options, "设置")
menu.list_select(BlockArea_options, "阻挡物体", {}, "", block_area_data.object_ListItem, 1, function(value)
    block_area_data.setting.obj = value
end)
menu.toggle(BlockArea_options, "冻结", {}, "", function(toggle)
    block_area_data.setting.freeze = toggle
end, true)
menu.toggle(BlockArea_options, "可见", {}, "", function(toggle)
    block_area_data.setting.visible = toggle
end, true)
menu.toggle(BlockArea_options, "与玩家自身没有碰撞", {}, "玩家自身可以穿过这些阻挡物",
    function(toggle)
        block_area_data.setting.no_collision = toggle
    end)


----------------
-- 其它阻挡
----------------
local BlockArea_Other = menu.list(Session_options, "其它阻挡", {}, "")

menu.action(BlockArea_Other, "阻挡天基炮", {}, "会生成一个阻挡天基炮房间的铁门", function()
    local hash = util.joaat("h4_prop_h4_garage_door_01a")
    local coords = v3(335.9, 4833.9, -59.0)

    request_model(hash)
    local ent = entities.create_object(hash, coords)
    set_entity_networked(ent, false)
    ENTITY.SET_ENTITY_HEADING(ent, 125.0)
    ENTITY.FREEZE_ENTITY_POSITION(ent, true)
    ENTITY.SET_ENTITY_AS_MISSION_ENTITY(ent, true, false)

    ENTITY.SET_ENTITY_NO_COLLISION_ENTITY(ent, players.user_ped(), false)
    ENTITY.SET_ENTITY_NO_COLLISION_ENTITY(players.user_ped(), ent, false)

    STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(hash)
    util.toast("完成！")
end)



-------------------
-- 交通人口密度
-------------------
local Population_Density = menu.list(Session_options, "交通人口密度", {}, "")

menu.action(Population_Density, "立刻充满行人", { "fill_ped_population" }, "", function()
    PED.INSTANTLY_FILL_PED_POPULATION()
end)
menu.action(Population_Density, "立刻充满交通", { "fill_vehicle_population" }, "", function()
    VEHICLE.INSTANTLY_FILL_VEHICLE_POPULATION()
end)

-----
local Population_Density_Frame = menu.list(Population_Density, "设置交通人口密度", {}, "")
local population_density_frame = {
    ped = 1.0,
    random_vehicle = 1.0,
    parked_vehicle = 1.0,
}

menu.toggle_loop(Population_Density_Frame, "开启", {}, "", function()
    PED.SET_PED_DENSITY_MULTIPLIER_THIS_FRAME(population_density_frame.ped)
    VEHICLE.SET_RANDOM_VEHICLE_DENSITY_MULTIPLIER_THIS_FRAME(population_density_frame.random_vehicle)
    VEHICLE.SET_PARKED_VEHICLE_DENSITY_MULTIPLIER_THIS_FRAME(population_density_frame.parked_vehicle)
end)
menu.slider_float(Population_Density_Frame, "Ped", { "population_density_frame_ped" }, "",
    0, 100, 100, 10, function(value)
        population_density_frame.ped = value * 0.01
    end)
menu.slider_float(Population_Density_Frame, "Random Vehicle", { "population_density_frame_random_vehicle" }, "",
    0, 100, 100, 10, function(value)
        population_density_frame.random_vehicle = value * 0.01
    end)
menu.slider_float(Population_Density_Frame, "Parked Vehicle", { "population_density_frame_parked_vehicle" }, "",
    0, 100, 100, 10, function(value)
        population_density_frame.parked_vehicle = value * 0.01
    end)


-----
local Population_Density_Sphere = menu.list(Population_Density, "覆盖交通人口密度", {},
    "添加一个新的交通人口密度范围覆盖当前交通人口密度")
local population_density_sphere = {
    id = 0,
    pedDensity = 1.0,
    trafficDensity = 1.0,
    localOnly = false,
}

menu.toggle(Population_Density_Sphere, "覆盖范围", {}, "切换战局后会失效，需要重新操作",
    function(toggle)
        if toggle then
            population_density_sphere.id = MISC.ADD_POP_MULTIPLIER_SPHERE(1.1, 1.1, 1.1, 15000.0,
                population_density_sphere.pedDensity
                , population_density_sphere.trafficDensity, population_density_sphere.localOnly, true)
            MISC.CLEAR_AREA(1.1, 1.1, 1.1, 19999.9, true, false, false, true)
        else
            if MISC.DOES_POP_MULTIPLIER_SPHERE_EXIST(population_density_sphere.id) then
                MISC.REMOVE_POP_MULTIPLIER_SPHERE(population_density_sphere.id, false)
            end
        end
    end)
menu.divider(Population_Density_Sphere, "设置")
menu.slider_float(Population_Density_Sphere, "人口密度", { "population_density_sphere_pedDensity" }, "",
    0, 100, 100, 10, function(value)
        population_density_sphere.pedDensity = value * 0.01
    end)
menu.slider_float(Population_Density_Sphere, "交通密度", { "population_density_sphere_trafficDensity" }, "",
    0, 100, 100, 10, function(value)
        population_density_sphere.trafficDensity = value * 0.01
    end)
menu.toggle(Population_Density_Sphere, "仅本地有效", {}, "", function(toggle)
    population_density_sphere.localOnly = toggle
end)




menu.divider(Session_options, "PED")
menu.toggle_loop(Session_options, "新生成的NPC携带零食", {}, "", function()
    PED.SET_HEALTH_SNACKS_CARRIED_BY_ALL_NEW_PEDS(1.0, 99)
end)
menu.toggle_loop(Session_options, "周围NPC死亡时掉钱", {},
    "Sets whether ambient peds drop any money when killed. This is switched off by default in MP.", function()
        PED.SET_AMBIENT_PEDS_DROP_MONEY(true)
    end)
menu.toggle_loop(Session_options, "阻止周围NPC临时事件", {},
    "Blocks non temp events for ambient peds this frame.\nExcludes law enforcement peds.", function()
        PED.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS_FOR_AMBIENT_PEDS_THIS_FRAME(true)
    end)
menu.toggle_loop(Session_options, "周围执法NPC降低精准度", {},
    "Sets global ambient law ped accuracy modifier (only works in MP).", function()
        PED.SET_AMBIENT_LAW_PED_ACCURACY_MODIFIER(0.0)
    end)

--#endregion Session Options





--#region Bodyguard Options

--------------------------------
------------ 保镖选项 ------------
--------------------------------
local Bodyguard_options = menu.list(menu.my_root(), "保镖选项", {}, "")

Relationship = {
    friendly_group = 0,
}

function Relationship:addGroup(GroupName)
    local ptr = memory.alloc_int()
    PED.ADD_RELATIONSHIP_GROUP(GroupName, ptr)
    local rel = memory.read_int(ptr)
    memory.free(ptr)
    return rel
end

function Relationship:friendly(ped)
    if not PED.DOES_RELATIONSHIP_GROUP_EXIST(Relationship.friendly_group) then
        Relationship.friendly_group = Relationship:addGroup("friendly_group")
        PED.SET_RELATIONSHIP_BETWEEN_GROUPS(0, Relationship.friendly_group, Relationship.friendly_group)
    end
    PED.SET_PED_RELATIONSHIP_GROUP_HASH(ped, Relationship.friendly_group)
end

Group = {}
function Group:getSize(ID)
    local unkPtr, sizePtr = memory.alloc(1), memory.alloc(1)
    PED.GET_GROUP_SIZE(ID, unkPtr, sizePtr)
    return memory.read_int(sizePtr)
end

function Group:pushMember(ped)
    local groupID = PLAYER.GET_PLAYER_GROUP(players.user())
    local RelationGroupHash = util.joaat("rgFM_AiLike_HateAiHate")

    if not PED.IS_PED_IN_GROUP(ped) then
        PED.SET_PED_AS_GROUP_MEMBER(ped, groupID)
        PED.SET_PED_NEVER_LEAVES_GROUP(ped, true)
    end
    PED.SET_PED_RELATIONSHIP_GROUP_HASH(ped, RelationGroupHash)
    PED.SET_GROUP_SEPARATION_RANGE(groupID, 9999.0)
    --PED.SET_GROUP_FORMATION_SPACING(groupID, v3(1.0, 0.9, 3.0))
    --PED.SET_GROUP_FORMATION(groupID, self.formation)
end

local Bodyguard = {
    setting = {},
}

Bodyguard.npc = {
    --选择的保镖模型
    model_select = 1,
    --生成的保镖NPC list
    list = {},
    --生成的保镖NPC对应的menu list
    menu_list = {},
    --序号
    index = 1,
}

Bodyguard.heli = {
    --选择的直升机类型
    model_select = 1,
    --生成的保镖直升机 list
    list = {},
    --生成的保镖直升机里面的NPC list
    npc_list = {},
    --生成的保镖直升机对应的menu list
    menu_list = {},
    --序号
    index = 1,
}

--生成保镖NPC 默认设置
Bodyguard.setting.npc = {
    godmode = false,
    health = 1000,
    no_ragdoll = false,
    weapon = "WEAPON_MICROSMG",
    see_hear_range = 500,
    accuracy = 100,
    shoot_rate = 1000,
    combat_ability = 2,
    combat_range = 2,
    combat_movement = 1,
    target_loss_response = 1,
    fire_pattern = -957453492,
}

--生成保镖直升机 默认设置
Bodyguard.setting.heli = {
    godmode = false,
    health = 10000,
    Speed = 300,
    drivingStyle = 786603,
    CustomOffsets = -1.0,
    MinHeightAboveTerrain = 20,
    HeliMode = 0,
}

function Bodyguard.set_npc_attribute(ped)
    --INVINCIBLE
    ENTITY.SET_ENTITY_INVINCIBLE(ped, Bodyguard.setting.npc.godmode)
    ENTITY.SET_ENTITY_PROOFS(ped, Bodyguard.setting.npc.godmode, Bodyguard.setting.npc.godmode,
        Bodyguard.setting.npc.godmode,
        Bodyguard.setting.npc.godmode, Bodyguard.setting.npc.godmode, Bodyguard.setting.npc.godmode,
        Bodyguard.setting.npc.godmode,
        Bodyguard.setting.npc.godmode)
    --HEALTH
    ENTITY.SET_ENTITY_MAX_HEALTH(ped, Bodyguard.setting.npc.health)
    ENTITY.SET_ENTITY_HEALTH(ped, Bodyguard.setting.npc.health)
    --RAGDOLL
    PED.SET_PED_CAN_RAGDOLL(ped, not Bodyguard.setting.npc.no_ragdoll)
    PED.DISABLE_PED_INJURED_ON_GROUND_BEHAVIOUR(ped)
    PED.SET_PED_CAN_PLAY_AMBIENT_ANIMS(ped, false)
    PED.SET_PED_CAN_PLAY_AMBIENT_BASE_ANIMS(ped, false)
    --WEAPON
    local weapon_smoke = util.joaat("WEAPON_SMOKEGRENADE")
    WEAPON.GIVE_WEAPON_TO_PED(ped, weapon_smoke, -1, false, false)
    local weaponHash = util.joaat(Bodyguard.setting.npc.weapon)
    WEAPON.GIVE_WEAPON_TO_PED(ped, weaponHash, -1, false, true)
    WEAPON.SET_CURRENT_PED_WEAPON(ped, weaponHash, false)
    WEAPON.SET_PED_DROPS_WEAPONS_WHEN_DEAD(ped, false)
    PED.SET_PED_CAN_SWITCH_WEAPON(ped, true)
    WEAPON.SET_PED_INFINITE_AMMO_CLIP(ped, true)
    --PERCEPTIVE
    PED.SET_PED_SEEING_RANGE(ped, Bodyguard.setting.npc.see_hear_range)
    PED.SET_PED_HEARING_RANGE(ped, Bodyguard.setting.npc.see_hear_range)
    PED.SET_PED_ID_RANGE(ped, Bodyguard.setting.npc.see_hear_range)
    PED.SET_PED_VISUAL_FIELD_PERIPHERAL_RANGE(ped, Bodyguard.setting.npc.see_hear_range)
    PED.SET_PED_HIGHLY_PERCEPTIVE(ped, true)
    PED.SET_PED_VISUAL_FIELD_MIN_ANGLE(ped, 90.0)
    PED.SET_PED_VISUAL_FIELD_MAX_ANGLE(ped, 90.0)
    PED.SET_PED_VISUAL_FIELD_MIN_ELEVATION_ANGLE(ped, 90.0)
    PED.SET_PED_VISUAL_FIELD_MAX_ELEVATION_ANGLE(ped, 90.0)
    PED.SET_PED_VISUAL_FIELD_CENTER_ANGLE(ped, 90.0)
    --COMBAT
    PED.SET_PED_COMBAT_ABILITY(ped, Bodyguard.setting.npc.combat_ability)
    PED.SET_PED_COMBAT_RANGE(ped, Bodyguard.setting.npc.combat_range)
    PED.SET_PED_COMBAT_MOVEMENT(ped, Bodyguard.setting.npc.combat_movement)
    PED.SET_PED_TARGET_LOSS_RESPONSE(ped, Bodyguard.setting.npc.target_loss_response)
    --COMBAT ATTRIBUTES
    PED.SET_PED_COMBAT_ATTRIBUTES(ped, 4, true)   --Can Use Dynamic Strafe Decisions
    PED.SET_PED_COMBAT_ATTRIBUTES(ped, 5, true)   --Always Fight
    PED.SET_PED_COMBAT_ATTRIBUTES(ped, 6, false)  --Flee Whilst In Vehicle
    PED.SET_PED_COMBAT_ATTRIBUTES(ped, 13, true)  --Aggressive
    PED.SET_PED_COMBAT_ATTRIBUTES(ped, 14, true)  --Can Investigate
    PED.SET_PED_COMBAT_ATTRIBUTES(ped, 17, false) --Always Flee
    PED.SET_PED_COMBAT_ATTRIBUTES(ped, 20, true)  --Can Taunt In Vehicle
    PED.SET_PED_COMBAT_ATTRIBUTES(ped, 21, true)  --Can Chase Target On Foot
    PED.SET_PED_COMBAT_ATTRIBUTES(ped, 22, true)  --Will Drag Injured Peds to Safety
    PED.SET_PED_COMBAT_ATTRIBUTES(ped, 24, true)  --Use Proximity Firing Rate
    PED.SET_PED_COMBAT_ATTRIBUTES(ped, 27, true)  --Perfect Accuracy
    PED.SET_PED_COMBAT_ATTRIBUTES(ped, 28, true)  --Can Use Frustrated Advance
    PED.SET_PED_COMBAT_ATTRIBUTES(ped, 29, true)  --Move To Location Before Cover Search
    PED.SET_PED_COMBAT_ATTRIBUTES(ped, 38, true)  --Disable Bullet Reactions
    PED.SET_PED_COMBAT_ATTRIBUTES(ped, 39, true)  --Can Bust
    PED.SET_PED_COMBAT_ATTRIBUTES(ped, 41, true)  --Can Commandeer Vehicles
    PED.SET_PED_COMBAT_ATTRIBUTES(ped, 42, true)  --Can Flank
    PED.SET_PED_COMBAT_ATTRIBUTES(ped, 46, true)  --Can Fight Armed Peds When Not Armed
    PED.SET_PED_COMBAT_ATTRIBUTES(ped, 49, false) --Use Enemy Accuracy Scaling
    PED.SET_PED_COMBAT_ATTRIBUTES(ped, 52, true)  --Use Vehicle Attack
    PED.SET_PED_COMBAT_ATTRIBUTES(ped, 53, true)  --Use Vehicle Attack If Vehicle Has Mounted Guns
    PED.SET_PED_COMBAT_ATTRIBUTES(ped, 54, true)  --Always Equip Best Weapon
    PED.SET_PED_COMBAT_ATTRIBUTES(ped, 55, true)  --Can See Underwater Peds
    PED.SET_PED_COMBAT_ATTRIBUTES(ped, 58, true)  --Disable Flee From Combat
    PED.SET_PED_COMBAT_ATTRIBUTES(ped, 60, true)  --Can Throw Smoke Grenade
    PED.SET_PED_COMBAT_ATTRIBUTES(ped, 78, true)  --Disable All Randoms Flee
    --FLEE ATTRIBUTES
    PED.SET_PED_FLEE_ATTRIBUTES(ped, 512, true)   -- NEVER_FLEE
    --TASK
    TASK.SET_PED_PATH_CAN_USE_CLIMBOVERS(ped, true)
    TASK.SET_PED_PATH_CAN_USE_LADDERS(ped, true)
    TASK.SET_PED_PATH_CAN_DROP_FROM_HEIGHT(ped, true)
    TASK.SET_PED_PATH_AVOID_FIRE(ped, false)
    TASK.SET_PED_PATH_MAY_ENTER_WATER(ped, true)
end

function Bodyguard.add_blip_for_heli(entity, blipSprite, colour)
    local blip = HUD.ADD_BLIP_FOR_ENTITY(entity)
    HUD.SET_BLIP_SPRITE(blip, blipSprite)
    HUD.SET_BLIP_COLOUR(blip, colour)
    HUD.SHOW_HEIGHT_ON_BLIP(blip, false)

    util.create_tick_handler(function()
        if ENTITY.DOES_ENTITY_EXIST(entity) and not ENTITY.IS_ENTITY_DEAD(entity) then
            local heading = ENTITY.GET_ENTITY_HEADING(entity)
            HUD.SET_BLIP_ROTATION(blip, round(heading))
        elseif not HUD.DOES_BLIP_EXIST(blip) then
            return false
        else
            util.remove_blip(blip)
            return false
        end
    end)
    return blip
end

function Bodyguard.generate_npc_menu(menu_parent, ped, index)
    Entity_Control.generate_menu(menu_parent, ped, index)
end

function Bodyguard.generate_heli_menu(menu_parent, heli, index)
    Entity_Control.generate_menu(menu_parent, heli, index)
end

------------------
----- 保镖NPC -----
------------------
local Bodyguard_NPC_options = menu.list(Bodyguard_options, "保镖NPC", {}, "")

local Bodyguard_NPC_name_ListItem = {
    { "富兰克林",    {}, "" },
    { "麦克",          {}, "" },
    { "崔佛",          {}, "" },
    { "莱斯特",       {}, "" },
    { "埃万保安",    {}, "" },
    { "埃万重甲兵", {}, "" },
    { "越狱光头",    {}, "" },
    { "吉米",          {}, "麦克儿子" },
    { "崔西",          {}, "麦克女儿" },
    { "阿曼达",       {}, "麦克妻子" },
}
local Bodyguard_NPC_model_list = {
    "player_one",
    "player_zero",
    "player_two",
    "ig_lestercrest",
    "mp_m_avongoon",
    "u_m_y_juggernaut_01",
    "ig_rashcosvki",
    "ig_jimmydisanto",
    "ig_tracydisanto",
    "ig_amandatownley",
}

menu.list_select(Bodyguard_NPC_options, "选择模型", {}, "", Bodyguard_NPC_name_ListItem, 1
, function(value)
    Bodyguard.npc.model_select = value
end)

menu.action(Bodyguard_NPC_options, "生成保镖", {}, "", function()
    local groupID = PLAYER.GET_PLAYER_GROUP(players.user())
    if Group:getSize(groupID) >= 7 then
        util.toast("保镖人数已达到上限")
    else
        local modelHash = util.joaat(Bodyguard_NPC_model_list[Bodyguard.npc.model_select])
        local coords = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(players.user_ped(), 0.0, 2.0, 0.0)
        local heading = PLAYER_HEADING() + 180
        local ped = Create_Network_Ped(26, modelHash, coords.x, coords.y, coords.z, heading)
        --BLIP
        local blip = HUD.ADD_BLIP_FOR_ENTITY(ped)
        HUD.SET_BLIP_SPRITE(blip, 271)
        HUD.SET_BLIP_COLOUR(blip, 3)
        HUD.SET_BLIP_SCALE(blip, 0.5)

        Bodyguard.set_npc_attribute(ped)

        -- 添加进保镖小组
        Group:pushMember(ped)
        table.insert(Bodyguard.npc.list, ped)
        -- 创建对应的menu
        local index = Bodyguard.npc.index
        local menu_name = Bodyguard_NPC_name_ListItem[Bodyguard.npc.model_select][1]
        local menu_list = menu.list(Bodyguard_NPC_options, index .. ". " .. menu_name, {}, "")
        index = "bg" .. index
        Bodyguard.generate_npc_menu(menu_list, ped, index)
        table.insert(Bodyguard.npc.menu_list, menu_list)

        Bodyguard.npc.index = Bodyguard.npc.index + 1
    end
end)

menu.divider(Bodyguard_NPC_options, "管理保镖")

local Bodyguard_NPC_manage_all = menu.list(Bodyguard_NPC_options, "所有保镖", {}, "")
menu.toggle(Bodyguard_NPC_manage_all, "无敌", {}, "", function(toggle)
    for k, ent in pairs(Bodyguard.npc.list) do
        if ENTITY.DOES_ENTITY_EXIST(ent) then
            set_entity_godmode(ent, toggle)
        end
    end
end)
menu.list_action(Bodyguard_NPC_manage_all, "给予武器", {}, "", Weapon_Common.ListItem, function(value)
    for k, ent in pairs(Bodyguard.npc.list) do
        if ENTITY.DOES_ENTITY_EXIST(ent) then
            local weaponHash = util.joaat(Weapon_Common.ModelList[value])
            WEAPON.GIVE_WEAPON_TO_PED(ent, weaponHash, -1, false, true)
            WEAPON.SET_CURRENT_PED_WEAPON(ent, weaponHash, false)
        end
    end
end)
menu.action(Bodyguard_NPC_manage_all, "传送到我", {}, "", function()
    local y = 2.0
    for k, ent in pairs(Bodyguard.npc.list) do
        if ENTITY.DOES_ENTITY_EXIST(ent) then
            TP_TO_ME(ent, 0.0, y, 0.0)
            SET_ENTITY_HEAD_TO_ENTITY(ent, players.user_ped(), 180.0)
            y = y + 1.0
        end
    end
end)
menu.action(Bodyguard_NPC_manage_all, "删除", {}, "", function()
    for k, ent in pairs(Bodyguard.npc.list) do
        if ENTITY.DOES_ENTITY_EXIST(ent) then
            entities.delete_by_handle(ent)
        end
    end
    for k, v in pairs(Bodyguard.npc.menu_list) do
        if v ~= nil and menu.is_ref_valid(v) then
            menu.delete(v)
        end
    end
    Bodyguard.npc.list = {}      --生成的保镖NPC list
    Bodyguard.npc.menu_list = {} --生成的保镖直升机对应的menu list
end)


--------------------
----- 保镖直升机 -----
--------------------
local Bodyguard_Heli_options = menu.list(Bodyguard_options, "保镖直升机", {}, "")

local Bodyguard_Heli_name_ListItem = {
    { "女武神" },
    { "秃鹰" },
    { "猎杀者" },
    { "警用小蛮牛" },
}
local Bodyguard_Heli_model_list = {
    "valkyrie", "buzzard", "hunter", "polmav"
}

menu.list_select(Bodyguard_Heli_options, "直升机类型", {}, "", Bodyguard_Heli_name_ListItem,
    1, function(value)
        Bodyguard.heli.model_select = value
    end)

menu.action(Bodyguard_Heli_options, "生成保镖直升机", {}, "", function()
    local heli_hash = util.joaat(Bodyguard_Heli_model_list[Bodyguard.heli.model_select])
    local ped_hash = util.joaat("s_m_y_blackops_01")

    local pos = ENTITY.GET_ENTITY_COORDS(players.user_ped())
    pos.x = pos.x + math.random(-10, 10)
    pos.y = pos.y + math.random(-10, 10)
    pos.z = pos.z + 30

    local heli = Create_Network_Vehicle(heli_hash, pos.x, pos.y, pos.z, CAM.GET_GAMEPLAY_CAM_ROT(0).z)
    --BLIP
    Bodyguard.add_blip_for_heli(heli, 422, 26)
    --INVINCIBLE
    ENTITY.SET_ENTITY_INVINCIBLE(heli, Bodyguard.setting.heli.godmode)
    ENTITY.SET_ENTITY_PROOFS(heli, Bodyguard.setting.heli.godmode, Bodyguard.setting.heli.godmode,
        Bodyguard.setting.heli.godmode, Bodyguard.setting.heli.godmode, Bodyguard.setting.heli.godmode,
        Bodyguard.setting.heli.godmode, Bodyguard.setting.heli.godmode, Bodyguard.setting.heli.godmode)
    --HEALTH
    ENTITY.SET_ENTITY_MAX_HEALTH(heli, Bodyguard.setting.heli.health)
    ENTITY.SET_ENTITY_HEALTH(heli, Bodyguard.setting.heli.health)
    --BEHAVIOUR
    VEHICLE.SET_HELI_BLADES_FULL_SPEED(heli)
    VEHICLE.SET_VEHICLE_SEARCHLIGHT(heli, true, true)
    VEHICLE.SET_VEHICLE_HAS_UNBREAKABLE_LIGHTS(heli, true)
    VEHICLE.SET_HELI_TAIL_BOOM_CAN_BREAK_OFF(heli, true)

    table.insert(Bodyguard.heli.list, heli)

    Relationship:friendly(players.user_ped())

    ------
    local pilot = Create_Network_Ped(29, ped_hash, pos.x, pos.y, pos.z, CAM.GET_GAMEPLAY_CAM_ROT(0).z)
    PED.SET_PED_INTO_VEHICLE(pilot, heli, -1)
    --PED.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(pilot, true)
    --TASK.TASK_SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(pilot, true)
    --TASK.TASK_HELI_MISSION(pilot, heli, 0, players.user_ped(), 0.0, 0.0, 0.0, 23, 80.0, 50.0, -1.0, 0, 10, -1.0, 0)
    TASK.TASK_VEHICLE_HELI_PROTECT(pilot, heli, players.user_ped(), Bodyguard.setting.heli.Speed,
        Bodyguard.setting.heli.drivingStyle, Bodyguard.setting.heli.CustomOffsets,
        Bodyguard.setting.heli.MinHeightAboveTerrain, Bodyguard.setting.heli.HeliMode)
    PED.SET_PED_KEEP_TASK(pilot, true)

    Bodyguard.set_npc_attribute(pilot)
    PED.SET_PED_CAN_BE_SHOT_IN_VEHICLE(pilot, false)
    PED.SET_PED_CAN_BE_KNOCKED_OFF_VEHICLE(pilot, 1)

    Relationship:friendly(pilot)
    table.insert(Bodyguard.heli.npc_list, pilot)

    ------
    local seats = VEHICLE.GET_VEHICLE_MODEL_NUMBER_OF_SEATS(heli_hash) - 2
    for seat = 0, seats do
        local ped = Create_Network_Ped(29, ped_hash, pos.x, pos.y, pos.z, CAM.GET_GAMEPLAY_CAM_ROT(0).z)
        PED.SET_PED_INTO_VEHICLE(ped, heli, seat)

        Bodyguard.set_npc_attribute(ped)
        PED.SET_PED_CAN_BE_SHOT_IN_VEHICLE(ped, false)
        PED.SET_PED_CAN_BE_KNOCKED_OFF_VEHICLE(ped, 1)

        Relationship:friendly(ped)
        table.insert(Bodyguard.heli.npc_list, ped)
    end

    -- 创建对应的menu
    local index = Bodyguard.heli.index
    local menu_name = Bodyguard_Heli_name_ListItem[Bodyguard.heli.model_select][1]
    local menu_list = menu.list(Bodyguard_Heli_options, index .. ". " .. menu_name, {}, "")
    index = "bgh" .. index
    Bodyguard.generate_heli_menu(menu_list, heli, index)
    table.insert(Bodyguard.heli.menu_list, menu_list)

    Bodyguard.heli.index = Bodyguard.heli.index + 1
end)

menu.divider(Bodyguard_Heli_options, "管理保镖直升机")

local Bodyguard_Heli_manage_all = menu.list(Bodyguard_Heli_options, "所有保镖直升机", {}, "")
menu.toggle(Bodyguard_Heli_manage_all, "无敌", {}, "", function(toggle)
    for k, ent in pairs(Bodyguard.heli.npc_list) do
        if ENTITY.DOES_ENTITY_EXIST(ent) then
            set_entity_godmode(ent, toggle)
        end
    end
    for k, ent in pairs(Bodyguard.heli.list) do
        if ENTITY.DOES_ENTITY_EXIST(ent) then
            set_entity_godmode(ent, toggle)
        end
    end
end)
menu.action(Bodyguard_Heli_manage_all, "传送到我", {}, "", function()
    for k, ent in pairs(Bodyguard.heli.list) do
        if ENTITY.DOES_ENTITY_EXIST(ent) then
            TP_TO_ME(ent, math.random(-10, 10), math.random(-10, 10), 30)
        end
    end
end)
menu.action(Bodyguard_Heli_manage_all, "删除", {}, "", function()
    for k, ent in pairs(Bodyguard.heli.npc_list) do
        if ENTITY.DOES_ENTITY_EXIST(ent) then
            entities.delete_by_handle(ent)
        end
    end
    for k, ent in pairs(Bodyguard.heli.list) do
        if ENTITY.DOES_ENTITY_EXIST(ent) then
            entities.delete_by_handle(ent)
        end
    end
    for k, v in pairs(Bodyguard.heli.menu_list) do
        if v ~= nil and menu.is_ref_valid(v) then
            menu.delete(v)
        end
    end

    Bodyguard.heli.list = {}      --生成的保镖直升机 list
    Bodyguard.heli.npc_list = {}  --生成的保镖直升机里面的NPC list
    Bodyguard.heli.menu_list = {} --生成的保镖直升机对应的menu list
    Bodyguard.heli.index = 1
end)


----------------
----- 设置 ------
----------------
menu.divider(Bodyguard_options, "设置")

----- 保镖NPC -----
local Bodyguard_npc_setting = menu.list(Bodyguard_options, "保镖NPC 默认设置", {}, "")
menu.toggle(Bodyguard_npc_setting, "无敌", {}, "", function(toggle)
    Bodyguard.setting.npc.godmode = toggle
end)
menu.slider(Bodyguard_npc_setting, "生命", { "bodyguard_npc_health" }, "", 100, 30000, 1000, 100,
    function(value)
        Bodyguard.setting.npc.health = value
    end)
menu.toggle(Bodyguard_npc_setting, "不会摔倒", {}, "", function(toggle)
    Bodyguard.setting.npc.no_ragdoll = toggle
end)
menu.list_select(Bodyguard_npc_setting, "武器", {}, "", Weapon_Common.ListItem, 4, function(value)
    Bodyguard.setting.npc.weapon = Weapon_Common.ModelList[value]
end)
menu.divider(Bodyguard_npc_setting, "作战能力")
menu.slider(Bodyguard_npc_setting, "视力听觉范围", { "bodyguard_npc_see_hear_range" }, "", 10, 1000, 500,
    100, function(value)
        Bodyguard.setting.npc.see_hear_range = value
    end)
menu.slider(Bodyguard_npc_setting, "精确度", { "bodyguard_npc_accuracy" }, "", 0, 100, 100, 10,
    function(value)
        Bodyguard.setting.npc.accuracy = value
    end)
menu.slider(Bodyguard_npc_setting, "射击频率", { "bodyguard_npc_shoot_rate" }, "", 0, 1000, 1000, 100,
    function(value)
        Bodyguard.setting.npc.shoot_rate = value
    end)
menu.list_select(Bodyguard_npc_setting, "作战技能", {}, "", { { "弱" }, { "普通" }, { "专业" } }, 3,
    function(value)
        Bodyguard.setting.npc.combat_ability = value - 1
    end)
menu.list_select(Bodyguard_npc_setting, "作战范围", {}, "", { { "近" }, { "中等" }, { "远" }, { "非常远" } }
, 3, function(value)
    Bodyguard.setting.npc.combat_range = value - 1
end)
menu.list_select(Bodyguard_npc_setting, "作战走位", {}, "", { { "站立" }, { "防卫" }, { "会前进" },
    { "会后退" } }, 2, function(value)
    Bodyguard.setting.npc.combat_movement = value - 1
end)
menu.list_select(Bodyguard_npc_setting, "失去目标时反应", {}, "", { { "退出战斗" }, { "从不失去目标" },
    { "寻找目标" } }, 2, function(value)
    Bodyguard.setting.npc.target_loss_response = value - 1
end)
menu.list_select(Bodyguard_npc_setting, "射击模式", {}, "", Ped_FirePattern.ListItem, 1, function(value)
    Bodyguard.setting.npc.fire_pattern = Ped_FirePattern.ValueList[value]
end)

----- 保镖直升机 -----
local Bodyguard_heli_setting = menu.list(Bodyguard_options, "保镖直升机 默认设置", {}, "")
menu.toggle(Bodyguard_heli_setting, "无敌", {}, "", function(toggle)
    Bodyguard.setting.heli.godmode = toggle
end)
menu.slider(Bodyguard_heli_setting, "生命", { "bodyguard_heli_health" }, "", 100, 30000, 10000, 100,
    function(value)
        Bodyguard.setting.heli.health = value
    end)
menu.divider(Bodyguard_heli_setting, "任务设置")
menu.slider(Bodyguard_heli_setting, "速度", { "bodyguard_heli_Speed" }, "", 0, 10000, 300, 10,
    function(value)
        Bodyguard.setting.heli.Speed = value
    end)
menu.list_select(Bodyguard_heli_setting, "驾驶风格", {}, "", Vehicle_DrivingStyle.ListItem, 1, function(value)
    Bodyguard.setting.heli.drivingStyle = Vehicle_DrivingStyle.ValueList[value]
end)
menu.slider_float(Bodyguard_heli_setting, "Custom Offset", { "bodyguard_heli_CustomOffset" }, "", -100000, 100000, -100,
    10, function(value)
        Bodyguard.setting.heli.CustomOffsets = value
    end)
menu.slider(Bodyguard_heli_setting, "地面上的最小高度", { "bodyguard_heli_MinHeightAboveTerrain" }, "", 0, 10000
    , 20, 1,
    function(value)
        Bodyguard.setting.heli.MinHeightAboveTerrain = value
    end)
menu.list_select(Bodyguard_heli_setting, "直升机模式", {}, "", Vehicle_HeliMode.ListItem, 1, function(value)
    Bodyguard.setting.heli.HeliMode = Vehicle_HeliMode.ValueList[value]
end)

--#endregion Bodyguard Options





--#region Fun Options

--------------------------------
------------ 娱乐选项 ------------
--------------------------------
require "RScript.Menu.Fun"

--#endregion Fun Options





--#region Protect Options

--------------------------------
------------ 保护选项 ------------
--------------------------------
local Protect_options = menu.list(menu.my_root(), "保护选项", {}, "")

menu.toggle_loop(Protect_options, "移除爆炸", {}, "范围: 10", function()
    local pos = ENTITY.GET_ENTITY_COORDS(players.user_ped())
    FIRE.STOP_FIRE_IN_RANGE(pos.x, pos.y, pos.z, 10.0)
    FIRE.STOP_ENTITY_FIRE(players.user_ped())
end)
menu.toggle_loop(Protect_options, "移除粒子效果", {}, "范围: 10", function()
    local pos = ENTITY.GET_ENTITY_COORDS(players.user_ped())
    GRAPHICS.REMOVE_PARTICLE_FX_IN_RANGE(pos.x, pos.y, pos.z, 10.0)
    GRAPHICS.REMOVE_PARTICLE_FX_FROM_ENTITY(players.user_ped())
end)
menu.toggle_loop(Protect_options, "移除防空区域", {}, "不知有何作用(?)", function()
    WEAPON.REMOVE_ALL_AIR_DEFENCE_SPHERES()
end)
menu.toggle_loop(Protect_options, "移除载具上的黏弹", {}, "", function()
    local vehicle = entities.get_user_vehicle_as_handle()
    if vehicle ~= 0 then
        NETWORK.REMOVE_ALL_STICKY_BOMBS_FROM_ENTITY(vehicle)
    end
end)
menu.toggle_loop(Protect_options, "停止所有声音", {}, "", function()
    for i = 0, 99 do
        AUDIO.STOP_SOUND(i)
    end
end)

--#endregion Protect Options





--#region Other options

--------------------------------
------------ 其它选项 -----------
--------------------------------
local Other_options = menu.list(menu.my_root(), "其它选项", {}, "")

Dev_options = menu.list(Other_options, "开发者选项", {}, "")
require "RScript.Menu.Dev"



------------------
--- 零食护甲编辑 ---
------------------
local Snack_Armour_Editor = menu.list(Other_options, "零食护甲编辑", {}, "")

menu.action(Snack_Armour_Editor, "补满全部零食", {}, "", function()
    STAT_SET_INT("NO_BOUGHT_YUM_SNACKS", 30)
    STAT_SET_INT("NO_BOUGHT_HEALTH_SNACKS", 15)
    STAT_SET_INT("NO_BOUGHT_EPIC_SNACKS", 5)
    STAT_SET_INT("NUMBER_OF_ORANGE_BOUGHT", 10)
    STAT_SET_INT("NUMBER_OF_BOURGE_BOUGHT", 10)
    STAT_SET_INT("NUMBER_OF_CHAMP_BOUGHT", 5)
    STAT_SET_INT("CIGARETTES_BOUGHT", 20)
    STAT_SET_INT("NUMBER_OF_SPRUNK_BOUGHT", 10)
    util.toast("完成！")
end)
menu.action(Snack_Armour_Editor, "补满全部护甲", {}, "", function()
    STAT_SET_INT("MP_CHAR_ARMOUR_1_COUNT", 10)
    STAT_SET_INT("MP_CHAR_ARMOUR_2_COUNT", 10)
    STAT_SET_INT("MP_CHAR_ARMOUR_3_COUNT", 10)
    STAT_SET_INT("MP_CHAR_ARMOUR_4_COUNT", 10)
    STAT_SET_INT("MP_CHAR_ARMOUR_5_COUNT", 10)
    util.toast("完成！")
end)
menu.action(Snack_Armour_Editor, "补满呼吸器", {}, "", function()
    STAT_SET_INT("BREATHING_APPAR_BOUGHT", 20)
    util.toast("完成！")
end)

menu.divider(Snack_Armour_Editor, "零食")
menu.click_slider(Snack_Armour_Editor, "PQ豆", { "snack_yum" }, "+15 Health", 0, 999, 30, 1, function(value)
    STAT_SET_INT("NO_BOUGHT_YUM_SNACKS", value)
    util.toast("完成！")
end)
menu.click_slider(Snack_Armour_Editor, "宝力旺", { "snack_health" }, "+45 Health", 0, 999, 15, 1,
    function(value)
        STAT_SET_INT("NO_BOUGHT_HEALTH_SNACKS", value)
        util.toast("完成！")
    end)
menu.click_slider(Snack_Armour_Editor, "麦提来", { "snack_epic" }, "+30 Health", 0, 999, 5, 1,
    function(value)
        STAT_SET_INT("NO_BOUGHT_EPIC_SNACKS", value)
        util.toast("完成！")
    end)
menu.click_slider(Snack_Armour_Editor, "易可乐", { "snack_orange" }, "+36 Health", 0, 999, 10, 1,
    function(value)
        STAT_SET_INT("NUMBER_OF_ORANGE_BOUGHT", value)
        util.toast("完成！")
    end)
menu.click_slider(Snack_Armour_Editor, "尿汤啤", { "snack_bourge" }, "", 0, 999, 10, 1, function(value)
    STAT_SET_INT("NUMBER_OF_BOURGE_BOUGHT", value)
    util.toast("完成！")
end)
menu.click_slider(Snack_Armour_Editor, "蓝醉香槟", { "snack_champ" }, "", 0, 999, 5, 1, function(value)
    STAT_SET_INT("NUMBER_OF_CHAMP_BOUGHT", value)
    util.toast("完成！")
end)
menu.click_slider(Snack_Armour_Editor, "香烟", { "snack_cigarettes" }, "-5 Health", 0, 999, 20, 1,
    function(value)
        STAT_SET_INT("CIGARETTES_BOUGHT", value)
        util.toast("完成！")
    end)
menu.click_slider(Snack_Armour_Editor, "霜碧", { "snack_sprunk" }, "+36 Health", 0, 999, 10, 1,
    function(value)
        STAT_SET_INT("NUMBER_OF_SPRUNK_BOUGHT", value)
        util.toast("完成！")
    end)



--------------------
----- 标记点选项 -----
--------------------
local Blip_options = menu.list(Other_options, "标记点选项", {}, "")

------------------
-- 地图全部标记点
------------------
local All_Blip_On_Map = menu.list(Blip_options, "地图全部标记点", {}, "")

local map_all_blip = {
    count = 0,      -- 获取到的标记点数量
    menu_list = {}, -- 标记点的 menu.list
}

function map_all_blip.init_list_data()
    for k, v in pairs(map_all_blip.menu_list) do
        if v ~= nil and menu.is_ref_valid(v) then
            menu.delete(v)
        end
    end

    menu.set_menu_name(map_all_blip.menu_divider, "标记点列表")
    map_all_blip.count = 0
    map_all_blip.menu_list = {}
end

function map_all_blip.generate_menu(menu_parent, blip)
    menu.divider(menu_parent, menu.get_menu_name(menu_parent))

    local sprite = HUD.GET_BLIP_SPRITE(blip)
    local blip_type = GET_BLIP_TYPE(blip)

    ----- 信息显示 -----
    local readonly_menu_list = {}
    local blip_info = menu.list(menu_parent, "查看标记点信息", {}, "")
    menu.readonly(blip_info, "Sprite", sprite)
    readonly_menu_list[1] = menu.readonly(blip_info, "Type", HUD.GET_BLIP_INFO_ID_TYPE(blip))
    readonly_menu_list[2] = menu.readonly(blip_info, "Colour")
    readonly_menu_list[3] = menu.readonly(blip_info, "HUD Colour")
    readonly_menu_list[4] = menu.readonly(blip_info, "Display")
    readonly_menu_list[5] = menu.readonly(blip_info, "Rotation")
    menu.divider(blip_info, "Coords")
    readonly_menu_list[6] = menu.readonly(blip_info, "X")
    readonly_menu_list[7] = menu.readonly(blip_info, "Y")
    readonly_menu_list[8] = menu.readonly(blip_info, "Z")

    menu.on_tick_in_viewport(readonly_menu_list[1], function()
        if HUD.DOES_BLIP_EXIST(blip) then
            menu.set_value(readonly_menu_list[2], HUD.GET_BLIP_COLOUR(blip))
            menu.set_value(readonly_menu_list[3], HUD.GET_BLIP_HUD_COLOUR(blip))
            menu.set_value(readonly_menu_list[4], HUD.GET_BLIP_INFO_ID_DISPLAY(blip))
            menu.set_value(readonly_menu_list[5], HUD.GET_BLIP_ROTATION(blip))
            local coords = HUD.GET_BLIP_COORDS(blip)
            menu.set_value(readonly_menu_list[6], coords.x)
            menu.set_value(readonly_menu_list[7], coords.y)
            menu.set_value(readonly_menu_list[8], coords.z)
        end
    end)

    ----- 标记点设置 -----
    local blip_setting = menu.list(menu_parent, "标记点设置", {}, "")
    menu.click_slider(blip_setting, "Set Sprite", { "set_blip" .. sprite .. "sprite" }, "", 0, 826, sprite, 1,
        function(value)
            HUD.SET_BLIP_SPRITE(blip, value)
        end)
    menu.click_slider(blip_setting, "Set Colour", { "set_blip" .. sprite .. "colour" }, "", 0, 85,
        HUD.GET_BLIP_HUD_COLOUR(blip), 1,
        function(value)
            HUD.SET_BLIP_COLOUR(blip, value)
        end)
    menu.list_select(blip_setting, "Set Display", {}, "", Blip_DisplayID_ListItem, HUD.GET_BLIP_INFO_ID_DISPLAY(blip) + 1
    , function(value)
        HUD.SET_BLIP_DISPLAY(blip, value - 1)
    end)
    menu.toggle(blip_setting, "Flashs", {}, "", function(toggle)
        HUD.SET_BLIP_FLASHES(blip, toggle)
    end, HUD.IS_BLIP_FLASHING(blip))
    menu.toggle(blip_setting, "Set As Short Range", {},
        "Sets whether or not the specified blip should only be displayed when nearby, or on the minimap.",
        function(toggle)
            HUD.SET_BLIP_AS_SHORT_RANGE(blip, toggle)
        end, HUD.IS_BLIP_SHORT_RANGE(blip))
    menu.slider_text(blip_setting, "Set Friendly", {}, "", { "Friendly", "Enemy" }, function(value)
        local toggle = true
        if value == 2 then
            toggle = false
        end
        HUD.SET_BLIP_AS_FRIENDLY(blip, toggle)
    end)
    menu.toggle(blip_setting, "Set Radius Edge", {}, "Enabling this on a radius blip will make it outline only.",
        function(toggle)
            HUD.SET_RADIUS_BLIP_EDGE(blip, toggle)
        end)
    menu.click_slider_float(blip_setting, "Set Scale", { "set_blip" .. sprite .. "scale" }, "", 0, 1000, 100, 10,
        function(value)
            HUD.SET_BLIP_SCALE(blip, value * 0.01)
        end)
    menu.toggle(blip_setting, "Show Height On Blip", {}, "", function(toggle)
        HUD.SHOW_HEIGHT_ON_BLIP(blip, toggle)
    end)


    menu.divider(menu_parent, "Type: " .. blip_type)

    ----- 传送选项 -----
    local teleport_options = menu.list(menu_parent, "传送", {}, "")
    local tp_offset = {
        x = 0.0,
        y = 2.0,
        z = 0.0
    }
    menu.slider_float(teleport_options, "前/后", { "blip" .. sprite .. "_tp_x" }, "", -5000, 5000, 200, 50,
        function(value)
            tp_offset.y = value * 0.01
        end)
    menu.slider_float(teleport_options, "上/下", { "blip" .. sprite .. "_tp_y" }, "", -5000, 5000, 0, 50,
        function(value)
            tp_offset.z = value * 0.01
        end)
    menu.slider_float(teleport_options, "左/右", { "blip" .. sprite .. "_tp_z" }, "", -5000, 5000, 0, 50,
        function(value)
            tp_offset.x = value * 0.01
        end)

    menu.action(teleport_options, "传送到标记点", {}, "直接传送到坐标", function()
        if not IS_BLIP_ENTITY(blip) then
            local pos = HUD.GET_BLIP_COORDS(blip)
            if pos ~= nil then
                TELEPORT(pos.x, pos.y, pos.z + 1.0)
            end
        else
            local ent = HUD.GET_BLIP_INFO_ID_ENTITY_INDEX(blip)
            TP_TO_ENTITY(ent, tp_offset.x, tp_offset.y, tp_offset.z)
        end
    end)
    menu.action(teleport_options, "传送到标记点 (Safe)", {}, "会传送到地面", function()
        if not IS_BLIP_ENTITY(blip) then
            local pos = GET_BLIP_COORDS(blip)
            if pos ~= nil then
                TELEPORT(pos.x, pos.y, pos.z)
            end
        else
            local ent = HUD.GET_BLIP_INFO_ID_ENTITY_INDEX(blip)
            TP_TO_ENTITY(ent, tp_offset.x, tp_offset.y, tp_offset.z)
        end
    end)
    menu.action(teleport_options, "传送到我", {}, "", function()
        if not IS_BLIP_ENTITY(blip) then
            util.toast("标记点不是实体，无法传送到我")
        else
            local ent = HUD.GET_BLIP_INFO_ID_ENTITY_INDEX(blip)
            TP_TO_ME(ent, tp_offset.x, tp_offset.y, tp_offset.z)
        end
    end)
end

menu.action(All_Blip_On_Map, "获取地图显示的全部标记点", {}, "重复的标记点只能获取到最近的一个",
    function()
        map_all_blip.init_list_data()

        for i = 0, 826, 1 do
            -- local blip = HUD.GET_FIRST_BLIP_INFO_ID(i)
            local blip = HUD.GET_CLOSEST_BLIP_INFO_ID(i)
            if HUD.DOES_BLIP_EXIST(blip) then
                local blip_name = All_Blips[i + 1]
                local blip_type = GET_BLIP_TYPE(blip)

                -- menu.list
                local menu_name = i .. ". " .. blip_name
                local help_text = "Type: " .. blip_type
                local menu_list = menu.list(All_Blip_On_Map, menu_name, {}, help_text)
                map_all_blip.generate_menu(menu_list, blip)

                table.insert(map_all_blip.menu_list, menu_list)

                map_all_blip.count = map_all_blip.count + 1
                menu.set_menu_name(map_all_blip.menu_divider, "标记点列表 (" .. map_all_blip.count .. ")")
            end
        end
    end)

menu.action(All_Blip_On_Map, "清空列表", {}, "", function()
    map_all_blip.init_list_data()
end)
map_all_blip.menu_divider = menu.divider(All_Blip_On_Map, "标记点列表")



------------------
-- 自定义标记点
------------------
local Blip_custom = menu.list(Blip_options, "自定义标记点", {}, "")

local waypoint_blip_sprite = 8
menu.list_select(Blip_custom, "标记点类型", {}, "只作用于第一个标记的大头针位置",
    { "标记点位置", "大头针位置" }, 1, function(value)
        if value == 1 then
            waypoint_blip_sprite = 8
        elseif value == 2 then
            waypoint_blip_sprite = 162
        end
    end)

menu.toggle(Blip_custom, "在小地图上显示标记点", {}, "", function(toggle)
    local blip = HUD.GET_FIRST_BLIP_INFO_ID(waypoint_blip_sprite)
    if HUD.DOES_BLIP_EXIST(blip) then
        if toggle then
            HUD.SET_BLIP_DISPLAY(blip, 2)
        else
            HUD.SET_BLIP_DISPLAY(blip, 3)
        end
    end
end)
menu.toggle(Blip_custom, "闪烁标记点", {}, "", function(toggle)
    local blip = HUD.GET_FIRST_BLIP_INFO_ID(waypoint_blip_sprite)
    if HUD.DOES_BLIP_EXIST(blip) then
        HUD.SET_BLIP_FLASHES(blip, toggle)
    end
end)
menu.action(Blip_custom, "通知坐标", {}, "", function()
    local blip = HUD.GET_FIRST_BLIP_INFO_ID(waypoint_blip_sprite)
    if not HUD.DOES_BLIP_EXIST(blip) then
        util.toast("No Waypoint Found")
    else
        local pos = GET_BLIP_COORDS(blip)
        if pos ~= nil then
            local text = pos.x .. ", " .. pos.y .. ", " .. pos.z
            util.toast(text)
        end
    end
end)

menu.divider(Blip_custom, "在标记点位置")

local Waypoint_CreateVehicle = menu.list(Blip_custom, "生成载具", {}, "")

for k, data in pairs(Vehicle_Common) do
    local name = "生成 " .. data.name
    local hash = util.joaat(data.model)
    menu.action(Waypoint_CreateVehicle, name, {}, data.help_text, function()
        local blip = HUD.GET_FIRST_BLIP_INFO_ID(waypoint_blip_sprite)
        if not HUD.DOES_BLIP_EXIST(blip) then
            util.toast("No Waypoint Found")
        else
            local pos = GET_BLIP_COORDS(blip)
            if pos ~= nil then
                local vehicle = Create_Network_Vehicle(hash, pos.x, pos.y, pos.z + 1.0, 0)
                if vehicle ~= 0 then
                    upgrade_vehicle(vehicle)
                    set_entity_godmode(vehicle, true)
                    VEHICLE.SET_VEHICLE_ON_GROUND_PROPERLY(vehicle, 5.0)

                    util.toast("完成！")
                end
            end
        end
    end)
end

local Waypoint_CreatePickup = menu.list(Blip_custom, "生成拾取物", {}, "")
local Waypoint_Pickup_ListItem = {
    --name, model, pickupHash, value
    { "医药包",    "prop_ld_health_pack", 2406513688, 100 },
    { "护甲",       "prop_armour_pickup",  1274757841, 100 },
    { "火神机枪", "W_MG_Minigun",        792114228,  100 },
}
for k, data in pairs(Waypoint_Pickup_ListItem) do
    local name = "生成" .. data[1]
    menu.action(Waypoint_CreatePickup, name, {}, "", function()
        local blip = HUD.GET_FIRST_BLIP_INFO_ID(waypoint_blip_sprite)
        if not HUD.DOES_BLIP_EXIST(blip) then
            util.toast("No Waypoint Found")
        else
            local pos = GET_BLIP_COORDS(blip)
            if pos ~= nil then
                local modelHash = util.joaat(data[2])
                local pickupHash = data[3]
                Create_Network_Pickup(pickupHash, pos.x, pos.y, pos.z, modelHash, data[4])
                util.toast("完成！")
            end
        end
    end)
end

local Waypoint_Explosion = menu.list(Blip_custom, "爆炸", {}, "")
local waypoint_explosion_type = 2
menu.list_select(Waypoint_Explosion, "爆炸类型", {}, "", ExplosionType_ListItem, 4, function(index)
    waypoint_explosion_type = index - 2
end)
menu.action(Waypoint_Explosion, "爆炸", {}, "", function()
    local blip = HUD.GET_FIRST_BLIP_INFO_ID(waypoint_blip_sprite)
    if not HUD.DOES_BLIP_EXIST(blip) then
        util.toast("No Waypoint Found")
    else
        local pos = GET_BLIP_COORDS(blip)
        if pos ~= nil then
            add_explosion(pos, waypoint_explosion_type)
        end
    end
end)

menu.action(Waypoint_Explosion, "RPG轰炸", {}, "以玩家的名义轰炸", function()
    local blip = HUD.GET_FIRST_BLIP_INFO_ID(waypoint_blip_sprite)
    if not HUD.DOES_BLIP_EXIST(blip) then
        util.toast("No Waypoint Found")
    else
        local pos = GET_BLIP_COORDS(blip)
        if pos ~= nil then
            local weaponHash = util.joaat("WEAPON_RPG")
            MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pos.x, pos.y, pos.z + 10.0, pos.x, pos.y, pos.z, 1000, false,
                weaponHash, players.user_ped(), true, false, 1000)
        end
    end
end)



-------------------
----- 聊天选项 -----
-------------------
local Chat_options = menu.list(Other_options, "聊天选项", {}, "")

local nophonespam = menu.ref_by_command_name("nophonespam")
menu.toggle_loop(Chat_options, "打字时禁用来电电话", {}, "避免在打字时有电话把输入框挤掉",
    function()
        if chat.is_open() then
            if not menu.get_value(nophonespam) then
                menu.set_value(nophonespam, true)
            end
        else
            if menu.get_value(nophonespam) then
                menu.set_value(nophonespam, false)
            end
        end
    end, function()
        menu.trigger_commands("nophonespam off")
    end)

menu.divider(Chat_options, "记录打字输入内容")
local typing_text_list = {}
local typing_text_list_item = {}
local typing_text_now = ""
menu.toggle_loop(Chat_options, "开启", {}, "", function()
    if chat.is_open() then
        if chat.get_state() > 0 then
            typing_text_now = chat.get_draft()
        end
    else
        if typing_text_now ~= "" and not isInTable(typing_text_list, typing_text_now) then
            table.insert(typing_text_list, typing_text_now)

            local temp = newTableValue(1, typing_text_now)
            table.insert(typing_text_list_item, temp)
            typing_text_now = ""

            menu.set_list_action_options(typing_text_list_action, typing_text_list_item)
        end
    end
end)

menu.action(Chat_options, "清空记录内容", {}, "", function()
    typing_text_list = {}
    typing_text_list_item = {}
    typing_text_now = ""
    menu.set_list_action_options(typing_text_list_action, typing_text_list_item)
end)
local typing_text_send_to_team = false
menu.toggle(Chat_options, "发送到团队", {}, "", function(toggle)
    typing_text_send_to_team = toggle
end)
typing_text_list_action = menu.list_action(Chat_options, "查看记录内容", {}, "点击即可弹出输入框",
    typing_text_list_item, function(value)
        local text = typing_text_list_item[value][1]
        chat.ensure_open_with_empty_draft(typing_text_send_to_team)
        chat.add_to_draft(text)
    end)



----------------
menu.toggle_loop(Other_options, "跳到下一条对话", { "skip_talk" }, "快速跳过对话", function()
    if AUDIO.IS_SCRIPTED_CONVERSATION_ONGOING() then
        AUDIO.SKIP_TO_NEXT_SCRIPTED_CONVERSATION_LINE()
    end
end)
menu.toggle_loop(Other_options, "停止对话", { "stop_talk" }, "", function()
    if AUDIO.IS_SCRIPTED_CONVERSATION_ONGOING() then
        AUDIO.STOP_SCRIPTED_CONVERSATION(false)
    end
end)
local simulate_left_click_delay = 30 --ms
menu.toggle_loop(Other_options, "模拟鼠标左键点击", { "left_click" }, "用于拿取目标财物时",
    function()
        if TASK.GET_IS_TASK_ACTIVE(players.user_ped(), 135) then
            PAD.SET_CONTROL_VALUE_NEXT_FRAME(0, 237, 1)
            util.yield(simulate_left_click_delay)
        end
    end)
menu.slider(Other_options, "模拟点击延迟", { "delay_left_click" }, "单位: ms", 0, 5000, 30, 10,
    function(value)
        simulate_left_click_delay = value
    end)
menu.action(Other_options, "清除帮助文本信息", { "cls_help_msg" }, "", function()
    HUD.CLEAR_ALL_HELP_MESSAGES()
end)
menu.action(Other_options, "Clear Tick Handler", {}, "用于解决控制实体的描绘连线、显示信息、锁定传送等问题"
, function()
    tick_handler_data.control_ent.clear()
end)

--#endregion Other options





--------------------------------
-------------- 关于 -------------
--------------------------------
local About_options = menu.list(menu.my_root(), "关于", {}, "")

menu.readonly(About_options, "Author", "Rostal#9913")
menu.hyperlink(About_options, "Github", "https://github.com/TCRoid/Stand-Lua-RScript")
menu.readonly(About_options, "Version", SCRIPT_VERSION)
menu.readonly(About_options, "Support GTAO Version", SUPPORT_GTAO)



---------------------------------------------------------------






--------------------------------
------------ 玩家选项 -----------
--------------------------------

require "RScript.Menu.Player"
