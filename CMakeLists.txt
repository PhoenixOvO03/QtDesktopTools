cmake_minimum_required(VERSION 3.16)

project(QtDesktopTools VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS
    Widgets
    Quick
    QuickWidgets
    Network
)

set(PROJECT_SOURCES
    src/main.cpp
    # 窗口
    src/desktopwidget.h src/desktopwidget.cpp
    # 工具
    utils/keyboardlistener.h utils/keyboardlistener.cpp
    utils/socketlistener.h utils/socketlistener.cpp
    utils/cachemanager.h utils/cachemanager.cpp
)

INCLUDE_DIRECTORIES(
    ${PROJECT_SOURCE_DIR}
)

qt_add_executable(QtDesktopTools
    MANUAL_FINALIZATION
    ${PROJECT_SOURCES}
    res.qrc
    qml.qrc
    cache.qrc
)

target_link_libraries(QtDesktopTools PRIVATE
    Qt6::Widgets
    Qt6::Quick
    Qt6::QuickWidgets
    Qt6::Network
)

set_target_properties(QtDesktopTools PROPERTIES
    ${BUNDLE_ID_OPTION}
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    # 日志打印到控制台 为OFF 取消为ON
    # WIN32_EXECUTABLE ON
    WIN32_EXECUTABLE OFF
)

include(GNUInstallDirs)
install(TARGETS QtDesktopTools
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

qt_finalize_executable(QtDesktopTools)
