# 002 – String Centering

## Objective

Center a text string within its maximum field width using pure string built-in functions, without any formatting opcodes.

This task builds a solid understanding of how RPG handles variable-length strings and how to calculate positional offsets mathematically.

---

## What the Program Does

Given a `varchar(50)` input string, the program:

1. Trims the string to remove any surrounding whitespace
2. Calculates the number of blank characters needed on each side:
   ```
   Numberblanks = %div( %len(OutputText : *Max) - %len(OutputText) : 2 )
   ```
   - `%len(OutputText : *Max)` → maximum field length (50)
   - `%len(OutputText)` → actual trimmed length
   - Difference ÷ 2 = padding per side
3. Builds the centered string:
   ```
   OutputText = %subst(X : 1 : Numberblanks) + %trim(OutputText) + %subst(X : 1 : Numberblanks)
   ```
4. Displays the result

**Example:**
- Input:  `'Das ist ein ganz langer langer Text'` (35 chars)
- Padding: `(50 - 35) / 2 = 7` blanks each side
- Output: `'       Das ist ein ganz langer langer Text       '`

---

## Key Concepts

| BIF / Keyword | Purpose |
|---|---|
| `%trim(value)` | Removes leading and trailing blanks |
| `%len(value)` | Returns current content length of a varchar |
| `%len(value : *Max)` | Returns the **maximum** declared length (not current) |
| `%div(a : b)` | Integer division (no remainder) |
| `%subst(string : start : len)` | Extracts a substring — here used to build a blank pad |

---

## Source File

[`strings.rpgle`](./strings.rpgle)
