#!/usr/bin/env bash

GODOT_VERSION=$1
MAJOR_VERSION=$(echo "$GODOT_VERSION" | cut -c -1)
MINOR_VERSION=$(echo "$GODOT_VERSION" | cut -c -3)

if [ "$MAJOR_VERSION" = "3" ]
then
    echo "mono:latest"
    exit 0
fi

case "$MINOR_VERSION" in
    "4.0" | "4.1" | "4.2" | "4.3")
        echo "mcr.microsoft.com/dotnet/sdk:6.0-jammy"
        ;;
    "4.4")
        echo "mcr.microsoft.com/dotnet/sdk:8.0-jammy"
        ;;
    "4.5" | "4.6")
        echo "mcr.microsoft.com/dotnet/sdk:9.0-noble"
        ;;
    *)
        echo "Unknown Godot version: '$MINOR_VERSION'"
        exit 1
        ;;
esac
