#!/usr/bin/env sh

RELEASE=${GIT_TAG:-$1}

if [ -z "${RELEASE}" ]; then
  echo "Usage:"
  echo "./scripts/release-notes.sh v0.1.0"
  exit 1
fi

if ! git rev-list ${RELEASE} >/dev/null 2>&1; then
  echo "${RELEASE} does not exist"
  exit
fi

PREV_RELEASE=${PREV_RELEASE:-$(git describe --tags --abbrev=0 ${RELEASE}^)}
PREV_RELEASE=${PREV_RELEASE:-$(git rev-list --max-parents=0 ${RELEASE}^)}
NOTABLE_CHANGES=$(git cat-file -p ${RELEASE} | sed '/-----BEGIN PGP SIGNATURE-----/,//d' | tail -n +6)
CHANGELOG=$(git log --no-merges --pretty=format:'- [%h] %s (%aN)' ${PREV_RELEASE}..${RELEASE})
if [ $? -ne 0 ]; then
  echo "Error creating changelog"
  exit 1
fi

cat <<EOF
${NOTABLE_CHANGES}

## Docker Images for pieewiee/bind:${RELEASE}

- [docker.io](https://hub.docker.com/r/pieewiee/bind/tags)
## Installation

For installation and usage instructions please refer to the [README](https://github.com/pieewiee/docker-bind/blob/${RELEASE}/README.md)

## Contributing

If you find this image useful here's how you can help:

- Send a Pull Request with your awesome new features and bug fixes
- Be a part of the community and help resolve [issues](https://github.com/pieewiee/docker-bind/issues)

## Changelog

${CHANGELOG}
EOF
