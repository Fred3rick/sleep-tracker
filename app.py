#!/usr/bin/env python3
"""
Kindle Web App – Federico
Server principale con routing per tutte le mini-app.
"""

from bottle import route, run, static_file, template, request, redirect
import csv
import datetime as dt
import json
import os
from pathlib import Path

# ─── Config ────────────────────────────────────────────────────────────────────
BASE_DIR    = Path(__file__).parent
DATA_DIR    = BASE_DIR / "data"
CFG_FILE    = BASE_DIR / "config.json"
SLEEP_CSV   = DATA_DIR / "sleep_log.csv"

DEFAULTS = {
    "target_minutes": 480,
    "green_tol_min":  15,
    "yellow_tol_min": 60,
}

def load_config():
    if CFG_FILE.exists():
        try:
            cfg = json.loads(CFG_FILE.read_text())
            for k, v in DEFAULTS.items():
                cfg.setdefault(k, v)
            return cfg
        except Exception:
            pass
    return dict(DEFAULTS)

def save_config(cfg):
    CFG_FILE.write_text(json.dumps(cfg, indent=2))

def ensure_storage():
    DATA_DIR.mkdir(parents=True, exist_ok=True)
    if not SLEEP_CSV.exists():
        with SLEEP_CSV.open("w", newline="") as fh:
            csv.writer(fh).writerow(["date","bed_time","wake_time","duration_min","status"])

# ─── Helpers ───────────────────────────────────────────────────────────────────
def fmt_m(mins):
    mins = int(mins)
    return f"{mins//60}h {mins%60:02d}m"

