# godot-ci

This is a heavy fork of https://github.com/abarichello/godot-ci and I'm very thankful for their work. I've added an smaller image and provided simplified templates to build your Godot game.

Docker image to build Godot Engine 4.x games. It includes tools for deployment.

## Image Tag

If you want to use a GitHub action you can use this (see section about templates for use cases):

    docker pull ghcr.io/meldanor/godot-ci:<GODOT_VERSION>-<RELEASE_TYPE>-<IMAGE_TYPE>

The variables are:

- `GODOT_VERSION` - The Version of Godot without any suffix, like `4.2.2`
- `RELEASE_TYPE` - `stable` for official releases, otherwise `beta3`, `dev6` and so on
- `IMAGE_TYPE` - See the next section, most should use `minimal` as a start.

Example: You are using Godot 4.2.2 with GDscript only and want to use release to linux and windows, you use the following tag: `ghcr.io/meldanor/godot-ci:4.2.2-stable-minimal`

## Image type

The are three different types of the image, each for a specific use case:

- `minimal` - GDscript only version for any plattform except android and iOS.
- `andriod_ios` - GDscript only version for android and iOS. (Not tested with a real project, can have bugs)
- `dotnet` - C# with .Net SDK 8 for plattforms except android, iOS and web (Not tested with a real project, can have bugs)

The reasons are totally opinionated. The main reason is image size. Android and iOS needs more tools, dotnet uses a different base image. A smaller size is always preferred.

## Godot Versions

This fork startet with 4.3-dev6 version. I've built all 4.X stable versions and all prerelease versions of 4.3. See the Docker registry of this project for all available tags.

When Godot releases a new version, prerelease or stable, I will trigger a new build. You can expect it in 24h of release that there is a new image.

## Templates

In the directory `templates/.github/workflows` are three templates for building your Godot game:

- `release-build.yml`: Build the Godot Game only when a `vX.Y.Z` tag is pushed. Useful for releases.
- `feature-build.yml`: Build the Godot Game only when the action is manually triggered. Useful for beta or certain features branches.
- `nightly-build.yml`: Build the Godot Game at 02:00 in the morning if there were changes in the last 24h. Useful to have a history of builds and for internal use.

Each template has comments and provides only the build process, but not the upload / deploy / release step! You have to define this yourself. For convenience the image includes `cURL`, `rsync` and `bulter` (for itch.io).

## Troubleshoot

- **Check that the export presets file (`export_presets.cfg`) is committed to version control.** In other words, `export_presets.cfg` must _not_ be in `.gitignore`.
  - Make sure you don't accidentally commit Android release keystore or Windows codesigning credentials. These credentials cannot be revoked if they are leaked!
- Check that the export names on `export_presets.cfg` match the ones used in your CI script **(case-sensitive)**. Export preset names that contain spaces must be written within quotes (single or double).
- Check the paths used in your CI script. Some commands may be running in the wrong place if you are keeping the project in a folder (like the `test-project` template) or not.

## Additional Resources

Greenfox has an [excellent repo](https://gitlab.com/greenfox/godot-build-automation) that is also for automating Godot exports.
