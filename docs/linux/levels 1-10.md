# OverTheWire Bandit Notes From Levels 1 Through 10

These are my personal notes and solutions while practicing Linux fundamentals through the **OverTheWire Bandit** wargame.

---

# Level 1

### Challenge
The password for the next level is stored in a file called `-` located in the home directory.

### Explanation
A filename containing only `-` can cause confusion because many Linux commands interpret `-` as **STDIN/STDOUT** (`/dev/stdin`, `/dev/stdout`).

To reference the file correctly, its path needs to be specified explicitly.

### Solution

```bash
cat ./-
```

`./` tells the shell that `-` is a file in the current directory rather than a command option.

---

# Level 2

### Challenge
The password for the next level is stored in a file called:

```
--spaces in this filename--
```

### Problem
The filename begins with `--`, which most commands interpret as an **option flag** rather than a filename.

Example error:

```bash
cat --spaces in this filename--
```

Output:

```
cat: unrecognized option '--spaces in this filename--'
```

### Solutions

#### Option 1 — Stop option parsing

```bash
cat -- --spaces\ in\ this\ filename--
```

Explanation:

- `--` tells the command to stop parsing options.
- `\` escapes the spaces.

#### Option 2 — Quote the filename

```bash
cat "./--spaces in this filename--"
```

---

# Level 3

### Challenge
The password for the next level is stored in a **hidden file** in the `inhere` directory.

### Solution

```bash
cd inhere
ls -la
```

Explanation:

- `ls -la` lists **all files**, including hidden ones (files beginning with `.`).

---

# Level 4

### Challenge
The password for the next level is stored in the **only human-readable file** in the `inhere` directory.

### Approach

1. Enter the directory:

```bash
cd inhere
```

2. Check file types:

```bash
file ./*
```

Example output:

```
./-file00: data
./-file01: data
./-file02: data
./-file03: data
./-file04: data
./-file05: data
./-file06: data
./-file07: ASCII text
./-file08: data
./-file09: data
```

Only `-file07` contains readable text.

### Solution

```bash
cat ./-file07
```

---

# Level 5

### Challenge
The password is stored in a file under the `inhere` directory with these properties:

- human-readable
- exactly **1033 bytes**
- **not executable**

### Solution

```bash
find inhere -type f -size 1033c ! -executable -print0 | \
xargs -0 file | \
awk -F: '/text/{print $1; exit}' | \
xargs -I{} cat "{}"
```

### Explanation

**find**

```
find inhere -type f -size 1033c ! -executable
```

Searches for:

- regular files
- size exactly **1033 bytes**
- **not executable**

**xargs -0 file**

Checks the type of each file.

**awk**

```
awk -F: '/text/{print $1; exit}'
```

Finds the first file that contains **human-readable text**.

**cat**

Prints the password.

---

# Level 6

### Challenge
The password is stored **somewhere on the server** with these properties:

- owned by user **bandit7**
- owned by group **bandit6**
- **33 bytes** in size

### Solution

```bash
find / -type f -user bandit7 -group bandit6 -size 33c -print0 -quit 2>/dev/null | xargs -0 cat
```

### Explanation

**find**

```
/ -type f
```

Searches the entire filesystem for regular files only.

```
-user bandit7
-group bandit6
```

Matches ownership.

```
-size 33c
```

File size is **33 bytes**.

```
-print0
```

Outputs filenames separated by **NULL characters** (safe for spaces).

```
-quit
```

Stops searching after the **first match**.

```
2>/dev/null
```

Suppresses permission errors.

**xargs -0 cat**

Reads the filename and prints its contents.

---

# Level 7

### Challenge
The password is stored in `data.txt` next to the word **millionth**.

### Solution

```bash
grep "millionth" data.txt
```

Example output:

```
millionth abcdefghijklmnopqrstuvwxyz
```

The value next to `millionth` is the password.

### Option 2 - Automatic extraction

```bash
grep "millionth" data.txt | awk '{print $2}'
```

Explanation:

- `grep` finds the line
- `awk` prints the second field

---

# Level 8

### Challenge
The password is the **only line that occurs once** in `data.txt`.

### Solution

```bash
sort data.txt | uniq -u
```

### Explanation

```
sort data.txt
```

Sorts the file so identical lines become adjacent.

```
uniq -u
```

Prints lines that appear **only once**.

---

# Level 9

### Challenge
The password is in `data.txt` inside one of the few **human-readable strings**, preceded by several `=` characters.

### Solution

```bash
strings data.txt | grep ===
```

### Explanation

**strings**

Extracts readable text from binary data.

**grep ===**

Searches for lines containing `===`, which precede the password.

---

# Level 10

### Challenge
The password in `data.txt` is **Base64 encoded**.

### Solution

```bash
base64 --decode data.txt
```

or

```bash
base64 -d data.txt
```

### Alternative (using OpenSSL)

```bash
openssl base64 -d -in data.txt
```

### If the output looks binary

```bash
base64 -d data.txt 2>/dev/null | strings
```

This extracts only the **human-readable text**.

---