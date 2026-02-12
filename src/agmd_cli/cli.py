"""Command-line interface for agmd."""

from __future__ import annotations

import argparse

from agmd_cli import __version__


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        prog="agmd",
        description="A scaffolded Python CLI tool.",
    )
    parser.add_argument(
        "--version",
        action="version",
        version=f"%(prog)s {__version__}",
    )

    subparsers = parser.add_subparsers(dest="command")

    greet_parser = subparsers.add_parser("greet", help="Print a greeting.")
    greet_parser.add_argument(
        "name",
        nargs="?",
        default="world",
        help="Name to greet.",
    )

    return parser


def main() -> int:
    parser = build_parser()
    args = parser.parse_args()

    if args.command == "greet":
        print(f"Hello, {args.name}!")
        return 0

    parser.print_help()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
