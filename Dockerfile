# syntax = docker/dockerfile:experimental
#
# Requires Docker v18.06 or later and BuildKit mode to use cache mount
# Docker v18.06 also requires the daemon to be running in experimental mode.
#
# $ DOCKER_BUILDKIT=1 docker build .
#
# See https://github.com/moby/buildkit/blob/master/frontend/dockerfile/docs/experimental.md

FROM registry.gitlab.com/pld-linux/pld AS base

FROM base AS sphinx
WORKDIR /sphinx

RUN --mount=type=cache,target=/var/cache/poldek \
	set -x \
	&& poldek -u wget
RUN wget carme.pld-linux.org/~glen/th/x86_64/sphinx-2.0.10-1.1.x86_64.rpm
RUN poldek --mkidx -s .

FROM base AS runtime

COPY --from=sphinx /sphinx /usr/src/sphinx
RUN --mount=type=cache,target=/var/cache/poldek \
	set -x \
	&& poldek --up -u --noask \
		-s /usr/src/sphinx/ -n th \
		sphinx-2.0.10-1.1.x86_64 \
	&& poldek --clean-whole \
	&& exit 0
