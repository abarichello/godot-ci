Notes:

Gitea's Godot repository preset will add exports_template.cfg to the gitignore, you ***DO NOT WANT THIS***, it will break the runner as it won't be able to find the preset.

Changes made:

Modified Docker image (Requires manual building from the Docker folder) as NodeJS is required for Act Runners.
Changed actions/upload-artifact in the workflow to @v3 as both V1 and V4 break the artifact upload.
Changed naming to defaults for what Godot outputs as a export preset, if you edit your exports please make sure the --export-release "$PLATFORM" matches your export_presets.cfg file. 
This is modified specifically for the current latest Godot 4.2.2 build.
Changes were made and confirmed working for Gitea. This has not been tested for C# support in any functional manner.

Docker image will need to be built with "docker build -t godot-ci-nodejs ." on the runner host in the /Docker/ folder from this repository.
