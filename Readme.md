# This repository is a fork

The wretry.action executes the PRE and POST steps of the action that we are trying to retry, even if the action is disabled by a conditional `if` statement. This repository contains minor changes and adds the parameter `disable_pre_and_post`.

## How to use this fork

```yaml
- uses: gmsllc/wretry.action@master
  if: ${{ vpn_connection == 'true' }}
  with:
    action: action/openvpn@1.0.0
    with: |
      username: test
      password: test123
    attempt_limit: 3
    attempt_delay: 2000
    disable_pre_and_post: 'true'
```

[![Stand With Ukraine](https://raw.githubusercontent.com/vshymanskyy/StandWithUkraine/main/banner2-direct.svg)](https://stand-with-ukraine.pp.ua)

# action::retry [![status](https://github.com/Wandalen/wretry.action/actions/workflows/wRetryActionPublish.yml/badge.svg)](https://github.com/Wandalen/wretry.action/actions/workflows/wRetryActionPublish.yml) [![stable](https://img.shields.io/badge/stability-stable-brightgreen.svg)](https://github.com/emersion/stability-badges#stable)

Retries an Github Action step or command on failure.

Works with either shell commands or other actions to retry.

## Why

Github actions which use an Internet connection can fail when connection is lost :

```bash
Run actions/setup-node@v1
connect ETIMEDOUT 104.20.22.46:443
Waiting 15 seconds before trying again
connect ETIMEDOUT 104.20.22.46:443
Waiting 18 seconds before trying again
Error: connect ETIMEDOUT 104.20.22.46:443
```

It is a cause of failed jobs. For this case, the action `wretry.action` can retry the action immediately after fail or with some delay. And if the connection will be restored, then the job will continue the normal run.

## Features

- Retries Github `JavaScript` actions. The action can be an action repository that is not published on `Marketplace`.
- Retries shell commands.
- Can retry single action or single command ( multiline command ), but not both simultaneously.
- Retries `main`, `pre` and `post` stages of external actions.
- Always has `pre` and `post` stages. If external action has `pre` or/and `post` stage, then action run it also.
- Handles no conditions in external actions ( fields `pre-if` and `post-if` ). All stages of external action will be performed.
- Resolves external action default inputs from next contexts : `github`, `env`, `job`, `matrix`.
- Retries actions with defined number of attempts ( default is 2 ).
- Retries actions with defined delay between attempts ( default is 0 ).

## Inputs

### `action`

The name of the Github action.

### `command`

The command to run.

**Attend**. Action requires defined `action` or `command`. If the fields `action` and `commands` are defined simultaneously, then action will throw error.

### `with`

An options map for Github action. It is a multiline string with pairs `key : value`.

An example of declaration of option with single line value :
```yaml

- uses: Wandalen/wretry.action@master
  with:
    action: owner/action-repo@version
    with: |
      option1: value
      option2: value
```
An example of declaration of option with multiline string :
```yaml

- uses: Wandalen/wretry.action@master
  with:
    action: owner/action-repo@version
    with: |
      option1: |
        value1
        value2
          value3
      option2: value
```

### `current_path`

Setup working directory for the action. Works with only commands. Default is `github.workspace` path.

### `attempt_limit`

Set number of attempts. Default is 2.

### `attempt_delay`

Set delay between attempts in ms. Default is 0.

## Outputs

The action exposes single output named `outputs`. It collects all the outputs from the action/command in the pretty print JSON map.

### How to use outputs from the external action

To access the value from an external action outputs parse the `wretry.action` output and select required key. To parse the outputs use builtin Github Actions function `fromJSON`.

Let's look at an example:

```yaml
jobs:
  job1:
    runs-on: ubuntu-latest
    outputs:
      out: ${{ steps.my-action.outputs.outputs }}
    steps:
      - id: my-action
        uses: Wandalen/wretry.action@1.2.0
        with:
          attempt_limit: 3
          action: user/action@version
          with: |
            foo: bar
  job2:
    runs-on: ubuntu-latest
    needs: job1
    steps:
      - env:
          OUTPUT1: ${{ fromJSON( needs.job1.outputs.out ) }}
          OUTPUT2: ${{ fromJSON( needs.job1.outputs.out ).foo }}
        run: echo "$OUTPUT1 $OUTPUT2"
```

To setup job output we access output `outputs` of the step `my-action`. In the job `job2` we parse this output to JSON. The environment variable `OUPUT1` represents full JSON and the variable `OUPUT2` represents key `foo` of the parsed JSON.

## Example usage

### Retry action

```yaml
- uses: Wandalen/wretry.action@master
  with:
    action: action/setup-node@2.3.0
    with: |
      node-version: 14.x
      architecture: x64
    attempt_limit: 3
    attempt_delay: 2000
```

### Retry command

```yaml
- uses: Wandalen/wretry.action@master
  with:
    command: npm i
    attempt_limit: 3
    attempt_delay: 2000
```

### Development and contributing

To build compiled dependencies utility `willbe` is required. To install utility run :

```
npm i -g 'willbe@latest'
```

`willbe` is not required to use the action in your project as submodule.

<!-- will .publish action.release.minor -->
