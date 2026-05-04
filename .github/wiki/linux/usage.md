# Using the Raylib Container (Linux)

<!-- toc start open="true" depthStart="2" --><!-- toc end -->
<!-- backlinks start open="true" --><!-- backlinks end -->

Quick reference for running the Raylib Docker container on Linux.

Home: [[Home]]

Prerequisites

- Allow containers to access the display:

```bash
# Allow connections from Docker on the current graphical session
xhost +local:docker
```

- (Optional) Add your user to the `docker` group to avoid `sudo`:

```bash
sudo usermod -aG docker $USER
```

Building the image (if needed)

```bash
docker build -t raylib_container .
```

Running the container

Hardware-accelerated (recommended):

```bash
docker run -it --rm \
  -e DISPLAY=$DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v ./user_code:/app/user_code \
  --device /dev/dri:/dev/dri \
  raylib_container
```

Software rendering (fallback):

```bash
docker run -it --rm \
  -e DISPLAY=$DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v ./user_code:/app/user_code \
  -e LIBGL_ALWAYS_SOFTWARE=1 \
  raylib_container
```

Verify graphics connection

Inside the container, run:

```bash
xeyes
```

Developing inside the container

Place your source in the host `user_code` directory (mounted as `/app/user_code`). Example compile inside the container:

```bash
cd /app/user_code
gcc my_game.c -o my_game -lraylib -lGL -lm -lpthread -ldl -lrt -lX11
./my_game
```

Reverting host changes

- Revoke display access: `xhost -local:docker`
- Remove user from docker group (if added): `sudo gpasswd -d $USER docker`

Troubleshooting

- "Cannot connect to the Docker daemon": verify docker group membership or use `sudo`.
- "cannot open display": ensure `xhost +local:docker` ran in the current graphical session and that `DISPLAY` is passed.
- Hardware acceleration errors (MESA/drm): try the software rendering command above.

For more details and platform-specific notes see [overview.md](../overview.md).

Wiki links: [[Home]] [[overview]] [[macos/compatibility]] [[windows/usage]]
