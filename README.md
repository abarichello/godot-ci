# godot-ci
Docker image to export Godot Engine games and deploy to GitLab/GitHub Pages and Itch.io.

<img src="https://i.imgur.com/nwZHG4f.png" width=450>

## Docker Hub
https://hub.docker.com/r/barichello/godot-ci/

## How To Use

A `.gitlab-ci.yml` is included in this project as reference, for live projects using this image check the list below:<br>

- Repository examples: [GitHub](https://github.com/aBARICHELLO/game-off) | [GitLab](https://gitlab.com/BARICHELLO/game-off)
- Deployed game examples: [GitHub Pages](http://barichello.me/game-off/) | [GitLab Pages](https://barichello.gitlab.io/game-off/) | [Itch.io](https://barichello.itch.io/game-off)
- [Pipelines running](https://gitlab.com/BARICHELLO/game-off/pipelines)

You can choose either [GitLab Pages](https://gitlab.com/help/user/project/pages/index.md) or [GitHub Pages](https://pages.github.com/) to deploy web exports.

### GitLab Pages

Delete the `deploy-github-pages` job from your `.gitlab-ci.yml`.

### GitHub Pages

Delete the `pages` job and set the following **Variables** in the GitLab CI/CD panel:

*Access `https://gitlab.com/<username>/<repo-name>/settings/ci_cd` to edit:*

|Variable|Description|Example|
|-|-|-|
| $REMOTE_URL | The `git remote` where the web export will be hosted (in this case GitHub), it should contain your [deploy/personal access token](https://github.com/settings/tokens)|`https://<github username>:<deploy token>@github.com/<username>/<repository>.git`
| $GIT_EMAIL | Git email of the account that will commit to the `gh-pages` branch. | `artur@barichello.me`
| $GIT_USERNAME | Username of the account that will commit to the `gh-pages` branch. | `abarichello`

Others variables are set automatically by the `gitlab-runner`, see the documentation for [predefined variables](https://docs.gitlab.com/ee/ci/variables/predefined_variables.html).<br>

### Itch.io

Deployment to Itch.io is done via [Butler](https://itch.io/docs/butler/).
You will need to set variables in the Gitlab CI/CD settings panel for it to work.

|Variable|Description|Example|
|-|-|-|
| $ITCHIO_USERNAME | Your username on Itch.io, as in your personal page will be at `https://<username>.itch.io` |`username`
| $ITCHIO_GAME | the name of your game on Itchio, as in your game will be available at `https://<username>.itch.io/<game>`  |`game`
| $BUTLER_API_KEY | An [Itch.io API key](https://itch.io/user/settings/api-keys) is necessary for Butler so that Gitlab-ci can authenticate on Itch.io on your behalf. **Make that API key `Masked` to keep it secret** |`aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa`
