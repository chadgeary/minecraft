# Minecraft
A playbook for installing / starting minecraft on RHEL/CentOS 7 server with backup cron.

# Install ansible
```
sudo yum -y install ansible
```

# Deploy
```
# locally - install ansible if not installed
ansible-playbook minecraft.yml --extra-vars "target=localhost"

# alternatively, update minecraft to the latest version (restarts service)
ansible-playbook minecraft.yml --extra-vars "target=localhost mc_update=True"
```
