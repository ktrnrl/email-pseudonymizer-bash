#!/usr/bin/env bash
set -euo pipefail

OUT_DIR="out_pseudo"      
PREFIX_KEEP=2            
SUFFIX_KEEP=2             

usage() {
  cat <<USAGE
Usage: $0 [-o OUT_DIR] [files...]
  -o DIR   output directory for processed copies (default: out_pseudo)

USAGE
}

# --- parse options ---
while getopts ":o:h" opt; do
  case "$opt" in
    o) OUT_DIR="${OPTARG}";;
    h) usage; exit 0;;
    \?) echo "Unknown option: -$OPTARG" >&2; usage; exit 2;;
    :)  echo "Option -$OPTARG requires an argument" >&2; usage; exit 2;;
  esac
done
shift $((OPTIND-1))

mkdir -p "$OUT_DIR"

# Якщо файли не передані аргументами — беремо всі .txt у поточній теці
if [ "$#" -eq 0 ]; then
  mapfile -d '' FILES < <(find . -maxdepth 1 -type f -name '*.txt' -print0)
else
  FILES=("$@")
fi

# Досить широкий регекс для e-mail (ASCII)
RE='[A-Za-z0-9][A-Za-z0-9._%+-]*@[A-Za-z0-9.-]+\.[A-Za-z]{2,}'

# --- основна AWK-програма ---
read -r -d '' AWK_CODE <<'AWK_END' || true
function lower(s)        { return tolower(s) }
function strip_tag(s)    { sub(/\+.*/, "", s); return s }      # обрізати +тег
function strip_dots(s)   { gsub(/\./, "", s); return s }       # прибрати крапки

# Маскування за правилами:
# - len > 4  → перші 2 + "***" + останні 2
# - len ≤ 4  → a***a (перший + "***" + останній; якщо len=1 → дублюємо)
function mask_local(l,    L,first,last) {
  L = length(l)
  if (L == 0) return "***"
  if (L > 4) {
    return substr(l,1,2) "***" substr(l,L-1,2)
  }
  first = substr(l,1,1)
  last  = (L >= 2 ? substr(l,L,1) : first)
  return first "***" last
}

# Нормалізація локальної частини:
#  - lowercase
#  - обрізати +тег
#  - прибрати крапки
function normalize_local(l) {
  l = lower(l)
  l = strip_tag(l)
  l = strip_dots(l)
  return l
}

# Псевдонімізація повної адреси
function pseudonymize(email,   a,l,d,masked) {
  split(email, a, "@")
  l = a[1]; d = a[2]
  l = normalize_local(l)
  d = lower(d)
  masked = mask_local(l)
  return masked "@" d
}

# Замінити всі входження e-mail у рядку
function rewrite_line(s,   out,pre,em) {
  out = ""
  while (match(s, re)) {
    pre = substr(s, 1, RSTART-1)
    em  = substr(s, RSTART, RLENGTH)
    out = out pre pseudonymize(em)
    s   = substr(s, RSTART + RLENGTH)
  }
  return out s
}

{
  print rewrite_line($0)
}
AWK_END

# --- запуск обробки ---
count=0
for f in "${FILES[@]}"; do
  # basename (прибираємо початковий ./ якщо є)
  base="${f#./}"
  out_path="${OUT_DIR}/${base}"
  mkdir -p "$(dirname "$out_path")"

  awk -v re="$RE" "$AWK_CODE" "$f" > "$out_path"
  count=$((count+1))
done

echo "✓ Готово. Оброблено файлів: $count"
echo "→ Результати в каталозі: $OUT_DIR/"