def minutes_between(bed_str, wake_str):
    today = dt.date.today()
    bed  = dt.datetime.combine(today, dt.time(*[int(x) for x in bed_str.split(":")]))
    wake = dt.datetime.combine(today, dt.time(*[int(x) for x in wake_str.split(":")]))
    if wake <= bed:
        wake += dt.timedelta(days=1)
    return int((wake - bed).total_seconds() // 60)

def status_for(dur, cfg):
    diff = abs(dur - cfg["target_minutes"])
    if diff <= cfg["green_tol_min"]:  return "GREEN"
    if diff <= cfg["yellow_tol_min"]: return "YELLOW"
    return "RED"

def read_rows():
    if not SLEEP_CSV.exists():
        return []
    with SLEEP_CSV.open() as fh:
        return list(csv.DictReader(fh))

def write_rows(rows):
    with SLEEP_CSV.open("w", newline="") as fh:
        w = csv.writer(fh)
        w.writerow(["date","bed_time","wake_time","duration_min","status"])
        for r in rows:
            w.writerow([r["date"],r["bed_time"],r["wake_time"],r["duration_min"],r["status"]])

# ─── Route: Home ───────────────────────────────────────────────────────────────
@route('/')
def home():
    return template('home')

# ─── Route: Sleep Tracker ──────────────────────────────────────────────────────
@route('/sleep')
def sleep_index():
    cfg  = load_config()
    rows = sorted(read_rows(), key=lambda r: r["date"], reverse=True)[:7]
    for r in rows:
        r["duration_fmt"] = fmt_m(r["duration_min"])
    return template('sleep_index', rows=rows, cfg=cfg, fmt_m=fmt_m)

@route('/sleep/add', method='GET')
def sleep_add_get():
    today = dt.date.today().isoformat()
    rows  = read_rows()
    exists = any(r["date"] == today for r in rows)
    return template('sleep_add', today=today, exists=exists, error=None)

@route('/sleep/add', method='POST')
def sleep_add_post():
    cfg       = load_config()
    date_str  = request.forms.get('date', dt.date.today().isoformat())
    bed_str   = request.forms.get('bed_time', '').strip()
    wake_str  = request.forms.get('wake_time', '').strip()
    force     = request.forms.get('force', '') == '1'

    # Validazione
    try:
        dt.date.fromisoformat(date_str)
        dt.time(*[int(x) for x in bed_str.split(":")])
        dt.time(*[int(x) for x in wake_str.split(":")])
    except Exception:
        return template('sleep_add', today=date_str, exists=False,
                        error="Formato non valido. Usa HH:MM per gli orari.")

    rows = read_rows()
    if any(r["date"] == date_str for r in rows):
        if not force:
            return template('sleep_add', today=date_str, exists=True, error=None)
        rows = [r for r in rows if r["date"] != date_str]

    duration = minutes_between(bed_str, wake_str)
    status   = status_for(duration, cfg)

    rows.append({
        "date":         date_str,
        "bed_time":     bed_str,
        "wake_time":    wake_str,
        "duration_min": str(duration),
        "status":       status,
    })
    write_rows(sorted(rows, key=lambda r: r["date"]))
    redirect('/sleep')

@route('/sleep/history')
def sleep_history():
    cfg  = load_config()
    n    = int(request.query.get('n', 14))
    rows = sorted(read_rows(), key=lambda r: r["date"], reverse=True)[:n]
    for r in rows:
        r["duration_fmt"] = fmt_m(r["duration_min"])
    return template('sleep_history', rows=rows, n=n, cfg=cfg)

@route('/sleep/stats')
def sleep_stats():
    cfg  = load_config()
    rows = read_rows()
    if not rows:
        return template('sleep_stats', stats=None, cfg=cfg)

    durations = [int(r["duration_min"]) for r in rows]
    avg = sum(durations) // len(durations)

    # Streak verde
    sorted_rows = sorted(rows, key=lambda r: r["date"], reverse=True)
    streak = 0
    for r in sorted_rows:
        if r["status"] == "GREEN":
            streak += 1
        else:
            break

    # Distribuzione
    greens  = sum(1 for r in rows if r["status"] == "GREEN")
    yellows = sum(1 for r in rows if r["status"] == "YELLOW")
    reds    = sum(1 for r in rows if r["status"] == "RED")
    total   = len(rows)

    # Giorno migliore/peggiore
    days = {}
    for r in rows:
        dow = dt.date.fromisoformat(r["date"]).strftime("%A")
        days.setdefault(dow, []).append(int(r["duration_min"]))
    day_avgs = {d: sum(v)//len(v) for d, v in days.items()}
    best_day  = max(day_avgs, key=day_avgs.get) if day_avgs else "-"
    worst_day = min(day_avgs, key=day_avgs.get) if day_avgs else "-"

    stats = {
        "total":      total,
        "avg":        fmt_m(avg),
        "min":        fmt_m(min(durations)),
        "max":        fmt_m(max(durations)),
        "streak":     streak,
        "greens":     greens,
        "yellows":    yellows,
        "reds":       reds,
        "green_pct":  round(greens/total*100),
        "yellow_pct": round(yellows/total*100),
        "red_pct":    round(reds/total*100),
        "best_day":   best_day,
        "worst_day":  worst_day,
    }
    return template('sleep_stats', stats=stats, cfg=cfg)

@route('/sleep/delete/<date_str>')
def sleep_delete(date_str):
    rows = [r for r in read_rows() if r["date"] != date_str]
    write_rows(rows)
    redirect('/sleep/history')

@route('/sleep/config', method='GET')
def sleep_config_get():
    cfg = load_config()
    return template('sleep_config', cfg=cfg, saved=False)

@route('/sleep/config', method='POST')
def sleep_config_post():
    cfg = load_config()
    try:
        cfg["target_minutes"] = int(request.forms.get('target', 480))
        cfg["green_tol_min"]  = int(request.forms.get('green', 15))
        cfg["yellow_tol_min"] = int(request.forms.get('yellow', 60))
        save_config(cfg)
    except Exception:
        pass
    return template('sleep_config', cfg=cfg, saved=True)

# ─── Static files ──────────────────────────────────────────────────────────────
@route('/static/<filename>')
def serve_static(filename):
    return static_file(filename, root=str(BASE_DIR / 'static'))

# ─── Run ───────────────────────────────────────────────────────────────────────
if __name__ == '__main__':
    ensure_storage()
    run(host='0.0.0.0', port=8080, debug=True)
