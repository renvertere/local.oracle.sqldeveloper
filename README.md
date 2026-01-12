# com.local.sqldeveloper — Local Flatpak Build

This repository provides a **portable, reproducible Flatpak build** of **Oracle SQL Developer** for local use, without relying on Flathub or external Flatpak repositories.

The build is fully isolated using **Docker/Podman** and installs cleanly into the host’s **user Flatpak installation**.

---

## Goals

- Local, reproducible Flatpak build
- No external Flatpak repos required at runtime
- Java sourced from Flatpak SDK extensions (not bundled JREs)
- Works consistently across Linux distributions
- Clean separation of:
  - build environment (container)
  - application definition (Flatpak manifest)
  - runtime execution (host Flatpak)

---

## Project Layout

```text
.
├── com.local.sqldeveloper.yml        # Flatpak manifest
├── com.local.sqldeveloper.desktop    # Desktop entry
├── Dockerfile                        # Flatpak builder container
├── Makefile                          # Build orchestration
├── icons/                            # Application icon
│   └── com.local.sqldeveloper.png
├── sources/                          # Vendor ZIPs (pinned)
│   ├── sqldeveloper.zip
│   └── openjfx-*.zip
├── build-dir/                        # Flatpak build output (generated)
├── repo/                             # Local Flatpak repo (generated)
├── dist/                             # .flatpak bundle (generated)
├── .flatpak-builder/                # Flatpak build cache (generated)
└── .make/                            # Makefile stamps (generated)
```

Generated directories are ignored via .gitignore.

## Prerequisites (Host)

- Linux (tested on Linux Mint / Cinnamon)
- `flatpak`
- `docker` **or** `podman` (Docker-compatible CLI)
- Internet access (first build only

> Flatpak SDKs and extensions are installed **inside the container**, not on the host.

## First-time Setup (Required)
### 1) Obtain Oracle SQL Developer
Due to Oracle licensing, SQL Developer must be downloaded manually.
1. Download **SQL Developer (no JRE)** from Oracle
2. Place it into `sources/`
3. Rename it to:
    `sources/sqldeveloper.zip`
    
### 2) Obtain OpenJFX (matching architecture)
Download the OpenJFX SDK matching your system (x86_64 recommended):
`sources/openjfx-<version>-linux-x64-sdk.zip`
### 3) Update checksums
Compute SHA256 hashes and update `com.local.sqldeveloper.yml`:
`sha256sum sources/*.zip`

## Quick Start

### Build + Install

```shell
git clone https://github.com/renvertere/local.oracle.sqldeveloper.git
cd local.oracle.sqldeveloper
make install
```

This will:

1. Build the Flatpak builder image (once)
2. Build SQL Developer inside the container
3. Export a local Flatpak repo
4. Create a `.flatpak` bundle
5. Install the app into the host user Flatpak
    

### Run

```shell
make run # or flatpak run com.local.sqldeveloper
```


---
## Uninstall

### Remove application only (keep user data)

```shell
flatpak uninstall com.local.sqldeveloper
```

### Full reset (remove app + all persisted data)

```shell
flatpak uninstall com.local.sqldeveloper
rm -rf ~/.var/app/com.local.sqldeveloper
```

---

## Notes on Oracle Artifacts

Oracle SQL Developer ZIPs may require manual download due to licensing.  
Once downloaded:

1. Rename to a stable filename:
    `sources/sqldeveloper.zip`
2. Update the SHA256 in the manifest
3. Rebuild

---
## License

Oracle SQL Developer is subject to Oracle’s license.  
This repository contains **build tooling only**.