# 008 - Interactive INSERT Screen (New Person)

## Objective

Build an interactive 5250 display screen for **creating a new person record**. The program handles screen I/O, F-key commands, field-level input validation, error messages, and finally writes the validated record to the database via a service program.

This is the first task involving a **workstation file (DSPF)** and the standard IBM i interactive program pattern.

---

## Program Flow

```
Init()                          ← Set program name, user ID, message queue, indicator map

DoW not (F3 or F12)
  ExcScreen()                   ← Write message subfile + EXFMT main screen
  IF Cmdkey pressed
    ChkCmdKeys()                ← Handle F3 (exit), F12 (cancel), F5 (clear fields)
  ELSE
    PrcEnter()                  ← Validate input → write to DB
  ENDIF
EndDo
```

---

## Validation in PrcEnter

Each field is validated before the record is written. Required fields fail if blank or contain invalid characters:

| Field | Required | Validation |
|-------|----------|------------|
| Vorname | Yes | `IsAlpha()` |
| Nachname | Yes | `IsAlpha()` |
| Gebdatum | Yes | `IsValDate()` |
| Nation | Yes | `IsAlpha()` |
| Titel | No | `IsAlpha()` if filled |
| Gebort | No | `IsAlpha()` if filled |
| Groesse | No | `IsNum()` if filled |
| Augenfarbe | No | `IsAlpha()` if filled |

On validation failure:
- The corresponding **error indicator** is set (`DSPFInd.Vorname = *on`, etc.) — this highlights the field on screen
- A diagnostic message is sent to the message subfile via `SndDiagMsg('ERR000x')`

Only if **no indicators are set** does the program proceed to `ChkPerson` (business logic check) and then `WrtPerson` (database write).

---

## Indicator Data Structure

```rpgle
dcl-ds DSPFInd qualified;
  all       ind dim(99) pos(1); // Full array view for %lookup
  F3        ind pos(3);
  F12       ind pos(12);
  Vorname   ind pos(31);        // Highlights Vorname field on error
  Nachname  ind pos(32);
  ...
end-ds;
```

This maps each indicator number directly to a named field, making the code self-documenting.

---

## Key Concepts

| Keyword / Concept | Purpose |
|---|---|
| `dcl-f PERSON_AD workstn indDS(DSPFInd)` | Declares the display file, binds indicators to DS |
| `EXFMT F0RECORD` | Writes the screen and waits for user input (combined WRITE + READ) |
| `WRITE F0MSGCTL` | Updates the message subfile before showing the screen |
| `%lookup(*on : DSPFInd.all : 31 : 8)` | Checks if any error indicator (31-38) is set — avoids writing on errors |
| `Clear %subarr(DSPFInd.all : 30 : 20)` | Resets all field-level error indicators after each screen cycle |
| `SndDiagMsg('ERR0001')` | Sends a predefined message to the message subfile |
| `WrtPerson(o_Person00)` | Service program procedure — writes the validated record |
| `ChkPerson(o_Person00 : d_ChkPerson)` | Business logic duplicate check before writing |
| `/Copy QPTTSRC,PERSON` | Includes the PERSON service program copybook |

---

## Source File

[`display_db_editing.rpgle`](./display_db_editing.rpgle)
