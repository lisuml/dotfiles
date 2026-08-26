#!/usr/bin/env bash
# Claude Code status line: repo and git state, context usage bar, session
# cost, lines changed by the session, session duration, and model name.

input=$(cat)

# One jq call for all fields, one per line; rounding happens in jq so the
# shell only ever sees integers (avoids locale-dependent printf %f parsing)
mapfile -t f < <(echo "$input" | jq -r '
  (.model.display_name // "unknown"),
  (.context_window.used_percentage // 0 | round),
  (.workspace.current_dir // ""),
  (.cost.total_cost_usd // 0),
  (.cost.total_lines_added // 0),
  (.cost.total_lines_removed // 0),
  (.cost.total_duration_ms // 0 | round)')
model=${f[0]} pct=${f[1]} cwd=${f[2]} cost=${f[3]}
added=${f[4]} removed=${f[5]} duration_ms=${f[6]}

R="\033[0m"
BOLD="\033[1m"
DIM="\033[2m"

rgb()  { printf "\033[38;2;%s;%s;%sm" "$1" "$2" "$3"; }
pipe() { printf "$(rgb 80 80 80)${DIM}│${R}"; }
g()    { GIT_OPTIONAL_LOCKS=0 git -C "${cwd:-.}" "$@" 2>/dev/null; }

# Repo name (bold yellow)
repo=$(basename "${cwd:-$(pwd)}")
printf "${BOLD}$(rgb 255 200 0)%s${R}" "$repo"

# Git branch (bold cyan), * when the tree is dirty, ahead/behind upstream
branch=$(g symbolic-ref --short HEAD)
if [ -n "$branch" ]; then
  printf " $(rgb 80 80 80)${DIM}(${R}${BOLD}$(rgb 0 220 220)🌿 %s${R}" "$branch"
  [ -n "$(g status --porcelain)" ] && printf "${BOLD}$(rgb 220 140 0)*${R}"
  ab=$(g rev-list --left-right --count '@{u}...HEAD')
  if [ -n "$ab" ]; then
    read -r behind ahead <<< "$ab"
    [ "$ahead" -gt 0 ]  && printf " $(rgb 0 200 80)↑%s${R}" "$ahead"
    [ "$behind" -gt 0 ] && printf " $(rgb 220 40 20)↓%s${R}" "$behind"
  fi
  printf "$(rgb 80 80 80)${DIM})${R}"
fi

printf " "
pipe
printf " "

# 20-block context bar, green→yellow→red gradient, one awk call for the lot
filled=$(( pct * 20 / 100 ))
[ "$filled" -gt 20 ] && filled=20
awk -v filled="$filled" 'BEGIN{
  for (i = 1; i <= 20; i++) {
    if (i <= filled) {
      t = (i - 1) / 19
      if (t < 0.5) { r = int(220*t*2); g = 200;                      b = int(80 - 80*t*2) }
      else         { r = 220;          g = int(200 - 160*(t-0.5)*2); b = int(20*(t-0.5)*2) }
      printf "\033[38;2;%d;%d;%dm█\033[0m", r, g, b
    } else {
      printf "\033[38;2;60;60;60m█\033[0m"
    }
  }
}'

# Dynamic emoji + percentage colored by usage
if   [ "$pct" -ge 90 ]; then emoji="🚨"; pct_color=$(rgb 220 40 20)
elif [ "$pct" -ge 70 ]; then emoji="🔥"; pct_color=$(rgb 220 140 0)
elif [ "$pct" -ge 20 ]; then emoji="⚡"; pct_color=$(rgb 220 200 0)
else                         emoji="🟢"; pct_color=$(rgb 0 200 80)
fi
printf " %s ${pct_color}${BOLD}%s%%${R}" "$emoji" "$pct"

printf " "
pipe

# Session cost as reported by Claude Code (yellow)
printf " $(rgb 255 200 0)\$%s${R}" "$(awk -v c="$cost" 'BEGIN{printf "%.4f", c}')"

printf " "
pipe
printf " "

# Lines changed by this session (not git state, which mixes in manual edits)
if [ "$added" -gt 0 ] || [ "$removed" -gt 0 ]; then
  printf "$(rgb 0 200 80)+%s${R} $(rgb 220 40 20)-%s${R}" "$added" "$removed"
else
  printf "$(rgb 80 80 80)+0 -0${R}"
fi

printf " "
pipe

# Session duration
secs=$(( duration_ms / 1000 ))
if   [ "$secs" -ge 3600 ]; then dur="$((secs / 3600))h$(( (secs % 3600) / 60 ))m"
elif [ "$secs" -ge 60 ];   then dur="$((secs / 60))m"
else                            dur="${secs}s"
fi
printf " ⏱ $(rgb 160 160 160)%s${R}" "$dur"

printf " "
pipe

# Model name in magenta with robot icon, plus the account plan.
# organizationType is undocumented internal state; omit the plan if absent.
plan=$(jq -r '.oauthAccount.organizationType // empty' "$HOME/.claude.json" 2>/dev/null)
case "$plan" in
  claude_pro)        plan="Pro" ;;
  claude_max)        plan="Max" ;;
  claude_team)       plan="Team" ;;
  claude_enterprise) plan="Enterprise" ;;
  *)                 plan=${plan#claude_}; plan=${plan//_/ } ;;
esac
printf " 🤖 ${BOLD}$(rgb 220 80 220)%s${R}" "$model"

# A trailing `[ -n "$plan" ] && printf` would exit 1 when the plan is unknown,
# which Claude Code reads as the status line command failing
if [ -n "$plan" ]; then
  printf "$(rgb 80 80 80)${DIM} · ${R}$(rgb 160 160 160)%s${R}" "$plan"
fi
