# THE STEP CARD - E8450 to OpenWrt

Print this or keep it on your phone. The kit downloads and verifies the three files first; this card is the flash itself. Cabled connection only. Do not unplug anything mid-step. The router reboots twice and goes quiet for minutes at a time - quiet is normal.

## Part A - the AT&T box steps aside (BGW210-700, do this first)

1. Browse to the gateway page at 192.168.1.254 and sign in with the access code printed on the gateway sticker.
2. Open Firewall, then IP Passthrough.
3. Allocation Mode: Passthrough. Passthrough Mode: DHCPS-fixed. In the device list, pick the Linksys router (its MAC address is on its bottom sticker).
4. Save. The gateway reboots. From now on the Linksys is the real router.

## Part B - the installer (stock Linksys page)

5. Browse to the Linksys page at 192.168.1.1. If the setup wizard opens: tick the terms radio button exactly, then abort/close the wizard. (On stock 1.2.x, complete the wizard instead.)
6. Open Administration, then Firmware Upgrade. Note the Current Firmware Version shown there.
7. Upload the installer file that matches:
   - Version older than 1.2.00.273012 -> the file ending recovery-installer.itb
   - Version 1.2.00.273012 or newer -> the file ending recovery-installer_signed.itb
8. Confirm and WAIT. The router converts its storage and reboots into a recovery OpenWrt. When 192.168.1.1 answers again, you are halfway.

## Part C - the real OpenWrt

9. On the recovery page: System - Backup / Flash Firmware.
10. Upload the squashfs-sysupgrade file for this model and untick the keep-settings box.
11. Wait for the reboot. OpenWrt answers at 192.168.1.1 with its first-boot login - set a real password as your first act.
12. Run FLASH-KIT.bat postcheck to confirm - then set the router password (System - Administration) and rebuild your Wi-Fi name and password (Network - Wireless).

## Rules of the road

- The installer runs once, ever. Never upload a recovery-installer file again after this - future updates use plain sysupgrade files from the OpenWrt download site.
- Going back to stock Linksys firmware afterwards is not a menu option - treat this as a one-way door you walk through on purpose. The installer does keep a backup of the stock boot chain inside the router, but restoring stock is expert work, not a button.
- If Part B fails and the router seems dead: wait a full 10 minutes first. Then read the recovery notes in README-FLASH-KIT.txt before touching anything else.
