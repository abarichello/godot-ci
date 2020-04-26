# godot-ci
Docker image to export Godot Engine games and deploy to GitLab/GitHub Pages and Itch.io using GitLab CI and GitHub Actions.

<img src="https://i.imgur.com/3z4Sxhd.png" width=450>

## Docker Hub
https://hub.docker.com/r/barichello/godot-ci/

## How To Use

`.gitlab-ci.yml` and `.github/workflows/godot-ci.yml` are included in this project as reference.
<br>For live projects, examples and tutorials using this template check the list below:<br>

- [Video tutorial by Kyle Luce](https://www.youtube.com/watch?v=wbc1qut0vT4)
- Repository examples: [GitHub](https://github.com/aBARICHELLO/game-off) | [GitLab](https://gitlab.com/BARICHELLO/game-off)
- Deployed game examples: [GitHub Pages](http://barichello.me/game-off/) | [GitLab Pages](https://barichello.gitlab.io/game-off/) | [Itch.io](https://barichello.itch.io/game-off)
- [GitLab CI Pipelines running](https://gitlab.com/BARICHELLO/game-off/pipelines)
- [GitHub Actions running](https://github.com/aBARICHELLO/game-off/actions)

## Platforms

Here's a mapping between each supported CI service and the template jobs.

|CI|Template|
|-|-|
|GitLab CI|[Godot Exports](https://github.com/aBARICHELLO/godot-ci/blob/master/.gitlab-ci.yml#L22-L56) / [GitHub Pages](https://github.com/aBARICHELLO/godot-ci/blob/master/.gitlab-ci.yml#L59-L74) / [GitLab Pages](https://github.com/aBARICHELLO/godot-ci/blob/master/.gitlab-ci.yml#L77-L89) / [Itch.io](https://github.com/aBARICHELLO/godot-ci/blob/master/.gitlab-ci.yml#L91-L111)
|GitHub Actions|[Godot Exports](https://github.com/aBARICHELLO/godot-ci/blob/master/.github/workflows/godot-ci.yml#L9-L87)

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
| GIT_EMAIL | Git email of the account that will commit to the `gh-pages` branch. | `artur@barichello.me`
| GIT_USERNAME | Username of the account that will commit to the `gh-pages` branch. | `abarichello`

Others variables are set automatically by the `gitlab-runner`, see the documentation for [predefined variables](https://docs.gitlab.com/ee/ci/variables/predefined_variables.html).<br>

### Itch.io

Deployment to Itch.io is done via [Butler](https://itch.io/docs/butler/).<br>
Secrets needed for a Itch.io deploy via GitLab CI:

|Variable|Description|Example|
|-|-|-|
| ITCHIO_USERNAME | Your username on Itch.io, as in your personal page will be at `https://<username>.itch.io` |`username`
| ITCHIO_GAME | the name of your game on Itchio, as in your game will be available at `https://<username>.itch.io/<game>`  |`game`
| BUTLER_API_KEY | An [Itch.io API key](https://itch.io/user/settings/api-keys) is necessary for Butler so that the CI can authenticate on Itch.io on your behalf. **Make that API key `Masked`(GitLab CI) to keep it secret** |`xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`
