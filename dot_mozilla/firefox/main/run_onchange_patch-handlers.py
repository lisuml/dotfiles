#!/usr/bin/env python3
# Set mattermost:// scheme to use system default handler (action 4)
import json, os

path = os.path.expanduser("~/.mozilla/firefox/main/handlers.json")
if not os.path.exists(path):
    exit(0)

d = json.load(open(path))
d.setdefault("schemes", {})["mattermost"] = {"action": 4}
open(path, "w").write(json.dumps(d))
