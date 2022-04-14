ROS2_PACKAGES = " \
    ros-base \
    examples-rclcpp-minimal-action-client \
    examples-rclcpp-minimal-action-server \
    examples-rclcpp-minimal-client \
    examples-rclcpp-minimal-composition \
    examples-rclcpp-minimal-publisher \
    examples-rclcpp-minimal-service \
    examples-rclcpp-minimal-subscriber \
    examples-rclcpp-minimal-timer \
    examples-rclcpp-multithreaded-executor \
    examples-rclpy-executors \
    examples-rclpy-minimal-action-client \
    examples-rclpy-minimal-action-server \
    examples-rclpy-minimal-client \
    examples-rclpy-minimal-publisher \
    examples-rclpy-minimal-service \
    examples-rclpy-minimal-subscriber \
    demo-nodes-cpp \
    demo-nodes-cpp-rosnative \
    demo-nodes-py \
    cyclonedds \
    rmw-cyclonedds-cpp \
    python3-argcomplete \
    glibc-utils \
    localedef \
    rt-tests \
    stress \
    xrt-dev \
    xrt \
    zocl \
    opencl-headers-dev \
    opencl-clhpp-dev \
"

FEATURE_PACKAGES_petalinux-ros2 ?= "${ROS2_PACKAGES}"
