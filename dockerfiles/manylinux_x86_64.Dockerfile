# We build our portable linux releases on the manylinux (RHEL-based)
# images, with custom additional packages installed.
# TODO(https://github.com/pypa/manylinux/issues/1306): replace with official multi-platform images
#   This should instead be:
#     ```
#     FROM quay.io/pypa/manylinux_2_28
#     ARG TARGETARCH
#     ARG TARGETPLATFORM
#     ```
#
# Build for x86_64 (amd64) with:
#     sudo docker buildx build --file dockerfiles/manylinux_x86_64.Dockerfile . --tag manylinux:latest
# Build for aarch64 with:
#     sudo docker buildx build --file dockerfiles/manylinux_x86_64.Dockerfile . --tag manylinux:latest --build-arg TARGET_ARCHITECTURE=aarch64 --platform linux/arm64
ARG TARGET_ARCHITECTURE=x86_64
FROM quay.io/pypa/manylinux_2_28_${TARGET_ARCHITECTURE}

RUN yum install -y epel-release && \
    yum install -y ccache clang lld && \
    yum install -y capstone-devel tbb-devel libzstd-devel && \
    yum install -y rust cargo && \
    yum clean all && \
    rm -rf /var/cache/yum

######## GIT CONFIGURATION ########
# Git started enforcing strict user checking in 2.35.3, which thwarts version
# configuration scripts in a docker image where the tree was checked out by the
# host and mapped in.
# We use the wildcard option to disable the checks globally.
RUN git config --global --add safe.directory '*'
