## List of used tools
* [pre-commit](https://pre-commit.com/) - simplifies configuration of git pre-commit hook to improve build in quality
* [commitizen](https://commitizen-tools.github.io/commitizen/) - Automate creation of commits following **Conventional Commit** standard

## Repository structure
* /example - place where we call root module and showcase it's usage. Also used as test case.
* locals.tf - should contain Terraform global internal variables
* main.tf - should contain module central logic
* main_*.tf - also contains logic, divided into separate files for better visibility
* outputs.tf - Terraform output variables
* providers.tf - Should contain only **dynamic** providers for module
* variables.tf - Terraform input variables
* versions.tf - Terraform version constrains for binary and providers

## Code development
### Branch names
When creating new feature or delivering bugfix create new branch named:</br>
- feature/{miningful name}
- bugfix/{miningful name}

### Testing code locally
To run static analysis of your code run command:</br>
`pre-commit run -a`

### Creating commit
To create commit following **Conventional Commits** run command:</br>
`cz commit -a`

### Versioning
Versioning will be handled by CI setup based on commit messages.</br>
Different parts of SemVer version will be bumped based on type of commit:
* feat - bumps minor
* fix - bumps patch

## Releasing
After PR with new feature is merged to **main** branch, CI will generate **Release PR**</br>
You can then either: 
* approve of Release PR which will start new pipeline on main branch -> version code, generate Changelog and publish module
* omit approval and prepare new functionality. New feature after being added to codebase will update Release PR.

