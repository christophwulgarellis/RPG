# 001 - Array Manipulation & Compacting

## Objective

Process an array of 10 name strings by:
1. Trimming leading and trailing whitespace
2. Capitalizing the first letter of each non-empty entry
3. Removing blank entries and compacting valid values to the front of the array

This task simulates a real-world data cleaning scenario where input data contains inconsistent spacing and empty slots.

---

## What the Program Does

Five test arrays (`Base`, `Namen1`-`Namen5`) are prepared with names that have varying amounts of leading/trailing spaces and some fully blank entries. The active test case is selected by assigning the desired array to `Base`.

The algorithm then processes `Base` in a single `FOR` loop:

```
FOR X = 1 to %elem(Base)
  Base(X) = %trim(Base(X))            // Strip whitespace
  IF %len(%trim(Base(X))) > 0         // Skip blank entries
    Base(X) = %upper(Base(X) : 1 : 1) // Capitalize first letter
    IF X <> Z
      Base(Z) = Base(X)               // Move value to next valid slot
      Base(X) = ' '                   // Clear old position
    ENDIF
    Z += 1                            // Advance valid-entry counter
  ENDIF
ENDFOR
```

**Result:** All valid names are packed to the beginning of the array in order, blanks are moved to the end.

---

## Key Concepts

| BIF / Keyword | Purpose |
|---|---|
| `dim(10)` | Declares an array of 10 elements |
| `%elem(Base)` | Returns the number of elements (10) — avoids hardcoding |
| `%trim(value)` | Removes leading and trailing blanks |
| `%len(value)` | Returns the current length of a varchar string |
| `%upper(var : start : len)` | Uppercases a substring in-place |
| `FOR / ENDFOR` | Index-based loop over array elements |

**Logger service program**
The program uses a custom `log()` procedure from a binding directory (`KURS18DIR`), demonstrating the use of external service programs via `/Copy` and `BNDDIR`.

---

## Source File

[`arrays.rpgle`](./arrays.rpgle)
