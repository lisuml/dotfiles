#!/usr/bin/env fish

# Prompt for Ansible infra repo and clone into ~/infra/ansible
echo
echo "📦 Let's clone your Ansible infra repository."
read -l -P "Enter repo URL (HTTPS or SSH, e.g. https://github.com/USER/REPO.git): " infra_input

if test -z "$infra_input"
    echo "ℹ️  No repository URL provided — skipping clone."
    exit 0
end

# Convert HTTPS GitHub URL to SSH automatically
set infra_url $infra_input
if string match -rq '^https://github\.com/([^/]+)/([^/]+?)(\.git)?$' -- $infra_input
    set iuser (string replace -r '^https://github\.com/([^/]+)/.*' '$1' $infra_input)
    set irepo (string replace -r '^https://github\.com/[^/]+/([^/]+?)(\.git)?$' '$1' $infra_input)
    set infra_url "git@github.com:$iuser/$irepo.git"
    echo "🔁 Converted to SSH URL: $infra_url"
end

set target_dir "$HOME/infra/ansible"
mkdir -p (path dirname $target_dir)

if test -d "$target_dir/.git"
    echo "ℹ️  Target already contains a Git repo:"
    git -C "$target_dir" remote -v | sed 's/^/    /'
    echo "ℹ️  Skipping clone."
else if test -d "$target_dir" -a (count (ls -A "$target_dir" 2>/dev/null)) -gt 0
    echo "⚠️  Target directory exists and is not empty; not cloning."
    echo "    Clone manually:"
    echo "    git clone $infra_url \"$target_dir\""
else
    echo "⬇️  Cloning $infra_url -> $target_dir"
    if git clone "$infra_url" "$target_dir"
        echo "✅ Ansible infra repository cloned."
    else
        echo "❌ Failed to clone repository. Try manually:"
        echo "   git clone $infra_url \"$target_dir\""
    end
end
