# Copyright (C) 2023 Advanced Micro Devices, Inc.  All rights reserved.

# | -- Configuring done
# | CMake Error in CMakeLists.txt:
# |   Imported target "control_msgs::control_msgs__rosidl_generator_py" includes
# |   non-existent path
# |
# |     "/tmp/sandeepg/yocto/build-kr260-stater-kit/work/cortexa72-cortexa53-xilinx-linux/hardware-interface/2.5.0-2-r0/recipe-sysroot-native/usr/lib/python3.10/site-packages/numpy/core/include"
# |
# |   in its INTERFACE_INCLUDE_DIRECTORIES.  Possible reasons include:
# |
# |   * The path was deleted, renamed, or moved to another location.
# |
# |   * An install or uninstall procedure did not complete successfully.
# |
# |   * The installation package was faulty and references files it does not
# |   provide.
# |
# |
# |
# | -- Generating done
# | CMake Warning:
# |   Manually-specified variables were not used by the project:
# |
# |     CMAKE_EXPORT_NO_PACKAGE_REGISTRY
# |     CMAKE_INSTALL_BINDIR
# |     CMAKE_INSTALL_DATAROOTDIR
# |     CMAKE_INSTALL_INCLUDEDIR
# |     CMAKE_INSTALL_LIBDIR
# |     CMAKE_INSTALL_LIBEXECDIR
# |     CMAKE_INSTALL_LOCALSTATEDIR
# |     CMAKE_INSTALL_SBINDIR
# |     CMAKE_INSTALL_SHAREDSTATEDIR
# |     CMAKE_INSTALL_SYSCONFDIR
# |     FETCHCONTENT_FULLY_DISCONNECTED
# |     LIB_SUFFIX
# |     PYTHON_EXECUTABLE
# |     PYTHON_SOABI
# |     Python_EXECUTABLE
# |
# |
# | CMake Generate step failed.  Build files cannot be regenerated correctly.

ROS_BUILDTOOL_DEPENDS += " \
    ament-cmake-ros-native \
    python3-numpy-native \
"

