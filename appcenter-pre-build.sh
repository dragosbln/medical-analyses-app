#!/usr/bin/env bash

# Check platform
if [ -z "$APP_CENTER_CURRENT_PLATFORM" ]
then
    echo "❌ You need define the APP_CENTER_CURRENT_PLATFORM variable in App Center with values android or ios"
    exit
fi

PROJECT_NAME=MedicalAnalysesApp
ANDROID_GRADLE_PROPERTIES_FILE=$APPCENTER_SOURCE_DIRECTORY/android/app/gradle.properties
INFO_PLIST_FILE=$APPCENTER_SOURCE_DIRECTORY/ios/$PROJECT_NAME/Info.plist

# Set version code
if [ -z "$INITIAL_VERSION_CODE" ]
then
    echo "❌ You need define the INITIAL_VERSION_CODE variable in App Center \n"
    echo "Example: INITIAL_VERSION_CODE = 93 if my build number when I moved the app to AppCenter was 93"
    exit
else
  # APPCENTER_BUILD_ID -	The unique identifier for the current build
  VERSION_CODE=$((INITIAL_VERSION_CODE + APPCENTER_BUILD_ID))
  if [ "$APP_CENTER_CURRENT_PLATFORM" == "ios" ]
  then
    echo "Incrementing iOS VERSION_CODE in $INFO_PLIST_FILE"
    plutil -replace CFBundleVersion -string $VERSION_CODE $INFO_PLIST_FILE
  else
    echo "Incrementing Android VERSION_CODE in $ANDROID_GRADLE_PROPERTIES_FILE"
    sed -i "" 's/VERSION_CODE=[0-9]*/VERSION_CODE='$VERSION_CODE'/' $ANDROID_GRADLE_PROPERTIES_FILE
    cat $ANDROID_GRADLE_PROPERTIES_FILE
  fi
  echo "✅ Incremented VERSION_CODE to ${VERSION_CODE}"
fi

# Set version name
if [ -z "$VERSION_NAME" ]
then
  echo "💡Tip: You can define the VERSION_NAME variable in App AppCenter"
  echo "Example: VERSION_NAME = 1.2.0"
else
  if [ "$APP_CENTER_CURRENT_PLATFORM" == "ios" ]
  then
    echo "Changing iOS VERSION_NAME in $INFO_PLIST_FILE"
    plutil -replace CFBundleShortVersionString -string $VERSION_NAME $INFO_PLIST_FILE
  else
    echo "Changing Android VERSION_NAME in $ANDROID_GRADLE_PROPERTIES_FILE"
    sed -i '' 's/VERSION_NAME=[0-9.]*/VERSION_NAME='$VERSION_NAME'/' $ANDROID_GRADLE_PROPERTIES_FILE
    cat $ANDROID_GRADLE_PROPERTIES_FILE
  fi
  echo "✅ Changed VERSION_NAME to ${VERSION_NAME}"
fi

# Set ENVFILE
if [ -z "$RELEASE_ENV" ]
then
  echo "💡Tip: You can define the RELEASE_ENV variable in App AppCenter"
  echo "It creates an .env from existing .env files for use with react-native-config"
  echo "Example: RELEASE_ENV = production"
  echo "Default value is staging"
else
  if [ "$RELEASE_ENV" == "production" ]
  then
    echo "Setting PRODUCTION environment"
    npx @around25/ncrypt -m "decrypt" -f ".env.production" -p $RELEASE_ENV_KEY
    cp .env.production .env
  else
    echo "Setting STAGING environment"
    npx @around25/ncrypt -m "decrypt" -f ".env.staging" -p $RELEASE_ENV_KEY
    cp .env.staging .env
  fi
  echo "✅ Environment set to ${RELEASE_ENV}"
fi
