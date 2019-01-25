# - Add host to Ansible
## -- add line to inventory
```bash
cd <ansible_folder>
# add host with ip, user and password spec to inventory
vim ./hosts
'
[VM]
VM-prometheus ansible_host=192.168.88.196 ansible_user=root ansible_ssh_pass=<put_password_here>
'


# test access
ssh ...
ansible-playbook -vvD -l VM-prometheus id.yml
```

## -- add ansible user to remote hosts *host root password needed*
```bash
cd <ansible_folder>
ansible-playbook -vvD -l <hostname in inventory> -u root add-ansible-user.yml -k
```


## -- add admin users
*host root password needed*
```bash
cd <ansible_folder>
ansible-playbook -vvD -l <hostname in inventory> -u root add-admin-users.yml -k
```
or
*ansible ssh private key needed*
```bash
cd <ansible_folder>
ansible-playbook -vvD -l <hostname in inventory> -u ansible add-admin-users.yml
```


# - Run playbooks
## -- playbooks run from root user with password in inventory
```bash
cd <ansible_folder>
hosts
'
balance-01       ansible_host=192.168.88.1  ansible_user=root ansible_ssh_pass=<put_password_here>
'

ansible-playbook -vvD -l <hostname in inventory> <some_playbook>.yml
```

## -- playbooks run from ansible user or admin users (with sudo to root)
```bash
# remove user and password spec from inventory
vim ./hosts
'
[VM]
VM-prometheus ansible_host=192.168.88.196
'

su - ansible
# or
su - <admin_user>


# Running playbooks
cd <ansible_folder>
ansible-playbook -vvD -l <hostname in inventory> <some_playbook>.yml

ansible-playbook -vvD <some_playbook>.yml --check
ansible-playbook -vvD <some_playbook>.yml

ansible-playbook -vvD id.yml --check
ansible-playbook -vvD id.yml
```
