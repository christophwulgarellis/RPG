# 006 - CSV File Parsing

## Objective

Read a semicolon-delimited CSV file (`CSVFILE`), parse each line into its individual fields, and write the structured records to a keyed physical file (`OBSTPF` — fruit/produce table).

This task demonstrates how to handle flat-file data imports — a very common requirement in IBM i batch processing.

---

## What the Program Does

1. Opens `CSVFILE` for sequential read and `OBSTPF` for write
2. Skips the header row (first `READ` is discarded)
3. Loops over all remaining lines with `DOW not %eof`
4. For each line, locates the three semicolons using `%scan` and extracts four fields with `%subst`
5. Writes the parsed values to `OBSTPF`

### CSV Format (assumed)

```
ARTNR;ARTIKELBEZ;KILOPREIS;QUALITAETSKLASSE
A001;Apfel;1.29;1
A002;Birne;2.50;2
...
```

### Parsing Logic

```rpgle
pos1 = %scan(Semico : Zeile);
part1 = %subst(Zeile : 1 : pos1 - 1);               // Before 1st semicolon

pos2 = %scan(Semico : Zeile : pos1 + 1);
part2 = %subst(Zeile : pos1 + 1 : pos2 - pos1 - 1); // Between 1st and 2nd

pos3 = %scan(Semico : Zeile : pos2 + 1);
part3 = %subst(Zeile : pos2 + 1 : pos3 - pos2 - 1); // Between 2nd and 3rd

part4 = %subst(Zeile : pos3 + 1);                   // After 3rd semicolon
```

Each `%scan` starts searching **after** the previous delimiter position to avoid finding the same semicolon twice.

---

## Output File: OBSTPF

| Field | Source | Type |
|-------|--------|------|
| `ARTNR` | `part1` | Article number |
| `ARTBEZ` | `part2` | Article description |
| `KPREIS` | `%dec(part3)` | Price per kg (packed decimal) |
| `QUALKLS` | `%dec(part4)` | Quality class (packed decimal) |

---

## Key Concepts

| Keyword / BIF | Purpose |
|---|---|
| `ctl-opt main(main)` | ILE program with named main procedure |
| `dcl-f ... keyed` | Declares a keyed (indexed) output file |
| `%scan(search : string : start)` | Finds delimiter position, with optional start offset |
| `%subst(string : start : len)` | Extracts a field between two delimiter positions |
| `%dec(string)` | Converts text representation of a number to packed decimal |
| `WRITE` | Appends a new record to the output file |
| First `READ` (skip header) | A simple technique for skipping the CSV header line |

---

## Source File

[`db_parsing.rpgle`](./db_parsing.rpgle)
