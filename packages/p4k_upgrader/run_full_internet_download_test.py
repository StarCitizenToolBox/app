#!/usr/bin/env python3
"""
Run a full internet-only P4K download/update test for the Rust p4k_upgrader.

The script may read local launcher capture JSON only to discover fresh signed
RSI HTTP URLs. It does not read local manifest/base/object payload cache files.
"""

from __future__ import annotations

import argparse
import json
import os
import shutil
import subprocess
import sys
import time
from pathlib import Path
from typing import Any
from urllib.parse import parse_qs, urlparse


PACKAGE_DIR = Path(__file__).resolve().parent
DEFAULT_SIGNED_URLS_JSON = Path(
    r"C:\Users\c_jui\Documents\P4K\artifacts\downloads"
    r"\live_full_package_cache\SC_LIVE_4.8.2-live.12061511\signed_urls.json"
)
DEFAULT_CAPTURE_DIR = (
    Path(os.environ.get("APPDATA", r"C:\Users\c_jui\AppData\Roaming"))
    / "rsilauncher"
    / "p4k-api-capture"
)
DEFAULT_WORK_DIR = PACKAGE_DIR / "target" / "manual_internet_download_test"


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Generate and run an internet-only full P4K download test."
    )
    parser.add_argument(
        "--signed-urls",
        type=Path,
        default=DEFAULT_SIGNED_URLS_JSON,
        help="Path to signed_urls.json used only as signed HTTP URL metadata.",
    )
    parser.add_argument(
        "--capture-dir",
        type=Path,
        default=DEFAULT_CAPTURE_DIR,
        help="Launcher API capture directory used to find fresh games-release-response JSON.",
    )
    parser.add_argument(
        "--release-json",
        type=Path,
        default=None,
        help="Specific games-release-response JSON to use instead of signed_urls.json.",
    )
    parser.add_argument(
        "--work-dir",
        type=Path,
        default=DEFAULT_WORK_DIR,
        help="Output directory for config, temporary files, and test P4K files.",
    )
    parser.add_argument(
        "--clean",
        action="store_true",
        help="Delete the test work directory before running.",
    )
    parser.add_argument(
        "--no-run",
        action="store_true",
        help="Only write config and print the cargo command.",
    )
    parser.add_argument(
        "--debug",
        action="store_true",
        help="Use cargo debug build instead of --release.",
    )
    parser.add_argument(
        "--skip-expiry-check",
        action="store_true",
        help="Allow running even if signed URL Expires values look expired.",
    )
    parser.add_argument(
        "--no-pause",
        action="store_true",
        help="Do not pause before exit when double-clicked on Windows.",
    )
    return parser.parse_args()


def load_signed_urls(path: Path) -> dict[str, str]:
    if not path.exists():
        raise ValueError(f"missing signed URL metadata: {path}")
    with path.open("r", encoding="utf-8-sig") as f:
        data = json.load(f)
    required = ["manifest", "objects", "p4kBase", "p4kBaseVerificationFile"]
    missing = [key for key in required if not isinstance(data.get(key), str) or not data[key]]
    if missing:
        raise ValueError(f"missing signed URL fields: {', '.join(missing)}")
    return {key: data[key] for key in required}


def join_url_and_signature(value: dict[str, Any], label: str) -> str:
    url = value.get("url")
    signatures = value.get("signatures")
    if not isinstance(url, str) or not isinstance(signatures, str) or not url or not signatures:
        raise ValueError(f"release JSON field {label} is missing url/signatures")
    separator = "&" if "?" in url else "?"
    return f"{url}{separator}{signatures}"


def load_release_json(path: Path) -> dict[str, str]:
    payload = json.loads(path.read_text(encoding="utf-8-sig"))
    if isinstance(payload, dict) and isinstance(payload.get("body"), str):
        payload = json.loads(payload["body"])
    if isinstance(payload, dict) and isinstance(payload.get("data"), dict):
        payload = payload["data"]
    if not isinstance(payload, dict):
        raise ValueError(f"unsupported release JSON shape: {path}")
    return {
        "manifest": join_url_and_signature(payload.get("manifest", {}), "manifest"),
        "objects": join_url_and_signature(payload.get("objects", {}), "objects"),
        "p4kBase": join_url_and_signature(payload.get("p4kBase", {}), "p4kBase"),
        "p4kBaseVerificationFile": join_url_and_signature(
            payload.get("p4kBaseVerificationFile", {}), "p4kBaseVerificationFile"
        ),
    }


def latest_release_json(capture_dir: Path) -> Path | None:
    if not capture_dir.exists():
        return None
    files = sorted(capture_dir.glob("*games-release-response*.json"))
    return files[-1] if files else None


