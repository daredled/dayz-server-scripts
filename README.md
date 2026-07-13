# DayZ Dedicated Server – Multi-Map Scripts

This repository contains **Windows batch scripts and configuration files** to run and manage **DayZ Dedicated Servers** for multiple maps using a **single server installation**.

It is designed for **self-hosted private servers**, making it easy to:
- Update the DayZ server
- Run different maps independently
- Keep map-specific configs clean and separated

---

## Repository Structure

### Server launch scripts (`.bat`)
Each `dayz_server_*_run.bat` file starts the server for a **specific map** using its corresponding configuration file.

| Script | Map |
|------|----|
| `dayz_server_chernarusplus_run.bat` | Chernarus Plus |
| `dayz_server_livonia_run.bat` | Livonia |
| `dayz_server_namalsk_run.bat` | Namalsk |
| `dayz_server_deerisle_run.bat` | Deer Isle (stable versions) |
| `dayz_server_deerisle60_run.bat` | Deer Isle v6.0 |
| `dayz_server_alteria_run.bat` | Alteria |
| `dayz_server_sakhal_run.bat` | Sakhal |
| `dayz_server_hashima_run.bat` | Hashima |

Each script:
- Points to the DayZ server install directory
- Selects the correct mission/map
- Loads the correct `serverDZ*.cfg`
- Starts the server with the proper parameters

---

### Server configuration files (`serverDZ*.cfg`)
Each map has its **own server configuration file**.

| Config file | Used by |
|-----------|--------|
| `serverDZchernarusplus.cfg` | Chernarus Plus |
| `serverDZlivonia.cfg` | Livonia |
| `serverDZnamalsk.cfg` | Namalsk |
| `serverDZdeerisle.cfg` | Deer Isle |
| `serverDZdeerisle60.cfg` | Deer Isle v6.0 |
| `serverDZalteria.cfg` | Alteria |
| `serverDZsakhal.cfg` | Sakhal |
| `serverDZhashima.cfg` | Hashima |

These files control:
- Server name
- Passwords
- Max players
- Persistence
- Logging
- Gameplay rules

You can customize each map independently without affecting the others.

---

### Update script
`dayz_server_install.bat`

This script updates the **DayZ Dedicated Server** using **SteamCMD**, via the
shared `common/steam_app_install.bat` (see below). Requires the `STEAM_USER`
environment variable to be set (`setx STEAM_USER yourSteamAccount`).

Typical usage:
- Run before starting the server
- Run after DayZ updates
- Run on a schedule (Task Scheduler)

---

### `common/`
Shared SteamCMD install/update scripts from the
[steamcmd-server-scripts](https://github.com/daredled/steamcmd-server-scripts)
repo, checked out here as a git submodule. Installs SteamCMD into
`C:\steamcmd` automatically if it isn't already present. You normally don't
need to run anything in here directly - `dayz_server_install.bat` calls it.

Clone this repo with `git clone --recurse-submodules <url>`, or if already
cloned, run `git submodule update --init`.

---

## Requirements

- Windows (tested on Windows Server / Windows 10+)
- DayZ Dedicated Server (App ID: `223350`) - installed automatically by `dayz_server_install.bat`
- Required mods downloaded via Steam Workshop (if used)
- Proper firewall port forwarding (default: UDP 2302–2305)

---

## 🚀 How to Use

### Update the server
Run:
```

dayz_server_install.bat

```

This ensures the server binaries are up to date.

---

### 2️⃣ Start a server (choose ONE map)
Run **only one** of the following at a time:

```

dayz_server_chernarusplus_run.bat
dayz_server_namalsk_run.bat
dayz_server_livonia_run.bat
dayz_server_deerisle_run.bat
dayz_server_deerisle60_run.bat
dayz_server_alteria_run.bat
dayz_server_sakhal_run.bat
dayz_server_hashima_run.bat

```

Each script:
- Uses the correct mission folder
- Loads the correct config
- Starts the server immediately

---

### Customize settings
Edit the corresponding `serverDZ*.cfg` file:
- Change server name
- Enable/disable passwords
- Adjust gameplay settings
- Configure logs

Restart the server after changes.

---

## Notes on Maps

- **Namalsk** requires its official mission files and server mod.
- **Deer Isle 6.0** uses a different config to avoid compatibility issues.
- **Alteria, Sakhal, Hashima** are community maps and may require additional mods.

Always verify:
- Mission folder name matches the `.bat` file
- Required `.bikey` files are present on the server

---

## 🔒 Best Practices

- Run **one map per server instance**
- Keep backups of `mpmissions` and configs
- Update the server before updating mods (each `dayz_server_*_run.bat` does this automatically)
- Check `.RPT` logs if the server fails to start

---

## 🧩 Intended Audience

This repository is intended for:
- Private DayZ server admins
- Self-hosted communities
- Local testing environments
- Multi-map server setups

Not intended as a plug-and-play public hosting solution.

---

## 📜 License / Usage

Free to use and modify for personal or community servers.  
No warranty provided.