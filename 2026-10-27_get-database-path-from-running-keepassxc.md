---
commit_ref: 7eef150e34f9fca5d385860fc53d5429d158be43
title: "Get database path from running KeePassXC"
author: "Janik von Rotz <login@janikvonrotz.ch>"
action: research
state: completed
date_completed: 2025-10-27
harness: pi
model: moonshotai/Kimi-K2.6
input_tokens:
output_tokens:
---

# Get database path from running KeePassXC

Note: @Clanker refers to the "ai agent" (you) who is working on this prompt file.

@Clanker when working on this prompt file, make sure to:

- Read context and research section first
- Change this file only
- State findings without making suggestions

## Context

@Clanker Read the `AGENTS.md` and `README.md` to get an understanding of the project.

## Research

There are task commands that interact with a KeePassXC database. It is required to set the path to the database and the keyfile.

I would like to know if it is possible to interact with the running KeePassXC instead of using the keepassxc-cli.

Similar to how the KeePassXC browser extension interacts with KeePassXC, I would like to read and store credentials from the database.

Can you analyse what options there are. Also interesting would be reading the path of the database and keyfile from KeePassXC and show a dialog to select the database when storing / reading info.

@Clanker When research is completed set frontmatter state to review. Prompt the author to verify the findings.

## Findings

### Executive Summary

It is **possible** to interact with a running KeePassXC instance without using `keepassxc-cli` and without re-entering the database password every time. However, it is **not possible** to programmatically discover the currently open database file path or to show a database selection dialog from an external tool. These limitations exist by design for security reasons.

### Interaction Options

#### 1. KeePassXC Browser Integration Protocol

KeePassXC exposes a native messaging protocol (used by browser extensions) that allows reading and writing credentials from an **unlocked** database after a one-time association.

**Capabilities:**
- `get-logins` — retrieve credentials matching a URL/search string
- `set-login` — add or update credentials
- `generate-password` — generate passwords using KeePassXC's settings
- `create-new-group` — create new groups
- `get-database-groups` — list groups
- `lock-database` — lock the database

**Limitations:**
- Requires browser integration to be enabled in KeePassXC (`Tools → Settings → Browser Integration`)
- Works with whichever database is currently active/unlocked; cannot target a specific database file
- Cannot expose the database file path
- Cannot show a database selection dialog
- Requires a one-time association step (public key exchange stored in the OS keyring)

**Existing CLI Tools:**
| Tool | Language | Install | Notes |
|------|----------|---------|-------|
| `kpx` / `kpx-cli` | Rust | `cargo install kpx-cli` | Mature tool, stores associations in OS keyring, outputs JSON |
| `keepassxc-proxy-cli` | Python | `pip install keepassxc_proxy_client` | Simple wrapper around the Python client library |
| `kpxccligo` | Go | Build from source | Go client for browser protocol |
| `keepassxc-browser-client` | Python library | `pip install keepassxc-browser-client` | Low-level library for custom scripts |

**Example (using `kpx`):**
```bash
# One-time setup: create association with KeePassXC
kpx associations new
# Fetch credentials for a URL
kpx get --url https://example.com
```

#### 2. Freedesktop.org Secret Service Integration

KeePassXC can act as a Secret Service provider over D-Bus, exposing a configured group of entries to any Secret Service client.

**Capabilities:**
- Store and retrieve secrets via standard tools (`secret-tool`, `python-secretstorage`)
- No database password prompt needed once KeePassXC is unlocked
- Access confirmation dialogs can be enabled per-request

**Limitations:**
- Requires manual setup in KeePassXC (`Tools → Settings → Secret Service Integration`)
- Only one Secret Service provider can run at a time (may conflict with GNOME Keyring / KWallet)
- Must explicitly expose a specific group per database
- Cannot get the database file path
- Cannot browse or list all entries freely; works via attribute-based search

**Setup Steps:**
1. In KeePassXC: `Tools → Settings → Secret Service Integration → Enable`
2. Per database: `Database → Database Settings → Secret Service Integration → Expose entries under this group`
3. Optionally enable access confirmation dialogs

**Example (using `secret-tool`):**
```bash
# Store a secret
secret-tool store --label="my-label" service myapp username myuser
# Retrieve a secret
secret-tool lookup service myapp username myuser
```

#### 3. KeePassXC D-Bus Interface

KeePassXC registers `org.keepassxc.KeePassXC.MainWindow` on the session bus.

**Available Methods:**
- `openDatabase(fileName, pw, keyFile)` — open a specific database file
- `appExit()` — exit the application
- `lockAllDatabases()` — lock all open databases
- `closeAllDatabases()` — close all open databases
- `isHardwareKeySupported()` / `refreshHardwareKeys()` — hardware key support

**Limitations:**
- **Cannot** list open databases
- **Cannot** get the path of the currently open database
- **Cannot** read or write entries
- Only useful for opening a known database file or locking/closing

#### 4. `keepassxc-proxy` (Low-level)

The `/usr/bin/keepassxc-proxy` binary implements the browser protocol's transport layer but is designed to be launched by browser native messaging hosts. It is not intended for direct CLI use.

### Can the Database Path Be Discovered?

**No.** There is no supported API to get the path of the currently open `.kdbx` file from a running KeePassXC instance. This is an intentional security boundary.

Workarounds (all have trade-offs):
- **Parse window title** (`xprop` / `wmctrl`): KeePassXC shows the database name in the window title, but not necessarily the full path.
- **Parse process arguments**: KeePassXC may be launched with a file argument, but databases opened later won't be reflected.
- **Read recent files** from `~/.cache/keepassxc/keepassxc.ini`: Contains recent databases but may not reflect the currently open file.

### Can a Database Selection Dialog Be Triggered?

**No.** There is no API to show a database selection or "open file" dialog in KeePassXC from an external process. The D-Bus `openDatabase` method requires passing a concrete file path.

### Recommendation for This Project

Given the current `task` script architecture, the most practical paths forward are:

1. **Secret Service Integration** (best for automation):
   - Expose a dedicated group (e.g., `dotenv` or `cli`) to Secret Service
   - Rewrite `get-pass-from-keepass`, `save-pass-to-keepass`, etc., to use `secret-tool`
   - Benefit: no database path, no key file, no password prompt needed
   - Trade-off: requires Secret Service setup and single-group exposure

2. **Browser Protocol via `kpx`** (best for KeePassXC-native access):
   - Install `kpx-cli`
   - Replace `keepassxc-cli` calls with `kpx get --url <search>` / `kpx set ...`
   - Benefit: full access to database entries, no password prompts after association
   - Trade-off: requires Rust/Cargo, one-time association per machine/browser-protocol setup

3. **Hybrid Approach**:
   - Keep `KEEPASS_DATABASE_FILE` and `KEEPASS_DATABASE_KEY_FILE` in `.env` as fallback defaults
   - Add optional Secret Service or Browser Protocol paths that skip the `keepassxc-cli` flow when available
   - Show a helpful error when neither integration is configured

@Clanker If author confirms findings set frontmatter state to completed, otherwise to aborted. Update date, harness and model. If you have access to session info also add token count.
