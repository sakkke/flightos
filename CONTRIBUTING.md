# Contributing

## Versioning
This project uses [CalVer](https://calver.org/) with `YYYY.MM.MICRO`.

## Commit messages
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

## Commit Workflow
1. [Create an issue](https://github.com/sakkke/flightos/issues).
2. [Fork this repository](https://github.com/sakkke/flightos/fork).
3. Create an new branch.
4. Work. When the work is done, please run `make fmt`.
5. [Create an new pull request](https://github.com/sakkke/flightos/compare).
6. Done! Back to 1.

## Release Workflow
1. [Create an issue](https://github.com/sakkke/flightos/issues).
2. [Fork this repository](https://github.com/sakkke/flightos/fork).
3. Create an new branch.
4. Run `make release ver=<next-version>`.
5. [Create an new pull request](https://github.com/sakkke/flightos/compare).
6. Done!
