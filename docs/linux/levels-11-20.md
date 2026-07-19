## Level 11

### Objective

Decode the ROT13-encoded password stored in `data.txt`.

### Solution

```bash
tr 'A-Za-z' 'N-ZA-Mn-za-m' < data.txt
```

Alternative (Python):

```bash
python3 -c "import codecs; print(codecs.decode(open('data.txt').read(), 'rot_13'))"
```

### Explanation

The password is encoded using **ROT13**, a Caesar cipher that rotates each letter by 13 positions.

The `tr` command performs character translation:

- `A-Z` → `N-ZA-M`
- `a-z` → `n-za-m`

The `< data.txt` redirection feeds the contents of the file directly into `tr`, printing the decoded password.

---

## Level 12

### Objective

Recover the password from a repeatedly compressed hexdump stored in `data.txt`.

### Solution

Create a temporary working directory:

```bash
tmpdir=$(mktemp -d)
cd "$tmpdir"
```

Copy the challenge file:

```bash
cp /home/bandit12/data.txt .
```

Rename it:

```bash
mv data.txt data.bin
```

Reverse the hexdump:

```bash
xxd -r data.bin > data.orig
```

Identify the file type:

```bash
file data.orig
```

Depending on the reported format, decompress accordingly.

For gzip:

```bash
mv data.orig data.gz
gunzip data.gz
```

For bzip2:

```bash
mv data.orig data.bz2
bunzip2 data.bz2
```

For tar archives:

```bash
tar xf data.tar
```

Repeat the following until the file becomes plain text:

```bash
file <filename>
```

Finally, read the password:

```bash
cat <filename>
```

### Explanation

The challenge file is a hexadecimal dump of a file that has been compressed multiple times.

- `xxd -r` converts the hexdump back into its original binary form.
- `file` identifies the current file format.
- Each compression layer must be decompressed before inspecting the next one.
- Continue until `file` reports plain ASCII text.

If `gunzip` refuses to process a file because of its extension, rename it first:

```bash
mv data.out data.gz
gunzip data.gz
```

A file beginning with the magic number:

```text
1f8b
```

indicates a gzip archive.

---

## Level 13

### Objective

Use the provided SSH private key to log in as `bandit14` and retrieve the next password.

### Solution

Save the private key locally:

```bash
nano /tmp/bandit14_key
chmod 600 /tmp/bandit14_key
```

Connect using the key:

```bash
ssh -i /tmp/bandit14_key -p 2220 bandit14@bandit.labs.overthewire.org
```

Retrieve the password:

```bash
cat /etc/bandit_pass/bandit14
```

### Explanation

Instead of receiving the next password directly, this level provides an SSH private key.

After saving the key with appropriate permissions (`chmod 600`), use it to authenticate as `bandit14` and read the password from the standard password file.

---

## Level 14

### Objective

Submit the current password to the service listening on port `30000`.

### Solution

```bash
cat /etc/bandit_pass/bandit14 | nc localhost 30000
```

### Explanation

The command:

- reads the current password,
- pipes it into `nc` (Netcat),
- connects to `localhost` on TCP port `30000`,
- sends the password to the service.

If the password is correct, the service returns the password for the next level.

---

## Level 15

### Objective

Submit the current password to the SSL/TLS service running on port `30001`.

### Solution

Option 1:

```bash
printf "%s\n" "$(cat /etc/bandit_pass/bandit15)" | openssl s_client -connect localhost:30001 -quiet 2>/dev/null
```

Option 2:

```bash
openssl s_client -connect localhost:30001 -quiet < /etc/bandit_pass/bandit15 2>/dev/null
```

### Explanation

Unlike the previous level, the service communicates over **SSL/TLS**, requiring an encrypted connection.

`openssl s_client` performs the TLS handshake before sending the password.

- `printf` ensures the password ends with a newline.
- `-quiet` suppresses most TLS session information.
- `2>/dev/null` hides diagnostic output, leaving only the server response.

Input redirection (`<`) sends the contents of the password file directly into the encrypted connection.

---

## Level 16

### Objective

Retrieve the next password by submitting the current password to the correct SSL/TLS service running on one of the localhost ports between **31000** and **32000**.

### Solution

Scan the port range:

```bash
nmap -p 31000-32000 localhost
```

The scan reveals the following open ports:

```text
31046
31518
31691
31790
31960
```

Determine which ports support SSL/TLS:

```bash
timeout 2 bash -c 'echo | openssl s_client -connect 127.0.0.1:PORT 2>&1' | sed -n '1,6p'
```

