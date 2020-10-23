FROM ubuntu:focal
LABEL author="artur@barichello.me"

USER root
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get full-upgrade --yes && apt-get install --yes --no-install-recommends \
    ca-certificates \
    git \
    git-lfs \
    python \
    python-openssl \
    unzip \
    wget \
    zip \
    adb \
    openjdk-8-jdk-headless \
    imagemagick \
    wine-stable \
    && rm -rf /var/lib/apt/lists/*

RUN wget --quiet https://github.com/electron/rcedit/releases/download/v1.1.1/rcedit-x64.exe -O /usr/local/bin/rcedit.exe

ENV GODOT_VERSION "3.2.3"

RUN wget --quiet https://downloads.tuxfamily.org/godotengine/${GODOT_VERSION}/Godot_v${GODOT_VERSION}-stable_linux_headless.64.zip \
    && wget --quiet https://downloads.tuxfamily.org/godotengine/${GODOT_VERSION}/Godot_v${GODOT_VERSION}-stable_export_templates.tpz \
    && mkdir ~/.cache \
    && mkdir -p ~/.config/godot \
    && mkdir -p ~/.local/share/godot/templates/${GODOT_VERSION}.stable \
    && unzip Godot_v${GODOT_VERSION}-stable_linux_headless.64.zip \
    && mv Godot_v${GODOT_VERSION}-stable_linux_headless.64 /usr/local/bin/godot \
    && unzip Godot_v${GODOT_VERSION}-stable_export_templates.tpz \
    && mv templates/* ~/.local/share/godot/templates/${GODOT_VERSION}.stable \
    && rm -f Godot_v${GODOT_VERSION}-stable_export_templates.tpz Godot_v${GODOT_VERSION}-stable_linux_headless.64.zip

ADD getbutler.sh /opt/butler/getbutler.sh
RUN bash /opt/butler/getbutler.sh
RUN /opt/butler/bin/butler -V

ENV PATH="/opt/butler/bin:${PATH}"

# Adding android keystore and settings
RUN keytool -keyalg RSA -genkeypair -alias androiddebugkey -keypass android -keystore debug.keystore -storepass android -dname "CN=Android Debug,O=Android,C=US" -validity 9999 \
    && mv debug.keystore /root/debug.keystore
RUN godot -e -q
RUN echo 'export/android/adb = "/usr/bin/adb"' >> ~/.config/godot/editor_settings-3.tres
RUN echo 'export/android/jarsigner = "/usr/bin/jarsigner"' >> ~/.config/godot/editor_settings-3.tres
RUN echo 'export/android/debug_keystore = "/root/debug.keystore"' >> ~/.config/godot/editor_settings-3.tres
RUN echo 'export/android/debug_keystore_user = "androiddebugkey"' >> ~/.config/godot/editor_settings-3.tres
RUN echo 'export/android/debug_keystore_pass = "android"' >> ~/.config/godot/editor_settings-3.tres
RUN echo 'export/android/force_system_user = false' >> ~/.config/godot/editor_settings-3.tres
RUN echo 'export/android/timestamping_authority_url = ""' >> ~/.config/godot/editor_settings-3.tres
RUN echo 'export/android/shutdown_adb_on_exit = true' >> ~/.config/godot/editor_settings-3.tres
