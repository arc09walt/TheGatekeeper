# ROUTER FLASH KIT 1.0 - BUILD REPORT (owner copy)

Built 2026-11-01 for the owner's stack: AT&T BGW210-700 gateway + Linksys E8450
(stock firmware, confirmed by owner) - target: OpenWrt.

## Contents

- `FLASH-KIT.bat` - self-elevating launcher (normal run = prep + verify +
  guide; `postcheck` = confirm OpenWrt is live after a flash).
- `flash-kit.ps1` - 186 lines, PowerShell 5.1. Phases: recon (gateway,
  wired-vs-Wi-Fi with a WIRED typed-confirmation gate, box identification,
  already-OpenWrt detection), download + verify, on-screen step card +
  opening the two admin pages, and the postcheck mode.
- `STEPS.md` - the printable step card (gateway passthrough, installer by
  stock version, sysupgrade, rules of the road).
- `NEXT-AdGuardHome-and-SQM.md` - the two post-flash follow-ups as notes.
- `README-FLASH-KIT.txt` - owner manual, honest warnings, recovery notes.

## Firmware provenance (verified live at build time, 2026-11-01)

- Installer project: the official OpenWrt community UBI installer for the
  Linksys E8450 (dangowrt owrt-ubi-installer), pinned release **v1.1.4**
  (published 2025-02-07), carrying OpenWrt **24.10.0**.
- Files + published sizes checked against the release record:
  - recovery-installer.itb - 15,073,280 bytes (stock older than 1.2.00.273012)
  - recovery-installer_signed.itb - 14,994,067 bytes (stock 1.2.00.273012+)
  - squashfs-sysupgrade.itb - 10,654,432 bytes (step 2, from recovery)
- The release publishes no checksum file and no API digests, so the kit
  verifies by exact byte size against the release record and records each
  file's SHA-256 locally in firmware/VERIFY-RECEIPT.txt. Stated plainly in
  the README - no stronger claim is made.

## Safety design

- The kit NEVER uploads firmware, never logs into a router, never asks for
  or stores a router password, and changes no PC settings. The two uploads
  are the owner's clicks in the router pages.
- Wi-Fi flashing is gated: recon detects a wireless path and requires the
  owner to type WIRED after cabling up.
- If OpenWrt is already answering, the kit says so and stops.

## Verification

- Full token-level delimiter parse of flash-kit.ps1: BALANCED, no PS7-only
  syntax. (An early write truncated the file mid-line at the receipt string;
  caught by this parse, repaired, re-parsed clean. The parse earned its keep.)
- Privacy scrub: no sticker values (Wi-Fi passwords, access codes, SSIDs,
  serials, MACs) anywhere in the package - verified by grep.

## Status

UNRUN. Field proof = the owner's flash on the real E8450. Per the owner's
ruling (2026-11-01), publication to GitHub under Songwright happens only
AFTER it works.

## Field fix — 2026-11-01 ~15:51 (found by the owner on the house PC, first run)

Bug: launching FLASH-KIT.bat with no argument crashed the admin hand-off —
Start-Process rejected the empty -ArgumentList (''), red error text flashed
and the window closed before it could be read. Cause: the relaunch line
always passed '%~1', which is empty on a plain launch. Fix: the hand-off now
branches — no argument means no -ArgumentList at all; "postcheck" still
passes its argument through. No other file changed; flash-kit.ps1 untouched.
