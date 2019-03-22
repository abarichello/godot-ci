# godot-ci
Docker image to export Godot Engine games and deploy web exports.

## Docker Hub
https://hub.docker.com/r/barichello/godot-ci/

## Usage example
A `.gitlab-ci.yml` is included in this project as reference, a live example can be seen in [this project](https://github.com/aBARICHELLO/game-off).<br>
After adapting the paths and names according to your project needs you will need the following **Variables** set in GitLab for this image to work:

*Access  `https://gitlab.com/<username>/<repo-name>/settings/ci_cd` to edit:*

|Variable|Description|Example|
|-|-|-|
| $REMOTE_URL | The `git remote` where the web export will be hosted (in this case GitHub), it should contain your [deploy/personal access token](https://github.com/settings/tokens)|`https://<github username>:<deploy token>@github.com/<username>/<repository>.git`
| $GIT_EMAIL | Git email of the account that will commit to the `gh-pages` branch. | `artur@barichello.me`
| $GIT_USERNAME | Username of the account that will commit to the `gh-pages` branch. | `abarichello`

Others variables are set automatically by the `gitlab-runner`<br>
The included `gitlab-ci.yml` is set to only run the export jobs when you commit a new `git tag`, i suggest not using "." or "," in your tag's name since it messes with Godot's export system and will lead to failed jobs.

Check a usage example in this test project:<br>
- [`aBARICHELLO/game-off`](https://github.com/aBARICHELLO/game-off)<br>
