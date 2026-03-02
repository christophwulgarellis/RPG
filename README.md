# IBM i RPG Academy – Portfolio

> A hands-on learning portfolio documenting my journey through IBM i development as part of a structured RPG Academy programme.

---

## About Me

I am an aspiring IBM i developer currently completing a structured training programme focused on RPG and IBM i application development. This repository serves as a portfolio to document the practical tasks I completed during the academy - each one building on the last, covering core concepts from basic data types all the way up to interactive 5250 screen applications, CSV parsing, calendar generation, and inter-job messaging via Data Queues.

I am actively looking for opportunities in IBM i / AS400 environments and use this portfolio to demonstrate what I have learned and how I approach problems.

---

## What is IBM i & RPG?

**IBM i** (formerly known as AS/400 or iSeries) is an integrated business computing platform developed by IBM. It is widely used in industries such as banking, insurance, logistics, and manufacturing due to its exceptional reliability, security, and performance.

**RPG** (Report Program Generator) is the primary programming language of the IBM i platform. Modern RPG - often referred to as **RPGLE** or **Free-Format RPG** - is a fully featured, high-level language used to build business logic, process data, interact with DB2 for i databases, and integrate with external systems.

Key components of the IBM i ecosystem covered in this academy:

| Technology | Description |
|---|---|
| **RPGLE** | Free-format RPG - core business logic and file processing |
| **CL** | Control Language - job control, command execution, and automation |
| **DDS / DSPF** | Data Description Specifications - defining database files and 5250 display screens |
| **DB2 for i** | Integrated relational database - native record-level I/O |
| **ILE** | Integrated Language Environment - modular program design with service programs |
| **Data Queue (DTAQ)** | Lightweight inter-job messaging mechanism on IBM i |

---

## Skills Acquired

Through completing the academy tasks, I have gained practical experience in the following areas:

**RPG Programming**
- Free-format RPGLE syntax and program structure
- All native IBM i data types: `char`, `varchar`, `packed`, `int`, `zoned`, `unsigned`, `indicator`, `date`, `time`, `timestamp`
- Data structures (`dcl-ds`), templates, `LIKEDS`, `LIKEREC`, qualified and nested structures
- Arrays: declaration with `dim()`, processing with `%elem`, compacting and sorting
- Built-in functions: `%trim`, `%len`, `%subst`, `%scan`, `%scanrpl`, `%upper`, `%char`, `%dec`, `%date`, `%days`, `%subdt`
- ILE concepts: `ctl-opt main()`, `dcl-proc`, `dcl-pi`, value parameters, binding directories

**File & Database Handling**
- Physical file I/O: `READ`, `READP`, `WRITE`, `UPDATE`, `DELETE`
- File declarations: `dcl-f disk`, `usage(*input)`, `usage(*output)`, `usage(*update:*delete)`
- `INFDS` (Information Data Structure) for retrieving relative record numbers (RRN)
- `SETGT *HIVAL` + `READP` pattern for reading the last record
- Keyed file access, `DOW not %eof` read loops

**Interactive 5250 Screens (Display Files)**
- Workstation file handling: `dcl-f workstn`, `EXFMT`, `WRITE`/`READ`
- Indicator data structures (`indDS`) for F-key and field-level error control
- Subfile programming: `SFILE`, `SFLCLR`, `SFLDSP`, `SFLEND`, `SFLCSRRRN`, pagination
- Message handling: message subfile, `SndDiagMsg`, `ClrMsgQ`, `SetMsgQ`
- Input validation: `IsAlpha`, `IsNum`, `IsValDate` via service programs

**Program Design & Advanced Concepts**
- Modular design: service programs, binding directories (`BNDDIR`), `/Copy` copybooks
- Structured program flow: `Init → DoW → ExcScreen → ChkCmdKeys / PrcEnter`
- CSV file parsing with `%scan` / `%subst`
- Date arithmetic and calendar logic (Easter algorithm, Austrian public holidays)
- Data Queue inter-job messaging: `SndToDtaq`, `RcvDtaq`, `DTAARA`, `Monitor / On-Error`

---

## Academy Tasks

Each task is documented in its own folder with a `README.md` explaining the objective, approach, and key concepts demonstrated.

