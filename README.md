# json-name-to-title
A script that scans any JSON structure (at any nesting level) and replaces all keys "name" whose values are strings with "title". If "name" is part of a list (e.g. ["one", "name", "three"]) or its value is not a string (e.g. "name": 6009), it will not be replaced.
