#!/bin/bash
# Recreate IG analysis from a fresh Instagram export zip
# Usage: bash setup.sh instagram-export.zip

set -e

if [ -z "$1" ]; then
  echo "Usage: bash setup.sh instagram-export.zip"
  exit 1
fi

ZIP="$1"
WORKDIR="$(pwd)/ig_work"
mkdir -p "$WORKDIR"

echo "Installing dependencies..."
pip3 install ethnicolr tensorflow nameparser --break-system-packages -q

echo "Extracting export..."
unzip -q "$ZIP" -d "$WORKDIR"

echo "Parsing export..."
python3 - << 'PYEOF'
import json, os, glob

work = "./ig_work"

# Find followers file
followers_file = glob.glob(f"{work}/**/followers_1.json", recursive=True)
if not followers_file:
    print("Could not find followers_1.json in export")
    exit(1)

with open(followers_file[0]) as f:
    raw = json.load(f)

followers = [{"username": e["string_list_data"][0]["value"],
              "date": e["string_list_data"][0].get("timestamp", "")}
             for e in raw]

print(f"Found {len(followers)} followers")
with open("ig_data_new.json", "w") as f:
    json.dump({"followers": followers, "engagement": []}, f, indent=2)
print("Saved ig_data_new.json")
PYEOF

echo "Running name origin predictions..."
python3 - << 'PYEOF'
import json, csv, re
from nameparser import HumanName
from ethnicolr import pred_fl_reg_name

with open("ig_data_new.json") as f:
    data = json.load(f)

gambian = {'baboucarr','alieudarboe','bubacarr','kebba','alieubah'}

rows = []
for follower in data["followers"]:
    u = follower["username"]
    if any(g in u for g in gambian):
        continue
    clean = re.sub(r'[._0-9]', ' ', u).strip()
    name = HumanName(clean)
    rows.append({"username": u, "firstname": name.first or clean, "lastname": name.last or ""})

import pandas as pd
df = pd.DataFrame(rows)
result = pred_fl_reg_name(df, "lastname", "firstname")
result.to_csv("ig_followers_origins.csv", index=False)
print(f"Saved ig_followers_origins.csv ({len(result)} rows)")
PYEOF

echo "Done. Open ig_graph.html and ig_dashboard.html in your browser."
echo "You may want to uninstall heavy deps after: pip3 uninstall -y tensorflow keras ethnicolr"
