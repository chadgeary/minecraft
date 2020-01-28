# Minecraft
<<<<<<< HEAD
A playbook for installing / starting minecraft on a CentOS 7 server with backup cron.
=======
Ansible playbook for installing / starting minecraft on a CentOS 7 server.
>>>>>>> 6a3b248b4a3185739084acca45030c195cc4f29a

# Deploy
```
# locally
ansible-playbook minecraft.yml --extra-vars "target=localhost"

# if jar requires update (restarts service)
ansible-playbook minecraft.yml --extra-vars "target=localhost mc_update=True"
```
