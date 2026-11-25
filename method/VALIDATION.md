# Migration validation — 2026-11-05

These checks ran in an independent temporary directory without symlinks to the original repository or reuse of its build caches.

- Complete roster: VerilogEval 156, RTLLM 50, CVDP 78, ChipBench 45; 329 total. All four adapters independently load every design.
- Python: syntax checks of all delivered sources; Stage 1, author, and RTL importer CLIs load successfully.
- Lean: framework build started from an empty `.lake`. Default `lake build` completed all 91 jobs, including LeanSpec, LeanRTL, SpecIR, FrozenRefinement, FrozenSpecBridge, and the Counter example. Existing linter/deprecation warnings remain; there were no build errors.
- Python regressions: base group 32 passed / 1 skipped; actual parser/import-only/emission integration group 6 passed. The skip follows an existing environment condition. This does not claim execution of every repository test.
- Stage 1 schema: 26 elaborator/schema checks passed. All 14 generator symbols occur in LeanSpec declarations or the case-local list.
- CPU: the 999-line RTL and 730-node shallow-certificate generators reproduce their artifacts exactly. Native-memory import acceptance and eight rejection boundaries passed. Fresh Yosys lowering / NativeMemoryImporter output for the actual RTL was byte-for-byte identical to `NativeImported.lean`.
- Package integrity: original-source hashes, delivered-file hashes, 329 clarified/interface pairs, and imports of 68 CPU Lean modules were checked.

Migration did not rerun complete CPU Lean proof replay, long PDR jobs, all benchmark scoring, or remote services. Retained final CPU evidence comes from the original runs. For a first complete proof replay, use `python3 case_cpu/memory/scripts/replay.py` without `--reuse-shallow`. Build caches and validation temporary files were removed from the delivered package.

## Existing compatibility issues addressed during packaging

1. Renamed the root Lake project to `LeanHardware` and registered the required SpecIR/fixed-target libraries.
2. The newer CPU native-memory importer had replaced the old MemBlock roundtrip API while old callers remained. Restored the archived implementation unchanged as `v2lean/memblock_compat.py` and redirected four imports. CPU `native_memory.py` was unchanged; the two semantics were not merged.
3. Two old Lean regressions expected arbitrary initialization from the clocked adapter, but the existing `clockedInitial` explicitly uses a fixed-zero profile. Updated expectations to zero initialization and documented that limitation, without changing framework, relation, or proof semantics.
4. `symbols_test` retains its original path convention and runs from `method/`, not the repository root. The root-level schema test works normally.

Run `python3 method/check_package.py` for a read-only integrity check. The original LeanSilicon source repository was not modified.

## Two-stage directory reorganization

Method code is organized under `method/stage1/` and `method/stage2/`. The SpecIR Lean namespace moved into Stage 1's `leanspec/lean/`; the agent backend moved into `stage1/common/`. Former root-level `specir/` and `v2lean/` directories were removed. Python module names and Lean theorem namespaces were retained.

Validation after reorganization:

- Root entry points, Python imports, Stage 1/Stage 2 CLIs, and CPU replay CLI work. Stage 2 can install framework/proof assets into a new workspace.
- A fresh `lake build` passed all 91 jobs.
- Python base regressions: 32 passed / 1 skipped. Actual parser/import-only/emission integration tests: 6 passed.
- Stage 1 schema: 26 cases passed; all 14 generated symbols checked.
- CPU native-memory import acceptance/rejection checks passed. The 68 CPU Lean modules, RTL, and ISA sources were unchanged; replay scripts only adjusted method dependency paths. At that reorganization step, the only shared Lean source edit was a directory-description comment in `SpecIR.lean`; theorem declarations and proofs were unchanged.
- New package hashes bind the current layout. Historical records and HTML remain descriptions of their original runs. This reorganization did not rerun the full CPU proof, PDR, or agent/model sessions.

Anonymization is retained: personal accounts and private hosts use `usr`; test logs and build caches were excluded from delivery.

## Fresh NL-to-RTL proof run (2026-11-05)

A new independent workspace completed VerilogEval `Prob022_mux2to1`: NL extraction → LeanSpec formalization / diagnosis / convergence → fresh RTL generation → Yosys import of the actual LeanRTL → refinement proof → source-only cold replay. No historical benchmark RTL or proof was reused.

- Stage 1 converged in one round. All eight single-cycle input combinations were determined, with no unanswered questions. Clarification/revision required no behavior changes; no human or designer answers were fabricated as run inputs.
- Added the missing relational handoff: the executable reference selects outputs from the original `admits decidedSpec`. `HandoffContract.Exact` proves exact equivalence over arbitrary-length input/output traces, including empty traces.
- The actual imported RTL passed the fixed `FrozenRefinement.Refines` target, covering all physical inputs, arbitrary finite traces, all initial/choice oracles, and the complete output interface.
- Isolated source-only rebuilding passed. `frozen_refinement` and `handoff_exact` depend only on standard Lean axioms, with no `sorryAx`, added axiom, or native LRAT dependency.
- Negative controls: constant-zero RTL failed the functional proof; a `by trivial` handoff term failed the handoff gate.
- Framework build: 92 jobs passed. Relevant Python regressions: 24 passed / 1 skipped. Schema: 27 cases passed. The skip is an existing optional integration test; the real end-to-end cold replay above ran separately.

Repairs covered the extraction template's required source field and Unicode-span description, the first Codex library grant and tool prompts, the generated `Case` stanza namespace, single-file Lake library globs, and pipeline ledgers being written into method directories. Added the MUX e2e profile, relational handoff proof gate, and corresponding regressions. Run outputs belong only in ignored `data/`, not the clarified benchmark corpus or method source. The anonymous export excluded raw agent transcripts and caches.

This new automatic handoff profile covers only the explicitly declared one-bit stateless MUX trace representation. It does not establish automatic end-to-end support for arbitrary sequential CPUs or memories. This run did not rerun the CPU, all benchmarks, or PDR. NL formalization and Yosys/RTLIL translation remain semantic conversion boundaries requiring review.

After `source env.sh`, configure an authorized backend and run `python3 -m leanrtl.e2e_mux --case mux_fresh`. See `method/stage2/example/mux_e2e/README.md`. Smoke-test `data/` artifacts were deleted during repository cleanup. These are historical validation results; the entry point regenerates specifications, RTL, proofs, and standalone replay certificates.
