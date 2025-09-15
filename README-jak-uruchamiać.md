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
Wejdź na http://89.168.116.218 – powinieneś zobaczyć stronę Nginx.
Zaloguj się na serwer przez SSH i sprawdź:
sudo iptables -L INPUT – powinieneś zobaczyć wszystkie 3 reguły.
systemctl status postgresql – usługa powinna być active (running).

