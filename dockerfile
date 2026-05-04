# Stage 1: Builder (编译阶段)
FROM alpine:latest AS builder
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories
RUN apk update && apk upgrade && \
    apk add --no-cache \
    git cmake make gcc g++ linux-headers \
    mesa-dev alsa-lib-dev libx11-dev libxrandr-dev libxinerama-dev libxcursor-dev libxi-dev && \
    rm -rf /var/cache/apk/*

WORKDIR /tmp

# 复制本地已下载的 raylib 源码
COPY ./raylib /tmp/raylib

# 编译安装 raylib
RUN cd raylib && mkdir build && cd build && \
    cmake .. -DCMAKE_BUILD_TYPE=Release -DPLATFORM=Desktop -DBUILD_SHARED_LIBS=ON -DCMAKE_INSTALL_PREFIX=/usr/local && \
    make -j$(nproc) && make install

# 复制本地已下载的 raylib-quickstart 示例项目
COPY ./raylib-quickstart /tmp/raylib-quickstart

# ----------------------------------------------------------------------
# Stage 2: Runtime (运行环境)
FROM alpine:latest

# 使用清华大学 Alpine 镜像源
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories

# 安装运行时库和开发工具
RUN apk update && apk upgrade && \
    apk add --no-cache \
    mesa-gl alsa-lib libx11 mesa-dev libx11-dev libxrandr libxinerama libxcursor libxi \
    xeyes gcc g++ make git bash && \
    rm -rf /var/cache/apk/*

# 从构建阶段复制编译好的 raylib 库
COPY --from=builder /usr/local /usr/local

# 工作目录设置为 /app
WORKDIR /app

# 将示例项目复制到 /app
COPY --from=builder /tmp/raylib-quickstart /app

# 初始化 Git 仓库并提交（符合规范要求）
RUN git init && \
    git config user.email "agent@local" && \
    git config user.name "CodeAgent" && \
    git add . && \
    git commit -m "Initial state: Raylib quickstart project"

# 用户代码挂载点
VOLUME ["/app/user_code"]