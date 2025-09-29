# Heads Up

Fork of Godot-CI, made multiple modifications cut and pasted from my personal Gitea repository using Gitea Runners. Spent a decent amount of time getting that working.


General overview for anyone who comes across this, Gitea's Godot repository preset will add exports_template.cfg to the gitignore, you ***DO NOT WANT THIS***, it will break the runner as it won't be able to find the preset. There is likely to be issues with proper secret management, however getting things working was my first priority.


Changes made:

Modified Docker image (not public, you will have to build it at the moment) as NodeJS is required for Act Runners.
Changed actions/upload-artifact in the workflow to @v3 as both V1 and V4 break the artifact upload.
Changed naming to defaults for what Godot outputs as a export preset, if you edit your exports please make sure the --export-release "$PLATFORM" matches your export_presets.cfg file. 
This is modified specifically for the current latest Godot 4.2.2 build.
Changes were made and confirmed working for Gitea. I have not tested C# support in any functional manner.

Docker image will need to be built with "docker build -t godot-ci-nodejs ." on the runner host in the /Docker/ folder.