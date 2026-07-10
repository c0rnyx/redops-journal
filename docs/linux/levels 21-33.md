# OverTheWire Bandit Notes From Levels 21 Through 33

These are my personal notes and solutions while practicing Linux fundamentals through the **OverTheWire Bandit** wargame.

---

# Level 21

## Challenge
A program is running automatically at regular intervals from cron, the time-based job scheduler. Look in /etc/cron.d/ for the configuration and see what command is being executed.

## Solution 
**Step 1 - List the directory:**

```
ls /etc/cron.d
```

---

**Step 2 — Read the cronjob file**

Look at its contents:

```
cat /etc/cron.d/cronjob_bandit22
```
```
@reboot bandit22 /usr/bin/cronjob_bandit22.sh
* * * * * bandit22 /usr/bin/cronjob_bandit22.sh
```

That means:

- Every minute, as user **bandit22**, cron runs the script:
    
```
/usr/bin/cronjob_bandit22.sh
```
    

---

**Step 3 — Read the script**

Inspect the script:

```
cat /usr/bin/cronjob_bandit22.sh
```

```
#!/bin/bash
chmod 644 /tmp/bandit22_pass
cat /etc/bandit_pass/bandit22 > /tmp/bandit22_pass
```

---

**Step 4 — Read the file that cron writes**

Since cron runs this script every minute as user **bandit22**, it writes the password into `/tmp` with open permissions.

Look in `/tmp`:

```
ls -l /tmp
```

Look for a file mentioned in the script.
Then read it:

```
cat /tmp/bandit22_pass
```

That printed value is the **password for bandit22**

## **Explanation - Why this works**

- Cron runs the script **as bandit22**, which means the script **can read** `/etc/bandit_pass/bandit22`
- The script **copies that password into /tmp**, which *we* can access
- The output file can be simply read

---


# Level 22 

## Challenge 
A program is running automatically at regular intervals from cron, the time-based job scheduler. Look in /etc/cron.d/ for the configuration and see what command is being executed. NOTE: Looking at shell scripts written by other people is a very useful skill. The script for this level is intentionally made easy to read. If you are having problems understanding what it does, try executing it to see the debug information it prints.

## Solution summary

```bash
# 1) inspect cron and the script
cat /etc/cron.d/cronjob_bandit23
cat /usr/bin/cronjob_bandit23.sh

# 2) compute the exact filename cron will create (script's behavior)
hash=$(echo "I am user bandit23" | md5sum | cut -d' ' -f1)

# 3) remove any leftover file you might have created by mistake
rm -f /tmp/"$hash"

# 4) wait up to 60s for cron to run, then print the password file
sleep 65
cat /tmp/"$hash"
```

## Detailed Solution

### 1) See what cron is configured to run

```bash
cat /etc/cron.d/cronjob_bandit23
```

### 2) Read the script

```bash
cat /usr/bin/cronjob_bandit23.sh
```

The script does:

- sets `myname=$(whoami)` (so when cron runs it, `myname=bandit23`)
- computes `mytarget=$(echo I am user $myname | md5sum | cut -d ' ' -f 1)`
- writes the password for `$myname` into `/tmp/$mytarget`

So cron will create a file `/tmp/<md5-of-"I am user bandit23">` containing the bandit23 password.


### 3) Compute the exact filename cron will use (use the same `echo` as the script)

```bash
echo "I am user bandit23" | md5sum | cut -d' ' -f1
```

Save it:

```bash
hash=$(echo "I am user bandit23" | md5sum | cut -d' ' -f1)
echo "$hash"
```

### 4) Remove any conflicting file that could have been created earlier

If the script had been previously ran manually, we may have created `/tmp/<hash>` owned by our user, which prevents cron from writing the real file. Remove that file so cron can create it:

```bash
rm -f /tmp/"$hash"
```

### 5) Wait for cron and then read the file

Cron runs the script once per minute. Wait up to ~60 seconds, then read the file:

