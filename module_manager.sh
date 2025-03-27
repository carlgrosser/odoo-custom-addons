#!/bin/bash

REPO_DIR="/home/administrator/odoo-custom-addons"
ACTIVE_DIR="/home/administrator/custom_addons"
ODOO_SERVICE="odoo"

function add_submodule() {
    echo "Enter the OCA GitHub repo URL (e.g., https://github.com/OCA/account-reconcile):"
    read repo_url
    echo "Enter a short name to use for this submodule (e.g., account_reconcile_oca):"
    read module_dir
    echo "Enter the branch (usually 17.0):"
    read branch

    cd "$REPO_DIR/oca" || mkdir -p "$REPO_DIR/oca" && cd "$REPO_DIR/oca"
    git submodule add -b "$branch" "$repo_url" "$module_dir"
    cd "$REPO_DIR"
    git add .
    git commit -m "Add submodule: $module_dir from $repo_url"
    git push
    echo "✅ Submodule added and pushed."
}

function list_modules() {
    echo "\n📦 Available modules in submodules:"
    find "$REPO_DIR/oca" -type f -name "__manifest__.py" | sed "s|$REPO_DIR/oca/||" | cut -d/ -f1,2 | sort | uniq
    echo ""
}

function activate_module() {
    echo "Enter the relative path to the module (e.g., account_reconcile_oca/account_reconcile):"
    read module_path
    full_source="$REPO_DIR/oca/$module_path"
    full_target="$ACTIVE_DIR/$(basename $module_path)"
    if [ -d "$full_source" ]; then
        mkdir -p "$ACTIVE_DIR"
        ln -sf "$full_source" "$full_target"
        echo "✅ Module activated: $full_target"
    else
        echo "❌ Module not found: $full_source"
    fi
}

function update_all() {
    echo "🔄 Pulling latest changes from main repo and submodules..."
    cd "$REPO_DIR"
    git pull
    git submodule update --remote --merge
    git add .
    git commit -m "Update submodules" || echo "(Nothing to commit)"
    git push
    echo "✅ All modules updated."
}

function restart_odoo() {
    echo "🔁 Restarting Odoo service..."
    sudo systemctl restart "$ODOO_SERVICE"
    echo "✅ Odoo restarted."
}

while true; do
    echo "\n==== Odoo Module Manager ===="
    echo "1. Add new OCA repo as submodule"
    echo "2. List available modules"
    echo "3. Activate a module"
    echo "4. Update all modules"
    echo "5. Restart Odoo"
    echo "6. Exit"
    echo -n "Choose an option: "
    read choice
    case $choice in
        1) add_submodule ;;
        2) list_modules ;;
        3) activate_module ;;
        4) update_all ;;
        5) restart_odoo ;;
        6) echo "Goodbye!"; exit 0 ;;
        *) echo "Invalid option" ;;
    esac
done
