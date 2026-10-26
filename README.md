# ig-instagram-analysis

Personal Instagram follower analysis tools built from an Instagram data export.

## What's included

- **ig_graph.html** — D3.js force-directed node graph (Obsidian-style, dark theme). Nodes colored by relationship type: self, mutual, follower, engagement. Click any node to open the Instagram profile.
- **ig_dashboard.html** — Stats overview with follower breakdown by name origin/background.
- **ig_following.html** — Clickable page of all accounts you follow.
- **ig_followers_origins.csv** — Name origin predictions for 255 followers using ethnicolr (Florida voter name model). Gambian scammer accounts excluded.

## To recreate from a fresh Instagram export

1. Export your Instagram data (JSON format) from Instagram settings
2. Run `setup.sh` with the export zip as argument

## Follower breakdown (as of Oct 2026)
- Anglo/European: 176
- Asian: 29
- African/Diaspora: 26
- Hispanic/Latin: 19

## Notes
- `ig_data.json` is excluded from this repo (personal data)
- Friends-of-friends scraping was attempted but blocked by Instagram — deferred
