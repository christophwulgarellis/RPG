# 010 - Main List with Subfile (CRUD Hub)

## Objective

Build the **central list/browse screen** for the person database - a paginated subfile with dual view modes, search functionality, and direct access to all CRUD operations (Create, Read, Update, Delete).

This is the most complex program in the series, tying together subfile control, pagination logic, view toggling, and calls to all other programs (008-012).

---

## Program Overview

The list screen displays up to 13 persons per page. The user can navigate, filter, and act on individual records:

| Key / Option | Action |
|---|---|
| `F6` | Open INSERT screen (task 008) |
| Option `2` | Open UPDATE screen (task 009) for the selected person |
| Option `4` | Open DELETE screen (task 011) for the selected person |
| Option `5` | Open VIEW screen (task 012) for the selected person |
| `F11` | Toggle between View 1 and View 2 |
| `PageDown` / `PageUp` | Navigate pages |
| `F17` | Jump to first record |
| `F18` | Jump to last record |
| `F5` | Refresh (reload current page) |
| Search by ID | Type a person ID in the "Listenanfang bei" field |
| Filter by name | Type a name substring in the filter field |

---

## View Modes (F11 Toggle)

| Field | View 1 (default) | View 2 |
|-------|-----------------|--------|
| Col 1 | ID | ID |
| Col 2 | Vorname + Nachname | Titel |
| Col 3 | Geburtsdatum | Geburtsort |
| Col 4 | Nation | Grösse |
| Col 5 | | Augenfarbe |

---

## Subfile Architecture

```rpgle
dcl-f PERSONWK workstn indDS(DSPFInd) SFILE(F0SUBFIL : S_SF);
//                           ↑ subfile record          ↑ RRN field

DSPFInd.SFLCLR  ← Clears the subfile buffer
DSPFInd.SFLDSP  ← Controls display of subfile
DSPFInd.Ende    ← Shows "Ende" / "Weitere..." in footer
```

### GetData Procedure

All page loads go through `GetData(startKey, posMode)`:

| PosMode | Meaning |
|---------|---------|
| `POS_FIRST` | Load from the very beginning |
| `POS_NEXT` | Load the next page (after last shown key) |
| `POS_PREV` | Load the previous page (before first shown key) |
| `POS_LAST` | Load the last page |
| `POS_AT` | Reload the current page (refresh, cursor restore) |

The first/last key of the visible page is saved in `g_PageFirstKey` / `g_PageLastKey` to enable correct forward and backward navigation.

---

## Key Concepts

| Keyword / Concept | Purpose |
|---|---|
| `SFILE(F0SUBFIL : S_SF)` | Declares a subfile - `S_SF` is the RRN counter field |
| `DSPFInd.SFLCLR = *on` | Clears all subfile records before reloading |
| `F0FRRCDNBR` | Each subfile row stores the DB record's RRN for use in option processing |
| `ReadC F0SUBFIL` | Reads the subfile row where the cursor is positioned |
| `g_RowDbRrn dim(200)` | Maps subfile row index → DB RRN (up to 200 rows) |
| `ListPersons(req : list)` | Service program proc - fills a `z_PersonList` DS with a page of persons |
| `eval-corr g_PageFirstKey = ...` | Copies matching field names from source to target DS |
| `PrcParseRRN` | Validates that the "position to" input is a valid integer |
| `%list(POS_FIRST : POS_NEXT : POS_AT)` | Used in `select/when` for grouping position modes |

---

## Source File

[`db_editing.rpgle`](./db_editing.rpgle)
