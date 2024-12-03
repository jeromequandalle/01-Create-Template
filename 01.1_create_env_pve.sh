#!/bin/sh
# Variables communes
TEMPLATE_DIR="/root/cloud-version"
STORAGE_POOL="local-lvm"
BRIDGE="vmbr0"
CORES=2
MEMORY=2048
DISK_SIZE="10G"
CLOUDINIT_DISK="${STORAGE_POOL}:cloudinit"
# Création de répertoires et de l'arborescence de travail
mkdir -p "$TEMPLATE_DIR"
cd "$TEMPLATE_DIR"
# Fonction pour créer un template
create_template() {
    local id=$1
    local name=$2
    local url=$3
    local img_file=$(basename "$url")
    echo "Création du template $name"
    mkdir -p "$name"
    cd "$name"
    #wget "$url"
    qm create "$id" --name "$name" --net0 virtio,bridge="$BRIDGE" --scsihw virtio-scsi-single
    qm set "$id" --scsi0 "${STORAGE_POOL}:0,iothread=1,backup=off,format=qcow2,import-from=${TEMPLATE_DIR}/${name}/${img_file}"
    qm disk resize "$id" scsi0 "$DISK_SIZE"
    qm set "$id" --boot order=scsi0
    qm set "$id" --cpu host --cores "$CORES" --memory "$MEMORY"
    qm set "$id" --ide2 "$CLOUDINIT_DISK"
    qm set "$id" --agent enabled=1
    qm template "$id"
    cd ..
    echo "Fin de création du template $name"
}


#création des pools 
pvesh create /pools --poolid zone-relais --comment "Pool zone Relais"
pvesh create /pools --poolid zone-exposee --comment "pool infrastructure exposée sur le net"
pvesh create /pools --poolid zone-interne --comment "pool service interne"
pvesh create /pools --poolid zone.templates --comment "les templates sont la"

# Templates 
create_template 9001 "debian.template" "https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-generic-amd64.qcow2"
create_template 9002 "alma.template" "https://repo.almalinux.org/almalinux/9/cloud/x86_64/images/AlmaLinux-9-GenericCloud-9.4-20240507.x86_64.qcow2"
create_template 9003 "ubuntu.last.template" "https://cloud-images.ubuntu.com/oracular/current/oracular-server-cloudimg-amd64.img"
create_template 9004 "ubuntu.lts.template" "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64-disk-kvm.img"

pvesh set /pools/zone.templates --vm 9001
pvesh set /pools/zone.templates --vm 9002
pvesh set /pools/zone.templates --vm 9003
pvesh set /pools/zone.templates --vm 9004


echo "Fin de création du paramétrage de bases de  proxmox"
