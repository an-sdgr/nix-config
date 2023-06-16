# Dockerfile
#FROM docker.io/nixos/nix:latest
FROM docker.io/library/ubuntu:latest
RUN apt update -y
RUN apt install curl git -y
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

RUN curl -fsSL https://get.jetpack.io/devbox | bash
#RUN nix-shell -p git --command 'nix build .#nixosConfigurations.podman.config.system.build.toplevel'

# good lord, I think this is due to a mismatch with nixos-unstable and 23.05
#RUN nix profile install .#nixosConfigurations.podman.config.system.build.toplevel --extra-experimental-features 'nix-command flakes' --priority 4

# need to detect arch here
#RUN curl -L https://github.com/nix-community/nix-user-chroot/releases/download/1.2.2/nix-user-chroot-bin-1.2.2-x86_64-unknown-linux-musl --output nix-user-chroot
#RUN curl -L https://github.com/nix-community/nix-user-chroot/releases/download/1.2.2/nix-user-chroot-bin-1.2.2-aarch64-unknown-linux-musl --output nix-user-chroot

#RUN chmod +x nix-user-chroot

#RUN mkdir -m 0755 .nix
#RUN ./nix-user-chroot .nix bash -c 'curl -L https://nixos.org/nix/install | sh'

# RUN ./result/activate

