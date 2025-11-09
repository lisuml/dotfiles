#!/usr/bin/env fish

# Update chezmoi source repo remote to SSH (no chezmoi calls to avoid lock)
set repo_dir "{{ .chezmoi.sourceDir }}"
if test -n "$repo_dir" -a -d "$repo_dir/.git"
    pushd $repo_dir >/dev/null
    if git rev-parse --is-inside-work-tree >/dev/null 2>&1
        if git remote | string match -q origin
            set remote_url (git remote get-url --push origin 2>/dev/null; or git remote get-url origin 2>/dev/null)
            if test -n "$remote_url"
                if string match -rq '^https://github\.com/([^/]+)/([^/]+?)(\.git)?$' -- $remote_url
                    set user (string replace -r '^https://github\.com/([^/]+)/.*' '$1' $remote_url)
                    set repo (string replace -r '^https://github\.com/[^/]+/([^/]+?)(\.git)?$' '$1' $remote_url)
                    set ssh_url "git@github.com:$user/$repo.git"
                    echo "🔄 Updating dotfiles remote URL to SSH: $ssh_url"
                    git remote set-url origin $ssh_url
                else if string match -rq '^git@github\.com:.*' -- $remote_url
                    echo "ℹ️  Dotfiles remote already uses SSH."
                else
                    echo "ℹ️  Dotfiles remote is not GitHub: $remote_url"
                end
            else
                echo "ℹ️  No URL for 'origin'."
            end
        else
            echo "ℹ️  No 'origin' remote — skipping."
        end
    else
        echo "ℹ️  Not a Git working tree."
    end
    popd >/dev/null
else
    echo "ℹ️  No repo at {{ .chezmoi.sourceDir }} — skipping."
end
