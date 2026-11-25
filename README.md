# LeanHardware

[Project website](https://anonymous.4open.science/w/LeanHardware/)

An anonymous source package containing 329 clarified benchmarks, the two-stage LeanHardware method, and a complete RISC-V CPU case study.

```text
LeanHardware/
├── benchmarks/                 VerilogEval / RTLLM / CVDP / ChipBench
├── method/
│   ├── stage1/                 LeanSpec: formalization, diagnosis, clarification / revision
│   ├── stage2/                 LeanRTL: RTL-to-Lean parser, agentic theorem proving
│   ├── check_package.py
│   ├── VALIDATION.md           Validation scope and historical records
│   └── MIGRATION.json          Sources, layout, and package hashes
├── case_cpu/                   Complete RISC-V CPU case study
├── README.md
├── lakefile.toml               Lean build configuration
├── lean-toolchain             Lean version
├── requirements.txt           Python dependencies
└── env.sh                     Python environment setup
```

## Clarified benchmarks

| Suite | Cases |
|---|---:|
| VerilogEval | 156 |
| RTLLM | 50 |
| CVDP | 78 |
| ChipBench | 45 |

The final specifications are in `benchmarks/<suite>/clarified/<design>/spec.clarified.txt`, with the public interface in the adjacent `interface.json`. Corrected testbenches, reference files, and necessary test data are included; model-generated candidates and scores are excluded. See the [benchmark guide](benchmarks/README.md).

## Two-stage method

All method source code is under [method/](method/README.md):

1. [Stage 1 — LeanSpec](method/stage1/README.md): NL formalization, diagnosis over finite relational models, designer clarification, revision, and frozen outputs. The former SpecIR Lean types now belong here as an executable specification representation; their role differs from the partial LeanSpec namespace.
2. [Stage 2 — LeanRTL](method/stage2/README.md): RTL parsing, actual LeanRTL semantics, agentic implementation and theorem proving, fixed refinement targets, and independent proof replay.

Stage 1's designer decision protocol is the integration point for human input. The current default uses a designer agent and has no separate human interaction UI. Each stage's README distinguishes the implementation from its role in the method.

## RISC-V CPU case study

The [self-contained HTML walkthrough](case_cpu/memory/method.html) presents the method and complete code. The [five-stage CPU README](case_cpu/memory/README.md) states the proof scope.

`case_cpu/memory/` includes the NL specification, 999 lines of Verilog, 38 instructions, native RAM, transaction ISA, cycle LeanSpec, actual imported LeanRTL, complete two-level refinement proofs, and reproduction scripts. `case_cpu/lean/` and `case_cpu/bridge/` retain the base CPU and shared proof dependencies.

Historical evidence and offline HTML retain paths from the original runs or snapshots. The `layout.old_to_new` mapping in `method/MIGRATION.json` records the directory changes. New runs use the current two-stage layout. Historical validation records do not mean the CPU proof was replayed during packaging.

## Usage

Requirements: Python 3.11+, Lean/Lake 4.29.0, Yosys, and Icarus. Python dependencies are listed in `requirements.txt`; optional pyslang dependencies are in `method/stage2/v2lean/requirements-slang.txt`. Configure agent backends and optional remote tools separately.

```bash
source env.sh
lake build
python3 -m leanspec.cli --help
python3 -m leanrtl.frozen --help
python3 -m v2lean.import_refinement --help
python3 method/check_package.py
python3 case_cpu/memory/scripts/replay.py
```

Do not use `--reuse-shallow` for the first CPU replay. `LEANSILICON_*` environment variables and the Python/Lean namespaces remain compatibility interfaces. The method package excludes historical experiment workspaces and caches; new runs write to `data/` or the CPU's `evidence/` directories.

The [validation record](method/VALIDATION.md) and [migration manifest](method/MIGRATION.json) are stored within the method directory. They record validation scope, sources, directory mappings, and package hashes. Previous smoke-test `data/` artifacts have been removed and can be regenerated. Personal account, path, and private-host identifiers in repository content use `usr`.
