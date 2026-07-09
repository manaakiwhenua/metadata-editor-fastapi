# Metadata Editor - FastAPI service (platform fork)

This is our fork of [`worldbank/metadata-editor-fastapi`](https://github.com/worldbank/metadata-editor-fastapi) - the Python/FastAPI data-processing service (SPSS/Stata/CSV → summaries + data dictionaries) consumed by the Metadata Editor web app. It's packaged to build and run on our Kubernetes platform.

For the **service's own** documentation, see the upstream [`README.md`](../README.md). This page covers how **we** work in the fork: which branch is live, and how to name branches so our build/deploy changes stay cleanly separable from upstream (and so genuine fixes can still go back).

## Running it locally

The full stack (web + this API + MySQL + Mailpit) runs from the **web repo's** `docker-compose` (it builds this service via `FASTAPI_CONTEXT`, pointing at a local checkout of this repo). A standalone `Dockerfile` for this service is still to come (MT-34).

## Which branch is live?

**`downstream`** — not `main`.

- **`main`** is a mirror of the World Bank's `main`. We never commit our own work here; it only moves by pulling in upstream updates.
- **`downstream`** is our version: `main` **plus** everything we add to run it ourselves (Dockerfile, CI, config). This is the branch CI builds and deploys.

Think of it as: **`downstream` is our `main`; `main` is theirs.**

## Naming your branch

Before you start, ask one question: **would the World Bank want this change too?**

| Your change is… | Branch off | Name it | PR into |
|---|---|---|---|
| **Just to run it here** (Docker, CI, config, our dev docs) | `downstream` | `build/<desc>` | `downstream` |
| **A real fix/feature for the service itself** (upstreamable) | `main` | `fix/` `feat/` `docs/` `chore/<desc>` | `main`, then offer upstream |

The **base branch** is what matters — the prefix just labels the choice. `build/` means "ours," even when it isn't literally a build file.

```bash
# Something just for us (the usual case):
git switch downstream && git pull
git switch -c build/<short-desc>
#   ...work...  →  open a PR into downstream

# Something worth sending back upstream:
git switch main && git pull
git switch -c fix/<short-desc>        # or feat/ , docs/
#   ...work...  →  open a PR into main
```

**The rule in one line:** `main` only ever moves by pulling from upstream; everything we write lands on `downstream`.

## Where fork-only files live

Our additions go in paths upstream doesn't have, so they never cause merge conflicts on re-sync:

- **CI** → `.github/` (this file lives here too)
- **Container build** → `Dockerfile` at the repo root (to come — MT-34)
- **Kubernetes manifests** → the separate `k8s-apps-config` repo (not in this fork at all)

Name any fork-only folder by **function, not by us** (`ops/`, `deploy/`), never an org name — that keeps it durable. Avoid editing files upstream also owns (like the root `README.md`) where you can; that's why this doc is in `.github/` rather than appended to the shared README.

To see everything the fork adds: `git diff main downstream`.
