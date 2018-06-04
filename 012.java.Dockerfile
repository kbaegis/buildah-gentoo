FROM crucible.lab:4000/gentoo/libressl:latest
ARG BDATE="$(date --rfc-3339=date)"
ARG GHEAD="$(git rev-parse HEAD)"
LABEL nulllabs.build-date="$BDATE" \
nulllabs.name="java" \
nulllabs.maintainer="kbaegis@gmail.com" \
nulllabs.description="Build container for catalyst/buildah/jenkins CI" \
nulllabs.usage="https://services.home/git/NullLabs/oci/src/master/README.md" \
nulllabs.url="https://services.home/git/NullLabs/oci/src/master/README.md" \
nulllabs.vcs-url="https://services.home/git/NullLabs/oci/src/master/" \
nulllabs.vcs-ref="$GHEAD" \
nulllabs.vendor="NullLabs" \
nulllabs.version="beta-0.0.1" \
nulllabs.schema-version="1.0" \
nulllabs.docker.cmd="docker run -d --name nulllabs-java -l nulllabs.image=crucible.lab:4000/oci/java crucible.lab:4000/oci/java:latest" \
nulllabs.docker.cmd.devel="docker run -it --name nulllabs-java-tmp -l nulllabs.image=crucible.lab:4000/oci/java --entrypoint=/bin/bash crucible.lab:4000/oci/java:latest" \
nulllabs.docker.cmd.test="docker run -it --name nulllabs-java-test -l nulllabs.image=crucible.lab:4000/oci/java --rm --entrypoint=/bin/bash crucible.lab:4000/oci/java:latest" \
nulllabs.docker.cmd.debug="docker exec -it nulllabs-java bash" \
nulllabs.docker.cmd.help="docker exec -it nulllabs-java /usr/local/bin/entrypoint.sh --help" \
nulllabs.docker.params="REPO=,THREADS="
ENV PORTAGE_BINHOST="https://crucible.lab/generic" \
  PORTDIR="/usr/portage" \
  PKGDIR="/usr/portage/packages/generic" \
  FEATURES="binpkg-multi-instance" \
  MAKEOPTS="-j$THREADS" \
  EMERGE_DEFAULT_OPTS="-bg" \
  GENTOO_MIRRORS="https://crucible.lab" \
  SSL_CERT_FILE="/etc/ssl/certs/ca-certificates.crt" \
  EDITOR="/usr/bin/vi"
RUN printf 'dev-java/icedtea alsa cups -gtk headless-awt jbootstrap libressl sctp shenandoah source sunec webstart\ndev-java/icedtea-bin -gtk -webstart -alsa -cups\napp-text/ghostscript-gpl cups dbus tiff unicode\n' >> /etc/portage/package.use/java \
 && printf 'dev-java/icedtea ~amd64\n' >> /etc/portage/package.accept_keywords \
 && printf 'FEATURES="-usersandbox"\n' >> /etc/portage/env/nousersandbox.conf \
 && printf 'dev-java/icedtea nousersandbox.conf\ndev-java/maven-bin nousersandbox.conf' >> /etc/portage/package.env \
 && emerge dev-java/icedtea dev-java/maven-bin \
 && $HOME/.build/rsync.sh

ENTRYPOINT ["/bin/bash"]
