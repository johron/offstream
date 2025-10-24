#!/usr/bin/env python3
import json, sys, datetime
from jsonmerge import merge

base, current, other, output = sys.argv[1:]

with open(base) as f: base_data = json.load(f)
with open(current) as f: current_data = json.load(f)
with open(other) as f: other_data = json.load(f)

schema = {
    "properties": {
        "Songs": {
            "mergeStrategy": "arrayMergeById",
            "mergeOptions": {"idRef": "UUID"}
        },
        "LastUpdate": {"mergeStrategy": "overwrite"}
    }
}

merged = merge(base_data, current_data, schema)
merged = merge(merged, other_data, schema)

with open(output, "w") as f:
    json.dump(merged, f, indent=2)
