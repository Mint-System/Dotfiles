# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Added
- Added `AGENTS.md` to define universal rules and expectations for LLM agents working within the repository, including safety, planning, context, sparsity, environment/tooling, and detailed Bash coding conventions.
- Added support for the `cortecs` LLM model in `llm/extra-openai-models.yaml` and configured API key setup in the `install-llm` task.
- Added `prompts/01_add-cortects-to-llm-models.md` to document the task of integrating the cortecs model.

### Changed
- Updated license from GNU General Public License v3 to GNU Affero General Public License v3 to ensure source code availability for network server software.
- Updated `install-llm` task to use `dotenv/api_key_infomaniak` and `dotenv/api_key_cortecs` for API key retrieval from KeePass.

### Removed
- Removed unnecessary newline at end of `CHANGELOG.md`.
