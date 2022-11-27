# Contributing

## Table of Contents

- [Contributing](#contributing)
    - [Versioning](#versioning)
    - [Commit Messages](#commit-messages)
        - [Scopes](#scopes)
    - [Commit Workflow](#commit-workflow)
    - [Release Workflow](#release-workflow)

## Versioning
[(Back to top)](#table-of-contents)

This project uses [CalVer](https://calver.org/) with `YYYY.0M.MICRO`.

## Commit Messages
[(Back to top)](#table-of-contents)

This project uses [Semantic Commit Messages](https://gist.github.com/joshbuchea/6f47e86d2510bce28f8e7f42ae84c716).

```
feat: add hat wobble
^--^  ^------------^
|     |
|     +-> Summary in present tense.
|
+-------> Type: chore, docs, feat, fix, refactor, style, or test.
```

More Examples:
- `feat`: (new feature for the user, not a new feature for build script)
- `fix`: (bug fix for the user, not a fix to a build script)
- `docs`: (changes to the documentation)
- `style`: (formatting, missing semi colons, etc; no production code change)
- `refactor`: (refactoring production code, eg. renaming a variable)
- `test`: (adding missing tests, refactoring tests; no production code change)
- `chore`: (updating grunt tasks etc; no production code change)

### Scopes
[(Back to top)](#table-of-contents)

- none: (changes to production code)
- `build`: (changes to compiler options, etc.)
- `dev`: (improves DX)
- `release`: (releases an new version **only**, for more information, please see how to [release workflow](#release-workflow))
- `task`: (changes to tasks)
- `workflow`: (changes to workflows)

Scope Examples:
- `feat: implement the basic feature`
- `chore(build): add -prod option`
- `chore(dev): add .editorconfig`
- `chore(release): 2023.01.0`
- `chore(task): add build`
- `chore(workflow): add release step`

## Commit Workflow
[(Back to top)](#table-of-contents)

1. [Create an issue](https://github.com/sakkke/flightos/issues).
2. [Fork this repository](https://github.com/sakkke/flightos/fork).
3. Create an new branch.
4. Work. When the work is done, please run `make fmt`.
5. Commit with following (commit messages)[#commit-messages]
6. [Create an new pull request](https://github.com/sakkke/flightos/compare).
7. When a pull request is merged, close an issue.
8. Done! Back to 1.

## Release Workflow
[(Back to top)](#table-of-contents)

1. [Create an issue](https://github.com/sakkke/flightos/issues) titled `Releasing <next-version>`.
2. [Fork this repository](https://github.com/sakkke/flightos/fork).
3. Create an new branch.
4. Commit with `chore(draft): <next-version>`.
5. [Create an new pull request](https://github.com/sakkke/flightos/compare).
6. When a pull request is merged, close an issue.
7. Done!
