#!/usr/bin/env sh

# Prompt for Ansible infra repo and clone into ~/infra/ansible
echo
echo "Let's clone your Ansible infra repository."
read -p "Enter repo URL (HTTPS or SSH, e.g. https://github.com/USER/REPO.git): " infra_input

if [ -z "$infra_input" ]; then
    echo "No repository URL provided — skipping clone."
    exit 0
fi

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
