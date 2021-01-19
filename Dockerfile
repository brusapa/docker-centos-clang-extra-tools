# Stage 1, builder
FROM centos:centos7 as builder
# Compile llvm
RUN yum install -y epel-release && \
    yum install -y centos-release-scl wget ninja-build git python3 cmake3 && \
    ln -s /usr/bin/cmake3 /usr/bin/cmake && \
    yum update -y && \
    yum install -y devtoolset-7 && \
    source /opt/rh/devtoolset-7/enable && \
    cd /tmp && \
    git clone https://github.com/llvm/llvm-project.git && \
    mkdir llvm-project/build && \
    cd llvm-project/build && \
    cmake -G "Ninja" -DLLVM_ENABLE_PROJECTS="clang;clang-tools-extra" -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/tmp/clang-install ../llvm && \
    ninja install

# Stage 2, produce minimal release image with build results
FROM centos:centos7
# Copy build results of stage 1 to /usr/local
COPY --from=builder /tmp/clang-install/ /usr/local/