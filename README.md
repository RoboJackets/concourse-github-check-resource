# concourse-github-check-resource
[![GitHub license](https://img.shields.io/github/license/RoboJackets/concourse-github-check-resource)](https://github.com/RoboJackets/concourse-github-check-resource/blob/main/LICENSE) [![CI](https://concourse.sandbox.aws.robojackets.net/api/v1/teams/information-technology/pipelines/github-check/jobs/build-main/badge)](https://concourse.sandbox.aws.robojackets.net/teams/information-technology/pipelines/github-check)

Concourse resource for GitHub Checks

## Source configuration

- `repository_url` (required) - location of the repository
- `commit` (required) - commit that is being built
- `token` (required) - GitHub App token to use to authenticate
- `check_name` (required) - name of the check within GitHub
- `resource_name` (required) - name of the resource within Concourse
- `annotations_format` (optional) - format for annotations; supports `yamllint`, `mypy`, `flake8` (with the `flake8-json` package), `pylint`, `codesniffer`, `phpstan`, `phan`, and `psalm`
- `phpstan.neon` (optional) - PHPStan configuration file contents, as a string
- `debug` (optional) - whether to enable debug logging; must be set to boolean true if present

GitHub endpoint information and the URL to the Concourse job log will be derived from the environment.

## Behavior
Do not `get` this resource manually, it will not work.

### `check`
Returns an empty list.

### `in`
Writes the requested version out to disk for future `put`s to update. Intended only for implicit `get`s after `put`s.

### `out`

#### First `put`
Creates a new check with state `in_progress`. `started_at` will automatically be set to the time when `in` was called. Must be called with no `inputs`.

#### Subsequent `put`s
Updates an existing check. Refer to [the GitHub Checks API documentation](https://docs.github.com/en/rest/reference/checks) for possible values and descriptions. `completed_at` will automatically be set to the time when `out` was called.

Supported `params`:
- `conclusion` (required, see docs linked above)
- `title` (optional, for the `output` object)
    - If `conclusion` is `cancelled` this will default to "Task cancelled by user"
    - If `conclusion` is `action_required` this will default to "Error running task"
    - If annotations are available to publish, the parser will replace this value.
- `summary` (optional, for the `output` object)
    - If `conclusion` is `cancelled` this will default to "Re-run the job within Concourse."
    - If `conclusion` is `action_required` this will default to "Review the output within Concourse."
    - If annotations are available to publish, the parser will replace this value.
