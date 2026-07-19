
---

# Bandit (OverTheWire) — Levels 0–10

---

This document contains concise notes and solutions for **Bandit Levels 0–10** from OverTheWire, focusing on the Linux commands and concepts required to solve each challenge.

---

## Level 0

### Objective

Connect to the Bandit server using SSH.

### Solution

```bash
ssh bandit0@bandit.labs.overthewire.org -p 2220
```

Password:

```text
bandit0
```

---

## Level 1

### Objective

Retrieve the password stored in a file named `-`.

### Solution

```bash
cat ./-
```

### Explanation

The filename is literally `-`. Prefixing it with `./` prevents it from being interpreted as standard input.

---

## Level 2

### Objective

Read a file named:

```text
--spaces in this filename--
```

### Solution

```bash
cat -- --spaces\ in\ this\ filename--
```

or

```bash
cat "./--spaces in this filename--"
```

### Explanation

Files beginning with `--` are normally interpreted as command options.

Using `--` tells the command to stop parsing options and treat everything afterwards as a filename.

---

## Level 3

### Objective

Locate a hidden file inside the `inhere` directory.

### Solution

```bash
cd inhere

ls -la

cat .hidden
```

### Explanation

`ls -la` displays hidden files beginning with a period.

---

## Level 4

### Objective

Find the only human-readable file.

### Solution

```bash
cd inhere

file ./*

cat ./-file07
```

### Explanation

The `file` command identifies file types. Only one file is plain ASCII text.

---

## Level 5

### Objective

Locate a file that is:

- human-readable
- exactly 1033 bytes
- not executable

### Solution

```bash
find inhere -type f -size 1033c ! -executable -print0 \
| xargs -0 file \
| awk -F: '/text/{print $1; exit}' \
| xargs -I{} cat "{}"
```

### Explanation

This command searches for files matching the required properties before displaying the contents of the first text file found.

---

## Level 6

### Objective

Locate a file that is:

- owned by bandit7
- group bandit6
- 33 bytes

### Solution

```bash
find / -type f -user bandit7 -group bandit6 -size 33c \
-print0 -quit 2>/dev/null \
| xargs -0 cat
```

### Explanation

- `-print0` safely handles unusual filenames.
- `-quit` stops after the first match.
- `2>/dev/null` hides permission errors.
- `xargs -0` safely passes the filename to `cat`.

---

## Level 7

### Objective

Locate the password stored beside the word `millionth`.

### Solution

```bash
grep "millionth" data.txt
```

or

```bash
grep "millionth" data.txt | awk '{print $2}'
```

### Explanation

`grep` finds the matching line, while `awk` extracts only the password.

---

## Level 8

### Objective

Find the only line appearing exactly once.

### Solution

```bash
sort data.txt | uniq -u
```

### Explanation

`uniq` only compares adjacent lines, so the input must first be sorted.

---

## Level 9

### Objective

Locate the password hidden inside a binary file.

### Solution

```bash
strings data.txt | grep "==="
```

### Explanation

`strings` extracts printable text before filtering with `grep`.

---

## Level 10

### Objective

Decode the Base64 encoded password.

### Solution

```bash
base64 -d data.txt
```

Alternative:

```bash
base64 --decode data.txt
```

If necessary:

```bash
base64 -d data.txt | strings
```

### Explanation

The password is stored using Base64 encoding and simply needs to be decoded.

---

# Skills Practiced

- SSH
- Linux filesystem navigation
- Hidden files
- File permissions
- `find`
- `grep`
- `awk`
- `sort`
- `uniq`
- `strings`
- Base64 decoding
- Command pipelines
- Shell escaping

---

# Tools Used

- SSH
- GNU Coreutils
- find
- grep
- awk
- xargs
- strings
- base64

---