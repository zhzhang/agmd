# agmd

**agmd** manages `AGENTS.md` files for your project. It pulls agent instructions from GitHub repositories—shared skills, best practices, project conventions—and composes them into a single `AGENTS.md` alongside your local rules, which are given in `AGENTS.local.md` instead.

This allows you to easily maintain a set of local rules specific to your project, while also keeping up to date to externally written `AGENTS.md`s, i.e. those written by the providers of frameworks you are using in your project.

---

## Quickstart

### 1. Install agmd

From the project root:

```bash
curl -sSL https://raw.githubusercontent.com/zhzhang/agmd/refs/heads/main/install.sh | sh
```

### 2. Initialize your project

In a your project directory:

```bash
agmd init
```

This will:

- Create `agmd.yml` in the project root, a manifest for externally sourced `AGENTS.md` similar to `package.json` or `pyproject.toml`
- Add entries to `.gitignore` for `AGENTS.md` and `**/.agmd/`
- If you have existing `AGENTS.md` files, rename them to `AGENTS.local.md`

### 3. Add a remote source

Pull in an `AGENTS.md` from a GitHub repo:

```bash
agmd add owner/repo/path/containing/target
```

To target the `AGENTS.md` at specific path in your project:

```bash
agmd add owner/repo --path src
```

Some `AGENTS.md` such as [Supabase's](https://github.com/supabase/agent-skills/blob/main/skills/supabase-postgres-best-practices/AGENTS.md) refer to dependency files that add additional information.

```bash
agmd add owner/repo/tree/main/skills/my-skill --module
```

This downloads all files from that path into `.agmd/<module-name>/` so they can be referenced from the materialized `AGENTS.md`.

### 4. Sync

After adding sources or changing `agmd.yml`, refresh the composed files:

```bash
agmd sync
```

`agmd` fetches the latest remote content, merges it with any `AGENTS.local.md`, and writes the result to `AGENTS.md`.


## How it works

