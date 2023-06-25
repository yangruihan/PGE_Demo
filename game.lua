function config()
    return {
        title = "Breakout!",
        screen_width = 512,
        screen_height = 480,
        screen_x_scale = 1,
        screen_y_scale = 1
    }
end

local block_size = {w = 16, h = 16}

local graphics = PGE.graphics
local input = PGE.input
local ecs = PGE.ecs

local world = ecs.world()
world:register{
    name = "pos",
    "x:float",
    "y:float",
}

world:register{
    name = "velocity",
    "x:float",
    "y:float",
}

world:register{
    name = "color",
    "r:byte",
    "g:byte",
    "b:byte",
    "a:byte",
}

world:register{
    name = "g_circle",
    "radius:float",
}

world:register{
    name = "g_rect",
    "w:float",
    "h:float",
}

world:register{
    name = "g_fill",
}

world:register{
    name = "sprite",
    "idx:int",
    "idx2:int",
}

local type_player = 0
local type_tile = 1
local type_wall = 2

world:register{
    name = "type",
    type = "int"
}

local sprites = {}
local tut_tile_idx = 0

local function init_tiles()
    for y = 1, 30 do
        for x = 1, 24 do
            local idx2 = -1

            if x == 1 or y == 1 or x == 24 then
                idx2 = 0
            end

            if x > 3 and x <= 21 and y > 4 and y <= 6 then
                idx2 = 1
            elseif x > 3 and x <= 21 and y > 6 and y <= 8 then
                idx2 = 2
            elseif x > 3 and x <= 21 and y > 8 and y <= 10 then
                idx2 = 3
            end

            if idx2 >= 0 then
                world:new{
                    pos = {x = x * block_size.w, y = y * block_size.h},
                    sprite = {idx = tut_tile_idx, idx2 = idx2},
                    type = idx2 == 0 and type_wall or type_tile,
                }
            end
        end
    end

    world:new{
        pos = {x = 0, y = 0},
        g_circle = {radius = 10},
        color = {r = 255, g = 0, b = 0, a = 255},
        g_fill = true,
        velocity = {x = 10, y = 10},
    }
end

function load()
    sprites[tut_tile_idx] = graphics.load_sprite("./assets/tut_tiles.png")

    init_tiles()
end

local function draw_system(dt)
    graphics.clear(0, 0, 128)
    graphics.set_pixel_mode(graphics.PixelMode.Mask)

    -- draw sprite
    for e in world:select"pos:in sprite:in" do
        graphics.draw_partial_sprite(
            e.pos.x,
            e.pos.y,
            sprites[e.sprite.idx],
            e.sprite.idx2 * block_size.w,
            0,
            block_size.w,
            block_size.h
        )
    end

    -- draw circle
    for e in world:select"pos:in g_circle:in color:in g_fill" do
        graphics.fill_circle(
            e.pos.x,
            e.pos.y,
            e.g_circle.radius,
            e.color.r,
            e.color.g,
            e.color.b,
            e.color.a
        )
    end

    for e in world:select"pos:in g_circle:in color:in" do
        graphics.draw_circle(
            e.pos.x,
            e.pos.y,
            e.g_circle.radius,
            e.color.r,
            e.color.g,
            e.color.b,
            e.color.a
        )
    end

    -- draw rect
    for e in world:select"pos:in g_rect:in color:in g_fill" do
        graphics.fill_rect(
            e.pos.x,
            e.pos.y,
            e.g_rect.w,
            e.g_rect.h,
            e.color.r,
            e.color.g,
            e.color.b,
            e.color.a
        )
    end

    for e in world:select"pos:in g_rect:in color:in" do
        graphics.draw_rect(
            e.pos.x,
            e.pos.y,
            e.g_rect.w,
            e.g_rect.h,
            e.color.r,
            e.color.g,
            e.color.b,
            e.color.a
        )
    end
end

local function move_system(dt)
    for e in world:select"pos:update velocity:in" do
        e.pos.x = e.pos.x + e.velocity.x * dt
        e.pos.y = e.pos.y + e.velocity.y * dt
    end
end

function update(dt)
    move_system(dt)
    draw_system(dt)
end