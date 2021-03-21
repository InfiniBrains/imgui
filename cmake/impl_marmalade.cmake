if(IMGUI_IMPL_MARMALADE)
    list(APPEND IMGUI_HEADERS
        backends/imgui_impl_marmalade.h
)
    list(APPEND IMGUI_SOURCE
        backends/imgui_impl_marmalade.cpp
)
endif()
