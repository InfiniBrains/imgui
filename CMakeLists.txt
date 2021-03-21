cmake_minimum_required(VERSION 3.1)

if(POLICY CMP0074)
    cmake_policy(SET CMP0074 NEW)
endif()

project(imgui VERSION 1.82.1) # using patch .1 to map docking branch

if(MSVC)
    #setup pdb info
    set(pdb_output_dir "${CMAKE_CURRENT_BINARY_DIR}/pdb-files")

    set(CMAKE_PDB_OUTPUT_DIRECTORY "${pdb_output_dir}")
    set(CMAKE_COMPILE_PDB_OUTPUT_DIRECTORY "${pdb_output_dir}") 

    #need to sync pdp files
    add_compile_options("/FS")
endif()

set(IMGUI_IMPL_DEFINES)
set(IMGUI_IMPL_LIBRARIES)
set(IMGUI_IMPL_EXAMPLES)

option(IMGUI_IMPL_ALLEGRO5 "Include Allegro5 renderer" OFF)
option(IMGUI_IMPL_ANDROID "Include Android renderer" OFF)
option(IMGUI_IMPL_DIRECTX9 "Include DirectX 9 renderer" OFF)
option(IMGUI_IMPL_DIRECTX10 "Include DirectX 10 renderer" OFF)
option(IMGUI_IMPL_DIRECTX11 "Include DirectX 11 renderer" OFF)
option(IMGUI_IMPL_DIRECTX12 "Include DirectX 12 renderer" OFF)
option(IMGUI_IMPL_MARMALADE "Include Marmalade renderer" OFF)
option(IMGUI_IMPL_OPENGL2 "Include Opengl 2 renderer" OFF)
option(IMGUI_IMPL_OPENGL3 "Include Opengl 3 renderer" OFF)
option(IMGUI_IMPL_VULKAN "Include Vulkan renderer" OFF)
option(IMGUI_IMPL_METAL "Include Metal renderer" OFF)
option(IMGUI_IMPL_WGPU "Include WGPU renderer" OFF)

option(IMGUI_IMPL_GLFW "Include GLFW window manager" OFF)
option(IMGUI_IMPL_GLUT "Include GLUT window manager" OFF)
option(IMGUI_IMPL_SDL "Include SDL window manager" OFF)
option(IMGUI_IMPL_WIN32 "Include Win32 window manager" OFF)
option(IMGUI_IMPL_OSX "Include OSX window manager" OFF)

option(IMGUI_BUILD_EXAMPLES "Build imgui examples" OFF)
option(IMGUI_ENABLE_TEST_ENGINE "Build imgui tests" OFF)

set(IMGUI_HEADERS
    imconfig.h
    imgui.h
    imgui_internal.h
    imstb_rectpack.h
    imstb_textedit.h
    imstb_truetype.h
)

set(IMGUI_SOURCE
    imgui.cpp
    imgui_demo.cpp
    imgui_draw.cpp
    imgui_widgets.cpp
    imgui_tables.cpp
)

include(cmake/impl_allegro5.cmake)
include(cmake/impl_android.cmake)
include(cmake/impl_marmalade.cmake)
include(cmake/impl_directx9.cmake)
include(cmake/impl_directx10.cmake)
include(cmake/impl_directx11.cmake)
include(cmake/impl_directx12.cmake)
include(cmake/impl_opengl2.cmake)
include(cmake/impl_opengl3.cmake)
include(cmake/impl_vulkan.cmake)
include(cmake/impl_wgpu.cmake)

include(cmake/impl_glfw.cmake)
include(cmake/impl_glut.cmake)
include(cmake/impl_sdl.cmake)
include(cmake/impl_win32.cmake)
include(cmake/impl_osx.cmake)

include_directories(${CMAKE_CURRENT_LIST_DIR})

add_library(imgui ${IMGUI_HEADERS} ${IMGUI_SOURCE})

if(IMGUI_ENABLE_TEST_ENGINE)
    set(IMGUI_IMPL_DEFINES ${IMGUI_IMPL_DEFINES} -DIMGUI_ENABLE_TEST_ENGINE)
endif()

target_compile_definitions(imgui PUBLIC ${IMGUI_IMPL_DEFINES})
target_link_libraries(imgui ${IMGUI_IMPL_LIBRARIES})

if(IMGUI_BUILD_EXAMPLES)
    add_subdirectory(examples)
endif()

#Install imgui
# Introduce variables:
# * CMAKE_INSTALL_LIBDIR
# * CMAKE_INSTALL_BINDIR
# * CMAKE_INSTALL_INCLUDEDIR
include(GNUInstallDirs)

#install config path
set(GENERATED_DIR "${CMAKE_CURRENT_BINARY_DIR}/generated")
set(INSTALL_CONFIGDIR "${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}")
set(VERSION_CONFIG "${GENERATED_DIR}/${PROJECT_NAME}ConfigVersion.cmake")
set(PROJECT_CONFIG "${GENERATED_DIR}/${PROJECT_NAME}Config.cmake")
set(TARGETS_EXPORT_NAME "${PROJECT_NAME}Targets")
set(NAMESPACE "${PROJECT_NAME}::")

#install header files
install(FILES ${IMGUI_HEADERS} 
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

#build and install project config
include(CMakePackageConfigHelpers)
configure_package_config_file(
    "cmake/Config.cmake.in"
    "${PROJECT_CONFIG}"
    INSTALL_DESTINATION "${INSTALL_CONFIGDIR}"
)

#build config version into bin directory
write_basic_package_version_file(
    "${VERSION_CONFIG}"
    COMPATIBILITY AnyNewerVersion
    
)

#install target
install(
    TARGETS imgui
    EXPORT "${TARGETS_EXPORT_NAME}"
    LIBRARY DESTINATION "${CMAKE_INSTALL_LIBDIR}"
    ARCHIVE DESTINATION "${CMAKE_INSTALL_LIBDIR}"
    RUNTIME DESTINATION "${CMAKE_INSTALL_BINDIR}"
    INCLUDES DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}"
)

#install files
install(
    FILES 
        "${VERSION_CONFIG}"
        "${PROJECT_CONFIG}"
    DESTINATION ${INSTALL_CONFIGDIR}
)

install(
    EXPORT "${TARGETS_EXPORT_NAME}"
    NAMESPACE "${NAMESPACE}"
    DESTINATION "${INSTALL_CONFIGDIR}"
)

if(MSVC)
    #install pdbs
    get_cmake_property(is_multi GENERATOR_IS_MULTI_CONFIG)

    if(is_multi)
      set(config_suffix "$<CONFIG>")
    else()
      set(config_suffix "")
    endif() 

    if(BUILD_SHARED_LIBS)
      set(pdb_dst ${CMAKE_INSTALL_BINDIR})
    else()
      set(pdb_dst ${CMAKE_INSTALL_LIBDIR})
    endif() 

    install(
        DIRECTORY "${pdb_output_dir}/${config_suffix}/"
        DESTINATION ${pdb_dst}
    )
endif()
