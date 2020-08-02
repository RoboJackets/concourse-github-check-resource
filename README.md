# concourse-github-check-resource
Concourse resource for GitHub Checks

## Source configuration

- `repository` (required) - the resource where your source code is provided
- `token` (required) - GitHub App token to use to authenticate
- `check_name` (required) - the name of the check within GitHub
- `resource_name` (required) - the name of the resource within Concourse
- `annotations_format` (optional) - the format for annotations; supports `yamllint`, `mypy`, `flake8` (with the `flake8-json` package), and `pylint`
- `annotations_location` (optional) - the location of annotations; by default, this is the same as `annotations_format`, but you can provide another path if necessary

GitHub endpoint information, commit SHA, and the URL to the Concourse job log will be derived from the environment.

## Behavior
Do not `get` this resource manually, it will not work.

### `check`
Returns an empty list.

### `in`
Writes the requested version out to disk for future `put`s to update. Intended only for implicit `get`s after `put`s.

### `out`
You may want to [manually configure inputs](https://concourse-ci.org/jobs.html#schema.step.put-step.inputs) for better performance if you have large resources in your pipeline.

#### First `put`
Creates a new check with state `in_progress`. `started_at` will automatically be set to the time when `in` was called.

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
