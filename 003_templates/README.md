# 003 – Nested Data Structures (Receipt / Kassenbon)

## Objective

Model a complete supermarket receipt using **template data structures** and **nested `LIKEDS`** — a design pattern widely used in production IBM i applications for structuring complex business data.

---

## What the Program Does

The program defines five separate template data structures (one per receipt section) and then combines them into a single `Rechnung` (receipt) structure. Values are assigned by navigating the qualified dot notation.

### Receipt Structure

```
Rechnung
├── Header          (Firmenname, PLZ, Anschrift, Telefon)
├── Datum           (Jahr, Monat, Tag, JJJJMMTT as overlay)
├── Positionen(3)   (Produktname, Possumme1)  ← array of 3 items
├── Summen_Steuern  (Possumme1-3, Steuern, Waehrung)
└── Zahlungsdaten   (Zahlungsart, Zahlungsbetrag)
```

**Sample data filled in:**
- `Rechnung.Header.Firmenname = 'Billa Plus'`
- `Rechnung.Positionen(1).Produktname = 'Apfel'`
- `Rechnung.Datum.JJJJMMTT = %dec(%date())` — today's date as 8-digit number

---

## Key Concepts

| Keyword | Purpose |
|---|---|
| `dcl-ds ... template` | Declares a reusable structure definition — **not** allocated in memory, only used as a type reference |
| `LIKEDS(t_Header)` | Declares a substructure that mirrors the layout of a template DS |
| `qualified` | Requires dot-notation access (`Rechnung.Header.Firmenname`) — prevents name collisions |
| `inz` / `inz(*likeds)` | Initialises all fields to their default values |
| `dim(3)` | Declares the `Positionen` substructure as an array of 3 receipts |
| `pos(1)` | Overlays a field at a specific byte offset — used for the combined `JJJJMMTT` date field |
| `%dec(%date())` | Converts today's date to a packed decimal number |

### Why Templates?

Without templates, every program that works with a receipt would need to redeclare the same fields independently. Templates allow the structure to be defined once (e.g. in a `/Copy` member) and reused consistently across all programs — the same principle as structs or classes in other languages.

---

## Source File

[`templates.rpgle`](./templates.rpgle)
