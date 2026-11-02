# ROUTER FLASH KIT 1.0 - Linksys E8450 to OpenWrt (prep + verify + guide)
# Songwright. One-click prep for the owner's E8450 behind an AT&T BGW210-700.
#
# WHAT THIS DOES: recon on the network, downloads the official OpenWrt UBI
# installer files for the E8450, verifies them by exact byte size against
# the official GitHub release (and records their SHA-256 locally), then
# walks the owner through the flash with the step card and the admin pages.
# WHAT THIS NEVER DOES: it never uploads firmware, never logs into a router,
# and never asks for or stores any router password. The two uploads are the
# owner's own clicks in the router pages - a blind scripted flash is how
# routers die, and this kit is not a bricking machine.
#
# The installer files come from the official OpenWrt community installer
# project for this exact model: github.com/dangowrt/owrt-ubi-installer
# Pinned release: v1.1.4 (OpenWrt 24.10.0). Verified 2026-11-01.

param([switch]$PostCheck)

$ErrorActionPreference = 'Stop'
try { [Console]::OutputEncoding = [System.Text.Encoding]::UTF8 } catch { }

$KitDir   = Split-Path -Parent $MyInvocation.MyCommand.Path
$FwDir    = Join-Path $KitDir 'firmware'
$Tag      = 'v1.1.4'
$BaseUrl  = "https://github.com/dangowrt/owrt-ubi-installer/releases/download/$Tag"

$Files = @(
  @{ Name = 'openwrt-24.10.0-mediatek-mt7622-linksys_e8450-ubi-initramfs-recovery-installer.itb';        Size = 15073280; Role = 'STEP 1 installer - upload this if the router page shows stock firmware OLDER than 1.2.00.273012' },
  @{ Name = 'openwrt-24.10.0-mediatek-mt7622-linksys_e8450-ubi-initramfs-recovery-installer_signed.itb'; Size = 14994067; Role = 'STEP 1 installer - upload this if the router page shows stock firmware 1.2.00.273012 or NEWER' },
  @{ Name = 'openwrt-24.10.0-mediatek-mt7622-linksys_e8450-ubi-squashfs-sysupgrade.itb';                  Size = 10654432; Role = 'STEP 2 sysupgrade - upload this from the recovery screen after Step 1' }
)

function Line($t) { Write-Host $t }
function Head($t) { Write-Host ''; Write-Host "== $t ==" -ForegroundColor Cyan }
function Good($t) { Write-Host "  OK  $t" -ForegroundColor Green }
function Warn($t) { Write-Host "  !!  $t" -ForegroundColor Yellow }
function Bad($t)  { Write-Host "  XX  $t" -ForegroundColor Red }

function Test-Page($Url) {
  try {
    $r = Invoke-WebRequest -Uri $Url -UseBasicParsing -TimeoutSec 5
    return $r.Content
  } catch { return $null }
}

# ---------------------------------------------------------------- post check
if ($PostCheck) {
  Head 'POST-FLASH CHECK'
  $c = Test-Page 'http://192.168.1.1'
  if ($c -and ($c -match 'LuCI' -or $c -match 'OpenWrt')) {
    Good 'OpenWrt is answering at 192.168.1.1. THE FLASH WORKED.'
    Line '  Next, in the OpenWrt page: set a router password (System - Administration),'
    Line '  then set your Wi-Fi name and password again (Network - Wireless).'
    Line '  After that, the follow-ups live in NEXT-AdGuardHome-and-SQM.md.'
  } elseif ($c) {
    Warn 'Something answers at 192.168.1.1 but it does not look like OpenWrt yet.'
    Line '  If you are mid-flash, give it a few minutes - the router reboots twice.'
  } else {
    Warn 'Nothing answers at 192.168.1.1 right now.'
    Line '  Mid-flash reboots can take a few minutes. Do NOT unplug the router.'
    Line '  If it stays silent past 10 minutes, read the recovery notes in README-FLASH-KIT.txt.'
  }
  Read-Host 'Press Enter to close'
  exit
}

# --------------------------------------------------------------------- recon
Head 'ROUTER FLASH KIT - E8450 to OpenWrt (prep, verify, guide)'
Line 'This kit prepares and guides. It never flashes anything itself.'
Line 'The two uploads are your clicks, in the router pages, when you say go.'

Head 'STEP 0 - RECON'
$gw = $null
try {
  $cfg = Get-NetIPConfiguration | Where-Object { $_.IPv4DefaultGateway } | Select-Object -First 1
  if ($cfg) {
    $gw = $cfg.IPv4DefaultGateway.NextHop
    Line "  This PC's gateway (the box that routes you): $gw"
    $ad = Get-NetAdapter -InterfaceIndex $cfg.InterfaceIndex -ErrorAction SilentlyContinue
    if ($ad) {
      Line "  Connection to it: $($ad.MediaType) via '$($ad.Name)'"
      if ($ad.MediaType -match '802\.11|Wireless|Wi-Fi') {
        Warn 'You are reaching the router over WI-FI.'
        Warn 'A flash over Wi-Fi can drop mid-write and brick the router.'
        $a = Read-Host '  Plug a cable from this PC into the LINKSYS and type WIRED to continue (anything else stops)'
        if ($a -ne 'WIRED') { Line 'Stopped. No harm done - run it again once you are cabled.'; Read-Host 'Enter to close'; exit }
      } else {
        Good 'Wired connection - the safe way to flash.'
      }
    }
  }
} catch { Warn "Recon could not read the network setup: $($_.Exception.Message)" }

