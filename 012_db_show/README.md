# 012 – Read-Only VIEW Screen (Person Detail)

## Objective

Build a **read-only detail screen** that displays all fields of a person record. Called from the list program (option `5`), it shows the data but does not allow any modifications.

This is the simplest interactive program in the series — it demonstrates when and how to implement a pure display screen.

---

## Program Flow

```
dcl-pi *n;
  p_RRN packed(11);         ← Receives RRN from the list program (010)
end-pi;

if Init();                  ← Load person data, return *off if not found

  DoW not (F3 or F12)
    ExcScreen()             ← Display all person fields (read-only)
    IF Cmdkey → ChkCmdKeys()
    ELSE      → PrcEnter()   ← Intentionally empty
    ENDIF

  EndDo
endif;
```

### PrcEnter – Intentionally Empty

```rpgle
dcl-proc PrcEnter;
  // no-op
end-proc;
```

There is nothing to do on Enter — the screen is purely for viewing. Pressing Enter simply redraws the same screen.

---

## All Fields Displayed

| Screen Field | Data Source |
|---|---|
| `F0PERSNBR` | `%char(o_PERSON00.ID)` |
| `F0VORNAME` | `o_PERSON00.VORNAME` |
| `F0NACHNAME` | `o_PERSON00.NACHNAME` |
| `F0TITEL` | `o_PERSON00.TITEL` |
| `F0GEBDATUM` | `%char(o_PERSON00.GEBDATUM : *ISO0)` |
| `F0GEBORT` | `o_PERSON00.GEBORT` |
| `F0NATION` | `o_PERSON00.NATION` |
| `F0GROESSE` | `%char(o_PERSON00.GROESSE)` |
| `F0AUGFARBE` | `o_PERSON00.AUGENFARBE` |

---

## Comparison: VIEW vs. DELETE vs. UPDATE

| Feature | 012 VIEW | 011 DELETE | 009 UPDATE |
|---------|----------|-----------|-----------|
| Fields editable | No | No | Yes |
| On Enter | Redisplay | Delete record | Validate & update |
| `PrcEnter` body | Empty | `DelPerson(...)` | Full validation logic |
| EXFMT vs WRITE/READ | WRITE/READ | WRITE/READ | EXFMT |

---

## Key Concepts

| Keyword / Concept | Purpose |
|---|---|
| `dcl-f PERSONVIEW workstn indDS(DSPFInd)` | Read-only display file declaration |
| `WRITE F0RECORD` + `READ F0RECORD` | Manual write+read for display-only screens |
| `RtvPersonByRRN(p_RRN : o_PERSON00)` | Retrieves the person record from the DB |
| `%char(date : *ISO0)` | Formats date as `YYYYMMDD` (no separators) |
| Empty `PrcEnter` | Design decision: signals this is a view-only screen with no Enter action |

---

## Source File

[`db_show.rpgle`](./db_show.rpgle)
