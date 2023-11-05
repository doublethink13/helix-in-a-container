# helix-in-a-container

This project allows running the [Helix](https://helix-editor.com/) editor inside a container using [Zellij](https://zellij.dev/) as the terminal workspace.

This container comes included with some tools, please check the [Dockerfile](./.helix/Dockerfile) for additional information.

- dockerfile-language-server
- gitui
- go
- go dlv
- gopls
- helix
- marksman
- node
- nvm
- prettier
- pyenv
- python
- taplo
- zellij

For this to work, we need to copy the `.helix` folder to the workspace root. Then, we need to add the following code to `.bashrc`:

```bash
hxd_build() {
  if [ "$1" == "new" ]; then
    docker rm $NAME

    docker build \
      --build-arg WORKSPACE=$WORKSPACE \
      --tag $NAME \
      -f .helix/Dockerfile \
      .helix/
  fi
}

hxd_run() {
  if [ "$1" == "new" ]; then
    docker run \
      --volume $(pwd):/workspaces/$WORKSPACE \
      --volume $HOME/.ssh:/root/.ssh \
      --volume /tmp/.X11-unix:/tmp/.X11-unix \
      --env DISPLAY=$DISPLAY \
      -it \
      --name $NAME \
      $NAME
  else
    docker start -i $NAME
  fi
}

hxd(){
  set -e

  WORKSPACE=$(basename $(pwd))
  NAME=hxd-$WORKSPACE

  hxd_build $1
  hxd_run $1

  set +e
}
```

Finally, we can run `hxd` in the workspace root. This will launch the expected container. Note that it mounts the user's `.ssh` folder into the container, as well as the `x11` socket (so that we are able to copy to the host's clipboard).

If the `Dockerfile` changes, we can run `hxd new` to rebuild the container.
