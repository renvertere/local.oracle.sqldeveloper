FROM fedora:39

RUN dnf -y update && \
    dnf -y install flatpak flatpak-builder bsdtar xz unzip && \
    dnf clean all

RUN flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo && \
    flatpak install -y flathub \
      org.freedesktop.Platform//23.08 \
      org.freedesktop.Sdk//23.08 \
      org.freedesktop.Sdk.Extension.openjdk17//23.08
WORKDIR /work
