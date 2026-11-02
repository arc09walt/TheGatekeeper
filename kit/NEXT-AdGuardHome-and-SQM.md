# AFTER THE FLASH - the two follow-ups (separate sittings, not part of the flash)

*Read-only notes for later. Nothing here runs automatically. Do these rested, one at a time, after OpenWrt has run clean for a few days.*

## 1. AdGuard Home on the router (the goalie moves into the door)

- In OpenWrt: System - Software - Update lists, then install the adguardhome package.
- AdGuard Home's own setup wizard then runs on the router (it offers port 3000 for setup). Point it at the router's LAN address as its DNS listener.
- Then set OpenWrt to hand out the router itself as the house DNS (Network - Interfaces - LAN - DHCP options), so every device asks the goalie first.
- Result: ad and telemetry domains get a dead-end answer for the whole house - phones, tablets, the house PC - the Muzzle idea, promoted to the front door.
- Keep the escape hatch: if a site breaks, AdGuard Home's query log shows exactly what was blocked for that device, and one click whitelists it.

## 2. SQM cake (the game lane)

- Install luci-app-sqm from the same software page.
- Set it on the WAN interface with your real speeds: run a speed test first, then enter about 95 percent of the measured download and upload. That small haircut is the whole trick - the queue lives at your router, where cake can manage it, instead of at the ISP.
- Interface: ethernet with cake / piece_of_cake is the standard recipe.
- Result: when a phone decides to back up a day of photos mid-match, your packets no longer queue behind it. Flat beats low.

## 3. Standing care

- Future OpenWrt updates: System - Backup / Flash Firmware with the plain sysupgrade file for linksys_e8450-ubi. NEVER a recovery-installer file again.
- Take a settings backup (System - Backup) after each change you like. A backup turns every future experiment into a reversible one.