Ports presenting a certificate are TLS-enabled.

Submit the current password to each TLS service:

```bash
PASS="$(cat /etc/bandit_pass/bandit16)"; for p in 31518 31790; do echo "---- $p ----"; printf "%s\n" "$PASS" | timeout 3 bash -c "openssl s_client -connect 127.0.0.1:$p -quiet 2>/dev/null" | sed -n '1,8p'; done
```

The service that returns a **different** string instead of echoing the submitted password provides the password for the next level.

### Explanation

The challenge requires identifying which service both:

- accepts SSL/TLS connections,
- and validates the supplied password.

The process consists of:

1. Scanning the specified port range.
2. Identifying TLS-enabled services using `openssl s_client`.
3. Sending the current password to each TLS service.
4. Identifying the service that returns a new password rather than echoing the input.

The `sed -n '1,8p'` command limits the output to the first eight lines, making the server's response easier to read.

---

## Level 17

### Objective

Find the only line that differs between `passwords.old` and `passwords.new`.

### Solution

```bash
diff passwords.old passwords.new
```

Alternative:

```bash
diff passwords.old passwords.new | grep ">"
```

Only print the changed line:

```bash
diff --new-line-format="%L" --old-line-format="" --unchanged-line-format="" passwords.old passwords.new
```

### Explanation

The challenge states that exactly one line has changed.

The `diff` utility compares both files line-by-line.

- Lines beginning with `<` belong to `passwords.old`.
- Lines beginning with `>` belong to `passwords.new`.

The changed line from `passwords.new` is the password for the next level.

---

## Level 18

### Objective

Retrieve the password stored in `readme` despite `.bashrc` logging you out immediately after login.

### Solution

Run the command directly through SSH:

```bash
ssh bandit18@bandit.labs.overthewire.org -p 2220 cat readme
```

Alternative using SCP:

```bash
scp -P 2220 bandit18@bandit.labs.overthewire.org:readme .
cat readme
```

Alternative shell without loading configuration files:

```bash
ssh bandit18@bandit.labs.overthewire.org -p 2220 'bash --noprofile --norc'
```

### Explanation

The modified `.bashrc` immediately terminates interactive login sessions.

Providing a command directly to `ssh` avoids starting an interactive shell, preventing `.bashrc` from executing. The command runs immediately and prints the contents of `readme`, which contains the next password.

---

## Level 19

### Objective

Use the provided setuid binary to read the password for `bandit20`.

### Solution

Inspect the home directory:

```bash
ls -l
```

Execute the binary without arguments:

```bash
./bandit20-do
```

Read the password:

```bash
./bandit20-do cat /etc/bandit_pass/bandit20
```

### Explanation

The `bandit20-do` binary has the **setuid** bit enabled.

Although logged in as `bandit19`, executing the binary causes it to run with the privileges of `bandit20`.

This allows the supplied command (`cat /etc/bandit_pass/bandit20`) to access a file that would normally be unreadable.

---

## Level 20

### Objective

Use the provided setuid binary to retrieve the password for `bandit21`.

### Solution

Start a Netcat listener:

```bash
nc -lvp 12345
```

In a second terminal, connect to the same Bandit account and execute:

```bash
./suconnect 12345
```

Return to the Netcat listener, paste the current password, and press **Enter**.

The service responds with:

```text
Correct!
<bandit21 password>
```

### Explanation

The `suconnect` binary runs with the privileges of **bandit21**.

Instead of listening for connections, it connects to a TCP port that you specify.

The solution is therefore to:

1. Create a listener using Netcat.
2. Execute the setuid binary, pointing it at the listener.
3. Send the current password through the established connection.
4. Receive the next password from the service.

---

# Skills Practiced

- ROT13 decoding
- Character translation with `tr`
- Working with temporary directories
- Reversing hexadecimal dumps
- File type identification
- Decompressing archives
- SSH key authentication
- Netcat
- SSL/TLS communication
- Input and output redirection
- Network service enumeration
- Port scanning
- TLS service identification
- SSL/TLS communication
- Command substitution
- Shell loops
- File comparison
- SSH command execution
- Secure file transfer (SCP)
- Setuid binaries
- Linux permissions
- Netcat listeners
- Client-server communication

---

# Tools Used

- tr
- python3
- mktemp
- cp
- mv
- xxd
- file
- gunzip
- bunzip2
- tar
- ssh
- cat
- nc
- openssl
- nmap
- openssl
- timeout
- sed
- printf
- diff
- grep
- ssh
- scp
- bash
- ls
- cat
- nc

---
