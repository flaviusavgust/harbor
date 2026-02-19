[![Conventional Commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-green.svg)](https://conventionalcommits.org)
[![Semantic Versioning](https://img.shields.io/badge/Semantic%20Versioning-2.0.0-green)](https://semver.org/spec/v2.0.0.html)
[![Pipeline](https://code.vandalsweb.com/ansible-roles/harbor_registry/badges/master/pipeline.svg)](https://code.vandalsweb.com/ansible-roles/harbor_registry/pipelines)

# Ansible role - Harbor Registry
Install/configure a [Harbor Docker registry](https://goharbor.io).


## Project management
To provide an easy way to manage the project, there are some _make targets_ to run the most common tasks:

- To download dependencies, requirements, etc: `make deps`.
- To run tests suites: `make tests`.
- To generate the CHANGELOG based in the _git_ history: `make changelog`.
- To clean the temporary files, built artifacts and _clean_ the project directory: `make clean`.
- To see a complete list of targets with a short description about each one: `make help`.


## Requirements
Harbor requires [Docker](https://www.docker.com/) and [OpenSSL](https://www.openssl.org/), so you can use these other Ansible roles to manage these requirements:
- [Docker role](https://code.vandalsweb.com/ansible-roles/docker)
- [SSL certs role](https://code.vandalsweb.com/ansible-roles/sslcerts)

These requirements are configured in the [`requirements-roles.yml`](requirements-roles.yml) file.

About the rest of requirements, you only need [Python](https://www.python.org/) (v3, of course!). The rest of the packages or dependencies required to run the project
are downloaded with the `make deps` command, but as in the rest of projects based on Python, it's a good recommendation to use a
[Virtualenv](https://virtualenv.pypa.io/en/latest/) before download dependencies, just like this:

```bash
$ python3 -m venv .venv
$ source .venv/bin/activate
(.venv) $ make deps
``` 


## Role Variables
Almost every option have a _default_ value (you can check these values in `defaults/main.yml` file), but you can override as much as
you want (from _command-line_ param, in your own `vars.yml` file, etc).

- General options:
    - `foo1`: Variable description (default: `value`).
    - `foo2`: Set to `true` to enable, `false` otherwise (default: `true`).


## Example Playbook
You can run the role with this basic example:

```yaml
- hosts: all
  vars:
    foo1: value
    foo2: false
  roles:
    - "harbor_registry"
```


## Upgrading
Upgrading the Harbor registry server to a latest version (using the variable `harbor_registry_version`) only update the packages, not the configuration files... so maybe in 
future versions some configuration parameters could change, but the `harbor.yml.tmpl` file will be always the same (this file is not changed with each upgrade).

A good recommendation is download the latest version of the
[Harbor configuration file](https://github.com/goharbor/harbor/blob/master/make/harbor.yml.tmpl) after
each upgrade and compare with your version in order to detect deprecated, new or modified directives, just like that:

```bash
$ sudo curl https://raw.githubusercontent.com/goharbor/harbor/master/make/harbor.yml.tmpl -o/tmp/harbor.yml.latest
$ vimdiff /etc/harbor/harbor.yml /tmp/harbor.yml.latest
```


## References
Tools, external libraries, useful references and other third-part software used in the project:

- [Semantic Versioning (semver)](https://semver.org): A simple set of rules and requirements that dictate how version numbers are assigned
  and incremented.
- [Conventional Commits](https://www.conventionalcommits.org): A specification for adding human and machine readable meaning to commit
  messages.
- [Git-hooks](https://github.com/git-hooks/git-hooks): Hook manager.
- [Git-chglog](https://github.com/git-chglog/git-chglog): CHANGELOG generator.
- [Ansible](https://www.ansible.com/): Ansible is an open-source software provisioning, configuration management, and 
  application-deployment tool enabling infrastructure as code.
- [Molecule](https://molecule.readthedocs.io/en/latest/): Molecule project is designed to aid in the development and testing of Ansible
  roles.


## License
This project is licensed under MIT License. See [LICENSE](LICENSE) for more details.


## Author
This project is just another amazing idea of _BhEaN_, created on 2021.
