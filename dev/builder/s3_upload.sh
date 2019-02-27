#!/bin/bash
# Upload ckeditor build to an s3 bucket

set -e

echo "CKS3Uplaod - Upload the built version of ckeditor to a S3 bucket."
echo ""

# Move to the script directory.
cd $(dirname $0)

VERSION=$(grep '"version":' ./../../package.json | sed $'s/[\t\",: ]//g; s/version//g' | tr -d '[[:space:]]')
CK_PATH="ckeditor"
RELEASE=release/ckeditor

# Arguments
usage() { echo "Usage: $0 - using version from package.json [-b <S3 bucket> -p <path under the S3 bucket, default: ckeditor>]" 1>&2; exit 1; }

while getopts "b:p:" opt; do
  case $opt in
    b)
      BUCKET=${OPTARG}
      ;;
    p)
      CK_PATH=${OPTARG}
      ;;
    \?)
      usage
      ;;
  esac
done
shift $((OPTIND-1))

if [ -z "$BUCKET" ]
then
  echo "Missing S3 bucket argument"
  echo
  usage
fi

echo "Upload version $VERSION of ckeditor to S3 bucket '$BUCKET' under the path '$CK_PATH'"
echo "Full path: $BUCKET/$CK_PATH/$VERSION"
echo

read -p "Continue with upload?" -n 1 -r
echo

if [[ ! $REPLY =~ ^[Yy]$ ]]
then
  echo "Not uploading!"
else
  aws s3 cp --recursive $RELEASE/ $BUCKET/$CK_PATH/$VERSION/
fi
