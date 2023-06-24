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
    name = "g_circle",
    "radius:float",
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
local tut_wall_idx = 1

function load()
    sprites[tut_tile_idx] = graphics.load_sprite("./assets/tut_tiles.png")
    sprites[tut_wall_idx] = graphics.load_sprite("./assets/tut_tile.png")

    -- init tiles
    world:new{
        pos = {x = 0, y = 0},
        sprite = {idx = tut_tile_idx, idx2 = 0},
    }

end

local function draw_system(dt)
    graphics.clear(0, 0, 128)
    graphics.set_pixel_mode(graphics.PixelMode.Mask)

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
end

function update(dt)
    draw_system(dt)
end