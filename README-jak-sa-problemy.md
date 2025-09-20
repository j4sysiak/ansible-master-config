(ansible-venv) jacek@BERLIN:~/dev/ansible-master-config$ ansible-playbook playbooks/setup.yml

PLAY [Apply common configuration to all hosts] *************************************************************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************************************************************************************
ok: [ubuntu-vm]

TASK [common : Update apt cache and install common packages] ***********************************************************************************************************************************************************
[WARNING]: Failed to update cache after 1 retries due to , retrying
[WARNING]: Sleeping for 2 seconds, before attempting to refresh the cache again
[WARNING]: Failed to update cache after 2 retries due to , retrying
[WARNING]: Sleeping for 3 seconds, before attempting to refresh the cache again
[WARNING]: Failed to update cache after 3 retries due to , retrying
[WARNING]: Sleeping for 5 seconds, before attempting to refresh the cache again
[WARNING]: Failed to update cache after 4 retries due to , retrying
[WARNING]: Sleeping for 9 seconds, before attempting to refresh the cache again
[WARNING]: Failed to update cache after 5 retries due to , retrying
[WARNING]: Sleeping for 13 seconds, before attempting to refresh the cache again
fatal: [ubuntu-vm]: FAILED! => {"changed": false, "msg": "Failed to update apt cache after 5 retries: "}

PLAY RECAP *************************************************************************************************************************************************************************************************************
ubuntu-vm                  : ok=1    changed=0    unreachable=0    failed=1    skipped=0    rescued=0    ignored=0   

(ansible-venv) jacek@BERLIN:~/dev/ansible-master-config$ ansible-playbook playbooks/setup.yml

PLAY [Apply common configuration to all hosts] *************************************************************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************************************************************************************
ok: [ubuntu-vm]

TASK [common : Update apt cache and install common packages] ***********************************************************************************************************************************************************
[WARNING]: Failed to update cache after 1 retries due to , retrying
[WARNING]: Sleeping for 2 seconds, before attempting to refresh the cache again
[WARNING]: Failed to update cache after 2 retries due to , retrying
[WARNING]: Sleeping for 3 seconds, before attempting to refresh the cache again
[WARNING]: Failed to update cache after 3 retries due to , retrying
[WARNING]: Sleeping for 5 seconds, before attempting to refresh the cache again
[WARNING]: Failed to update cache after 4 retries due to , retrying
[WARNING]: Sleeping for 9 seconds, before attempting to refresh the cache again
[WARNING]: Failed to update cache after 5 retries due to , retrying
[WARNING]: Sleeping for 13 seconds, before attempting to refresh the cache again


Usuń pliki repozytoriów. To jest kluczowy krok.

sudo rm -f /etc/apt/sources.list.d/influxdb.list
sudo rm -f /etc/apt/sources.list.d/influxdata.list # Na wszelki wypadek
Usuń plik klucza GPG.

sudo rm -f /usr/share/keyrings/influxdata-archive_compat.gpg
Uruchom apt update jeszcze raz.

sudo apt update