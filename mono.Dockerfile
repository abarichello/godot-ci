FROM mono:latest
LABEL author="artur@barichello.me,asheraryam@gmail.com"


USER root

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    git \
    python \
    python-openssl \
    unzip \
    wget \
    zip \
    && rm -rf /var/lib/apt/lists/*

# When in doubt see the downloads page
# https://downloads.tuxfamily.org/godotengine/
ENV GODOT_VERSION "3.2.2"

# Example values: stable, beta1, rc2, alpha3, etc.
# Also change the SUBDIR property when NOT using stable
ENV RELEASE_NAME "beta3"

# This is only needed for non-stable builds (alpha, beta, RC)
# e.g. SUBDIR "/beta1"
ENV SUBDIR "/beta3" 

RUN wget https://downloads.tuxfamily.org/godotengine/${GODOT_VERSION}${SUBDIR}/mono/Godot_v${GODOT_VERSION}-${RELEASE_NAME}_mono_linux_headless_64.zip \
    && wget https://downloads.tuxfamily.org/godotengine/${GODOT_VERSION}${SUBDIR}/mono/Godot_v${GODOT_VERSION}-${RELEASE_NAME}_mono_export_templates.tpz

RUN mkdir ~/.cache \
    && mkdir -p ~/.config/godot \
    && mkdir -p ~/.local/share/godot/templates/${GODOT_VERSION}.${RELEASE_NAME}.mono \
    && unzip Godot_v${GODOT_VERSION}-${RELEASE_NAME}_mono_linux_headless_64.zip \
    && mv Godot_v${GODOT_VERSION}-${RELEASE_NAME}_mono_linux_headless_64/Godot_v${GODOT_VERSION}-${RELEASE_NAME}_mono_linux_headless.64 /usr/local/bin/godot \
    && mv Godot_v${GODOT_VERSION}-${RELEASE_NAME}_mono_linux_headless_64/GodotSharp /usr/local/bin/GodotSharp \
    && unzip Godot_v${GODOT_VERSION}-${RELEASE_NAME}_mono_export_templates.tpz \
    && mv templates/* ~/.local/share/godot/templates/${GODOT_VERSION}.${RELEASE_NAME}.mono \
    && rm -f Godot_v${GODOT_VERSION}-${RELEASE_NAME}_mono_export_templates.tpz Godot_v${GODOT_VERSION}-${RELEASE_NAME}_mono_linux_headless_64.zip
