# RayLib 游戏开发环境

> 来源：https://github.com/gm64x/RayLibContainer
> 用途：代码标注训练素材

## 项目简介

这是一个容器化的 RayLib 游戏开发环境，预装了：
- RayLib 图形库
- GCC/C++ 编译工具链
- 示例项目 (raylib-quickstart)

## Docker 使用

` ` `bash
# 构建镜像
docker build -t raylib-env .

# 运行容器并进入开发环境
docker run -it --rm raylib-env /bin/bash

# 编译示例项目
cd /app
make

# 运行示例程序（需要 X11 支持）
./raylib_quickstart
` ` `

## 目录结构

- `/app` - 工作目录，包含示例项目
- `/app/user_code` - 挂载你自己的代码

## 许可证

MIT License