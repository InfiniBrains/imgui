if(IMGUI_IMPL_METAL)
    list(APPEND IMGUI_HEADERS
        backends/imgui_impl_metal.h
)
    list(APPEND IMGUI_SOURCE
        backends/imgui_impl_metal.mm
)
endif()
