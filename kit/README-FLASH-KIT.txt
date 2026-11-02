ROUTER FLASH KIT 1.0 - by Songwright
Linksys E8450 -> OpenWrt, behind an AT&T BGW210-700.

WHAT IT IS
A one-click preparation kit. Double-click FLASH-KIT.bat and it:
  1. Looks at your network (which box routes you, wired or Wi-Fi, what
     face each box shows).
  2. Downloads the three official OpenWrt installer files for the
     Linksys E8450 from the official installer project's release page,
     and verifies each one byte-for-byte by its published size, recording
     its SHA-256 beside it.
  3. Prints the step card on screen and opens the two admin pages.
The flash itself is then three short parts in the router pages - see
STEPS.md. When you are done, FLASH-KIT.bat postcheck confirms OpenWrt
is live.

WHAT IT NEVER DOES
- It never uploads firmware, never logs into a router, and never asks
  for, sees, or stores any router password. You type passwords into the
  router pages yourself.
- It changes no settings on the PC. Admin rights are requested only so
  the network recon can read adapter details.

THE HONEST WARNINGS
- Do it WIRED. A flash over Wi-Fi can drop mid-write. The kit warns you
  and makes you type WIRED if it catches you on wireless anyway.
- Do it rested, with nobody depending on the internet for the next hour,
  and not during stormy power.
- The installer runs ONCE, ever, per router. It replaces the router's
  boot chain and storage layout. Going back to stock Linksys firmware
  is expert work, not a button - walk through the door on purpose.
- If the router seems dead after the installer step: WAIT ten full
  minutes before concluding anything. These boxes reboot twice and go
  quiet. Do not power-cycle in a panic during the first minutes.

RECOVERY NOTES (if it really goes wrong)
- The installer leaves a recovery OpenWrt in place by design; if the
  second upload was the problem, the recovery page at 192.168.1.1 is
  where you retry it.
- The installer also stores a backup of the stock boot chain inside the
  router. Full stock restoration needs that plus expert steps documented
  on the OpenWrt device page for the E8450 - a rainy-day project, not a
  panic project.

AFTER IT WORKS
NEXT-AdGuardHome-and-SQM.md holds the two follow-ups: AdGuard Home on
the router (house-wide ad/telemetry dead-ends) and SQM cake (the game
lane). Separate sittings. Let OpenWrt run clean for a few days first.

PUBLISH STATUS
Proven-first house rule: this kit gets published (GitHub, Songwright)
only after it has worked on the owner's own router.
