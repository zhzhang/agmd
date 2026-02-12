# am

**am** manages `AGENTS.md` files for your project. It pulls agent instructions from GitHub repositories-shared skills, best practices, project conventions-and composes them into a single `AGENTS.md` alongside your local rules, which are given in `AGENTS.local.md` instead.

This allows you to easily maintain a set of local rules specific to your project, while also keeping up to date to externally written `AGENTS.md`s, i.e. those written by the providers of frameworks you are using in your project.

---

## Quickstart

### 1. Install am

```bash
curl -sSL https://raw.githubusercontent.com/zhzhang/am/refs/heads/main/install.sh | sh
```

This installer does not require cloning the repository. It creates a virtual environment in `~/.local/share/am-cli`, installs `am` from GitHub, and links the executable at `~/.local/bin/am`.

Optional overrides:

```bash
# Install location overrides
AM_APP_DIR="$HOME/.am" AM_BIN_DIR="$HOME/bin" \
  curl -sSL https://raw.githubusercontent.com/zhzhang/am/refs/heads/main/install.sh | sh

# Source override (for tags, forks, or custom archives)
AM_SOURCE_URL="https://github.com/zhzhang/am/archive/refs/tags/v0.1.0.tar.gz" \
  curl -sSL https://raw.githubusercontent.com/zhzhang/am/refs/heads/main/install.sh | sh
```

### 2. Initialize your project

In a your project directory:

```bash
am init
```

This will:

- Create `am.yml` in the project root, a manifest for externally sourced `AGENTS.md` similar to `package.json` or `pyproject.toml`
- Add entries to `.gitignore` for `AGENTS.md` and `**/.am/`
- If you have existing `AGENTS.md` files, rename them to `AGENTS.local.md`

### 3. Add a remote source

Pull in an `AGENTS.md` from a GitHub repo:

```bash
am add owner/repo/path/containing/target
```

To target the `AGENTS.md` at specific path in your project:

```bash
am add owner/repo --path src
```

Some `AGENTS.md` such as [Supabase's](https://github.com/supabase/agent-skills/blob/main/skills/supabase-postgres-best-practices/AGENTS.md) refer to dependency files that add additional information. Use the `--module` flag to pull down the additional references:

```bash
am add supabase/agent-skills/skills/supabase-postgres-best-practices --module
```

This downloads all files from that path into `.am/<module-name>/` so they can be referenced from the materialized `AGENTS.md`.

### 4. Sync

After adding sources or changing `am.yml`, refresh the composed files:

```bash
am sync
```

`am` fetches the latest remote content, merges it with any `AGENTS.local.md`, and writes the result to `AGENTS.md`.


## Why?

Jude Gao's (Vercel) [recent post](https://vercel.com/blog/agents-md-outperforms-skills-in-our-agent-evals) talks about how `AGENTS.md` files outperforms Skills by making sure that relevant context is always visible to the agent, rather than making the agent decide on where to look with a tool call.

In order to preserve the benefits of context visibility, most rules should live directly within `AGENTS.md` files.
Most current workflows to do this involve copypasting or concatenating directly into your project `AGENTS.md` files, and committing these changes.
This means that to incorporate new changes, i.e. when package interfaces change, developers have to manually edit these files, remove old rules, and update to new ones (or prompt an AI to do it, and hope that they get it right).

`am` solves this by materializing `AGENTS.md` files on the fly from remote files and local `AGENTS.local.md` files, which contain the project specific rules that you write for yourself.
A preamble is added at the top of the materialized root `AGENTS.md` telling agents how to find referenced files if an exernal provide has a module structure with a directory of additional referenced files.

```
This project's AGENTS.md files are managed by am, which may pull in AGENTS.md files from other sources.
These external AGENTS.md files will be delimited by:
# am start <module_name>.
Any files referenced by these modules will be located relative to the AGENTS.md file at .am/<module_name>.

# am start supabase/agent-skills/skills/supabase-postgres-best-practices.
...

# am local
My project's local rules.
```
