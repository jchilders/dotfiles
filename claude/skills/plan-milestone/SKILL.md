---
name: plan-milestone
description: Decompose a milestone/spec directory into beads issues (features + task + dependency graph) as a dry-run plan. User reviews and approves before any `bd create` fires. Use when the user points at a spec doc or directory and asks for a bead breakdown, task graph, or project plan. One bead per task doc (type=feature), plus one bead for milestone-level end-to-end acceptance (type=task). Dry-run is the default — never create beads without explicit approval.
---

# plan-milestone

Convert a milestone specification into a beads plan. Always dry-run first.

## Scope guard — M9 only

The user is contracted for **M9 (Parcel Evaluation Agent)** only. Other
milestones in `krabby-contracts/milestones/` are handled by other contractors.

**If the input path resolves under `krabby-contracts/milestones/` and the
milestone is NOT M9, refuse.** Print:

> Refusing: this workspace is scoped to M9. Other milestones are handled by
> other contractors. See memory `project_m9_only_scope`.

Do not proceed. Do not offer to plan it anyway.

Paths outside `krabby-contracts/milestones/` (e.g. sibling projects like
`krabby-home`) are fine — the scope guard is specifically about milestone specs.

## Inputs

- **spec path** (required) — directory or file. If a file, walk up to the
  enclosing milestone directory. Expect an `OVERVIEW.md` plus one or more
  `Task-N-<NAME>.md` docs.
- **rig** (optional) — which Gas Town rig this work lands in. Default: infer
  from the spec (M9 → `krabby-home`).

If the user doesn't specify a path, ask — don't guess.

## Workflow

### 1. Read the specs

Read `OVERVIEW.md` and every `Task-N-*.md`. Pull out:
- Milestone-level acceptance criteria (§ "Acceptance Criteria" in OVERVIEW).
- Per-task summary and data-flow position.
- Inter-task dependencies implied by the data flow diagram.

### 2. Scan existing beads

Run in parallel:
- `bd list --status=open`
- `bd list --status=in_progress`
- `bd search <milestone-tag>` (e.g. `bd search M9`)

Flag any existing bead that looks like it already covers a task doc. Do NOT
propose a duplicate — reference the existing ID in the plan and note "already
tracked."

### 3. Build the plan

**Structure:**
- One **feature** bead per `Task-N-*.md` (title = task doc title, description
  summarizes scope + links to the spec doc path).
- One **task** bead for milestone-level end-to-end acceptance (title = "M<N>
  E2E acceptance", description = the milestone-level AC list from OVERVIEW §6).

**Dependencies** (inferred from the data flow, verify against OVERVIEW §2):
- Walker depends on Curator.
- Assessor depends on Walker and Curator.
- Realtor (and minimal GC) depends on Assessor.
- E2E depends on all four features.

**Priority:** Default P2 (medium). Critical-path items (Curator, then the E2E
acceptance) can be P1. Ask the user if unsure rather than guessing.

### 4. Present the dry-run plan

Show the user:
1. A bulleted list of proposed beads with title, type, priority, and a 1-line
   description. Mark anything that matches an existing bead as `[EXISTS: bd-xyz]`.
2. A dependency graph in ASCII or mermaid. Label the critical path.
3. A numbered `bd create` command list they could run manually (for
   transparency — don't run them yet).
4. Explicit question: "Create these beads now? (yes / edit / no)"

**Do NOT run `bd create` in this step.** The whole point of dry-run is that the
user sees the plan before anything is written.

### 5. On approval: create

Only after explicit "yes":

1. Run `bd create` for each new bead. These can run in parallel via subagents
   if there are many (>4).
2. Collect the returned bead IDs.
3. Run `bd dep add <child> <parent>` for each edge. Must be sequential after
   step 1 completes — deps need real IDs.
4. Run `bd ready` and show the output. These are the unblocked starting
   points.
5. Remind the user: `bd dolt push` at session end to persist.

### 6. On "edit"

Let the user revise (drop a bead, re-parent, re-prioritize). Re-render the
plan. Ask again. Do not create until a clean "yes."

### 7. On "no"

Stop. Do not create anything. Offer to save the dry-run plan as a markdown
note if useful.

## Out of scope (v1)

- **Per-AC beads.** One bead per task doc is deliberate — keeps `bd ready`
  signal coarse. If an AC is big enough to need its own bead, the user can
  add it as a dependent task after the feature is open.
- **Spec drift detection.** If a spec changes later, this skill doesn't
  re-diff. Manual path: `bd supersede <old> --with=<new>`.
- **Cross-milestone planning.** Scope guard forbids it.

## Notes on beads CLI

- Priority values are `0-4` or `P0-P4`, not `"high"/"medium"`.
- Never use `bd edit` — it opens $EDITOR and blocks. Use `--title`, `--description`, etc. inline.
- `bd create --validate` checks for required sections; `bd create --acceptance=...` sets AC.
- For many creates in parallel, dispatch subagents — but only after the user has approved the plan.
