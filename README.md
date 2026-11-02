<img src="gatekeeper-icon-1024.png" width="160" alt="The Gatekeeper icon">

# The Gatekeeper

The Gatekeeper is a guided firmware-upgrade assistant for home routers.

It identifies your exact hardware, hardware revision, and current firmware, retrieves the correct OpenWrt images from official sources, verifies them by size and SHA-256 hash, and guides the installation with human checkpoints at every irreversible step.

The Gatekeeper never uploads firmware and never handles your router password: the decisive steps are performed by the owner, in the router's own interface, followed by post-installation verification and a written receipt.

## Compatibility

**Verified working for:** Linksys E8450 — stock 1.2.00.360516, dangowrt owrt-ubi-installer v1.1.4, OpenWrt 24.10.0 r28427 (walked 2026-11-01, postcheck green).

**Compatible through compiler:** the same installer line for E8450 stock builds on both sides of the 1.2.00.273012 signed/unsigned split (untested — in theory).

Any other router, however OpenWrt-listed, is a candidate — not a supported model — until a recipe for it has been walked and receipted the same way.

## Honest status — read this first

Honesty over all, to the public:

- **What this release is:** the field-proven guide in kit form — the scripts and step cards that performed the walk in the Experience Notes. Every functional line is identical to the walked files; the only edits are the owner's name scrubbed out of comments and reports for publication. **There is no graphical window yet.** A windowed version is designed, not built, and this page will not pretend otherwise.
- **What is proven:** one complete walk on one Linksys E8450 (stock 1.2.00.360516 → OpenWrt 24.10.0), recorded step by step in [EXPERIENCE-NOTES.md](EXPERIENCE-NOTES.md).
- **What is not proven:** the unsigned-installer path (stock below 1.2.00.273012) and the Part A gateway passthrough sitting. Both are written as instructions; neither has been walked. They are in theory.
- **Known issue:** `FLASH-KIT.bat` accepts only the exact word `postcheck` for the after-flash check, while its own hint words it differently, and a trailing character (even a period) defeats it. The reliable way to run the check is the direct command given in the kit's README: `powershell -ExecutionPolicy Bypass -File flash-kit.ps1 -PostCheck`. A fix is owed in a future release and is not hidden here.
- **One router in the box.** This release ships with the E8450 recipe because that is the router that was walked. Recipes for further models will be added only as each is proven.

## What's in the box

- `kit/` — the Router Flash Kit, the files that walked (name-scrubbed for publication as described above): `FLASH-KIT.bat`, `flash-kit.ps1` (network recon, firmware download + byte-size verification with SHA-256 recorded, step guide, postcheck), `STEPS.md` (the step card), `README-FLASH-KIT.txt`, `NEXT-AdGuardHome-and-SQM.md` (the follow-up sittings — not part of the proven walk), and the kit's own `BUILD-REPORT.md`.
- `EXPERIENCE-NOTES.md` — Field Walk No. 1: the full receipt of the proven flash, including everything that tried to go wrong and what each catch teaches.
- `gatekeeper.ico` / `gatekeeper-icon-1024.png` — the icon: a gate, shut, with the wild world on its side of it.
- `STORE-PAGE.txt` — the short public description of this project.
- `LICENSE` — MIT, by Songwright.

## The law of the guide

The Gatekeeper never uploads firmware. It never asks for, stores, or types a router password. The two uploads in any walk are the owner's clicks, in the router's own pages, at checkpoints a human eye has verified — because the two moments tonight's walk could have gone wrong (one version string, one pre-ticked checkbox) were both caught by a person looking, not a script assuming.

Flashing a router is a one-way door. Read the Experience Notes before you walk through it, do it wired, and do it rested.

— Songwright
