vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO osrf/gazebo
    REF gazebo11_11.7.0
    SHA512 9308b00b573d59b33b89b6b3a123107d36ed89ee93451be0c17e3af6279f74562ecb0f325d01709f02786724f03de4a4f008ff90578d9a1ef40ef7f119fc0891
    HEAD_REF gazebo11
    PATCHES
        0001-Fix-build.patch
)

vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        openal    HAVE_OPENAL
        simbody   SIMBODY_FEATURE
        dart      DART_FEATURE
        ffmpeg    FFMPEG_FEATURE
        gts       GTS_FEATURE
        bullet    BULLET_FEATURE
    INVERTED_FEATURES
        libusb    NO_LIBUSB_FEATURE
        gdal      NO_GDAL_FEATURE
        graphviz  NO_GRAPHVIZ_FEATURE
)

vcpkg_add_to_path("${VCPKG_ROOT_DIR}/packages/protobuf_${TARGET_TRIPLET}/debug/bin")
vcpkg_add_to_path("${VCPKG_ROOT_DIR}/packages/protobuf_${TARGET_TRIPLET}/bin")
vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        -DPKG_CONFIG_EXECUTABLE="${CURRENT_INSTALLED_DIR}/tools/pkgconf/pkgconf.exe"
        -DGRAPHVIZ_GVC_PKG_INCLUDE_DIRS="${VCPKG_ROOT_DIR}/packages/graphviz_${TARGET_TRIPLET}/include/graphviz"
        ${FEATURE_OPTIONS}
    OPTIONS_RELEASE -DGRAPHVIZ_GVC_PKG_LIBRARY_DIRS="${VCPKG_ROOT_DIR}/packages/graphviz_${TARGET_TRIPLET}/lib"
    OPTIONS_DEBUG -DGRAPHVIZ_GVC_PKG_LIBRARY_DIRS="${VCPKG_ROOT_DIR}/packages/graphviz_${TARGET_TRIPLET}/debug/lib"
)

vcpkg_install_cmake()
vcpkg_fixup_cmake_targets(CONFIG_PATH lib/cmake/gazebo)

vcpkg_copy_tools(
    TOOL_NAMES gazebo gz gzclient gzserver
    AUTO_CLEAN
)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include" "${CURRENT_PACKAGES_DIR}/debug/share")

# # Handle copyright
file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/gazebo11 RENAME copyright)
