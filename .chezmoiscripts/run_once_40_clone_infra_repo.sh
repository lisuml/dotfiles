#!/usr/bin/env sh

# Prompt for Ansible infra repo and clone into ~/infra/ansible
echo
echo "Let's clone your Ansible infra repository."
printf "Enter repo URL (HTTPS or SSH, e.g. https://github.com/USER/REPO.git): "
read infra_input

if [ -z "$infra_input" ]; then
    echo "No repository URL provided — skipping clone."
else
    # Convert HTTPS GitHub URL to SSH automatically
    infra_url="$infra_input"
    if echo "$infra_input" | grep -Eq '^https://github\.com/([^/]+)/([^/]+?)(\.git)?$'; then
        user=$(echo "$infra_input" | sed -E 's|^https://github\.com/([^/]+)/.*|\1|')
        repo=$(echo "$infra_input" | sed -E 's|^https://github\.com/[^/]+/([^/]+?)(\.git)?$|\1|')
        infra_url="git@github.com:$user/$repo"
        echo "Converted to SSH URL: $infra_url"
    fi

    target_dir="$HOME/infra/ansible"
    mkdir -p "$(dirname "$target_dir")"

    if [ -d "$target_dir/.git" ]; then
        echo "Target already contains a Git repo:"
        git -C "$target_dir" remote -v | sed 's/^/    /'
        echo "Skipping clone."
    elif [ -d "$target_dir" ] && [ "$(ls -A "$target_dir" 2>/dev/null | wc -l)" -gt 0 ]; then
        echo "Target directory exists and is not empty; not cloning."
        echo "Clone manually:"
        echo "    git clone $infra_url \"$target_dir\""
    else
        echo "Cloning $infra_url -> $target_dir"
        if git clone "$infra_url" "$target_dir"; then
            echo "Ansible infra repository cloned."
        else
            echo "Failed to clone repository. Try manually:"
            echo "    git clone $infra_url \"$target_dir\""
        fi
    fi
fi

echo

# Configure Ansible Vault password file
vault_file="$target_dir/.vault_pass"
vault_dir="$(dirname "$vault_file")"
mkdir -p "$vault_dir"

if [ -f "$vault_file" ]; then
    echo "Ansible Vault password file already exists at:"
    echo "  $vault_file"
    echo "Leaving it unchanged."
    exit 0
fi

printf "Do you want to set up an Ansible Vault password file now? [y/N]: "
read answer

case "$answer" in
    y|Y|yes|YES)
        ;;
    *)
        echo "Skipping Vault password setup."
        exit 0
        ;;
esac

echo
echo "Enter Ansible Vault password (input will be hidden)."
printf "Password: "
stty -echo
read pass1
stty echo
echo
printf "Confirm password: "
stty -echo
read pass2
stty echo
echo

if [ "$pass1" != "$pass2" ]; then
    echo "Passwords do not match. Not writing vault password file."
    exit 1
fi

# Write password file with restrictive permissions
umask 077
printf "%s\n" "$pass1" > "$vault_file"

echo "Ansible Vault password saved to:"
echo "  $vault_file"
echo "Make sure ansible.cfg has:"
echo "  [defaults]"
echo "  vault_password_file = $vault_file"
