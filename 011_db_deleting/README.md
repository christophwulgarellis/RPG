# 011 – Interactive DELETE Screen (Delete Confirmation)

## Objective

Build an interactive 5250 confirmation screen for **deleting a person record**. The program receives the person's RRN, displays all their details in read-only mode, and deletes the record when the user presses Enter.

This task demonstrates the confirmation pattern common in IBM i maintenance applications and shows the `WRITE`/`READ` pattern as an alternative to `EXFMT`.

---

## Program Flow

```
dcl-pi *n;
  p_RRN packed(11);         ← Receives RRN from the list program (010)
end-pi;

if Init();                  ← Load person data, exit if not found

  DoW not (F3 or F12)
    ExcScreen()             ← Display person details (read-only)
    IF Cmdkey → ChkCmdKeys()  (F3/F12 = cancel, F5 = no-op)
    ELSE      → PrcEnter()    (Enter = confirm delete)
    ENDIF

  EndDo
endif;
```

### ExcScreen — WRITE/READ Instead of EXFMT

```rpgle
WRITE F0MSGCTL;      // Write message subfile
WRITE F0RECORD;      // Write (render) the screen
READ  F0RECORD;      // Wait for user input

// Re-populate fields from in-memory DS after each READ
F0VORNAME  = o_PERSON00.VORNAME;
...
```

Because the fields are read-only (output-only in DDS), they must be re-assigned after every `READ` to keep them visible — `EXFMT` would handle this automatically for input fields, but here a manual re-fill is required.

### PrcEnter — Delete on Confirmation

```rpgle
dcl-proc PrcEnter;
  DelPerson(o_Person00 : p_RRN);   // Call service program → delete record
  DSPFInd.F12 = *on;               // Exit the DoW loop
end-proc;
```

There is intentionally **no further validation** — the user has already seen the record. Pressing Enter is the confirmation.

---

## Key Concepts

| Keyword / Concept | Purpose |
|---|---|
| `WRITE F0RECORD` + `READ F0RECORD` | Displays screen, then waits — used for read-only screens |
| `EXFMT` vs `WRITE/READ` | `EXFMT` = combined write+read for input screens; `WRITE/READ` = fine-grained control for display-only screens |
| `DelPerson(o_Person00 : p_RRN)` | Service program procedure — deletes the record by RRN |
| `DSPFInd.F12 = *on` | Programmatically triggers the exit condition of the `DoW` loop |
| `RtvPersonByRRN(p_RRN : o_PERSON00)` | Loads the existing person data into the output DS |

---

## Source File

[`db_editing.rpgle`](./db_editing.rpgle)
