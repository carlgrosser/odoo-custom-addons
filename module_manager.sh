#!/bin/bash

REPO_ROOT="/home/administrator/odoo-custom-addons"
SUBMODULE_DIR="$REPO_ROOT/oca"
ACTIVE_ADDONS="/home/administrator/custom_addons"

function pause() {
    read -rp "Press Enter to continue..."
}

function safe_git_push() {
    git push origin main
    if [ $? -ne 0 ]; then
        echo "🔁 Push failed. Attempting to rebase and retry..."
        git pull origin main --rebase
        git push origin main
    fi
}

function add_submodule() {
    read -rp "Enter GitHub repo URL (e.g. https://github.com/OCA/project): " repo_url
    read -rp "Enter folder name to clone into (e.g. project): " folder_name
    read -rp "Enter branch (e.g. 17.0): " branch

    cd "$SUBMODULE_DIR" || exit
    git submodule add -b "$branch" "$repo_url" "$folder_name"
    cd "$REPO_ROOT" || exit
    git add .
    git commit -m "Add submodule: $folder_name"
    safe_git_push
    echo "✅ Submodule added and pushed."
    pause
}

function list_available_modules() {
    echo "📦 Modules NOT yet activated:"
    for subdir in "$SUBMODULE_DIR"/*; do
        [ -d "$subdir" ] || continue
        for module in "$subdir"/*; do
            if [ -f "$module/__manifest__.py" ]; then
                module_name=$(basename "$module")
                if [ ! -L "$ACTIVE_ADDONS/$module_name" ]; then
                    echo "$(basename "$subdir")/$module_name"
                fi
            fi
        done
    done
    pause
}

function list_activated_modules() {
    echo "✅ Currently activated modules:"
    for link in "$ACTIVE_ADDONS"/*; do
        [ -L "$link" ] && echo "$(basename "$link")"
    done
    pause
}

function activate_module() {
    read -rp "Enter path relative to 'oca/' (e.g. fieldservice/fieldservice_task): " module_path
    full_path="$SUBMODULE_DIR/$module_path"
    module_name=$(basename "$module_path")
    if [ -d "$full_path" ]; then
        ln -sf "$full_path" "$ACTIVE_ADDONS/$module_name"
        echo "✅ Module '$module_name' activated."
    else
        echo "❌ Module path not found."
    fi
    pause
}

function update_all() {
    cd "$REPO_ROOT" || exit
    echo "🔄 Pulling main repo..."
    git pull origin main --rebase
    echo "🔄 Updating submodules..."
    git submodule update --remote --merge
    git add .
    git commit -am "Update submodules"
    safe_git_push
    echo "✅ All modules updated."
    pause
}

function remove_submodule() {
    read -rp "Enter submodule folder name (e.g. account_reconcile_oca): " folder_name
    cd "$REPO_ROOT" || exit

    git submodule deinit -f "oca/$folder_name"
    rm -rf ".git/modules/oca/$folder_name"
    rm -rf "oca/$folder_name"

    git add .
    git commit -m "Remove submodule: $folder_name"
    safe_git_push
    echo "✅ Submodule removed."

    echo "🔍 Checking for activated modules to clean..."
    for link in "$ACTIVE_ADDONS"/*; do
        target=$(readlink "$link")
        if [[ "$target" == *"$folder_name"* ]]; then
            echo "Removing symlink: $(basename "$link")"
            rm "$link"
        fi
    done
    pause
}

function restart_odoo() {
    echo "Restarting Odoo..."
    sudo systemctl restart odoo
    echo "✅ Odoo restarted."
    pause
}

while true; do
    clear
    echo "==== Odoo Module Manager ===="
    echo "1. Add new OCA repo as submodule"
    echo "2. List available (NOT activated) modules"
    echo "3. List activated modules"
    echo "4. Activate a module"
    echo "5. Update all modules"
    echo "6. Remove a submodule"
    echo "7. Restart Odoo"
    echo "8. Exit"
    echo "=============================="
    read -rp "Choose an option [1-8]: " choice

    case $choice in
        1) add_submodule ;;
        2) list_available_modules ;;
        3) list_activated_modules ;;
        4) activate_module ;;
        5) update_all ;;
        6) remove_submodule ;;
        7) restart_odoo ;;
        8) exit 0 ;;
        *) echo "❌ Invalid option." && pause ;;
    esac
done
