W terminalu WSL (lub Intelij) aktywuj środowisko: 

source ~/ansible-venv/bin/activate

i odpal to:  ansible-galaxy collection install community.postgresql

------------------------------------------------------------------------------------
Teraz Twój cykl pracy (np. podczas testowania zmian) wygląda tak:
"Burzenie" starej konfiguracji (aby mieć czysty start):

# (w terminalu z aktywnym venv)
(ansible-venv) jacek@BERLIN:~/dev/ansible-master-config$ ansible-playbook playbooks/teardown.yml


"Budowanie" nowej, świeżej konfiguracji:
(ansible-venv) jacek@BERLIN:~/dev/ansible-master-config$ ansible-playbook playbooks/setup.yml



Weryfikacja
Wejdź na http://130.61.228.18 – powinieneś zobaczyć stronę Nginx.
Zaloguj się na serwer przez SSH i sprawdź:
sudo iptables -L INPUT – powinieneś zobaczyć wszystkie 3 reguły.
systemctl status postgresql – usługa powinna być active (running).

*****************************************************************************************************************
uruchamianie al'la molecule:   testowanie roli

 
 
(ansible-venv) jacek@BERLIN:  ansible-playbook playbooks/test_role.yml --extra-vars "test_role=influxdb"

--extra-vars "test_role=influxdb": To jest polecenie, które przekazuje zmienną z linii poleceń do naszego playbooka. 
Ansible podstawi influxdb w miejsce {{ test_role }}.
To polecenie uruchomi tylko zadania z roli influxdb na Twoim serwerze. To jest dokładnie to, co robi molecule converge.
