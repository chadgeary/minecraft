# Minecraft
A playbook for installing / starting minecraft on RHEL/CentOS 7 server with backup cron.

# Install ansible/git
```
# Ubuntu/Debian
sudo apt update && sudo apt install ansible git

# CentOS/RedHat
sudo yum -y install ansible git
```

# Deploy
```
# clone
git clone https://github.com/chadgeary/minecraft && cd minecraft

# run locally - install ansible if not installed
ansible-playbook minecraft.yml --extra-vars "target=localhost"

# alternatively, update minecraft to the latest version (restarts service)
ansible-playbook minecraft.yml --extra-vars "target=localhost mc_update=True"
```
