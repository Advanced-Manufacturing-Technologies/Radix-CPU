# Radix CPU

Radix is a from-scratch RISC-V CPU design written in Verilog, with a focus on clarity, modularity, and expandability. The long-term goal is to build a 5-stage pipeline RISC-V CPU that can eventually boot Linux, beginning from a minimal RV32I base and adding features incrementally.

## Repository Structure
```
radix-cpu/
├── docs/
│   ├── architecture/
│   └── specifications/
├── rtl/
│   ├── alu.v
│   ├── regfile.v
│   ├── control.v
│   ├── cpu_top.v
│   └── …
├── tb/                # Testbench files
│   ├── testbench_cpu.v
│   ├── memory_model.v
│   └── …
├── scripts/           # Build/simulation helpers
├── .gitlab-ci.yml     # GitLab CI pipeline (optional)
└── README.md
```
## Getting Started

1. **Clone the Repository**
   ```bash
   git clone https://gitlab.com/your-group/radix-cpu.git
	```


## Git Best Practices

✅ Use GitLab Flow

- Main branches:
- main: always buildable and stable.
- dev: integration branch, may contain in-progress features.
- Feature branches:
- Use names like feature/mmu, bugfix/decode-stage, etc.
- Merge into main via Merge Requests after testing.

✅ Create Clear Merge Requests

- Include a description, what was changed, and any design notes.
- Use GitLab labels and milestones to organize work.
- Use the WIP prefix (Draft: or WIP:) for in-progress MRs.

✅ Commit Smart

- Commit often, but logically.


✅ Use .gitignore

- Keep generated files, bitstreams, and logs out of version control:

	```*.vcd
	*.log
	*.out
	*.bit
	build/
✅ Tag Milestones

- Use Git tags to mark stable releases:

	```
    git tag -a v0.1 -m "First working RV32I simulation"
	git push origin v0.1```
✅ Document Design Decisions

- Use docs/ for architecture diagrams, decisions, and specs.
- Link design docs in your merge request descriptions when relevant.


✅ Self or Peer Review

- Even solo, open MRs for yourself to stage, track, and review.
- Add comments to your own MR if you make design changes mid-way.

Contributing
1.	Create a feature branch:

	```
    git checkout -b feature/my-cool-feature```
2.	Commit and push your changes:

    ```git commit -m "[core] Add initial fetch stage"
    git push origin feature/my-cool-feature
    ```

3.	Open a Merge Request on GitLab:
    - Assign reviewers if applicable.
    - Mark as Draft if still in progress.

## Roadmap
- Phase 1: RV32I minimal CPU with testbenches and simulation
- Phase 2: Full 5-stage pipeline (IF, ID, EX, MEM, WB)
- Phase 3: Add M extension (mul/div), branching, basic memory controller
- Phase 4: Implement CSR system, trap logic, and MMU
- Phase 5: Boot Linux via OpenSBI, add interrupt controller, caches


Happy hacking — and welcome to the Radix CPU project!