```bash
sleep 65
cat /tmp/"$hash"
```

That output is the **password for bandit23**.

---

# Level 23
A program is running automatically at regular intervals from **cron**, the time-based job scheduler. Look in **/etc/cron.d/** for the configuration and see what command is being executed.

**NOTE:** This level requires you to create your own first shell-script. This is a very big step and you should be proud of yourself when you beat this level!

**NOTE 2:** Keep in mind that your shell script is removed once executed, so you may want to keep a copy around…

## Problem
### **Goal:**

Exploit a cron job run as **bandit24** that executes any scripts found in:

```
/var/spool/bandit24/foo
```

**place a malicious script in that directory** -> cron runs it as *bandit24* -> the script then reads the password file for bandit24 and writes it somewhere accessible.

## Solution 
**View the cron job**

```bash
cd /etc/cron.d
ls -l
```

```
cronjob_bandit24
```

```bash
cat cronjob_bandit24
```

```
* * * * * bandit24 /usr/bin/cronjob_bandit24.sh
```

---

**Read the script**

```bash
cat /usr/bin/cronjob_bandit24.sh
```

```bash
#!/bin/bash

for i in /var/spool/bandit24/foo/*; do
    if [ -f "$i" ]; then
        echo "Running $i..."
        touch /tmp/$i
        rm -f "$i"
    fi
done
```

**Interpretation:**

- Every minute, as **user bandit24**, cron checks `/var/spool/bandit24/foo/`
- For every file inside:
    - It **runs it**
    - Then **deletes it**

---

**Create the exploit script**

Create a writable working directory:

```bash
cd /tmp
mkdir exploit23
cd exploit23
```

Create the script:

```bash
nano myscript.sh
```

```bash
#!/bin/bash
cat /etc/bandit_pass/bandit24 > /tmp/b24pass
```

Save & exit.

---

**Make it executable**

```bash
chmod +x myscript.sh
```

---

**Copy it to the cron execution folder**

```bash
cp myscript.sh /var/spool/bandit24/foo/
```

 -> This folder is writable by **bandit23**, but scripts run as **bandit24**.

---

**WAIT 1 minute**

Cron only runs once per minute.

Wait:

```bash
sleep 65
```

---

**Read the password dumped by your script**

```bash
cat /tmp/b24pass
```

---

# Level 24
## Challenge 
A daemon is listening on port 30002 and will give you the password for bandit25 if given the password for bandit24 and a secret numeric 4-digit pincode. There is no way to retrieve the pincode except by going through all of the 10000 combinations, called brute-forcing.

You do not need to create new connections each time

# Problem 
A daemon on **localhost:30002** returns the password for `bandit25` if it receives:

- the **correct bandit24 password**
- a **4-digit numeric PIN**
- **both on one line**, separated by a space
    
There is **no way to retrieve the PIN except brute-forcing** all 10,000 combinations.

## Solution summary

```bash
pass=$(cat /etc/bandit_pass/bandit24); \
for pinin $(seq -w 0000 9999);do \
echo"$pass$pin"; \
done | nc localhost 30002
```

---

## Explanation

1. **Read the password once**
    
    ```bash
    pass=$(cat /etc/bandit_pass/bandit24)
    ```
    
2. **Generate all PINs**
    
    ```bash
    seq -w 0000 9999
    ```
    
    - `w` ensures zero-padding (0000 → 9999).
3. **Send correct input format**
    
    ```bash
    echo"$pass$pin"
    ```
    
    Password and PIN are sent on **one line**, separated by a space.
    
4. **Pipe everything into a single `nc` session**
    
    ```bash
    ... | nc localhost 30002
    ```
    
    This keeps the connection open while all combinations are tried.
    
5. **Daemon responds when the correct PIN is reached**
    
    ```
    Correct!
    The passwordfor user bandit25is ...
    ```
    

---

# Level 25 
## Challenge 
Logging in to bandit26 from bandit25 should be fairly easy… The shell for user bandit26 is not **/bin/bash**, but something else. Find out what it is, how it works and how to break out of it.

