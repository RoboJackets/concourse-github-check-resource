# concourse-github-check-resource
Concourse resource for GitHub Checks

## Source configuration
All fields are required.

- `repository` - the input where your source code is provided
- `token` - GitHub App token to use to authenticate
- `check_name` - the name of the check within GitHub
- `resource_name` - the name of the resource within Concourse

GitHub endpoint information, commit SHA, and the URL to the Concourse job log will be derived from the environment.

## Behavior
Do not `get` this resource manually, it will not work.

### `check`
Returns an empty list of versions.

### `in`
Writes the requested version out to disk for future `put`s to update. Intended only for implicit `get`s after `put`s.

### `out`
You may to set [`inputs: detect`](https://concourse-ci.org/jobs.html#schema.step.put-step.inputs) for better performance if you have large resources in your pipeline.

#### First `put`
Creates a new check with state `in_progress`. `started_at` will automatically be set to the time when `in` was called.

#### Subsequent `put`s
Updates an existing check. Refer to [the GitHub Checks API documentation](https://docs.github.com/en/rest/reference/checks) for possible values and descriptions. `completed_at` will automatically be set to the time when `out` was called.

Supported `params`:
- `conclusion` (required, see docs linked above)
- `title` (optional, for the `output` object)
    - If `conclusion` is `cancelled` this will default to "Task cancelled by user"
    - If `conclusion` is `action_required` this will default to "Error running task"
- `summary` (optional, for the `output` object)
    - If `conclusion` is `cancelled` this will default to "Re-run the job within Concourse."
    - If `conclusion` is `action_required` this will default to "Review the output within Concourse."
