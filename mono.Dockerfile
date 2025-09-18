ARG IMAGE="mcr.microsoft.com/dotnet/sdk:9.0-noble"
FROM $IMAGE
LABEL author="https://github.com/aBARICHELLO/godot-ci/graphs/contributors"

USER root
SHELL ["/bin/bash", "-c"]
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    git \
    git-lfs \
    unzip \
    wget \
    zip \
    openjdk-17-jdk-headless \
    adb \
    rsync \
    osslsigncode \
    && rm -rf /var/lib/apt/lists/*

# When in doubt, see the downloads page: https://github.com/godotengine/godot-builds/releases/
ARG GODOT_VERSION="4.5"

# Example values: stable, beta3, rc1, dev2, etc.
# Also change the `SUBDIR` argument below when NOT using stable.
ARG RELEASE_NAME="stable"

# This is only needed for non-stable builds (alpha, beta, RC)
# e.g. SUBDIR "/beta3"
# Use an empty string "" when the RELEASE_NAME is "stable".
ARG SUBDIR=""

ARG GODOT_TEST_ARGS=""
ARG GODOT_PLATFORM="linux.x86_64"

# NOTE: Mono downloads use an underscore instead of a dot between `linux` and `x86_64` in their URL
# and folder name within the ZIP, but not in the binary file name within the ZIP.
ARG GODOT_ZIP_PLATFORM="linux_x86_64"

RUN wget https://github.com/godotengine/godot-builds/releases/download/${GODOT_VERSION}-${RELEASE_NAME}/Godot_v${GODOT_VERSION}-${RELEASE_NAME}_mono_${GODOT_ZIP_PLATFORM}.zip \
    && wget https://github.com/godotengine/godot-builds/releases/download/${GODOT_VERSION}-${RELEASE_NAME}/Godot_v${GODOT_VERSION}-${RELEASE_NAME}_mono_export_templates.tpz \
    && mkdir -p ~/.cache \
    && mkdir -p ~/.config/godot \
    && mkdir -p ~/.local/share/godot/export_templates/${GODOT_VERSION}.${RELEASE_NAME}.mono \
    && unzip Godot_v${GODOT_VERSION}-${RELEASE_NAME}_mono_${GODOT_ZIP_PLATFORM}.zip \
    && mv Godot_v${GODOT_VERSION}-${RELEASE_NAME}_mono_${GODOT_ZIP_PLATFORM}/Godot_v${GODOT_VERSION}-${RELEASE_NAME}_mono_${GODOT_PLATFORM} /usr/local/bin/godot \
    && mv Godot_v${GODOT_VERSION}-${RELEASE_NAME}_mono_${GODOT_ZIP_PLATFORM}/GodotSharp /usr/local/bin/GodotSharp \
    && unzip Godot_v${GODOT_VERSION}-${RELEASE_NAME}_mono_export_templates.tpz \
    && mv templates/* ~/.local/share/godot/export_templates/${GODOT_VERSION}.${RELEASE_NAME}.mono \
    && rm -f Godot_v${GODOT_VERSION}-${RELEASE_NAME}_mono_export_templates.tpz Godot_v${GODOT_VERSION}-${RELEASE_NAME}_mono_${GODOT_ZIP_PLATFORM}.zip

ADD getbutler.sh /opt/butler/getbutler.sh
RUN bash /opt/butler/getbutler.sh
RUN /opt/butler/bin/butler -V

ENV PATH="/opt/butler/bin:${PATH}"

# Download and set up Android SDK to export to Android.
ENV ANDROID_HOME="/usr/lib/android-sdk"
RUN wget https://dl.google.com/android/repository/commandlinetools-linux-7583922_latest.zip \
    && unzip commandlinetools-linux-*_latest.zip -d cmdline-tools \
    && mv cmdline-tools $ANDROID_HOME/ \
    && rm -f commandlinetools-linux-*_latest.zip

ENV PATH="${ANDROID_HOME}/cmdline-tools/cmdline-tools/bin:${PATH}"

RUN yes | sdkmanager --licenses \
    && sdkmanager "platform-tools" "build-tools;33.0.2" "platforms;android-33" "cmdline-tools;latest" "cmake;3.22.1" "ndk;25.2.9519653"

# Add Android keystore and settings.
RUN keytool -keyalg RSA -genkeypair -alias androiddebugkey -keypass android -keystore debug.keystore -storepass android -dname "CN=Android Debug,O=Android,C=US" -validity 9999 \
    && mv debug.keystore /root/debug.keystore

RUN godot -v -e --quit --headless ${GODOT_TEST_ARGS}
# Godot editor settings are stored per minor version since 4.3.
# `${GODOT_VERSION:0:3}` transforms a string of the form `x.y.z` into `x.y`, even if it's already `x.y` (until Godot 4.9).
RUN echo '[gd_resource type="EditorSettings" format=3]' > ~/.config/godot/editor_settings-${GODOT_VERSION:0:3}.tres
RUN echo '[resource]' >> ~/.config/godot/editor_settings-${GODOT_VERSION:0:3}.tres
RUN echo 'export/android/java_sdk_path = "/usr/lib/jvm/java-17-openjdk-amd64"' >> ~/.config/godot/editor_settings-${GODOT_VERSION:0:3}.tres
RUN echo 'export/android/android_sdk_path = "/usr/lib/android-sdk"' >> ~/.config/godot/editor_settings-${GODOT_VERSION:0:3}.tres
RUN echo 'export/android/debug_keystore = "/root/debug.keystore"' >> ~/.config/godot/editor_settings-${GODOT_VERSION:0:3}.tres
RUN echo 'export/android/debug_keystore_user = "androiddebugkey"' >> ~/.config/godot/editor_settings-${GODOT_VERSION:0:3}.tres
RUN echo 'export/android/debug_keystore_pass = "android"' >> ~/.config/godot/editor_settings-${GODOT_VERSION:0:3}.tres
RUN echo 'export/android/force_system_user = false' >> ~/.config/godot/editor_settings-${GODOT_VERSION:0:3}.tres
RUN echo 'export/android/timestamping_authority_url = ""' >> ~/.config/godot/editor_settings-${GODOT_VERSION:0:3}.tres
RUN echo 'export/android/shutdown_adb_on_exit = true' >> ~/.config/godot/editor_settings-${GODOT_VERSION:0:3}.tres
