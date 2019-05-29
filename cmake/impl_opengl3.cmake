if(NOT IMGUI_IMPL_OPENGL3)
    return()
endif()

set(IMGUI_IMPL_OPENGL_ES "none" CACHE STRING "OpenGL ES version")
set_property(CACHE IMGUI_IMPL_OPENGL_ES PROPERTY STRINGS none 2 3)

set(IMGUI_IMPL_OPENGL_LOADER "GLEW" CACHE STRING "OpenGL Loader")
set_property(CACHE IMGUI_IMPL_OPENGL_LOADER PROPERTY STRINGS GLEW GL3W GLAD Custom)
option(IMGUI_IMPL_OPENGL_LOADER_CUSTOM "OpenGL custom loader" "")

message(STATUS "IMGUI_IMPL_OPENGL_ES: ${IMGUI_IMPL_OPENGL_ES}")
if(IMGUI_IMPL_OPENGL_ES STREQUAL 2)
    add_definitions(-DIMGUI_IMPL_OPENGL_ES2)
elseif(IMGUI_IMPL_OPENGL_ES STREQUAL 3)
    add_definitions(-DIMGUI_IMPL_OPENGL_ES3)
endif()

message(STATUS "IMGUI_IMPL_OPENGL_LOADER: ${IMGUI_IMPL_OPENGL_LOADER}")
if(${IMGUI_IMPL_OPENGL_LOADER} STREQUAL "GLEW")
    hunter_add_package(glew)
    find_package(glew CONFIG REQUIRED)

    set(IMGUI_IMPL_OPENGL_LOADER_GLEW ON)
    add_definitions(-DIMGUI_IMPL_OPENGL_LOADER_GLEW)

    list(APPEND IMGUI_IMPL_DEFINES -DIMGUI_IMPL_OPENGL_LOADER_GLEW)
    list(APPEND IMGUI_IMPL_LIBRARIES glew::glew)
elseif(${IMGUI_IMPL_LOADER} STREQUAL "GL3W")
    set(IMGUI_IMPL_OPENGL_LOADER_GL3W ON)
    add_definitions(-DIMGUI_IMPL_OPENGL_LOADER_GL3W)
elseif(${IMGUI_IMPL_LOADER} STREQUAL "GLAD")
    set(IMGUI_IMPL_OPENGL_LOADER_GLAD ON)
    add_definitions(-DIMGUI_IMPL_OPENGL_LOADER_GLAD)
else()
    set(IMGUI_IMPL_OPENGL_LOADER_CUSTOM ON)
    add_definitions(-DIMGUI_IMPL_OPENGL_LOADER_CUSTOM=${IMGUI_IMPL_OPENGL_LOADER_CUSTOM})
endif()

list(APPEND IMGUI_HEADERS
    examples/imgui_impl_opengl3.h
)
list(APPEND IMGUI_SOURCE
    examples/imgui_impl_opengl3.cpp
)
