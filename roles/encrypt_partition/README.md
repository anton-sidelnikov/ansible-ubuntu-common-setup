# Ansible Role: encrypt_partition
This Ansible role automates the process of encrypting and mounting partitions using LUKS (Linux Unified Key Setup) on Linux systems.
## Prerequisites

- Ansible installed on the control node.
- Passwordless SSH access to the target hosts.

## Dependencies

This role depends on the `community.crypto` collection.

To install the collection, you can use the following command:

```sh
ansible-galaxy collection install community.crypto
```

## Role Variables

- `partitions`: A dictionary specifying the partitions to be encrypted and mounted. Each key-value pair in the dictionary represents a partition.
  where the `key` is the partition name and the value is another dictionary containing the following keys:
  * `luks_passphrase`: This field stores the passphrase used for unlocking the LUKS (Linux Unified Key Setup) encryption on the partition. This passphrase is necessary to decrypt the data on the partition.
  * `luks_partition`: This field identifies the name of the LUKS partition
  * `mount_point`: This specifies where the partition will be mounted in the filesystem hierarchy.

## Example Playbook

```yaml
- hosts: server
  become: yes
  vars:
    partitions:
      /dev/sdb1:
        luks_passphrase: "your_passphrase_here"
        luks_partition: "/dev/sdb1"
        mount_point: "/mnt/encrypted_partition"
      /dev/sdc1:
        luks_passphrase: "another_passphrase"
        luks_partition: "/dev/sdc1"
        mount_point: "/mnt/another_encrypted_partition"
  roles:
    - encrypt_partition
```

## Rele Structure

The playbook consists of the following tasks:

1. Installs the `cryptsetup` package if not already installed.
2. Encrypts each specified partition using LUKS with the provided `luks_passphrase`.
3. Formats the encrypted partitions with the `ext4` file system.
4. Creates `mount_point` folders for the encrypted partitions.
5. Mounts the encrypted partitions to the specified `mount_point`.

## License
