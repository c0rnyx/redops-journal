
---

# **Take Over TryHackMe Room Walkthrough**

---

### **Step 1: Scanning with Nmap**

![](https://miro.medium.com/v2/resize:fit:700/1*7HZs-Lxkle3bySNKYLPGeQ.png)

So we have a web server running on ports 80 and 443, plus SSH on port 22.

### **Step 2: Discovering the First Subdomain**

The room description hints that the company is “rebuilding their support.” Sounds like there might be a `support.` subdomain. Let’s try it out!

First, we map it in our `/etc/hosts` file:

```
sudo nano /etc/hosts
```

Add this line:

![](https://miro.medium.com/v2/resize:fit:700/1*X2iQUDmpUkbV5SLJFlQCZQ.png)

Now, visiting `support.futurevera.thm` in the browser shows us a website with a certificate. Let’s inspect it closely…

![](https://miro.medium.com/v2/resize:fit:700/1*DJGrSPfCo12GqIhJdMWFkw.png)

### **Step 3: Certificate Sneak Peek**

Click on **Show certificate**. Digging deeper into the cert, there’s an **alternative name** listed.

And boom — we find another subdomain! Let’s call it:

Press enter or click to view image in full size

[](https://miro.medium.com/v2/resize:fit:700/0*0gnvE5vit79qLqFR)

(Don’t worry — you’ll see the full subdomain when you follow along in the room!)

![](https://miro.medium.com/v2/resize:fit:700/1*Cir2AzbXGJy3FsDCAFyC4w.png)

### **Step 4: The Second Subdomain**

Let’s now access the secret subdomain **on port 80** (important: *not* 443). Once loaded, the browser redirects us to an **AWS S3 static website**. But instead of a proper page, we get a “not found” error.

Press enter or click to view image in full size

[](https://miro.medium.com/v2/resize:fit:700/0*5H9ykNyhGouyBIG8)

Here’s the catch: this misconfigured subdomain is pointing to an S3 bucket that **doesn’t exist**, making it vulnerable to a **subdomain takeover**!

```
flag{*******************************}.s3-website-us-west-3.amazonaws.com
```

---