def load_best_url_source(args: argparse.Namespace) -> tuple[dict[str, str], str]:
    if args.release_json:
        return load_release_json(args.release_json), str(args.release_json)

    errors: list[str] = []
    latest_capture = latest_release_json(args.capture_dir)
    if latest_capture:
        try:
            return load_release_json(latest_capture), str(latest_capture)
        except Exception as err:
            errors.append(f"{latest_capture}: {err}")

    try:
        return load_signed_urls(args.signed_urls), str(args.signed_urls)
    except Exception as err:
        errors.append(f"{args.signed_urls}: {err}")

    raise SystemExit("Could not load signed HTTP URLs:\n" + "\n".join(errors))


def require_http_urls(urls: dict[str, str]) -> None:
    bad = [
        f"{key}={value}"
        for key, value in urls.items()
        if not value.startswith(("http://", "https://"))
    ]
    if bad:
        raise SystemExit("Internet-only test requires HTTP(S) URLs:\n" + "\n".join(bad))


def expires_at(url: str) -> int | None:
    values = parse_qs(urlparse(url).query).get("Expires")
    if not values:
        return None
    try:
        return int(values[0])
    except ValueError:
        return None


def check_expiry(urls: dict[str, str], skip: bool) -> None:
    now = int(time.time())
    expired = []
    for key, url in urls.items():
        expiry = expires_at(url)
        if expiry is not None and expiry <= now:
            expired.append(f"{key}: Expires={expiry}, now={now}")
    if expired and not skip:
        raise SystemExit(
            "Signed URL metadata is expired. Refresh launcher capture first, or pass "
            "--skip-expiry-check if you intentionally want to test the failure path.\n"
            + "\n".join(expired)
        )
    if expired:
        print("Warning: signed URL metadata appears expired:")
        for line in expired:
            print(f"  {line}")


def build_config(urls: dict[str, str], work_dir: Path) -> dict[str, Any]:
    return {
        "manifest_source": urls["manifest"],
        "mirror_bases": [],
        "official_bases": [urls["objects"]],
        "p4k_base_url": urls["p4kBase"],
        "p4k_base_verification_url": urls["p4kBaseVerificationFile"],
        "cache_dir": str(work_dir / "runtime"),
        "existing_p4k": str(work_dir / "Data.base.internet.p4k"),
        "output_p4k": str(work_dir / "Data.internet-full-test.p4k"),
        "loose_root": str(work_dir / "loose"),
        "update_p4k": True,
        "update_loose_files": False,
        "replace_existing_p4k": False,
        "inplace_update_p4k": False,
        "verify_after_assemble": True,
        "verify_crc32_for_loose": False,
        "verify_cig_structure": True,
        "verify_before_inplace": False,
        "resume_incomplete_inplace_update": False,
        "refuse_inplace_when_existing_table16": False,
        "remove_extra_p4k_entries": False,
        "fallback_rebuild_on_inplace_verify_failure": False,
        "p4k_sector_size": 4096,
        "max_entries": None,
        "include_regex": "",
        "exclude_regex": "",
        "user_agent": "P4KUpdateVerifyToolkit/1.0",
        "request_cookie": "",
        "rsi_token": "",
        "download_timeout_sec": 60,
        "chunk_size": 1024 * 1024,
        "download_retry_count": 10,
        "download_retry_delay_ms": 1000,
    }


def write_config(config: dict[str, Any], path: Path) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8") as f:
        json.dump(config, f, indent=2)
        f.write("\n")


def cargo_command(config_path: Path, debug: bool) -> list[str]:
    cmd = ["cargo", "run"]
    if not debug:
        cmd.append("--release")
    cmd.extend(["--", "update", "--config", str(config_path), "--no-replace"])
    return cmd


def maybe_pause(args: argparse.Namespace) -> None:
    if args.no_pause or os.name != "nt" or sys.stdin is None:
        return
    if sys.stdin.isatty() and not sys.argv[1:]:
        input("\nPress Enter to exit...")


def main(args: argparse.Namespace) -> int:
    work_dir = args.work_dir.resolve()
    if args.clean and work_dir.exists():
        shutil.rmtree(work_dir)

    urls, source = load_best_url_source(args)
    require_http_urls(urls)
    check_expiry(urls, args.skip_expiry_check)

    config_path = work_dir / "internet_full_config.json"
    write_config(build_config(urls, work_dir), config_path)

    cmd = cargo_command(config_path, args.debug)
    print(f"URL source: {source}")
    print(f"Wrote config: {config_path}")
    print("Command:")
    print(" ".join(f'"{part}"' if " " in part else part for part in cmd))

    if args.no_run:
        return 0

    completed = subprocess.run(cmd, cwd=PACKAGE_DIR)
    return completed.returncode


if __name__ == "__main__":
    parsed_args = parse_args()
    try:
        raise SystemExit(main(parsed_args))
    finally:
        maybe_pause(parsed_args)
