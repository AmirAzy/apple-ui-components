#!/usr/bin/env python3
"""Download the Fontshare faces the page asks for into assets/fonts/.

Why a script instead of committing the files: the ITF Free Font Licence lets
you use these fonts commercially but does not let you redistribute the font
files. So the repository ships zero Fontshare binaries, and this script pulls
them straight from Fontshare's own CDN into a gitignored folder.

    python3 scripts/fetch-fonts.py

Without it the page still renders — every family falls back to system fonts
through the stacks in :root, and Vazirmatn (OFL, committed) keeps the Persian
type correct.

Weights: variable families are requested with the special weight `1`, which is
how the Fontshare v2 API returns the variable file.
"""

from __future__ import annotations

import pathlib
import re
import sys
import urllib.error
import urllib.request

ROOT = pathlib.Path(__file__).resolve().parent.parent
OUT = ROOT / "assets" / "fonts"
API = "https://api.fontshare.com/v2/css"

# slug -> (local filename, css weight to request)
FACES = {
    "clash-display": ("clash-display-var.woff2", "1"),
    "satoshi": ("satoshi-var.woff2", "1"),
    "azeret-mono": ("azeret-mono-400.woff2", "400"),
    "cabinet-grotesk": ("cabinet-grotesk-var.woff2", "1"),
    "boska": ("boska-var.woff2", "1"),
    "gambetta": ("gambetta-var.woff2", "1"),
    "zodiak": ("zodiak-var.woff2", "1"),
    "general-sans": ("general-sans-var.woff2", "1"),
    "bespoke-sans": ("bespoke-sans-var.woff2", "1"),
    "melodrama": ("melodrama-var.woff2", "1"),
    "sentient": ("sentient-var.woff2", "1"),
    "tanker": ("tanker-400.woff2", "400"),
}

UA = {"User-Agent": "aurora-skill/1.0 (+scripts/fetch-fonts.py)"}


def css_for(slug: str, weight: str) -> str:
    url = f"{API}?f%5B%5D={slug}@{weight}&display=swap"
    request = urllib.request.Request(url, headers=UA)
    with urllib.request.urlopen(request, timeout=30) as response:
        return response.read().decode("utf-8")


def woff2_url(css: str) -> str | None:
    match = re.search(r"url\('(//cdn\.fontshare\.com/[^']+\.woff2)'\)", css)
    if not match:
        return None
    return "https:" + match.group(1)


def main() -> int:
    OUT.mkdir(parents=True, exist_ok=True)
    failures = 0
    for slug, (filename, weight) in FACES.items():
        target = OUT / filename
        if target.exists() and target.stat().st_size > 4096:
            print(f"have {filename}")
            continue
        try:
            url = woff2_url(css_for(slug, weight))
            if not url:
                print(f"skip {slug}: no woff2 in the Fontshare response")
                failures += 1
                continue
            request = urllib.request.Request(url, headers=UA)
            with urllib.request.urlopen(request, timeout=60) as response:
                data = response.read()
            target.write_bytes(data)
            print(f"got  {filename} ({len(data) / 1024:.0f} KiB)")
        except urllib.error.HTTPError as error:
            print(f"fail {slug}: HTTP {error.code}")
            failures += 1
        except urllib.error.URLError as error:
            print(f"fail {slug}: {error.reason}")
            failures += 1
    print()
    print(f"{len(list(OUT.glob('*.woff2')))} files in {OUT.relative_to(ROOT)}")
    if failures:
        print(f"{failures} face(s) could not be fetched; the page will fall back for those.")
    return 0 if failures == 0 else 1


if __name__ == "__main__":
    sys.exit(main())
