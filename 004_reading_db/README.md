# 004 – Reading and Writing Database Files

## Objective

Read every record from a `Person` database file, format each person's data into a structured left/right text layout, and write the results to an output file (`PERSAW`). An auto-incrementing sequence number (`SEQNBR`) is calculated by reading the last existing record before the write loop begins.

---

## What the Program Does

### Step 1 – Determine the next SEQNBR

Before reading the input, the program positions to the **end** of the output file and reads one record backwards to find the highest existing `SEQNBR`:

```rpgle
o_Persaw.SEQNBR = 1;
SETGT *hival PERSAWR;      // Position pointer past the last record
READP PERSAWR i_Persaw;    // Read the last record backwards

IF not %eof;
  o_Persaw.SEQNBR = i_Persaw.SEQNBR + 1;  // Increment from last value
ENDIF;
```

### Step 2 – Read and format all persons

A `DOW not %eof` loop reads each `Person` record. For every person, 4 formatted rows are built and written to `PERSAW`:

| Row | Left column | Right column |
|-----|-------------|--------------|
| 1 | `Name: <Vorname>` | `Geburtsort: <Gebort>` |
| 2 | `Nachname: <NACHNAME>` (uppercase) | `Augenfarbe: <Augenfarbe>` |
| 3 | `Titel: <Titel>` | `Geburtsdatum: <Gebdatum>` |
| 4 | `Nation: <Nation>` | `Grösse: <Groesse>` |

Each row also stores the source record's RRN (from `INFDS`) and the creation timestamp.

---

## Key Concepts

| Keyword / BIF | Purpose |
|---|---|
| `dcl-f ... disk usage(*input)` | Declares a database file opened for reading |
| `dcl-f ... disk usage(*input:*output)` | Opens a file for both reading and writing |
| `rename(Person:PersonR)` | Renames the record format to avoid name collisions |
| `infds(Persinfo)` | Binds a data structure to the file's information feedback area |
| `pos(397)` | The RRN of the last read record is stored at byte offset 397 in the INFDS |
| `LIKEREC(PERSONR:*input)` | Declares a DS with the exact layout of the file's input record format |
| `SETGT *hival` | Positions the file cursor past the last record (beyond the highest key) |
| `READP` | Reads one record backwards from the current cursor position |
| `%eof` | Returns `*on` if the last read hit end-of-file (or beginning-of-file for READP) |
| `WRITE` | Writes a new record to the output file |
| `%upper(value)` | Converts a string to uppercase |
| `%char(value)` | Converts numeric/date values to character for concatenation |

---

## Source File

[`reading_db.rpgle`](./reading_db.rpgle)
