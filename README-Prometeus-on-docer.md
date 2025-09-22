1.
# source ~/ansible-venv/bin/activate

2. Doinstaluj kolekcję community.docker. W Twoim środowisku WSL (venv):
# ansible-galaxy collection install community.docker --force

3.
# (ansible-venv) jacek@BERLIN:~/dev/ansible-master-config$ ansible-playbook playbooks/teardown.yml

Tagi: Dodałem tag prometheus do wszystkich tych zadań. 
Dzięki temu, jeśli w przyszłości będziesz chciał wyczyścić tylko i wyłącznie Dockera, będziesz mógł uruchomić:
# (ansible-venv) jacek@BERLIN:~/dev/ansible-master-config$ ansible-playbook playbooks/teardown.yml --tags "prometheus"
 

4
# (ansible-venv) jacek@BERLIN:~/dev/ansible-master-config$ ansible-playbook playbooks/setup.yml

Tagi: Dodałem tag prometheus do wszystkich tych zadań. 
Dzięki temu, jeśli w przyszłości będziesz chciał wyczyścić tylko i wyłącznie Dockera, będziesz mógł uruchomić:
# (ansible-venv) jacek@BERLIN:~/dev/ansible-master-config$ ansible-playbook playbooks/setup.yml --tags "prometheus"


# ************************************  Weryfikacja *********************************************

1.
Zaloguj się na serwer i wpisz docker ps. 
Powinieneś zobaczyć działający kontener prometheus-server.

Wielki finał: Otwórz przeglądarkę i wejdź na adres:
http://130.61.228.18:9090
Powinieneś zobaczyć interfejs webowy Prometheusa! 
Możesz wejść w Status -> Targets i zobaczysz, że Prometheus poprawnie monitoruje sam siebie.


# **********************************************************************************************
Co dalej? (Jak sprawdzić, czy zbiera dane)
Teraz, gdy masz już interfejs, wykonajmy ostatni, mały test, aby zobaczyć magię w akcji.

W menu na górze, kliknij na Status, a następnie z rozwijanej listy wybierz Targets.

Na stronie, która się otworzy, powinieneś zobaczyć jeden "cel" w sekcji "prometheus". 

Jego State (Stan) powinien być UP (na zielono).
To jest dowód na to, że Twoja konfiguracja (prometheus.yml) działa, 
    a Prometheus poprawnie monitoruje sam siebie, zbierając metryki o swoim własnym działaniu.