> NOTE: if you’re a Windows user and typically use Powershell to ssh into bandit: Powershell is known to cause issues with the intended solution to this level. You should use command prompt instead.

## Problem 

```bash
cat /etc/passwd | grep bandit26
```

Output:

```
bandit26:...:/home/bandit26:/usr/bin/showtext
```

`bandit26` uses `/usr/bin/showtext` instead of `/bin/bash`.

---

## What `/usr/bin/showtext` does

- `showtext` displays text using **`vi`**
- This creates a **restricted shell environment**
- We are inside a **text editor**

## Solution 

Why this can work

`vi` allows:

- Command execution
- Shell spawning
- Environment modification

-> If we can execute commands inside `vi`, we can **escape the restricted shell**

---

## Escape Procedure

Inside `vi`:

```
:set shell=/bin/bash
:shell
```

This spawns a real Bash shell.

---

## Backup Escape Method

If `:shell` is blocked:

```
:! /bin/bash
```

---

## Final Step

Once a shell is received:

```bash
cat /etc/bandit_pass/bandit26
```

---

# Level 26
## Challenge 
Good job getting a shell! Now hurry and grab the password for bandit27!

## Solution 
- In `bandit26`’s home directory, there is a SUID binary:

```
-rwsr-x--- 1 bandit27 bandit26 bandit27-do
```
---

### What the binary does

- `bandit27-do` is a helper program that:
    - Takes a command as input
    - Executes that command **as bandit27**

---

The SUID binary can be used to read the next password file:

```bash
./bandit27-docat /etc/bandit_pass/bandit27
```

---

# Level 27
## Challenge
There is a git repository at ssh://bandit27-git@bandit.labs.overthewire.org/home/bandit27-git/repo via the port 2220. The password for the user bandit27-git is the same as for the user bandit27.

From your local machine (not the OverTheWire machine!), clone the repository and find the password for the next level. This needs git installed locally on your machine.

## Solution 
1. 
```bash
cd ~/Desktop
```

---

2. Clone the repository via SSH

```bash
gitclone ssh://bandit27-git@bandit.labs.overthewire.org:2220/home/bandit27-git/repo
```

3. Enter the cloned repository

```bash
cd repo
```

---

4. List repository contents

```bash
ls -la
```

5. Read the password for bandit28

```bash
cat README
```

---

# Level 28
## Challenge 
There is a git repository at ssh://bandit28-git@bandit.labs.overthewire.org/home/bandit28-git/repo via the port 2220. The password for the user bandit28-git is the same as for the user bandit28.

From your local machine (not the OverTheWire machine!), clone the repository and find the password for the next level. This needs git installed locally on your machine.

## Solution 
1. Clone the repository

```bash
gitclone ssh://bandit28-git@bandit.labs.overthewire.org:2220/home/bandit28-git/repo
cd repo
```

---

2. Check the current files

```bash
cat README.md
```

- Password is hidden or replaced (e.g. `xxxxxxxxxx`)
- Indicates a possible **info leak fixed later**

---

3. View commit history

```bash
gitlog
```

Purpose:

- See all commits
- Identify commits with messages like:
    - `add missing data`
    - `fix info leak`
- These often indicate where secrets were added or removed

---

4. Inspect earlier commits

```bash
git show <commit_hash>
```

This shows:

- The commit message
- The **diff**
- Lines removed ()
- Lines added (`+`)


### 5. Extract the password

---
# Level 29
## Challenge 
There is a git repository at ssh://bandit29-git@bandit.labs.overthewire.org/home/bandit29-git/repo via the port 2220. The password for the user bandit29-git is the same as for the user bandit29.

## Solution 

1. Clone the repository

```bash
gitclone ssh://bandit29-git@bandit.labs.overthewire.org:2220/home/bandit29-git/repo
cd repo
```

