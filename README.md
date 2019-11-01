# ansible
ansible playground

# install dependencies:

## roles
```sh
ansible-galaxy install -r requirements.yml
```

## docker
```sh
sudo apt-get install python-docker
```

# run
there are different possibilities

## complete
this will setup, install and upgrade target hosts
### on local hosts only
```sh
ansible-playbook -v -i inventories/local.yml playbook_complete.yml
```

### on remote hosts only
```sh
ansible-playbook -v -i inventories/remote.yml playbook_complete.yml
```

### on local and remote hosts only
```sh
ansible-playbook -v -i inventories/local.yml -i inventories/remote.yml playbook_complete.yml
```

## only apt upgrade
this will upgrade target hosts
see inventory usage above
```sh
ansible-playbook -v -i inventories/local.yml playbook_upgrade.yml
```
