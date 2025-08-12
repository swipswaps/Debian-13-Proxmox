# Debian-13-Proxmox
set of scripts to automate the creation of a hardened Debian 13 (Trixie) template on Proxmox VE using cloud-init. This process allows for fast, reproducible, and secure deployments of new Debian VMs
=======
# 🚀 Automated Debian 13 (Trixie) Proxmox Cloud-Init Template

This repository contains a set of scripts to automate the creation of a hardened Debian 13 (Trixie) template on Proxmox VE using cloud-init. This process allows for fast, reproducible, and secure deployments of new Debian VMs.

---

### Prerequisites

* A functioning **Proxmox VE installation**.
* A **Debian 13 "netinst" ISO file** uploaded to your Proxmox server. The netinst ISO is recommended over the DVD version for a smaller footprint and easier automation.
* The `gh` command-line tool installed and authenticated on your local machine to push this project to GitHub.
* Basic understanding of the Proxmox UI and `qemu` commands.

---

### 🛠️ How to Use

The workflow is designed to be executed in two parts: first on the Proxmox host, then inside the newly created VM.

**1. Create the Base VM on Proxmox**

* Run the `scripts/host-setup.sh` script on your Proxmox host. This script will create a new VM, attach the netinst ISO, and configure it for cloud-init.
* During the Debian installation, make sure to:
    * Select **"Expert install"** or **"Install"**. The "netinst" installer is mostly non-interactive but may require some manual input.
    * **Do NOT install a desktop environment.**
    * Select **"cloud-init"** during the software selection phase.
    * **Do not create a `root` password** but do create a standard user.

**2. Configure and Harden the VM**

* Once the base installation is complete, boot the VM and run the `cloud-init-config/user-data.yaml` file. This is handled by Proxmox when you clone a template.
* Copy the `scripts/harden.sh` script into the VM (e.g., using `scp`).
* Execute the hardening script inside the VM. This will set up the firewall, SSH security, and unattended upgrades.

```sh
sudo bash harden.sh

3. Convert to Template

    After running the hardening script and confirming the configuration is correct, shut down the VM.

    On the Proxmox host, run the qm template <VMID> command to convert the VM into a template.

    You can now clone this template to create new, hardened Debian 13 VMs instantly.

⚠️ Common Troubleshooting

    Cloud-Init is not running:

        Ensure cloud-init is installed in your VM.

        Verify the ciagent and cicustom flags are set correctly in your VM configuration (qm config <VMID>).

        Check the cloud-init log files inside the VM: sudo cat /var/log/cloud-init.log.

    Networking issues:

        Check the DHCP server on your network.

        Verify the cloud-init network configuration in the Proxmox UI.

        Make sure the qemu-guest-agent is running and properly configured.

    SSH access problems:

        Ensure your publickey is correctly embedded in user-data.yaml.

        Check the firewall rules with ufw status. The script enables SSH access, but a manual error could block it.

        Verify the sshd service is running: sudo systemctl status ssh.
