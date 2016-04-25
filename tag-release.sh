#!/usr/bin/env bash

set -e

VERSION="$1"

if [ -z "$VERSION" ] || [ "$VERSION" = '-h' ] || [ "$VERSION" = '--help' ]
then
  echo "usage:	$0 version"
  echo '	Create a tagged version release.'
  echo
  echo '	Modifies the Dockerfile to use a specific base image tag, creates a'
  echo '	Git commit with message "Tag release version", tags the commit with'
  echo '	tag version, and resets to the current commit.'
  exit 1
fi

if git rev-parse "$VERSION" >/dev/null 2>&1
then
  echo "Tag ${VERSION} already exists. If you wish to replace it, please delete"
  echo 'it and run this script again.'
  exit 2
fi

DOCKER_REGISTRY='https://index.docker.io/v1'
DOCKER_IMAGE='openshift/origin-haproxy-router'

echo "Validating that upstream image ${DOCKER_IMAGE}:${VERSION} exists."
echo

if ! curl -sf "${DOCKER_REGISTRY}/repositories/${DOCKER_IMAGE}/tags/${VERSION}" -o /dev/null
then
  echo "Tag ${VERSION} does not exist in the upstream image. Please specify"
  echo 'a valid upstream image.'
  exit 3
fi

sed "s/FROM.*/&:${VERSION}/" Dockerfile >Dockerfile.2
mv Dockerfile.2 Dockerfile

git add Dockerfile
git commit -qm "Tag version $VERSION"
git tag "$VERSION"
git show
git reset -q HEAD~
git checkout Dockerfile

echo
echo "Tag $VERSION created. You can now push it to origin with:"
echo "	git push origin ${VERSION}"
