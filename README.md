# godot-ci
Docker image to deploy Godot Engine games

## Docker Hub
https://hub.docker.com/r/barichello/godot-ci/

## Usage example
A `.gitlab-ci.yml` is included in this project as a usage example.<br>
After adapting the paths and names according to your project needs you will need the following **Variable** set in GitLab for this image to work:

|Variable|Description|Example|
|-|-|-|
|$REMOTE_URL | The `git remote` where the web export will be hosted (in this case GitHub), it should contain your [deploy/personal access token](https://github.com/settings/tokens)|`https://<github username>:<deploy token>@github.com/<username>/<repository>.git`

Others variables are set automatically by the `gitlab-runner`
