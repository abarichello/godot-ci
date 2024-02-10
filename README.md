# godot-ci
Docker image to export Godot Engine games and deploy to GitLab/GitHub Pages and Itch.io using GitLab CI and GitHub Actions.

<img src="https://i.imgur.com/3z4Sxhd.png" width=450>

## Docker Hub
https://hub.docker.com/r/barichello/godot-ci/

## How To Use

`.gitlab-ci.yml` and `.github/workflows/godot-ci.yml` are included in this project as reference.
<br>For live projects, examples and tutorials using this template check the list below:<br>

- [Video tutorial by Kyle Luce](https://www.youtube.com/watch?v=wbc1qut0vT4)
- [Video tutorial series by David Snopek](https://www.youtube.com/watch?v=4oUs4IV_Mj4&list=PLCBLMvLIundAOAiCvluBNuEA0-ea7_EDp)
- Repository examples: [test-project](https://github.com/aBARICHELLO/godot-ci/tree/master/test-project) | [game-off](https://gitlab.com/BARICHELLO/game-off).
- Test deploys using this tool: [GitHub Pages](http://barichello.me/godot-ci/) | [GitLab Pages](https://barichello.gitlab.io/godot-ci/) | [Itch.io](https://barichello.itch.io/test-project).

### Mono/C#

To build a Godot project with Mono (C#) enabled, you must do two things for each job:
1. Change the container's `image` tag from `barichello/godot-ci:VERSION` to `barichello/godot-ci:mono-VERSION` in `.gitlab-ci.yml` (Gitlab) or `godot-ci.yml` (Github). (e.g. `barichello/godot-ci:mono-3.2.1`).
2. You will also need to change your "Setup" step's run commands (looks like `run: mv /root/.local ...`) from ending with `...${GODOT_VERSION}.stable` to ending with `...${GODOT_VERSION}.stable.mono`. You will need to do this for both directories in the command.
```bash
mv /root/.local/share/godot/export_templates/${GODOT_VERSION}.stable ~/.local/share/godot/export_templates/${GODOT_VERSION}.stable
```
becomes:
```bash
mv /root/.local/share/godot/export_templates/${GODOT_VERSION}.stable.mono ~/.local/share/godot/export_templates/${GODOT_VERSION}.stable.mono
```

### Android

To build a debug release (debug.keystore), use the `android_debug` job example in the `gitlab-ci.yml` file.

If you want to export for Android with your own keystore, you can do this with the following steps:
1. Take your generated keystore and convert it to Base64:
Linux & macOS: `base64 release.keystore -w 0`
Windows: `certutil -encodehex -f release.keystore encoded.txt 0x40000001`
2. Go to **GitLab Project > Settings > CI/CD > Variables** and copy the Base64-encoded keystore value in a new variable `SECRET_RELEASE_KEYSTORE_BASE64` as type variable.
3. Create a second variable SECRET_RELEASE_KEYSTORE_USER as type variable with the alias of your keystore as value.
4. Create a third variable SECRET_RELEASE_KEYSTORE_PASSWORD as type variable with the password of your keystore as value.
5. Use the `android` job example in the `gitlab-ci.yml` file.

### GDNative/C++

See [this repository](https://github.com/2shady4u/godot-cpp-ci) for automating GDNative C++ compilation, which is based off this repository.

### Modules

You have to compile Godot with the modules included first. See [this excellent repository](https://gitlab.com/Calinou/godot-builds-ci) by Calinou for automating Godot builds.

After that, you would use the custom build to export your project as usual. See [this guide](https://gitlab.com/greenfox/godot-build-automation/-/blob/master/advanced_topics.md#using-a-custom-build-of-godot) by Greenfox on how to use a custom Godot build for automated exports.

### iOS

Not available yet. Automating Xcode projects is doable but not trivial, and macOS runners only recently became available for GitHub actions, so it will happen eventually.

## Platforms

Here's a mapping between each supported CI service, the template jobs and a live example.

|CI|Template|Example
|-|-|-|
|GitLab CI|[Godot Exports](https://github.com/aBARICHELLO/godot-ci/blob/master/.gitlab-ci.yml#L16-L58) / [GitHub Pages](https://github.com/aBARICHELLO/godot-ci/blob/master/.gitlab-ci.yml#L60-L76) / [GitLab Pages](https://github.com/aBARICHELLO/godot-ci/blob/master/.gitlab-ci.yml#L78-L91) / [Itch.io](https://github.com/aBARICHELLO/godot-ci/blob/master/.gitlab-ci.yml#L93-L113)|[GitLab CI Pipelines](https://gitlab.com/BARICHELLO/godot-ci/pipelines)
|GitHub Actions|[Godot Exports](https://github.com/aBARICHELLO/godot-ci/blob/master/.github/workflows/godot-ci.yml#L8-99) | [GitHub Actions running](https://github.com/aBARICHELLO/godot-ci/actions)

## Environment configuration

First you need to remove unused jobs/stages from the `.yml` file you are using as a template(`.gitlab-ci.yml` or `.github/workflows/godot-ci.yml`).<br>
Then you have to add these environments to a configuration panel depending on the chosen CI and jobs:
- **GitHub**: `https://github.com/<username>/<project-name>/settings/secrets`
- **GitLab**: `https://gitlab.com/<username>/<repo-name>/settings/ci_cd`

### GitHub Pages

Secrets needed for a GitHub Pages deploy via GitLab CI:

|Variable|Description|Example|
|-|-|-|
| REMOTE_URL | The `git remote` where the web export will be hosted (in this case GitHub), it should contain your [deploy/personal access token](https://github.com/settings/tokens)|`https://<github username>:<deploy token>@github.com/<username>/<repository>.git`
| GIT_EMAIL | Git email of the account that will commit to the `gh-pages` branch. | `email@example.com`
| GIT_USERNAME | Username of the account that will commit to the `gh-pages` branch. | `username`

Others variables are set automatically by the `gitlab-runner`, see the documentation for [predefined variables](https://docs.gitlab.com/ee/ci/variables/predefined_variables.html).<br>

### Itch.io

Deployment to Itch.io is done via [Butler](https://itch.io/docs/butler/).<br>
Secrets needed for a Itch.io deploy via GitLab CI:

|Variable|Description|Example|
|-|-|-|
| ITCHIO_USERNAME | Your username on Itch.io, as in your personal page will be at `https://<username>.itch.io` |`username`
| ITCHIO_GAME | the name of your game on Itchio, as in your game will be available at `https://<username>.itch.io/<game>`  |`game`
| BUTLER_API_KEY | An [Itch.io API key](https://itch.io/user/settings/api-keys) is necessary for Butler so that the CI can authenticate on Itch.io on your behalf. **Make that API key `Masked`(GitLab CI) to keep it secret** |`xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`

## Troubleshoot

#### Problems while exporting

- **Check that the export presets file (`export_presets.cfg`) is committed to version control.** In other words, `export_presets.cfg` must *not* be in `.gitignore`.
  - Make sure you don't accidentally commit Android release keystore or Windows codesigning credentials. These credentials cannot be revoked if they are leaked!
- Check that the export names on `export_presets.cfg` match the ones used in your CI script **(case-sensitive)**. Export preset names that contain spaces must be written within quotes (single or double).
- Check the paths used in your CI script. Some commands may be running in the wrong place if you are keeping the project in a folder (like the `test-project` template) or not.

#### Authentication errors with Butler
- If using GitLab, check that the 'protected' tag is disabled in the [CI/CD variables panel](https://github.com/aBARICHELLO/godot-ci#environment-configuration).

## Additional Resources

Greenfox has an [excellent repo](https://gitlab.com/greenfox/godot-build-automation) that is also for automating Godot exports.
