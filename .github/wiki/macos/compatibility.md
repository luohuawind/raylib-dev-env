## MacOSX Compatibility for Raylib Docker Container

<!-- toc start open="true" depthStart="2" --><!-- toc end -->
<!-- backlinks start open="true" --><!-- backlinks end -->

To run graphical applications within a Docker container on macOS you need an X server and a few configuration steps.

Home: [[Home]]

1. Install XQuartz from https://www.xquartz.org/ and log out / log back in.

2. In XQuartz Preferences → Security, enable "Allow connections from network clients".

3. Allow local connections from Docker (on the host):

```bash
xhost + 127.0.0.1
```

4. Run the container (example):

```bash
docker run -it --rm \
  -e DISPLAY=127.0.0.1:0 \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v ./user_code:/app/user_code \
  raylib_container
```

5. Verify inside the container with `xeyes`.

Notes

- Ensure XQuartz is running before starting the container.
- If graphical output fails, double-check XQuartz security settings and that the `DISPLAY` is correct.

If you need troubleshooting help, see the repository README or open an issue.

Wiki links: [[Home]] [[overview]] [[linux/usage]] [[windows/usage]]
