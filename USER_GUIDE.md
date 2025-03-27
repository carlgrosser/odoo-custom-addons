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

Activated modules (linked into Odoo's addons\_path) go here:

```
/home/administrator/custom_addons
```

---

## 🚀 Quick Start (Install the CLI Script)

Run this one-liner to install the module manager script:

```bash
curl -o ~/module_manager.sh https://raw.githubusercontent.com/carlgrosser/odoo-custom-addons/main/module_manager.sh && chmod +x ~/module_manager.sh
```

Run the script anytime with:

```bash
~/module_manager.sh
```

---

## 💡 What the Script Can Do

1. **Add a new OCA repository** as a Git submodule
2. **List all available modules** from all submodules
3. **Activate a module** (symlink it to `custom_addons` so Odoo sees it)
4. **Update all modules** (main repo and submodules)
5. **Restart Odoo** service

---

## ✅ Common Tasks

### 1. Add a New OCA Repo

Choose option `1` in the script, then provide:

- GitHub repo URL (e.g., `https://github.com/OCA/account-reconcile`)
- Short folder name (e.g., `account_reconcile_oca`)
- Branch (e.g., `17.0`)

This adds the OCA repo as a submodule and pushes it to GitHub.

---

### 2. Activate a Module

Choose option `3`, then enter the path relative to the `oca/` folder.

**Example:**

```
account_reconcile_oca/account_reconcile
```

This creates a symlink in `custom_addons` so Odoo can load it.

---

### 3. Update All Modules

Choose option `4`. This will:

- Pull the latest code from your repo and all submodules
- Auto-commit changes
- Push back to GitHub

---

### 4. Restart Odoo

Choose option `5`. This runs:

```bash
sudo systemctl restart odoo
```

Make sure the user has appropriate `sudo` privileges.

---

## 🛠 Troubleshooting

- **App not showing in Odoo?** Be sure the module is symlinked or copied into a directory listed in `addons_path`.
- **Permission denied?** Ensure your user can run `systemctl restart odoo` or edit the script to skip restarting.
- **Submodule didn’t clone?** Run:

```bash
git submodule update --init --recursive
```

---

## 📁 Where to Put This Guide

Place this file in the root of your GitHub repo as `USER_GUIDE.md`. GitHub will render it automatically for easy reading.

---

## 🙋‍♀️ Need Help?

If in doubt, open an issue in the repo or ping your team lead!

