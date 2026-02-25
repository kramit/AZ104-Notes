# Docker Demo – NGINX + HTML5 Canvas Game

This demo shows how to package a very simple static web app (an HTML page with a small JavaScript "bouncing ball" canvas game) into a Docker image using NGINX as the web server.

## What the `dockerfile` Does

The `dockerfile` is very small:

```dockerfile
FROM nginx
COPY index.html /usr/share/nginx/html
```

- **`FROM nginx`**: Uses the official NGINX image from Docker Hub as the base. This image already contains:
  - An NGINX web server
  - A default web root at `/usr/share/nginx/html`
- **`COPY index.html /usr/share/nginx/html`**:
  - Copies your local `index.html` into the container’s NGINX web root.
  - Because `index.html` references `game.js`, you have two typical options:
    - Also copy `game.js` into the image (e.g. extend the Dockerfile), or
    - Mount the current directory into the container at runtime so NGINX can see both files.

In this folder:

- `index.html` – Simple HTML page that creates a `<canvas>` element and loads `game.js`.
- `game.js` – JavaScript that draws and animates a small green ball and responds to mouse clicks on the canvas.
- `dockerfile` – Instructions for building the NGINX-based image.
- `notes.txt` – Example `docker build` and `docker run` commands.

## Building the Image

From inside the `dockerdemo` folder, run:

```bash
docker build -t mynginx_image1 .
```

- **`-t mynginx_image1`**: Names (tags) the image `mynginx_image1`.
- **`.`**: Uses the current folder as the build context so Docker can see `dockerfile`, `index.html`, and `game.js`.

## Running the Container

To run the built image and expose it on port 80:

```bash
docker run --name mynginx3 -p 80:80 -d mynginx_image1
```

- **`--name mynginx3`**: Names the running container.
- **`-p 80:80`**: Maps host port 80 to container port 80.
- **`-d`**: Runs in detached mode.
- **`mynginx_image1`**: Uses the image you built in the previous step.

Once running, open `http://localhost` in your browser. You should see the "Hello, world!" page with the canvas game.

### Alternative: Use the Official Example Command

`notes.txt` also shows this pattern:

```bash
docker run --name some-nginx -d -p 8080:80 some-content-nginx
```

This is an example of running a pre-built image named `some-content-nginx` and mapping container port 80 to host port 8080. In this demo, you typically use your own image (`mynginx_image1`), but the command structure is the same.

## Extending the Dockerfile (Optional)

If you want the image to contain both `index.html` and `game.js` without needing any volume mounts, you can extend the Dockerfile like this:

```dockerfile
FROM nginx
COPY index.html /usr/share/nginx/html
COPY game.js /usr/share/nginx/html
```

Then rebuild:

```bash
docker build -t mynginx_image2 .
```

Run it on a different port (to avoid conflicts) if you like:

```bash
docker run --name mynginx4 -p 8080:80 -d mynginx_image2
```

Now both `index.html` and `game.js` are baked into the image.

