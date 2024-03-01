# Ansible Role: rename_interface
This Ansible playbook is designed to automate the process of renaming the active network interface
to value of `interface_name` variable and applying a new `Netplan` configuration.

## Prerequisites

- Ansible installed on the control node.
- Passwordless SSH access to the target hosts.

## Role Variables

- `interface_name`: The name of the network interface to be renamed. Default value is `eth0`.
- `netplan_path`: The path to the Netplan files. Default value is `/etc/netplan`.
- `cloud_init_file`: The name of cloud-init file. Default value is `50-cloud-init.yaml`.
- `net_cfg_file`: The name of netcfg file. Default value is `01-netcfg.yaml`.

## Example Playbook

```yaml
- hosts: all
  name: "Base: set up network interface on hosts"
  become: true
  tasks:
    - include_role: name=rename_interface
```

## Playbook Structure

The playbook consists of the following tasks:

1. Rename the active network interface to "net0".
2. Change the value after `set-name` in `/etc/netplan/01-netcfg.yaml` to `interface_name` value.
3. Check the Netplan configuration for errors.
4. Handle errors in the Netplan configuration.
5. Apply the new network configuration.
6. Display information about the renamed interface.

## License