foreach ($ip in @('192.168.1.254','192.168.1.1')) {
  $label = if ($ip -eq '192.168.1.254') { 'AT&T BGW210 gateway address' } else { 'Linksys address' }
  if (Test-Connection -ComputerName $ip -Count 1 -Quiet -ErrorAction SilentlyContinue) {
    Good "$ip answers ($label)."
  } else {
    Line "  --  $ip does not answer right now ($label)."
  }
}

# Which face does the Linksys show: stock, or already OpenWrt?
$linksysIp = $null
foreach ($ip in @('192.168.1.1','192.168.1.254')) {
  $c = Test-Page "http://$ip"
  if ($c -and ($c -match 'LuCI' -or $c -match 'OpenWrt')) {
    $linksysIp = $ip
    Good "The page at $ip is OpenWrt (LuCI) already."
    Line '  If the flash already happened, run this kit with -PostCheck instead.'
    Read-Host 'Press Enter to close'
    exit
  }
  if ($c -and $c -match 'Linksys') { $linksysIp = $ip; Good "The page at $ip looks like the stock Linksys face. Good - that is flashable." }
}
if (-not $linksysIp) { Warn 'Could not identify the Linksys page from here. The step card works regardless - the pages open at the end.' }

# ------------------------------------------------------- download and verify
Head 'STEP 1 - DOWNLOAD + VERIFY THE OFFICIAL FILES'
Line "  Source: $BaseUrl"
if (-not (Test-Path $FwDir)) { New-Item -ItemType Directory -Path $FwDir | Out-Null }
$receipt = @()
$allOk = $true
foreach ($f in $Files) {
  $dest = Join-Path $FwDir $f.Name
  if ((Test-Path $dest) -and ((Get-Item $dest).Length -eq $f.Size)) {
    Good "$($f.Name) already here, size exact."
  } else {
    Line "  Downloading $($f.Name) ..."
    try {
      Invoke-WebRequest -Uri "$BaseUrl/$($f.Name)" -OutFile $dest -UseBasicParsing
    } catch {
      Bad "Download failed for $($f.Name): $($_.Exception.Message)"
      $allOk = $false
      continue
    }
  }
  $item = Get-Item $dest
  if ($item.Length -eq $f.Size) {
    $hash = (Get-FileHash -Path $dest -Algorithm SHA256).Hash
    Good "$($f.Name) - size exact ($($f.Size) bytes). SHA-256 recorded."
    $receipt += $f.Name + ' | size ' + $item.Length + ' | sha256 ' + $hash
  } else {
    Bad $f.Name
    Line '  Size does NOT match the published size - the download is not trusted.'
    $allOk = $false
  }
}
$receipt | Set-Content -Path (Join-Path $FwDir 'VERIFY-RECEIPT.txt') -Encoding UTF8
if (-not $allOk) {
  Bad 'A file failed verification. Nothing was flashed (this kit never flashes).'
  Line '  Check the connection and run the kit again - it re-downloads what is missing.'
  Read-Host 'Press Enter to close'
  exit
}
Good 'All three files verified and staged in the firmware folder.'

# --------------------------------------------------------------------- guide
Head 'STEP 2 - THE FLASH (the step card - also in STEPS.md)'
Line '  Do this WIRED, rested, and with an hour where nobody needs the internet.'
Line ''
Line '  PART A - BGW210 steps aside: in the gateway page (192.168.1.254),'
Line '    Firewall - IP Passthrough - Allocation: Passthrough - Mode: DHCPS-fixed'
Line '    - pick the Linksys in the device list - Save.'
Line '  PART B - Linksys page: Administration - Firmware Upgrade.'
Line '    Look at the Current Firmware Version on that page:'
Line '      OLDER than 1.2.00.273012  -> upload the recovery-installer file'
Line '      1.2.00.273012 or NEWER    -> upload the recovery-installer_signed file'
Line '    Then WAIT - it reboots into a recovery screen. Quiet is normal.'
Line '  PART C - On the recovery page: System - Backup / Flash Firmware -'
Line '    upload the squashfs-sysupgrade file and UNCHECK Keep settings.'
Line '    After the reboot: log in as root (password empty for now), set a'
Line '    real password, and set your Wi-Fi name and password again.'
Line '  THEN: run FLASH-KIT.bat postcheck to confirm it worked.'
Line ''
$a = Read-Host 'Type OPEN to open both admin pages now (anything else skips)'
if ($a -eq 'OPEN') {
  Start-Process 'http://192.168.1.254'
  Start-Sleep -Seconds 2
  Start-Process 'http://192.168.1.1'
}
Line ''
Line 'The kit has done its part: files verified, card printed, pages open.'
Line 'The door is yours to walk through.'
Read-Host 'Press Enter to close'
