# Dockerfile
FROM ubuntu:latest
RUN apt update -y
RUN apt install curl -y
RUN curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install linux \
  --extra-conf "sandbox = false" \
  --init none \
  --no-confirm
ENV PATH="${PATH}:/nix/var/nix/profiles/default/bin"
COPY . /root
# copy ignores dotfiles, but flakes require a git repo
# lighter than reclone, and lets you test local changes
COPY .git /root/.git

WORKDIR /root
RUN nix-shell -p git --command 'nix build .#nixosConfigurations.docker.config.system.build.toplevel'

# RUN ./result/activate

