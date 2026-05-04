# Windows (Notes)

<!-- toc start open="true" depthStart="2" --><!-- toc end -->
<!-- backlinks start open="true" --><!-- backlinks end -->

This folder provides a placeholder for Windows-specific notes.

Home: [[Home]]

Short guidance:

- Use Docker Desktop for Windows.
- Install an X server on the host (for example, VcXsrv or Xming) if you need to forward X11 GUI from the container.
- Start the X server and allow connections from local addresses, then run the container and set `DISPLAY` accordingly (for example `host.docker.internal:0.0` or `127.0.0.1:0` depending on your setup).

Example (may vary by setup):

```bash
# Start X server on Windows host first
docker run -it --rm \
  -e DISPLAY=host.docker.internal:0.0 \
  -v ./user_code:/app/user_code \
  raylib_container
```

Windows instructions are environment-dependent. If you want, I can expand these steps with a tested workflow for your environment.

Wiki links: [[Home]] [[overview]] [[linux/usage]] [[macos/compatibility]]
