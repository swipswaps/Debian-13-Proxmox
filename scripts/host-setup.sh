#### `scripts/host-setup.sh`

This script runs on your Proxmox host to create the initial VM shell.

```sh
#!/bin/bash

# A script to create a new VM for the Debian 13 cloud-init template.
# Run this on your Proxmox host.

# Variables - adjust as needed
VMID=900
VMNAME="debian-13-template"
STORAGE="local-lvm"  # or your preferred storage
ISO_FILE="debian-13.0.0-amd64-netinst.iso" # The ISO file you have uploaded

# Create the VM
qm create $VMID --name $VMNAME --memory 2048 --net0 virtio,bridge=vmbr0
qm set $VMID --scsihw virtio-scsi-pci --scsi0 $STORAGE:32,format=qcow2
qm set $VMID --boot order=scsi0
qm set $VMID --ide2 $STORAGE:cloudinit
qm set $VMID --serial0 socket --vga serial0
qm set $VMID --agent enabled=1

# Attach the Debian netinst ISO
qm set $VMID --cdrom $STORAGE:iso/$ISO_FILE

echo "VM $VMID created. Now proceed with the manual Debian installation."
echo "Once installation is complete, follow the README.md instructions."