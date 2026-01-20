# DayZ Dedicated Server – Multi-Map Scripts

This repository contains **Windows batch scripts and configuration files** to run and manage **DayZ Dedicated Servers** for multiple maps using a **single server installation**.

It is designed for **self-hosted private servers**, making it easy to:
- Update the DayZ server
- Run different maps independently
- Keep map-specific configs clean and separated

---

## Repository Structure

### Server launch scripts (`.bat`)
Each `run_dayz_server_*.bat` file starts the server for a **specific map** using its corresponding configuration file.

| Script | Map |
|------|----|
| `run_dayz_server_chernarusplus.bat` | Chernarus Plus |
| `run_dayz_server_livonia.bat` | Livonia |
| `run_dayz_server_namalsk.bat` | Namalsk |
| `run_dayz_server_deerisle.bat` | Deer Isle (stable versions) |
| `run_dayz_server_deerisle60.bat` | Deer Isle v6.0 |
| `run_dayz_server_alteria.bat` | Alteria |
| `run_dayz_server_sakhal.bat` | Sakhal |
| `run_dayz_server_hashima.bat` | Hashima |

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
`update_dayz_server.bat`

This script updates the **DayZ Dedicated Server** using **SteamCMD**.

Typical usage:
- Run before starting the server
- Run after DayZ updates
- Run on a schedule (Task Scheduler)

---

## Requirements

- Windows (tested on Windows Server / Windows 10+)
- SteamCMD installed
- DayZ Dedicated Server (App ID: `223350`)
- Required mods downloaded via Steam Workshop (if used)
- Proper firewall port forwarding (default: UDP 2302–2305)

---

## 🚀 How to Use

### Update the server
Run:
```

update_dayz_server.bat

```

This ensures the server binaries are up to date.

---

### 2️⃣ Start a server (choose ONE map)
Run **only one** of the following at a time:

```

run_dayz_server_chernarusplus.bat
run_dayz_server_namalsk.bat
run_dayz_server_livonia.bat
run_dayz_server_deerisle60.bat

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
- Update mods before updating the server
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