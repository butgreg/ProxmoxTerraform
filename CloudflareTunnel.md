Here is a **detailed walkthrough** for **setting up Cloudflare Tunnel for Proxmox (HTTPS) and SSH**, incorporating all corrections and best practices while **anonymizing all personal details**.

---

# **🚀 Secure Proxmox & SSH Access via Cloudflare Tunnel**

This guide covers:
✅ **Setting up a Cloudflare Tunnel** for **Proxmox Web UI**  
✅ **Enabling secure SSH access** over **Cloudflare Zero Trust**  
✅ **Fixing common errors & troubleshooting**  

🔹 **Use Case**: Secure remote access **without exposing public IPs**  
🔹 **Tools Used**: `cloudflared`, Cloudflare **Zero Trust**, Cloudflare DNS  
🔹 **Applies To**: **Proxmox**, any **self-hosted service**, or **SSH servers**

---

## **📌 Step 1: Install Cloudflare Tunnel on Proxmox**
First, install the **Cloudflare Tunnel client (`cloudflared`)**:

```bash
apt update && apt install cloudflared -y
```

Verify the installation:

```bash
cloudflared --version
```
✅ You should see an output like:
```
cloudflared version 2025.2.0 (checksum ...)
```

---

## **📌 Step 2: Authenticate & Create a Cloudflare Tunnel**
Log into **Cloudflare Zero Trust** and authenticate:

```bash
cloudflared tunnel login
```
This will open a **browser window** → Select your **Cloudflare account** → Choose your **domain**.

---

## **📌 Step 3: Create & Configure the Tunnel**
### **1️⃣ Create a new tunnel**
```bash
cloudflared tunnel create proxmox-tunnel
```
This generates a **Tunnel ID** and a credentials file (stored in `~/.cloudflared/`).

### **2️⃣ Get Tunnel Credentials**
Run:
```bash
ls ~/.cloudflared/
```
You should see a file like:
```
<UUID>.json
```

---

## **📌 Step 4: Configure Cloudflare Tunnel for Proxmox**
Edit the **Cloudflare Tunnel configuration file**:

```bash
nano /etc/cloudflared/config.yml
```

Add the following configuration:
```yaml
tunnel: <UUID>  # Replace with your actual Tunnel ID
credentials-file: /root/.cloudflared/<UUID>.json

ingress:
  - hostname: proxmox.example.com  # Replace with your Cloudflare subdomain
    service: https://192.168.1.100:8006  # Replace with Proxmox's local IP
    originRequest:
      noTLSVerify: true  # Allows self-signed Proxmox SSL certs
  - hostname: ssh.example.com  # For SSH access
    service: tcp://192.168.1.100:22  # Replace with Proxmox's local SSH IP
  - service: http_status:404  # Fallback rule
```

🔹 **Key Fixes from Debugging**:
✅ **Used `tcp://` instead of `ssh://`** for SSH  
✅ **Allowed Proxmox self-signed certs with `noTLSVerify: true`**  
✅ **Set fallback rule to `http_status:404`** to prevent Cloudflare errors  

---

## **📌 Step 5: Start & Enable the Cloudflare Tunnel**
### **1️⃣ Restart the Cloudflare service**
```bash
systemctl restart cloudflared
```
### **2️⃣ Check for errors**
```bash
journalctl -u cloudflared -n 50 --no-pager
```
✅ **If no errors appear, the tunnel is running!** 🎉

### **3️⃣ Enable the tunnel on system startup**
```bash
systemctl enable cloudflared
```

---

## **📌 Step 6: Configure Cloudflare DNS**
Go to **Cloudflare Dashboard** → Select your domain → **DNS**.

### **1️⃣ Create a CNAME for Proxmox UI**
- **Type:** `CNAME`
- **Name:** `proxmox`
- **Target:** `<UUID>.cfargotunnel.com`
- **Proxy Status:** **Enabled (Orange Cloud)** ✅

### **2️⃣ Create a CNAME for SSH**
- **Type:** `CNAME`
- **Name:** `ssh`
- **Target:** `<UUID>.cfargotunnel.com`
- **Proxy Status:** **Enabled (Orange Cloud)** ✅

🔹 **Verify DNS is resolving**:
```bash
dig proxmox.example.com
dig ssh.example.com
```

---

## **📌 Step 7: Configure Cloudflare Zero Trust for Secure Access**
Go to **Cloudflare Zero Trust** → **Access** → **Applications**.

### **1️⃣ Add Proxmox as an Application**
- Click **"Create an Application"** → Choose **"Self-Hosted"**.
- **Application Name:** `Proxmox`
- **Domain:** `proxmox.example.com`
- Click **"Next"**.

### **2️⃣ Set Authentication Rules**
- **Click "Create a Policy"**.
- **Policy Name:** `Allow Proxmox Access`
- **Action:** `Allow`
- **Include**:
  - **Email** → Add your email (`your-email@example.com`).
  - (Optional) **IP Ranges** → Restrict to your IP (`X.X.X.X`).
  - (Optional) **Country** → Restrict access to your country.

✅ **Click "Save"**.

---

## **📌 Step 8: Securely Access SSH via Cloudflare**
### **1️⃣ Start a Local Proxy for SSH**
On your **local machine** (not Proxmox), run:
```bash
cloudflared access tcp --hostname ssh.example.com --url localhost:2222
```
Now, **connect using SSH**:
```bash
ssh -p 2222 root@localhost
```

### **2️⃣ Set Up Persistent SSH Access (Optional)**
Edit `~/.ssh/config`:
```bash
Host ssh.example.com
  ProxyCommand cloudflared access tcp --hostname ssh.example.com
  User root
```
Now, simply run:
```bash
ssh ssh.example.com
```

✅ **SSH now works securely through Cloudflare Tunnel!** 🎉

---

## **📌 Step 9: Troubleshooting & Debugging**
If you run into issues, try these:

### **1️⃣ Check if Proxmox is Reachable Locally**
```bash
curl -vk https://192.168.1.100:8006
```
If it fails, restart Proxmox:
```bash
systemctl restart pveproxy
```

### **2️⃣ Restart Cloudflare Tunnel**
```bash
systemctl restart cloudflared
journalctl -u cloudflared -n 50 --no-pager
```

### **3️⃣ Verify DNS Resolution**
```bash
dig proxmox.example.com
dig ssh.example.com
```

### **4️⃣ Ensure SSH Service is Running**
```bash
systemctl status ssh
```
If not running:
```bash
systemctl start ssh
```

---

# **🎯 Final Result:**
✅ **Proxmox UI (`https://proxmox.example.com`) is now accessible securely via Cloudflare Zero Trust.**  
✅ **SSH (`ssh ssh.example.com`) is now fully operational through Cloudflare Tunnel.**  
✅ **Zero public IP exposure – all traffic goes through Cloudflare.**  

---

# **🚀 Summary**
| **Component** | **Configuration** | **Notes** |
|--------------|------------------|-----------|
| **Cloudflare Tunnel** | `cloudflared tunnel run` | Securely proxies connections |
| **Proxmox UI** | `proxmox.example.com` | HTTPS secured with Cloudflare |
| **SSH** | `ssh.example.com` | Uses Cloudflare TCP Tunnel |
| **Cloudflare DNS** | CNAME records | Routes traffic securely |
| **Cloudflare Zero Trust** | Email/IP authentication | Controls access to Proxmox |

This setup **ensures maximum security**, **prevents brute force attacks**, and **removes the need for a VPN**.

---

🚀 **Mission accomplished! You now have a fully secure Cloudflare-protected Proxmox & SSH setup.** 🎉