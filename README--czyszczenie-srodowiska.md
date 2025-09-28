Doskonale! Zakończenie teardown.yml bez błędu to świetna wiadomość. Oznacza to, że proces "czyszczenia" serwera przebiegł pomyślnie.
Teraz, aby mieć 100% pewności, że serwer jest "dziewiczy" i gotowy na nową, czystą instalację, wykonajmy serię prostych sprawdzeń.
Plan Weryfikacji (po teardown.yml)
Zaloguj się na swój serwer w Oracle przez SSH i wykonaj te polecenia. Oczekujemy, że większość z nich zwróci błąd "nie znaleziono" – to będzie nasz dowód sukcesu.
1. Sprawdź Usługi
   Sprawdźmy, czy wszystkie kluczowe usługi, które instalowaliśmy, zostały zatrzymane i wyłączone.
   code
   Bash
   systemctl status nginx
   systemctl status tomcat
   systemctl status postgresql
   systemctl status influxdb
   systemctl status influxdb-legacy
   systemctl status grafana-server
   systemctl status telegraf
   systemctl status docker
   Oczekiwany wynik: Dla każdej z tych komend powinieneś zobaczyć komunikat w stylu Unit ... could not be found. lub Loaded: not-found (Reason: Unit ... not found). To potwierdzi, że pliki usług zostały usunięte.
2. Sprawdź Pakiety
   Sprawdźmy, czy pakiety zostały odinstalowane.
   code
   Bash
   dpkg -l | grep nginx
   dpkg -l | grep postgresql
   dpkg -l | grep influxdb
   dpkg -l | grep grafana
   dpkg -l | grep telegraf
   dpkg -l | grep docker-ce
   Oczekiwany wynik: Każde z tych poleceń powinno zwrócić pusty wynik. Jeśli coś zostanie znalezione, oznacza to, że apt purge nie zadziałał w 100%.
3. Sprawdź Kluczowe Katalogi i Pliki
   Sprawdźmy, czy nasze role teardown poprawnie usunęły katalogi.
   code
   Bash
   ls -l /opt/tomcat
   ls -l /opt/influxdb
   ls -l /usr/share/grafana
   ls -l /etc/nginx/sites-enabled/default
   ls -l /etc/apt/sources.list.d/influxdb.list
   ls -l /etc/apt/sources.list.d/grafana.list
   Oczekiwany wynik: Dla każdego z tych poleceń powinieneś zobaczyć błąd ls: cannot access '...': No such file or directory.
4. Sprawdź Firewall
   Sprawdźmy, czy iptables został wyczyszczony.
   code
   Bash
   sudo iptables -L INPUT
   Oczekiwany wynik: Powinieneś zobaczyć prawie pustą listę reguł, bez naszych wpisów ACCEPT dla portów 80, 8080 itd.