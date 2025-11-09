# 🧰 Linux System Maintenance Suite (Bash Automation)

![License](https://img.shields.io/badge/license-MIT-green.svg)
![Language](https://img.shields.io/badge/language-Bash-blue.svg)
![Platform](https://img.shields.io/badge/platform-Linux-lightgrey.svg)

> A modular Bash scripting suite to automate essential Linux system maintenance tasks like backups, updates, cleanup, and log monitoring — all from an interactive menu with colored terminal outputs.

---

## 📘 Overview
The **System Maintenance Suite** simplifies routine Linux administration by combining **backups**, **system upgrades**, and **log monitoring** into one user-friendly menu interface.  
This project helps automate repetitive tasks, ensure system health, and reduce human errors — ideal for daily desktop usage, servers, and learning system automation.

---

## 🎯 Objectives
- Automate frequent system maintenance tasks.
- Provide **incremental backup** capability.
- Perform **package updates** and remove unused dependencies.
- Monitor logs and detect critical warnings/errors.
- Offer an **interactive CLI dashboard** for quick control.
- Support **systemd-based scheduling** for automation.

---

## 🗂️ Project Structure
```bash
maintenance-suite/
├── bin/                 # Executable Bash scripts
│   ├── suite.sh         # Main Menu
│   ├── backup.sh        # Backup engine
│   ├── update_clean.sh  # Update & cleanup tool
│   └── log_watch.sh     # Log monitoring tool
├── lib/                 # Shared helper functions
│   └── common.sh
├── etc/                 # Environment configs & systemd units
│   ├── .env.example
│   └── systemd/
│       ├── maintenance-backup.service
│       ├── maintenance-backup.timer
│       ├── maintenance-logwatch.service
│       └── maintenance-logwatch.timer
├── var/                 # Runtime outputs
│   ├── backups/         # Snapshot storage
│   └── logs/            # Processed logs + run logs
├── tests/               # Testing scripts
│   └── smoke.sh
├── Makefile
├── README.md
└── LICENSE
```

---

## 📸 Interface Preview

### Main Menu (Colored Terminal Output)
<img width="720" alt="Main Menu Screenshot" src="https://github.com/user-attachments/assets/202113a2-5a70-40c4-aa17-283e6840ce4e" />

---

## 🛠️ Installation & Setup

```bash
# Clone the repository
git clone https://github.com/Diksha566/system-maintenance-suite.git

# Navigate to the project directory
cd system-maintenance-suite

# Copy environment configuration file
cp ./etc/.env.example ./etc/.env

# Make scripts executable
chmod +x ./bin/*.sh
```

---

## 🚀 Usage

Run the main suite menu:
```bash
./bin/suite.sh
```

Recommended (to allow system update & cleanup):
```bash
sudo ./bin/suite.sh
```

---

## 📄 Documentation

Full documentation with step-by-step explanation, architecture diagrams & workflow:

👉 **https://github.com/Diksha566/system-maintenance-suite/wiki**


