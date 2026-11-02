# THE GATEKEEPER — EXPERIENCE NOTES

Field walk No. 1 — the walk this whole program stands on.
Walked by Walter, with Muse reading over his shoulder, 2026-11-01.
Everything below is a receipt. The only things left out are the
things that are never written down: the passwords, and the address.

**Verified working for:** Linksys E8450 — stock firmware
1.2.00.360516, dangowrt owrt-ubi-installer v1.1.4, OpenWrt 24.10.0
r28427 (postcheck green, 2026-11-01 ~19:31 ET).
**Compatible through compiler:** the same installer line on both
sides of the 1.2.00.273012 signed/unsigned split (untested — in
theory).

## The ground we walked

- Fiber into an AT&T BGW210-700. Behind it, our own Linksys E8450
  (MediaTek MT7622) on stock Linksys firmware. That box was the gate
  being replaced.
- A Windows PC ("Center") cabled into the E8450. Flashing is a
  wired job. No exceptions were made and none are allowed.
- The Router Flash Kit had already done its half before the walk:
  recon of the network, the three firmware files downloaded from
  the official sources and verified by exact size, a step card,
  and a postcheck. The kit never uploads anything. The two uploads
  in this story were the owner's clicks.

The three files, exactly as verified:

- Unsigned installer: 15,073,280 bytes (stock below 1.2.00.273012)
- Signed installer: 14,994,067 bytes (stock at/above the split)
- Sysupgrade: 10,654,432 bytes

## The walk, in the order it actually happened

**The afternoon taught the first lesson before the flash began.**
Typed passwords failed. The router locks after a handful of wrong
tries, and the only key that fits a lockout is a factory reset. A
notebook password that looked right was rejected. Everything that
followed in the evening exists because of this: the password was
saved in a plain file on the PC, and from then on it was pasted,
never typed. Paste worked every single time it was used.

**Reset, wizard, and two traps defused (~18:37–18:51).** After a
clean reset, the factory Wi-Fi names came back and the setup
wizard was finished from the PC, pasting from the key file. The
wizard's "register your device" step is a cloud-account signup,
not a requirement — skipped; the account dies with the stock
firmware anyway. The automatic-updates offer was left OFF. We are
the update. A stock auto-update landing the night before a flash
can close the door the flash needs.

**The version read (~18:51).** A photo of the firmware page gave
the full version string: 1.2.00.360516. That one string picked the
file — at/above 1.2.00.273012 means the *signed* installer. This is
the checkpoint the whole recipe turns on, and a human eye read it
off a photo before anything was uploaded.

**Part B — the bridge (~18:59–19:11).** The signed installer went
up through Configuration → Administration → Firmware Upgrade (the
dashboard path was corrected mid-walk by photos — the guide's
first guesses at tab names were wrong, the photos were not). The
owner clicked Start Upgrade a breath before the verification reply
landed; the photo then confirmed the filename was the right one.
Filed honestly as the walk's one close call. The router went
quiet, converted its storage to UBI, and answered at 192.168.1.1
as the recovery OpenWrt — root, no password yet. Halfway.

**Part C — the crossing (~19:13–19:16).** The sysupgrade file
(10.16 MiB, name matched) went up through the recovery page — and
the owner's pre-upload photo caught the dialog's "Keep settings
and retain the current configuration" box arriving PRE-TICKED.
Unticked before Continue. That catch, alone, is the argument for
the guide's founding law. Production OpenWrt came up: 24.10.0
r28427, kernel 6.6.73.

**Closing the gate (~19:26–19:31).** Root password set. Both
radios rebuilt under the house Wi-Fi name ("The Light") and its
original key, WPA2-PSK, country US — and the owner's phone joined
on its own, no retyping: name and key matched to the letter, which
is the proof the rebuild was exact. Then the postcheck:
"OK — OpenWrt is answering at 192.168.1.1. THE FLASH WORKED."

**What was deliberately not walked that night.** Part A — putting
the AT&T box into IP Passthrough so it becomes a pure light
translator (fiber in, Ethernet out, no routing opinions) — was
left for its own sitting. The internet works meanwhile through
double NAT. One discovery is filed for that sitting: from inside
the new LAN, the AT&T box's page at 192.168.1.254 does not answer,
because both networks claim 192.168.1.x. Part A gets done by
cabling the PC straight into the AT&T box for ten minutes.

## The catches — what tried to bite, and what each one teaches

1. **Typed passwords fail; routers lock.** Five strikes and the
   only fix is a reset. → The guide teaches paste-from-file at its
   front door, and never asks for, stores, or types a password.
2. **Keyboards remember what you type.** A typed password trains
   the keyboard that saw it. A paste teaches it nothing. → Paste is
   privacy as well as accuracy. ("ctrl-c bitch." — the owner.)
3. **Registration is a sales step wearing a uniform.** → The guide
   says skip it, in plain words, before the user reaches it.
4. **Auto-update is a door closing itself.** → Never press Check
   Firmware, never enable automatic updates on a stock page that
   is about to be flashed.
5. **One version string picks the file.** Same hardware, two
   installers, and the split at 1.2.00.273012 decides. → Matching
   is model + hardware revision + stock version, never name alone.
6. **Photos catch what memory misses.** In one evening, the photo
   habit caught the full firmware string, the guide-writer's own
   wrong tab names, the auto-update trap, and the pre-ticked box.
   → The guide is built around checkpoints a person can see.
7. **The click can outrun the check.** The one upload that started
   before verification landed turned out right — by the filename,
   not by luck management. → Steps stay ordered so the check is
   read before the button is reached.
8. **"Keep settings" arrives pre-ticked.** On a crossing that must
   start clean. → The warning appears in the guide *before* the
   user ever sees that dialog.
9. **Quiet minutes feel like death.** Storage conversion is
   silent for minutes at a time. → Ten full minutes before worry;
   the guide runs the clock so the owner doesn't have to guess.
10. **A tool's own wart, admitted.** The kit's launcher only
    accepted the exact word "postcheck" — a trailing "." defeated
    it, while its own hint said "-PostCheck". → Hint and parser
    must agree; accept every reasonable form. Fixed before any
    publication.
11. **Addresses can shadow each other.** After the crossing, the
    ISP box hides behind the address overlap. → Every recipe
    carries its before/after address map, and the direct-cable
    method for reaching a shadowed box.

## What these notes do not prove

- The unsigned-installer path (stock below the split) — in theory.
- Part A, the light-translator sitting — designed, not yet walked.
- Any other router, anywhere. One walk is one walk. The next
  model's notes start the day somebody walks it and the receipt
  comes back green.

## The receipt

Router: Linksys E8450 (MT7622), stock 1.2.00.360516 → OpenWrt
24.10.0 r28427 via owrt-ubi-installer v1.1.4. Root password set.
House Wi-Fi rebuilt and self-joined by a client device. Postcheck
green. Internet live behind the AT&T box, double NAT, pending the
Part A sitting. AdGuard Home and SQM are separate sittings, after
a few clean days of soak — not part of this walk and not claimed
by it.

*A router is the gate at the property line between your home and
the wild world. On 2026-11-01, this house hung a new one — with
its own hands, and its own key.*

— Experience Notes No. 1, The Gatekeeper (Songwright)
