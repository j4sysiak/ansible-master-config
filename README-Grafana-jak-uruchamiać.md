1.
# source ~/ansible-venv/bin/activate

2.
# (ansible-venv) jacek@BERLIN:~/dev/ansible-master-config$ ansible-playbook playbooks/teardown.yml

3.
# (ansible-venv) jacek@BERLIN:~/dev/ansible-master-config$ ansible-playbook playbooks/setup.yml


3. lub tylko grafana - ale przedtem wyczyść środowisko
# ansible-playbook playbooks/test_role.yml --extra-vars "test_role=apt-fix"
# ansible-playbook playbooks/test_role.yml --extra-vars "test_role=grafana"

Weryfikacja (Moment Prawdy):
Otwórz przeglądarkę i wejdź na adres: http://130.61.228.18:3000
Powinieneś zobaczyć ekran logowania Grafany.
Zaloguj się, używając danych:    (\ansible-master-config\roles\grafana\defaults\main.yml)
User: jacek
Password: jacekjacek

Po zalogowaniu, przejdź do Connections -> Data sources.
Powinieneś zobaczyć źródło danych InfluxDB_Ansible już skonfigurowane i działające!
Możesz teraz przejść do Dashboards -> New dashboard -> Add visualization, wybrać InfluxDB_Ansible i zacząć budować swój pierwszy wykres, np. z użyciem CPU zebranym przez Telegrafa.