| # | Folder | Task | Topics Covered |
|---|--------|------|----------------|
| 00 | [000_hello_world](./000_hello_world/) | Data Types & Variable Declaration | All RPG data types, value assignment, `DSPLY`, `%CHAR` |
| 01 | [001_arrays](./001_arrays/) | Array Manipulation & Compacting | Arrays, `FOR`/`%elem`, `%trim`, `%upper`, compacting sparse arrays |
| 02 | [002_strings](./002_strings/) | String Centering | `%trim`, `%len`, `%div`, `%subst`, text padding |
| 03 | [003_templates](./003_templates/) | Nested Data Structures (Receipt) | Template DS, `LIKEDS`, qualified DS, nested arrays |
| 04 | [004_reading_db](./004_reading_db/) | Database Read & Write | File I/O, `INFDS`, `SETGT`/`READP`, `DOW`/`%eof`, `WRITE` |
| 05 | [005_filtering](./005_filtering/) | Subprocedure: String-to-Decimal Parser | ILE `main()`, subprocedures, `%scan`, `%scanrpl`, `%dec` |
| 06 | [006_db_parsing](./006_db_parsing/) | CSV File Parsing | Semicolon delimiter parsing, keyed file output |
| 07 | [007_leapyear_calc](./007_leapyear_calc/) | Calendar Generator (1900–2099) | Date arithmetic, Easter algorithm, Austrian holidays, leap year |
| 08 | [008_display_db_editing](./008_display_db_editing/) | Interactive INSERT Screen | `workstn`, `EXFMT`, indicator DS, validation, message subfile |
| 09 | [009_db_inserting](./009_db_inserting/) | Interactive UPDATE Screen | `RtvPersonByRRN`, `UptPerson`, `ChkPerson`, RRN parameter |
| 10 | [010_db_editing](./010_db_editing/) | Main List with Subfile (CRUD Hub) | Subfile, pagination, dual view, F-key navigation, filtering |
| 11 | [011_db_deleting](./011_db_deleting/) | Interactive DELETE Screen | Delete confirmation, `DelPerson`, `WRITE`/`READ` pattern |
| 12 | [012_db_show](./012_db_show/) | Read-Only VIEW Screen | Detail display, `RtvPersonByRRN`, read-only F-key handling |
| 13 | [013_data_queue](./013_data_queue/) | Data Queue – Inter-Job Messaging | `DTAQ`, `DTAARA`, `SndToDtaq`, `RcvDtaq`, `Monitor`/`On-Error` |

---

## Repository Structure

```
RPG/
├── README.md                    ← You are here
├── 000_hello_world/
│   ├── README.md
│   └── hello_world.rpgle
├── 001_arrays/
│   ├── README.md
│   └── arrays.rpgle
├── 002_strings/
│   ├── README.md
│   └── strings.rpgle
├── 003_templates/
│   ├── README.md
│   └── templates.rpgle
├── 004_reading_db/
│   ├── README.md
│   └── reading_db.rpgle
├── 005_filtering/
│   ├── README.md
│   └── filtering.rpgle
├── 006_db_parsing/
│   ├── README.md
│   └── db_parsing.rpgle
├── 007_leapyear_calc/
│   ├── README.md
│   └── leayear_calc.rpgle
├── 008_display_db_editing/
│   ├── README.md
│   └── display_db_editing.rpgle
├── 009_db_inserting/
│   ├── README.md
│   └── db_editing.rpgle
├── 010_db_editing/
│   ├── README.md
│   └── db_editing.rpgle
├── 011_db_deleting/
│   ├── README.md
│   └── db_editing.rpgle
├── 012_db_show/
│   ├── README.md
│   └── db_show.rpgle
└── 013_data_queue/
    ├── README.md
    ├── snd.rpgle
    └── rcv.rpgle
```

---

## Connect

Feel free to reach out if you have questions about any of the tasks or want to discuss IBM i development.

- **GitHub:** [christophwulgarellis](https://github.com/christophwulgarellis)
- **LinkedIn:** [Christop Wulgarellis](https://linkedin.com/in/christoph-wulgarellis-388a07312)
