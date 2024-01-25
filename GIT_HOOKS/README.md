<!-- markdownlint-disable MD024 MD026 MD036 MD041 -->
<!-- omit in toc -->
# Git Hooks 🪝

[![Python 3.12.1](https://img.shields.io/badge/Python-3.12.1-green)](https://www.python.org/downloads/release/python-3121/)
[![Django 4.2.9](https://img.shields.io/badge/Django-4.2.9-green)](https://docs.djangoproject.com/en/4.2/releases/4.2.9/)
[![PostgreSQL 14.6](https://img.shields.io/badge/PostgreSQL-14.6-green.svg)](https://www.postgresql.org/docs/14/)
[![Code style: black](https://img.shields.io/badge/code%20style-black-000000.svg)](https://github.com/psf/black)
[![License EUPL 1.2](https://img.shields.io/badge/License-EUPL--1.2-blue.svg)](LICENSE)
[![Follow SDU RIO Analytics on Mastodon](https://img.shields.io/mastodon/follow/110944426785095712)](https://mastodon.social/@sdurioanalytics "Follow @sdurioanalytics@mastodon.social on Mastodon")

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
