# Odoo Custom Addons Manager - User Guide

This guide explains how to manage OCA modules in your unified Odoo addons repository using a simple interactive CLI script.

---

## 📦 Repository Structure
Your main repository is located at:
```
/home/administrator/odoo-custom-addons
```
Submodules (OCA repos) live under:
```
/home/administrator/odoo-custom-addons/oca
```
Activated modules (linked into Odoo's addons_path) go here:
```
/home/administrator/custom_addons
```
---

## 🚀 Quick Start (Install the CLI Script)

Run this one-liner to install the module manager script:
```bash
curl -o ~/module_manager.sh https://raw.githubusercontent.com/YOUR_GITHUB_USERNAME/odoo-custom-addons/main/module_manager.sh && chmod +x ~/module_manager.sh
```
> ✅ Replace `YOUR_GITHUB_USERNAME` with your actual GitHub username.

Run the script anytime with:
```bash
~/module_manager.sh
```

---

## 💡 What the Script Can Do
1. **Add a new OCA repository** as a Git submodule
2. **List all available modules** not yet activated
3. **List activated modules**
4. **Activate a module**
5. **Update all modules**
6. **Remove a submodule**
7. **Restart Odoo** service

---

## ✅ Common Tasks

### 1. Add a New OCA Repo
Choose option `1` in the script, then provide:
- GitHub repo URL (e.g., `https://github.com/OCA/account-reconcile`)
- Short folder name (e.g., `account_reconcile_oca`)
- Branch (e.g., `17.0`)

This adds the OCA repo as a submodule and pushes it to GitHub.

> 🔐 **Note:** If using GitHub HTTPS and encountering authentication issues, switch to SSH and set your remote with:
> ```bash
> git remote set-url origin git@github.com:YOUR_USERNAME/odoo-custom-addons.git
> ```

> 🧾 **Also Important:** Ensure your Git identity is configured before pushing:
> ```bash
> git config --global user.name "Your Name"
> git config --global user.email "you@example.com"
> ```

> 📌 If your local branch is `master` but your remote uses `main`, you can rename it:
> ```bash
> git branch -M main
> git push --set-upstream origin main
> ```

---

### 2. Remove a Submodule
If you want to remove a previously added submodule:
```bash
cd /home/administrator/odoo-custom-addons
git submodule deinit -f oca/module_folder_name
rm -rf .git/modules/oca/module_folder_name
rm -rf oca/module_folder_name
git add .
git commit -m "Remove submodule: module_folder_name"
git push
```
Replace `module_folder_name` with the folder of the submodule (e.g., `account_reconcile_oca`).

Also remove any symlinks to its modules in `/home/administrator/custom_addons`:
```bash
rm /home/administrator/custom_addons/module_name
```

---

### 3. Activate a Module
Choose option `4`, then enter the path relative to the `oca/` folder.

**Example:**
```
account_reconcile_oca/account_reconcile
```
This creates a symlink in `custom_addons` so Odoo can load it.

---

### 4. Update All Modules
Choose option `5`. This will:
- Pull the latest code from your repo and all submodules
- Auto-commit changes
- Push back to GitHub

---

### 5. Restart Odoo
Choose option `7`. This runs:
```bash
sudo systemctl restart odoo
```
Make sure the user has appropriate `sudo` privileges.

---

### 6. List Available Modules (Not Activated)
Option `2` scans all submodules for valid Odoo modules (`__manifest__.py`) and excludes those already symlinked in `custom_addons`.

---

### 7. List Activated Modules
Option `3` shows only modules that are currently symlinked (i.e., active in Odoo).

---

## 🔐 SSH Setup for GitHub (No More Password Prompts)

### 1. Generate an SSH Key
```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
```

### 2. Add the Key to GitHub
- Go to [GitHub SSH Keys](https://github.com/settings/keys)
- Click **"New SSH key"** and paste in the key from:
```bash
cat ~/.ssh/id_ed25519.pub
```

### 3. Switch Repo Remote to SSH
```bash
cd /home/administrator/odoo-custom-addons
git remote set-url origin git@github.com:YOUR_USERNAME/odoo-custom-addons.git
```

### 4. Update Submodule Remotes to SSH
```bash
git submodule foreach 'git remote set-url origin `git config --get remote.origin.url | sed "s/https:\/\/github.com\//git@github.com:/"`'
```

---

## 🛠 Troubleshooting
- **App not showing in Odoo?** Be sure the module is symlinked or copied into a directory listed in `addons_path`.
- **Permission denied?** Ensure your user can run `systemctl restart odoo` or edit the script to skip restarting.
- **Submodule didn’t clone?** Run:
```bash
git submodule update --init --recursive
```
- **Push errors?** Confirm your Git identity is set and your branch is tracking the remote.

---

## 🌱 Future Optional Upgrades

### 🔄 Automated Repo Updates
- Schedule `git pull` + `git submodule update --remote --merge` using `cron`
- Optionally detect changes and restart Odoo only if needed
- Can push updates to GitHub automatically

### 🧷 Version Pinning
- Lock submodules to specific commits/tags for stability
- Prevent unexpected bugs from upstream changes

### 🚀 Dev → Staging → Production Sync
- Use Git branches or separate folders for each environment
- Apply and test changes in dev before merging to production

### ⚙️ Auto-Install Activated Modules
- Automatically run `odoo-bin -i module_name` after activation
- Optionally skip if already installed or add confirmation prompts

### 🧩 Config File for Module Metadata
- Use YAML or JSON to manage:
  - Activation flags
  - Descriptions
  - Notes for internal use

### 📊 Module Audit & Status Reports
- Script to show:
  - Which modules are activated
  - Which are not yet linked
  - Submodules needing updates

### 🌐 GUI/Web Frontend
- A simple web interface (e.g., Flask app) to manage:
  - Module activation
  - Updates
  - Restarting Odoo

---

## 📝 Quick Reference Cheat Sheet

### 🔧 Install Script
```bash
curl -o ~/module_manager.sh https://raw.githubusercontent.com/YOUR_GITHUB_USERNAME/odoo-custom-addons/main/module_manager.sh && chmod +x ~/module_manager.sh
```

### ▶️ Run the Script
```bash
~/module_manager.sh
```

### ✅ Menu Options
1. Add Submodule
2. List Available Modules (Not Activated)
3. List Activated Modules
4. Activate Module
5. Update All
6. Remove Submodule
7. Restart Odoo
8. Exit

---

### 📂 Addons Paths
- Base repo: `/home/administrator/odoo-custom-addons`
- Submodules: `/home/administrator/odoo-custom-addons/oca`
- Active modules: `/home/administrator/custom_addons`

---
