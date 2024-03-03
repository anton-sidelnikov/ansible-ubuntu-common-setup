# Playbook: Common Environment Setup

This Ansible playbook sets up a common environment on the host by performing various tasks and roles.

## Description
This playbook is designed to be executed on all hosts (`all`) and aims to set up a common environment by applying the following tasks and roles:
1. Rename Interface: This task is included as a role named `rename_interface`. It is responsible for renaming active network interface on the host.
2. Disable C-state: This task is included as a role named `disable_cstate`. It disables CPU C-states to improve performance and reduce latency.
3. Encrypt Partition: This task is included as a role named `encrypt_partition`. It encrypts specified partitions using LUKS (Linux Unified Key Setup) and mounts them.
4. Set CPU Operation Mode: This role (`cpu_operation_mode`) sets the CPU governor to `performance` mode to ensure consistent high performance and at the end prints CPU specification
   include information about `Intel Hyper-Threading (AMD multithreading)`.

## Playbook Variables

- `partitions`: (Optional, Dict) A list of partitions to be encrypted and mounted on the host. This variable is sourced from `partitions_to_encrypt` defined in the inventory for each host.
  Each key-value pair in the dictionary represents a partition:
  * where the `key` is the partition name, like (`/dev/xvda14`) and the value is another dictionary containing the following keys:
    * `luks_passphrase`: This field stores the passphrase used for unlocking the LUKS (Linux Unified Key Setup) encryption on the partition. This passphrase is necessary to decrypt the data on the partition.
    * `luks_partition`: This field identifies the name of the LUKS partition. It's typically the same as the device name without the /dev/ prefix.
    * `mount_point`: This specifies where the partition will be mounted in the filesystem hierarchy.
- `governor`: (Optional, String) The CPU governor mode to be set. If not specified, the default mode is `performance`.
- `interface_name`: (Optional, String) The Active network interface name to be set. If not specified, the default name is `net0`.
- `cpu_idle_state`: (Optional, Int) The CPU idle state to be set. If not specified, the default value is `1`.

## Example Usage
To execute the playbook base.yaml with the specified inventory file using Ansible, you would run the following command in your terminal:

```bash
ansible-playbook playbooks/base.yaml -i inventory/base
```

This command tells Ansible to run the playbook base.yaml and use the inventory base for defining the hosts on which the playbook tasks should be executed. Adjust the paths and filenames as needed to match the actual locations of your playbook and inventory files.

```yaml
- hosts: all
  name: "Base: set up common environment on host"
  become: yes
  vars:
    partitions: "{{ hostvars[inventory_hostname].partitions_to_encrypt }}"
  tasks:
    - include_role: name=rename_interface
    - include_role: name=disable_cstate
    - include_role: name=encrypt_partition
  roles:
    - { role: cpu_operation_mode, governor: 'performance' }
```
This playbook will execute the tasks and roles mentioned above on `all` hosts listed in the inventory.

## Hosts file
Each host listed under `all` now includes a `partitions_to_encrypt` key with a list of partitions to be encrypted.
Adjust the partitions accordingly for each host.
If a host does not require any partitions to be encrypted,
set an empty dictionary `{}` for `partitions_to_encrypt`.

Make sure the hostnames and partition paths match the actual configuration of your infrastructure.
Save the changes to the `hosts.yaml` file and ensure it is correctly referenced in your Ansible command.
```yaml
all:
  hosts:
    hostname1:
      ansible_host: 192.168.0.100
      ansible_user: ubuntu
      ansible_ssh_private_key_file: ~/.ssh/key.pem
      partitions_to_encrypt:
        "/dev/vdb4":
          luks_passphrase: "YourPassphraseHere"
          luks_partition: "encrypted_partition"
          mount_point: "/home/test"
    hostname2:
      ansible_host: 192.168.0.101
      ansible_user: ubuntu
      ansible_ssh_private_key_file: ~/.ssh/other_key.pem
      partitions_to_encrypt: {}
```

## Notes
* If `partitions_to_encrypt` is not set for a host, the `encrypt_partition` role will be skipped for that host.
* Customize the playbook according to specific requirements by adjusting variables and including additional tasks or roles as needed.

## License
