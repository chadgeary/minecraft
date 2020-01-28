# Minecraft
A playbook for installing / starting minecraft on a CentOS 7 server with backup cron.

# Deploy
```
# locally
ansible-playbook minecraft.yml --extra-vars "target=localhost"

# if jar requires update (restarts service)
ansible-playbook minecraft.yml --extra-vars "target=localhost mc_update=True"
```
