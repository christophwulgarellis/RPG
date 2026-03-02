# 007 – Calendar Generator (1900–2099) with Austrian Public Holidays

## Objective

Generate a complete calendar database covering **every day from 1900-01-01 to 2099-12-31** and write each day as a record to the `CALENDAR` file, including:

- Day of week (number and name)
- ISO calendar week number
- Running day index per year
- Leap year flag
- Austrian public holiday name (if applicable)

This task combines date arithmetic, the Gaussian Easter algorithm, and modular ILE design via a binding directory.

---

## What the Program Does

The main loop increments one day at a time from start to end date:

```rpgle
dow Datum_i <= Datum_e;
    Jahr = %subdt(Datum_i : *years);

    // When year changes: recalculate all holidays
    if Jahr <> JahrAlt;
        arrFeiertage = AlleFeiertage(Jahr : OsterSonntag);
    endif;

    // Check leap year
    // Check if today is a holiday
    // Write record to CALENDAR

    Datum_i += %days(1);
    LaufIndex += 1;
enddo;
```

---

## Austrian Public Holidays

### Fixed Holidays (8)

| Date | Name |
|------|------|
| Jan 1 | Neujahr |
| Jan 6 | Heilige Drei Könige |
| May 1 | Staatsfeiertag |
| Aug 15 | Maria Himmelfahrt |
| Nov 1 | Allerheiligen |
| Dec 8 | Maria Empfängnis |
| Dec 25 | Christtag |
| Dec 26 | Stefanitag |

### Moveable Holidays (Easter-based, 4)

| Offset from Easter Sunday | Name |
|---------------------------|------|
| +1 day | Ostermontag |
| +39 days | Christi Himmelfahrt |
| +50 days | Pfingstmontag |
| +60 days | Fronleichnam |

Easter Sunday is calculated by the external `OsterSonntag` procedure from the binding directory.

---

## Leap Year Algorithm

```rpgle
if %rem(Jahr:400) = 0;       IsSchaltjahr = *on;
elseif %rem(Jahr:100) = 0;   IsSchaltjahr = *off;
elseif %rem(Jahr:4) = 0;     IsSchaltjahr = *on;
else;                        IsSchaltjahr = *off;
endif;
```

The three-rule Gregorian leap year check: divisible by 4 = leap year, except centuries, except 400-year centuries.

---

## Key Concepts

| Keyword / BIF | Purpose |
|---|---|
| `%days(n)` | Adds n days to a date — used for daily increment and holiday offsets |
| `%subdt(date : *years)` | Extracts the year component from a date |
| `%rem(a : b)` | Remainder after integer division — used in leap year check |
| `%char(Jahr) + '-01-01'` | Builds an ISO date string dynamically for each year |
| `%date(string : *iso)` | Parses a character string into a date value |
| `dcl-ds arrFeiertage qualified` | Parallel arrays: `Datum(20)` and `Name(20)` for up to 20 holidays |
| External service procs | `WochentagZiffer`, `WochentagName`, `Kalenderwoche`, `OsterSonntag` from `BNDDIR('AUFGABEN')` |

---

## Source File

[`leayear_calc.rpgle`](./leayear_calc.rpgle)
