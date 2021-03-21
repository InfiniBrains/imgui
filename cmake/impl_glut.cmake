if(IMGUI_IMPL_GLUT)
    list(APPEND IMGUI_HEADERS
        backends/imgui_impl_glut.h
)
    list(APPEND IMGUI_SOURCE
        backends/imgui_impl_glut.cpp
)
endif()
