if(IMGUI_IMPL_ALLEGRO5)
    list(APPEND IMGUI_HEADERS
        backends/imgui_impl_allegro5.h
)
    list(APPEND IMGUI_SOURCE
        backends/imgui_impl_allegro5.cpp
)
endif()
