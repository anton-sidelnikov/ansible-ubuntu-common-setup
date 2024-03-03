# Ansible Role: cpu_operation_mode
This Ansible role is designed to automate the process of managing the
CPU scaling governor on Linux systems using the `cpufrequtils` package,
and displays CPU information including `Hyper-Threading/Multithreading` 
using the `lscpu` command.

## Prerequisites

- Ansible installed on the control node.
- Passwordless SSH access to the target hosts.

## Role Variables

 - `governor`: Specifies the desired CPU scaling governor. Default value is `performance`.


## Example Playbook

```yaml
- hosts: all
  name: "Base: set up CPU scaling governor and shows CPU info"
  become: true
  tasks:
    - include_role: name=cpu_operation_mode
```

## Role Structure

The playbook consists of the following tasks:

1. Validate governor variable that uses the `assert` module to check the following conditions:
   * The variable is defined.
   * The variable is a string.
   * The variable's value is within the list of valid options which is `performance`, `powersave`, `userspace`, `ondemand`, `conservative` or `schedutil`.
2. Install the `cpufrequtils` and `util-linux`packages and update the apt package cache.
3. Check the available CPU governors.
4. Set the CPU scaling governor to the specified value (default is `performance`) if supported.
5. Display CPU information including `Hyper-Threading/Multithreading`.

## License
