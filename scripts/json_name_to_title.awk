#!/usr/bin/awk -f
# Replaces "name" key with "title" only when the value is a JSON string.
# Handles any nesting depth and whitespace/newlines between tokens.
# Usage: awk -f scripts/json_name_to_title.awk input.json > output.json

function read_string(s, pos,  j, c, esc, content) {
    j = pos + 1; esc = 0; content = ""
    while (j <= length(s)) {
        c = substr(s, j, 1)
        if (esc) { content = content c; esc = 0 }
        else if (c == "\\") { content = content c; esc = 1 }
        else if (c == "\"") { g_str = content; return j }
        else { content = content c }
        j++
    }
    g_str = content; return length(s)
}

BEGIN { content = "" }
{ content = content $0 ORS }
END {
    n = length(content); i = 1; out = ""
    while (i <= n) {
        c = substr(content, i, 1)
        if (c == "\"") {
            closepos = read_string(content, i); key = g_str
            k = closepos + 1
            while (k <= n && substr(content, k, 1) ~ /[ \t\r\n]/) k++
            if (key == "name" && k <= n && substr(content, k, 1) == ":") {
                k++
                while (k <= n && substr(content, k, 1) ~ /[ \t\r\n]/) k++
                if (k <= n && substr(content, k, 1) == "\"") {
                    out = out "\"title\""; i = closepos + 1; continue
                }
            }
            out = out substr(content, i, closepos - i + 1); i = closepos + 1
        } else { out = out c; i++ }
    }
    printf "%s", out
}
