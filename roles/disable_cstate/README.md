# Ansible Role: disable_cstate
This Ansible role manages CPU idle states on Linux systems using the cpupower tool.

## Prerequisites

- Ansible installed on the control node.
- Passwordless SSH access to the target hosts.

## Role Variables

- `cpu_idle_state`: Specifies the desired CPU idle state. Default is `1`.
- 
## Example Playbook

```yaml
- hosts: all
  name: "Base: disable CPUs c-state on hosts"
  become: true
  vars:
    cpu_idle_state: 1
  tasks:
    - include_role: name=disable_cstate
```

## Role Structure

The playbook consists of the following tasks:

1. Install cpupower within linux-tools:
   Ensure that the cpupower tool is installed along with necessary dependencies:
   * linux-tools-5.15.0-1048-aws
   * linux-tools-common
   * linux-tools-generic
2. Check current CPU idle state:
  Run `cpupower idle-info` to obtain information about the current CPU idle state and register the output.
3. Determine if there are idle states:
  Parse the output to determine if there are idle states available.
4. Set CPU idle state to the desired state:
  If idle states need to be modified (i.e., if there are no idle states or if changes are required),
  use `cpupower idle-set` to set the CPU idle state to the desired value.
5. Check current CPU idle state (after change): Verify the CPU idle state after making changes.

## License
