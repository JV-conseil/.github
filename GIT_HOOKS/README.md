<!-- markdownlint-disable MD024 MD026 MD036 MD041 -->
<!-- omit in toc -->
# Git Hooks 🪝

[![Become a sponsor to JV-conseil](https://img.shields.io/static/v1?label=Sponsor&message=%E2%9D%A4&logo=GitHub&color=%23fe8e86)](https://github.com/sponsors/JV-conseil "Become a sponsor to JV-conseil")
[![Follow JV conseil on StackOverflow](https://img.shields.io/stackexchange/stackoverflow/r/2477854)](https://stackoverflow.com/users/2477854/jv-conseil "Follow JV conseil on StackOverflow")
[![Follow JVconseil on Twitter](https://img.shields.io/twitter/follow/JVconseil.svg?style=social&logo=twitter)](https://twitter.com/JVconseil "Follow JVconseil on Twitter")
[![Follow JVconseil on Mastodon](https://img.shields.io/mastodon/follow/110950122046692405)](https://mastodon.social/@JVconseil "Follow JVconseil@mastodon.social on Mastodon")
[![Follow JV conseil on GitHub](https://img.shields.io/github/followers/JV-conseil?label=JV-conseil&style=social)](https://github.com/JV-conseil "Follow JV-conseil on GitHub")

Git hooks are scripts that run automatically every time a particular event occurs in a Git repository. They let you customize Git’s internal behavior and trigger customizable actions at key points in the development life cycle.

![Hooks executing during the commit creation process](https://wac-cdn.atlassian.com/dam/jcr:ac22adee-d740-4216-a92a-33c14b5623e5/01.svg?cdnVersion=1408)

Common use cases for Git hooks include encouraging a commit policy, altering the project environment depending on the state of the repository, and implementing continuous integration workflows. But, since scripts are infinitely customizable, you can use Git hooks to automate or optimize virtually any aspect of your development workflow.

In this article, we’ll start with a conceptual overview of how Git hooks work. Then, we’ll survey some of the most popular hooks for use in both local and server-side repositories.

_source: <https://www.atlassian.com/git/tutorials/git-hooks>_

## Install

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/JV-conseil/.github/main/GIT_HOOKS/install.sh)"
```

## Documentation 📚

- [Git hooks](https://www.atlassian.com/git/tutorials/git-hooks) - atlassian.com
- [Customizing Git - Git Hooks](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks) - git-scm.com
- [How to avoid developers to commit without mention the issue on commit message on Github](https://stackoverflow.com/questions/13704498/how-to-avoid-developers-to-commit-without-mention-the-issue-on-commit-message-on) - stackoverflow.com
