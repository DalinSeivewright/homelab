# Setup Steps

## Setting up new Base OS Configuration

Currently have default configurations for Ubuntu and Rasbian.  When you need to support a new OS, create a `<os name>.yml` file under the `ansible/group_vars` folder where `<os name>` is going to be the Base OS group.  OS Configurations require the `ansible_python_interpreter` variable to choose ansibles python interpreter (usually `/usr/bin/python3`).  Every OS configuration also requires a default user, group and password.  **When the OS is bootstrapped this default user and group is removed.**

Example configuration file:
```
# my-os-type.yml
ansible_python_interpreter: /usr/bin/python3
default_user: default_user
default_group: default_user
default_password: default_user
```

Remember that any other specific Base OS Configuration variables need to go here as well.

`<os name>` should be placed into your host `inventory` file as `[<os name>]`.


## Adding a Host Configuration

Create a host file `<hostname>.yml` in the `ansible/host_vars` folder.  This is where your host specific configurations will exist.  There is **a lot** of duplication when it comes to hosts and certain configs as you will see.  One such issue is repeating IP Addresses for the host in several config files.  The file will be empty for now and in most cases will only contain a single line to specify the host address.

### Install Media
1. Pick base OS type.  Add your host to the `inventory` file under the OS group.
2. Start installation OS type on host.
3. Enter in the default user and password that corresponds to the chosen OS type.
4. After install is completed, boot the OS.

### Finishing Setup
Your host should get an IP Address from DHCP on the network.  No automated solution for this has been setup yet, so you need to rely on an existing DHCP Server (router, for example).  **Suggest you statically assign this via the DHCP Server!**  This IP Address needs to be placed in several configuration files now.

In `<hostname>.yml` specify the hosts IP Address like `ansible_host: <ip address>` for example `ansible_host: 192.168.10.10`.

The rest of the configuration for a host is specific to "non-DNS Nameserver" hosts but the setup is similar for both.  If this new host is intended to be a nameserver, you can carry on with these configuration steps just be aware that you'll have to follow the DNS Host setup as well.

The following assumes you are not setting up a new DNS Zone and are adding to an existing one.  If you are adding a new DNS Zone (Forward or Reverse) set that up first.

In `ansible/group_vars/dns_authority.yml` find the specific Forward Zone section for your host based on IP.  Add a new `hosts` entry consisting of the `hostname` and `host` port.  For example if you were adding a host called `newhost` with an IP of `192.168.10.10` it would look like:
```
dns_forward_zones:
  - forward_zone: myforwardzone.
    serial: 2019082401
    primary_nameserver: myprimaryns
    ttl: 10M
    refresh: 5M
    retry: 1M
    expire: 1H
    minimum: 10M
    records:
      - subnet: 192.168.10
        hosts:
        - name: existinghost
          host: 1
        - name: newhost
          host: 10
```
In `ansible/group_vars/dns_authority.yml` find the specific Reverse Zone section for your host based on IP.  Add a new `hosts` entry consisting of the `hostname` and `host` port.  For example if you were adding a host called `newhost` with an IP of `192.168.10.10` it would look like:
```
dns_reverse_zones:
  - forward_zone: myforwardzone.
    reverse_zone: 10.168.192.in-addr.arpa.
    serial: 2019082401
    primary_nameserver: auntie-dot
    ttl: 10M
    refresh: 5M
    retry: 1M
    expire: 1H
    minimum: 10M
    records:
      - name: existinghost
        host: 1
      - name: newhost
        host: 10
```

Ansible will take this data and re-write the DNS entries to include your new host the next time DNS Provisioning is performed.  Which should probably be run after this configuration is done.

The base host is now ready to be bootstrapped.

### Bootstrapping

The actual bootstrapping process is easy.  Run `ansible-playbook -i <your inventory file name> --limit <hostname> boostrap-provision.yml` from the `ansible` working directory.  The default user/group will be removed from the host, the provisioning user and group will be added and default configurations and installs will be applied (example:  Firewall settings).  SSHing into the host after this, unless other setup is done, will now only be possible via `ssh -o User=provision -i keys/provision <ip or hostname>` from the `ansible` working directory.


