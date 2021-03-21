if(IMGUI_IMPL_GLFW)
    hunter_add_package(glfw)
    find_package(glfw3 REQUIRED)

    add_definitions(-DIMGUI_IMPL_GLFW)

    list(APPEND IMGUI_IMPL_DEFINES ${IMGUI_IMPL_DEFINES} -DIMGUI_IMPL_GLFW)
    list(APPEND IMGUI_IMPL_LIBRARIES ${IMGUI_IMPL_LIBRARIES} glfw)

    list(APPEND IMGUI_HEADERS
        backends/imgui_impl_glfw.h
)
    list(APPEND IMGUI_SOURCE
        backends/imgui_impl_glfw.cpp
)
endif()
