# 013 - Data Queue: Inter-Job Messaging (SND + RCV)

## Objective

Implement a **Data Queue (DTAQ)** based messaging solution that sends all person records from a database file into a queue, and receives them from the queue in a separate program.

Data Queues are a core IBM i mechanism for lightweight, high-performance communication between jobs running simultaneously on the same system.

---

## What is a Data Queue?

A Data Queue is a system object on IBM i that acts as a **message buffer** between jobs:

```
SND job                    DTAQ object               RCV job
─────────────────────────────────────────────────────────────
READ Person file  →  SndToDtaq(name, data, lib)  →  RcvDtaq(name, ...)
(one record                                           (one record
per SndToDtaq)                                        per RcvDtaq)
```

- A sender puts records in; a receiver takes them out (FIFO)
- `waittime = 0` → non-blocking (return immediately if empty)
- `waittime = -1` → blocking (sleep until a message arrives - shows as `DEQW` in WRKACTJOB)

---

## SND Program (`snd.rpgle`)

1. Reads queue name and library from a **Data Area** (`KURS30/DQNAMLIB`)
2. Clears the queue first (`ClrDtaq`) to start fresh
3. Reads every record from the `Person` file in a `DOW not %eof` loop
4. Sends each record raw (`%subst(i_Person : 1 : %size(i_Person))`)

```rpgle
in DAValue; // Read data area
DtaqCfg.DtaqName = %subst(DAValue:1:10);
DtaqCfg.DtaqLib  = %subst(DAValue:11:10);

ClrDtaq(DtaqCfg.DtaqName : DtaqCfg.DtaqLib); // Empty the queue

Dow not %eof(Person);
  SndToDtaq(DtaqCfg.DtaqName : %subst(i_Person:1:%size(i_Person)) : DtaqCfg.DtaqLib);
  READ PERSON i_Person;
EndDo;
```

---

## RCV Program (`rcv.rpgle`)

1. Reads the same Data Area to know which queue to listen to
2. Loops calling `RcvDtaq` until it returns `dataLen = 0` (queue empty)
3. Displays the received data length for each entry

```rpgle
Dow *on;
  Monitor;
    dataLen = RcvDtaq(DtaqCfg.DtaqName : 0 : r_Person : DtaqCfg.DtaqLib);
    //                                   ↑ waittime=0 = non-blocking

    If dataLen = 0;
      leave; // Queue empty → stop
    EndIf;

    Snd-Msg('Empfangene Länge: ' + %char(dataLen));
  On-Error;
    dsply('Receiving Failed!');
    leave;
  EndMon;
EndDo;
```

---

## Key Concepts

| Keyword / Concept | Purpose |
|---|---|
| `DTAARA('KURS30/DQNAMLIB')` | Binds a variable to a data area - `in` opcode reads it |
| `in DAValue` | Reads the data area value into the variable |
| `ClrDtaq(name : lib)` | Empties all entries from the queue before sending |
| `SndToDtaq(name : data : lib)` | Sends a raw data buffer to the queue |
| `RcvDtaq(name : waittime : receiver : lib)` | Receives the next entry; returns data length (0 = empty) |
| `%size(i_Person)` | Returns the byte size of the DS - used to send the full record |
| `%subst(i_Person : 1 : %size(...))` | Treats the DS as a raw byte string |
| `Monitor / On-Error / EndMon` | Structured exception handling - equivalent to try/catch |
| `Snd-Msg` | Sends a message to the job message queue |

---

## Configuration via Data Area

Both programs read the queue name and library from a shared data area (`KURS30/DQNAMLIB`), making the queue configurable without recompiling:

```
Bytes 1-10:  Queue name   (e.g. 'DTAQ1     ')
Bytes 11-20: Library name (e.g. 'KURS18    ')
```

---

## Source Files

- [`snd.rpgle`](./snd.rpgle) - Sender: reads Person file → puts records into DTAQ
- [`rcv.rpgle`](./rcv.rpgle) - Receiver: reads records from DTAQ → displays length
