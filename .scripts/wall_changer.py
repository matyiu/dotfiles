#!/usr/bin/env python

import sys
import subprocess
import argparse
import time
from pathlib import Path
import random
from typing import Callable, Any
from itertools import cycle
import os

# --- Constants ---
WALLPAPER_PATH = Path.home() / ".wallpapers"
LOG_FILE = Path.home() / ".local/log/wallpaper_changer.log"
LOG_FILE.parent.mkdir(parents=True, exist_ok=True)


# --- Data types ---
class Mode():
    MANUAL = 0
    AUTO = 1
    DAEMON = 3


# Default arguments
mode = Mode.MANUAL
auto_mode_seconds = 300


# --- Utility functions ---
def get_wallpaper_list() -> list[Path]:
    valid_extensions = [".jpg", ".png", ".jpeg"]
    wallpaper_list = []
    wallpaper_dir = Path(WALLPAPER_PATH)

    # Filter list by numbered files
    for file_path in wallpaper_dir.glob("*"):
        if (file_path.is_file() and
            file_path.suffix in valid_extensions and
                not file_path.name.startswith("selected")):
            wallpaper_list.append(file_path)

    wallpaper_list.sort()

    return wallpaper_list


def interactive_select(wallpapers: list[Path]) -> Path | None:
    if not wallpapers:
        print(f"Error: there are no valid images inside {
              WALLPAPER_PATH}", file=sys.stderr)
        return None

    wallpaper_paths_str = "\n".join(str(p) for p in wallpapers)

    try:
        process = subprocess.run(
            ["fzf", "--prompt", "Select a Wallpaper: ",
             "--preview", "feh --bg-fill {}",
             "--preview-window", "0"],
            input=wallpaper_paths_str,
            capture_output=True,
            text=True,
            check=False
        )

        selected_path = process.stdout.strip()

        if selected_path:
            return Path(selected_path)
        else:
            return None

    except FileNotFoundError:
        print("Error: command 'fzf' or 'feh' were not found", file=sys.stderr)
        return None
    except Exception as e:
        print(f"Error: something unexpected ocurred during the selection: {
              e}", file=sys.stderr)
        return None


def random_select(wallpapers: list[Path]) -> Callable[[], Any]:
    if not wallpapers:
        print(f"Error: there are no valid images inside {
              WALLPAPER_PATH}", file=sys.stderr)
        return None

    shuffled_wallpapers = wallpapers[:]
    random.shuffle(shuffled_wallpapers)

    selector_iterator = cycle(shuffled_wallpapers)

    def get_next_wallpaper():
        return next(selector_iterator)

    return get_next_wallpaper


def apply_wallpaper(theme_path: Path):
    if not theme_path.exists():
        print(f"Error: selected background image does not exist: {
              theme_path}", file=sys.stderr)
        return

    print(f"Applying wallpaper: {theme_path}")

    try:
        for old_selected in WALLPAPER_PATH.glob("selected.*"):
            old_selected.unlink()
    except Exception as e:
        pass

    file_ext = theme_path.suffix.lstrip('.')
    if not file_ext:
        print("Error: The wallpaper does not have a file extension.", file=sys.stderr)
        return

    link_path = WALLPAPER_PATH / f"selected.{file_ext}"
    try:
        link_path.symlink_to(theme_path)
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        return

    try:
        subprocess.run(["feh", "--bg-fill", str(link_path)], check=True)
        print("Wallpaper applied.")
    except FileNotFoundError:
        print("Error: command 'feh' not found", file=sys.stderr)
    except subprocess.CalledProcessError as e:
        print(f"Error: something unexpected has ocurred with 'feh': {
              e}", file=sys.stderr)


def automatic_apply(
    wallpapers: list[Path],
    seconds: int
):
    wallpaper_selector = random_select(wallpapers)

    while True:
        apply_wallpaper(wallpaper_selector())
        time.sleep(seconds)


def daemonize(log_file: Path):
    try:
        pid = os.fork()
        if pid > 0:
            print(f"Wallpaper changer initialized in daemon mode. PID: {
                  pid}. The logs are saved in {log_file}")
            sys.exit(0)
    except OSError as e:
        sys.stderr.write(f"Forking Error: {
                         e.errno} ({e.strerror})\n")
        sys.exit(1)

    os.setsid()

    try:
        pid = os.fork()
        if pid > 0:
            sys.exit(0)
    except OSError as e:
        sys.stderr.write(f"Forking error: {
                         e.errno} ({e.strerror})\n")
        sys.exit(1)

    os.chdir("/")

    os.umask(0)

    sys.stdin.close()
    try:
        os.open("/dev/null", os.O_RDWR)
    except Exception:
        pass

    sys.stdout.flush()
    sys.stderr.flush()
    try:
        log_fd = os.open(log_file, os.O_CREAT | os.O_WRONLY | os.O_APPEND)
        os.dup2(log_fd, 1)
        os.dup2(log_fd, 2)
    except Exception as e:
        sys.stderr.write(
            f"Warning: could not set log file: {e}\n")


def main():
    parser = argparse.ArgumentParser(
        description="Change your wallpaper interactively or automatically",
        usage='%(prog)s [-a|--auto] [-s|--seconds SECONDS]'
    )

    parser.add_argument(
        '-a', '--auto',
        action='store_true',
        help='Habilita el modo de rotación automática de fondos de pantalla.'
    )

    parser.add_argument(
        '-s', '--seconds',
        type=int,
        default=auto_mode_seconds,
        help=f'Intervalo en segundos para la rotación automática (por defecto: {
            auto_mode_seconds}s).'
    )

    parser.add_argument(
        '-d', '--daemon',
        action='store_true',
        help='Ejecuta el script en modo de rotación automática como un demonio en segundo plano.'
    )

    args = parser.parse_args()

    wallpapers = get_wallpaper_list()

    if not wallpapers:
        print(f"Error: there are no valid images inside {WALLPAPER_PATH}")
        sys.exit(1)

    # Si se pide el modo daemon, lo ejecutamos y salimos.
    if args.daemon:
        # El modo daemon implica el modo automático
        if not args.auto:
            # Necesitamos los argumentos para la ejecución automática
            sys.argv.append("-a")
            # Volvemos a parsear para que args.auto sea True
            args = parser.parse_args()

        daemonize(LOG_FILE)
        # Después de la bifurcación, el código del hijo continúa aquí:

    if args.auto:
        automatic_apply(wallpapers, args.seconds)
    else:
        selected_theme_path = interactive_select(wallpapers)

        if selected_theme_path:
            apply_wallpaper(selected_theme_path)


if __name__ == "__main__":
    main()
