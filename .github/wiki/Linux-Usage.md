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

**Note about Wayland**

If your host uses Wayland, graphical apps may run through XWayland. The container approach above (using the X11 socket) often still works, but you may need to ensure XWayland is available on the host and that `DISPLAY` is set correctly. For Wayland-native setups you may need additional configuration (e.g., `WAYLAND_DISPLAY`) or other tooling; try the X11 approach first and fall back to software rendering if needed.

Building the image (if needed)

```bash
docker build -t raylib_container .
```

Advanced build (pull latest base layers, keep a temporary tag):

```bash
docker build --pull --rm -f 'Dockerfile' -t 'raylib_container:test' '.'
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

Parameter explanation

- **`-it`**: Starts the container in interactive mode with a terminal attached.
- **`--rm`**: Automatically removes the container when it exits.
- **`-e DISPLAY=$DISPLAY`**: Passes the host's `DISPLAY` environment variable to the container, telling it which screen to use.
- **`-v /tmp/.X11-unix:/tmp/.X11-unix`**: Mounts the host's X11 socket into the container, allowing graphical communication.
- **`-v ./user_code:/app/user_code`**: Mounts the host `user_code` directory into the container at `/app/user_code`.
- **`--device /dev/dri:/dev/dri`** (Hardware acceleration): Maps the host's Direct Rendering Infrastructure devices into the container, allowing GPU access.
- **`-e LIBGL_ALWAYS_SOFTWARE=1`** (Software rendering): Forces Mesa to use CPU rendering rather than the GPU.

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

Docker socket permissions — important security note

- **Do not** change the permissions of the Docker socket (`/var/run/docker.sock`) to `666`. That grants full access to any user and is a serious security risk.
- If you mistakenly changed permissions, restore them to the secure default:

```bash
sudo chmod 660 /var/run/docker.sock
sudo chown root:docker /var/run/docker.sock
```

The recommended, secure approach to avoid `sudo` is adding your user to the `docker` group (see above), then logging out and back in.

Troubleshooting

- "Cannot connect to the Docker daemon": verify docker group membership or use `sudo`.
- "cannot open display": ensure `xhost +local:docker` ran in the current graphical session and that `DISPLAY` is passed.
- Hardware acceleration errors (MESA/drm): try the software rendering command above.

Expanded troubleshooting

- **`docker: Cannot connect to the Docker daemon... Permission denied.`**: You likely haven't added your user to the `docker` group or didn't log out/log in after adding them. Try using `sudo docker ...` or add your user to the `docker` group and re-login.
- **`docker: invalid reference format`**: Check the image name (`raylib_container`) spelling and that the image exists (`docker images`).
- **`cannot open display: :0` / Window doesn't appear**: Make sure you ran `xhost +local:docker` in the same graphical session. Verify `DISPLAY` is exported and passed into the container (`-e DISPLAY=$DISPLAY`). On Wayland systems confirm XWayland is running.
- **MESA / drm / driver errors** (`Failed to query drm device`, `failed to create dri3 screen`, `failed to load driver: iris/radeon/...`): Hardware acceleration failed. Ensure `--device /dev/dri:/dev/dri` is passed and your host drivers are compatible. If it still fails, use the software rendering option with `-e LIBGL_ALWAYS_SOFTWARE=1`.
- **Need to rebuild image**: If the image seems outdated or corrupted, rebuild it with one of the build commands above.

For more details and platform-specific notes see [[overview]]

Wiki links: [[Home]] [[overview]] [[macOS-Compatibility]] [[Windows-Usage]]
