set(BUILD_PYTHON_VERSIONS)

if("python2" IN_LIST FEATURES)
    # Find Python2 libraries. Can't use find_package here, but we already know where everything is
    file(GLOB VCPKG_PYTHON2_INCLUDE "${CURRENT_INSTALLED_DIR}/include/python2.*")
    set(VCPKG_PYTHON2_LIBS_RELEASE "${CURRENT_INSTALLED_DIR}/lib")
    set(VCPKG_PYTHON2_LIBS_DEBUG "${CURRENT_INSTALLED_DIR}/debug/lib")
    string(REGEX REPLACE ".*python([0-9\.]+).*" "\\1" VCPKG_PYTHON2_VERSION "${VCPKG_PYTHON2_INCLUDE}")
    list(APPEND BUILD_PYTHON_VERSIONS "${VCPKG_PYTHON2_VERSION}")
endif()

if("python3" IN_LIST FEATURES)
    # Find Python3 libraries. Can't use find_package here, but we already know where everything is
    file(GLOB VCPKG_PYTHON3_INCLUDE "${CURRENT_INSTALLED_DIR}/include/python3.*")
    set(VCPKG_PYTHON3_LIBS_RELEASE "${CURRENT_INSTALLED_DIR}/lib")
    set(VCPKG_PYTHON3_LIBS_DEBUG "${CURRENT_INSTALLED_DIR}/debug/lib")
    string(REGEX REPLACE ".*python([0-9\.]+).*" "\\1" VCPKG_PYTHON3_VERSION "${VCPKG_PYTHON3_INCLUDE}")
    list(APPEND BUILD_PYTHON_VERSIONS "${VCPKG_PYTHON3_VERSION}")
endif()

# Find system Python library
find_package(Python COMPONENTS Interpreter Development)
if(Python_FOUND)
    list(APPEND BUILD_PYTHON_VERSIONS "${Python_VERSION_MAJOR}.${Python_VERSION_MINOR}")
    set(VCPKG_PYTHON_VERSION "${Python_VERSION_MAJOR}.${Python_VERSION_MINOR}")
    set(VCPKG_PYTHON_INCLUDE "${Python_INCLUDE_DIRS}")
    set(VCPKG_PYTHON_LIBS "${Python_LIBRARY_DIRS}")
endif()

string(REPLACE ";" "," BUILD_PYTHON_VERSIONS "${BUILD_PYTHON_VERSIONS}")

list(APPEND B2_OPTIONS
    python=${BUILD_PYTHON_VERSIONS}
)
if(VCPKG_CXX_FLAGS_DEBUG MATCHES "BOOST_DEBUG_PYTHON")
    list(APPEND B2_OPTIONS_DBG
        python-debugging=on
    )
endif()
