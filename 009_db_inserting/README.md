# 009 - Interactive UPDATE Screen (Edit Existing Person)

## Objective

Build an interactive 5250 display screen for **modifying an existing person record**. The program receives the person's RRN (Relative Record Number) as a parameter, pre-fills the screen with existing data, validates changes, and updates the record in the database.

This task extends task 008 (INSERT) with the additional concepts of parameter-driven initialisation and an UPDATE write-back.

---

## How It Differs from the INSERT Screen (008)

| Aspect | 008 - INSERT | 009 - UPDATE |
|--------|-------------|-------------|
| Parameter | None | `p_RRN packed(11)` |
| Init | Sets header fields only | Loads existing person via `RtvPersonByRRN` |
| Pre-filled fields | Empty | All fields populated from DB record |
| Write operation | `WrtPerson()` | `UptPerson(o_Person00 : p_RRN)` |
| Duplicate check | `ChkPerson(o_Person00 : d_ChkPerson)` | `ChkPerson(o_Person00 : d_ChkPerson : p_RRN)` (excludes self) |

---

## Program Flow

```
dcl-pi *n;
  p_RRN packed(11);             ← Receives RRN from calling program
end-pi;

if Init();                      ← Load person, return *off if not found → exit
  DoW not (F3 or F12)
    ExcScreen()
    IF Cmdkey → ChkCmdKeys()
    ELSE      → PrcEnter()
    ENDIF
  EndDo
endif;
```

### Init Procedure

```rpgle
if not RtvPersonByRRN(p_RRN : o_PERSON00);
    SndDiagMsg('ERR0017'); // Person not found
    return *off;
endif;

// Pre-fill all screen fields
F0VORNAME  = o_PERSON00.VORNAME;
F0NACHNAME = o_PERSON00.NACHNAME;
F0GEBDATUM = %char(o_PERSON00.GEBDATUM : *ISO0);
...
```

---

## Validation

Identical validation to task 008 — all required fields checked with `IsAlpha` / `IsValDate` / `IsNum`. The difference is that `ChkPerson` is called with the RRN so that the duplicate check **excludes the record being edited**.

---

## Key Concepts

| Keyword / Concept | Purpose |
|---|---|
| `dcl-pi *n; p_RRN packed(11); end-pi;` | Declares the program's external parameter interface |
| `RtvPersonByRRN(p_RRN : o_PERSON00)` | Service program proc — retrieves a person by RRN into a DS |
| `UptPerson(o_Person00 : p_RRN)` | Service program proc — updates the record at the given RRN |
| `ChkPerson(...: p_RRN)` | Duplicate check with RRN exclusion (don't flag the record as its own duplicate) |
| `%date(F0GEBDATUM : *iso0)` | Parses a date string in `YYYYMMDD` format (no separators) |
| `%uns(F0GROESSE)` | Converts character string to unsigned integer |

---

## Source File

[`db_editing.rpgle`](./db_editing.rpgle)
