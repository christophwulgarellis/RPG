# 000 – Data Types & Variable Declaration

## Objective

Get familiar with all fundamental IBM i RPG data types by declaring variables, assigning values, and displaying the results using `DSPLY`.

This is the "Hello World" of IBM i development — not just printing a string, but understanding the complete type system that underpins every RPG program.

---

## What the Program Does

1. Declares one variable for each of the core RPG data types
2. Assigns a representative value to each variable
3. Converts each value to a character string using `%CHAR` where necessary
4. Displays all values via `DSPLY` in the job log

---

## Data Types Covered

| Variable | Type | Declaration | Description |
|---|---|---|---|
| `Name` | Fixed-length character | `char(30)` | Padded to fixed length with blanks |
| `Beispielname` | Variable-length character | `varchar(30)` | Stores only actual characters used |
| `Beispielbetrag` | Packed decimal | `packed(4:2)` | 4 total digits, 2 decimal places |
| `Integerbeispiel` | Integer | `int(5)` | Signed integer, no decimal |
| `Randomflag` | Indicator | `ind` | Boolean: `*on` / `*off` |
| `Beispielsdatum` | Date | `date` | ISO format: `d'YYYY-MM-DD'` |
| `Beispielszeit` | Time | `time` | ISO format: `t'HH.MM.SS'` |
| `Timestampbeispiel` | Timestamp | `timestamp` | Combined date+time: `z'...'` |
| `Zone` | Zoned decimal | `zoned(2)` | Legacy format, compatible with DDS |
| `Unsigned` | Unsigned integer | `uns(5)` | Non-negative integer |

---

## Key Concepts

**`%CHAR(variable)`**
Converts any numeric or date/time type to a character string for display or concatenation. Required because `DSPLY` only accepts character values.

**Date/Time literals**
- Date:      `d'2025-09-18'`
- Time:      `t'14.11.00'`
- Timestamp: `z'2025-09-18-14.11.00'`

**`*INLR = *on`**
Sets the Last Record indicator to end the program cleanly. Required in every RPG program.

---

## Source File

[`hello_world.rpgle`](./hello_world.rpgle)
