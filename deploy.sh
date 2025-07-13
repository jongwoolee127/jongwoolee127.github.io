#!/bin/bash

# Exit immediately on error
set -e

SOURCE_BRANCH="master"
DEPLOY_BRANCH="gh-pages"
BUILD_DIR="_site"
REPO_URL="https://github.com/jongwoolee127/jongwoolee127.github.io.git"
# Timestamped header
TIMESTAMP="🚀 Deploy $(date '+%y-%m-%d %H:%M:%S')"
# Optional message
CUSTOM_MSG="$1"

# Final commit message
if [ -z "$CUSTOM_MSG" ]; then
  COMMIT_MSG="$TIMESTAMP"
else
  COMMIT_MSG="$TIMESTAMP

$CUSTOM_MSG"
fi

echo "📍 Switching to $SOURCE_BRANCH branch..."
git checkout $SOURCE_BRANCH

echo "🔨 Building Jekyll site..."
bundle exec jekyll build

echo "🧹 Cleaning old Git history..."
rm -rf $BUILD_DIR/.git

echo "📦 Preparing deployment to $DEPLOY_BRANCH..."
cd $BUILD_DIR
git init

if ! git remote get-url origin &> /dev/null; then
  git remote add origin $REPO_URL
fi

git checkout -b $DEPLOY_BRANCH || git checkout $DEPLOY_BRANCH


git add .
git commit -m "$COMMIT_MSG"
git push -f origin $DEPLOY_BRANCH

cd ..

echo "🔁 Switching back to $SOURCE_BRANCH..."
git checkout $SOURCE_BRANCH

echo "✅ Deployment complete!"

