# godot-ci

This is a heavy fork of https://github.com/abarichello/godot-ci and I'm very thankful for their work. I've added an smaller image and provided simplified templates to build your Godot game.

Docker image to build Godot Engine 4.x games. It includes tools for deployment.

## Image Tag

If you want to use a GitHub action you can use this (see section about templates for use cases):

    docker pull ghcr.io/meldanor/godot-ci:<GODOT_VERSION>-<RELEASE_TYPE>-<IMAGE_TYPE>

The variables are:

- `GODOT_VERSION` - The Version of Godot without any suffix, like `4.2.2`
- `RELEASE_TYPE` - `stable` for official releases, otherwise `beta3`, `dev6` and so on
- `IMAGE_TYPE` - See the next section, most shoud use `minimal` as a start.

Example: You are using Godot 4.2.2 with GDscript only and want to use release to linux and windows, you use the following tag: `ghcr.io/meldanor/godot-ci:4.2.2-stable-minimal`

TODO: Add ECR and docker registry as additional hostings because GitHub has a hard free limit.

## Image type

Each image has multiple tags more specific for a certain cause. Here is a matrix of the different combinations and their tags:

|            | Linux, windows, mac, web      | Android + iOS    |
| ---------- | ----------------------------- | ---------------- |
| Without C# | minimal                       | android-ios      |
| With C#    | minimal-mono (not yet there)  | android-ios-mono (not yet there) |

## Versions

I've started with Godot 4.2.2 and 4.3-dev6 because that was the state of my project. I will start adding all other versions when I have setup the other hostings.

## Templates

In the directory `templates/.github/workflows` are three templates for building your Godot game:

- `release-build.yml`: Build the Godot Game only when a `vX.Y.Z` tag is pushed. Useful for releases.
- `feature-build.yml`: Build the Godot Game only when the action is manually triggered. Useful for beta or certain features branches.
- `nightly-build.yml`: Build the Godot Game at 02 in the morning if there were changes in the last 24h. Useful to have a history of builds and for internal use.

Each template has comments and provides only the build process, but not the upload / deploy / release step! You have to define this yourself. For convenience the image includes `cURL`, `rsync` and `bulter` (for itch.io).

## Mono/C#

TODO: At the moment not there because I have no experience with it. I will add this later again.

## Android & IOS

TODO: At the moment they are build but I have no idea how to test these builds as I have no test environment or use case.

### GDNative/C++

See [this repository](https://github.com/2shady4u/godot-cpp-ci) for automating GDNative C++ compilation, which is based off this repository.

### Modules

You have to compile Godot with the modules included first. See [this excellent repository](https://gitlab.com/Calinou/godot-builds-ci) by Calinou for automating Godot builds.

After that, you would use the custom build to export your project as usual. See [this guide](https://gitlab.com/greenfox/godot-build-automation/-/blob/master/advanced_topics.md#using-a-custom-build-of-godot) by Greenfox on how to use a custom Godot build for automated exports.

## Troubleshoot

#### Problems while exporting

- **Check that the export presets file (`export_presets.cfg`) is committed to version control.** In other words, `export_presets.cfg` must _not_ be in `.gitignore`.
  - Make sure you don't accidentally commit Android release keystore or Windows codesigning credentials. These credentials cannot be revoked if they are leaked!
- Check that the export names on `export_presets.cfg` match the ones used in your CI script **(case-sensitive)**. Export preset names that contain spaces must be written within quotes (single or double).
- Check the paths used in your CI script. Some commands may be running in the wrong place if you are keeping the project in a folder (like the `test-project` template) or not.

## Additional Resources

Greenfox has an [excellent repo](https://gitlab.com/greenfox/godot-build-automation) that is also for automating Godot exports.
