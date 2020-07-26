# concourse-github-check-resource
Concourse resource for GitHub Checks

## Source configuration
All fields are required.

- `source` - the input where your source code is provided
- `token` - GitHub App token to use to authenticate
- `check_name` - the name of the check within GitHub
- `resource_name` - the name of the resource within Concourse

GitHub endpoint information, commit SHA, and the URL to the Concourse job log will be derived from the environment.

## Behavior

### `check`
Emits a random UUID (so Concourse calls `in` for every job, so we get the correct job URL.)

### `in`
Creates a new check with state `in_progress` and outputs the GitHub API response as `state.json` to the output directory. This should be used by `out` to update the check. `started_at` will automatically be set to the time when `in` was called.

### `out`
Updates an existing check. Refer to [the GitHub Checks API documentation](https://docs.github.com/en/rest/reference/checks) for possible values and descriptions. `completed_at` will automatically be set to the time when `out` was called.

Supported `params`:
- `conclusion` (required, see docs linked above)
- `title` (optional, for the `output` object)
    - If `conclusion` is `cancelled` this will default to "Task cancelled by user"
    - If `conclusion` is `action_required` this will default to "Error running task"
- `summary` (optional, for the `output` object)
    - If `conclusion` is `cancelled` this will default to "Re-run the job within Concourse."
    - If `conclusion` is `action_required` this will default to "Review the output within Concourse."

You also need to set `inputs` to the name of the resource and `skip: true` under `get_params`.
