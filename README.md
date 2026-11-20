# ste80-humanizer

A Nix flake pinning [STE80 Humanizer](https://github.com/Dodaios/ste80-humanizer), an agent skill that rewrites AI-sounding prose into the structure of Simplified Technical English, softened to 80%.

## Artifact

`skill` is the skill as an agent discovers it at the pinned commit: `SKILL.md`, the `references/` and `scripts/` trees it reads, and upstream's `LICENSE` and `THIRD_PARTY_NOTICES.md`. The rest of the upstream repository (its plugin manifests, eval cases and grader rubrics, overview image, and its own `README` and `CHANGELOG`) is that repository's own scaffolding. It travels with the output instead of being filtered out: evaluating this flake realizes the full tarball regardless, so a filtered copy would add a store path instead of avoiding one.

## Consuming

```nix
skill = ste80-humanizer.skill;
```

The output is a directory whose entry point is `SKILL.md`, so it drops into whichever directory a framework discovers skills in, as one entry named after the skill:

```nix
home.file.".agents/skills/ste80-humanizer".source = ste80-humanizer.skill;
```

## What you get

- Nothing is built here. The output is a plain store path reached by an eval-time fetch, so a consumer may read `SKILL.md` during evaluation rather than after a build. It is a flake-level output rather than `packages.default` for that reason: a plain path is not a derivation, and `nix flake check` requires `packages.<system>.*` to be one.
- The flake does not install, register, or validate anything. `SKILL.md` is prose an agent reads. Following it is the framework's business.
- `scripts/ste_check.py` is an optional heuristic linter the skill offers. It has no dependencies but needs a Python 3 the consumer provides, and it is not an AI detector or a compliance check.
- Nothing is filtered out, so an upstream release that puts the skill's content somewhere else in the repository still arrives complete. Skill discovery reads `SKILL.md` from the directory and the rest travels unread.
- Upstream publishes no releases, so the pin tracks commits: `version` is synthesized from the commit date and `sourceRev` names the commit it resolves to.

See [LICENSE.md](LICENSE.md) for licensing and copyright, and [NOTICE.md](NOTICE.md) for the terms of upstream and distributed artifacts.