---

2. Inspect the default branch

```bash
cat README.md
```

Result:

- No password
- Message suggests credentials were removed from production

---

3. Enumerate all branches

```bash
git branch -a
```

Found:

- `master`
- `origin/dev`
- `origin/sploits-dev`

This indicates **additional development branches exist**.

---

4. Switch to the development branch

```bash
git checkout dev
```

This creates a local branch tracking `origin/dev`.

---

5. Explore repository contents

```bash
ls
cat README.md
```

---

# Level 30
## Challenge 
There is a git repository at ssh://bandit30-git@bandit.labs.overthewire.org/home/bandit30-git/repo via the port 2220. The password for the user bandit30-git is the same as for the user bandit30.

From your local machine (not the OverTheWire machine!), clone the repository and find the password for the next level. This needs git installed locally on your machine.

## Solution 

1. Clone the repository (from local machine)

```bash
gitclone ssh://bandit29-git@bandit.labs.overthewire.org:2220/home/bandit29-git/repo
cd repo
```

---

2. Inspect repository contents

```bash
ls
cat README.md
```

The README did **not** contain the password.

---

3. Inspect full Git history (including all branches)

```bash
gitlog --all
```

This revealed:

- multiple commits
- additional remote branches (`dev`, `sploits-dev`)

---

4. List all branches

```bash
git branch -a
```

---

5. Check out the development branch

```bash
git checkout dev
```

New directories appeared.

---

6. Explore repository files

```bash
ls
cd <new_directory>
cat README.md
```

**Password for bandit30 was stored in a README file inside a non-master branch.**

# Level 31
## Challenge
There is a git repository at ssh://bandit31-git@bandit.labs.overthewire.org/home/bandit31-git/repo via the port 2220. The password for the user bandit31-git is the same as for the user bandit31.

From your local machine (not the OverTheWire machine!), clone the repository and find the password for the next level. This needs git installed locally on your machine.

## Solution 

1. Clone the repository (local machine)

```bash
gitclone ssh://bandit31-git@bandit.labs.overthewire.org:2220/home/bandit31-git/repo
cd repo
```

---

2. Read instructions

```bash
cat README.md
```

---

3. Create the required file

```bash
echo"May I come in?" > key.txt
```

---

4. Inspect `.gitignore`

```bash
cat .gitignore
```

Output:

```
*
```

 All files are ignored by default.

---

5. Force-add the file

```bash
git add -f key.txt
```

---

6. Commit changes

```bash
git commit -m"add key"
```

---

7. Push to remote

```bash
git push origin master
```

**During the push, the server printed the password for bandit32.**

---

# Level 32
## Challenge 
After all this git stuff, it’s time for another escape. Good luck!

## Problem 
Escape a restricted shell (“UPPERCASE SHELL”) and retrieve the final password for `bandit33`.
Upon login, we are placed in a **custom shell** that:

- Converts **all input to uppercase**
- Executes commands via `/bin/sh -c`
- Runs on a **case-sensitive system**

Because Linux commands are lowercase, this breaks normal usage.

### Examples

| Input | Executed | Result |
| --- | --- | --- |
| `ls` | `LS` | Permission denied |
| `sh` | `SH` | Permission denied |

---

## Solution

Although commands are uppercased, **shell variable expansion happens *after*** the uppercase conversion.

That means variables like `$0` still work.

---

### `$0` Variable

- `$0` expands to the name of the current shell
- In this environment, `$0 = sh`
- Even though input is uppercased, the expansion remains valid

### Escape Command

```bash
$0
```

This spawns a **real interactive shell**.

---

```bash
whoami
```

```
bandit32
```

```bash
cat /etc/bandit_pass/bandit33
```

This reveals the final Bandit password.

---

# Level 33
```bash
bandit33@bandit:~$ ls
README.txt
bandit33@bandit:~$ cat README.txt
Congratulations on solving the last level of this game!
```