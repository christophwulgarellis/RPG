# 005 – Subprocedure: String-to-Decimal Parser

## Objective

Build a reusable ILE subprocedure `Konvertierung` that converts an arbitrary character string into a packed decimal number — handling signs, invalid characters, multiple commas, and overflow — without crashing.

This task introduces the **ILE program model** with a main entry procedure and a separate subprocedure, which is the foundation of all modular RPG development.

---

## Program Structure

```
ctl-opt main(Aufg006) ...

Aufg006 (main proc)          ← Entry point, receives Char(30) parameter
  │  Calls Konvertierung(Wert)
  └─ Displays original and converted value

Konvertierung (subprocedure) ← Returns packed(30:9)
  │  Input: varchar(30) value parameter
  └─ Parses the string step by step
```

---

## Parsing Logic (step by step)

| Step | What happens |
|------|-------------|
| 1 | `%trim` the input — return `0` if empty |
| 2 | Check for a leading or trailing `-` sign — set `Minus = *on` |
| 3 | Filter: only keep digits `0-9` and comma `,` using `%scan` |
| 4 | Remove the minus sign from filtered result with `%scanrpl` |
| 5 | Find the comma position with `%scan` |
| 6 | Remove extra commas after the first one (only one decimal separator allowed) |
| 7 | Truncate integer part if it exceeds 21 digits (max for `packed(30:9)`) |
| 8 | Handle edge cases: empty string after filtering → `'0'` |
| 9 | Convert to packed with `%dec(Gefiltert : 30 : 9)` |
| 10 | Apply sign: `Final *= -1` if `Minus = *on` |

---

## Key Concepts

| Keyword / BIF | Purpose |
|---|---|
| `ctl-opt main(Aufg006)` | Designates `Aufg006` as the cycle-main procedure (program entry point) |
| `dftactgrp(*no)` | Required for ILE programs with named procedures |
| `dcl-proc` / `end-proc` | Defines a subprocedure |
| `dcl-pi *n` | Procedure interface — defines parameters and return type |
| `value` | Parameter passed by value (a copy), not by reference |
| `%scan(search : string)` | Returns position of first occurrence, or 0 if not found |
| `%scanrpl(from : to : string)` | Replaces all occurrences of a substring |
| `%subst(string : start : len)` | Extracts or replaces a substring |
| `%dec(string : digits : decimals)` | Converts a character string to packed decimal |

---

## Source File

[`filtering.rpgle`](./filtering.rpgle)
