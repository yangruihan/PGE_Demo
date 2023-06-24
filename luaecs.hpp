#pragma once

extern "C" {
#include "libs/luaecs/luaecs.h"

int luaopen_ecs_core(lua_State *L);
}