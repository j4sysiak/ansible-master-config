czy można sprawdzić coś w postgresie np w konsolce Oracla zalogować się i utworzyć bazę test ?
Model
ThinkingThoughts
(experimental)
Auto
Expand to view model thoughts

chevron_right
Tak, oczywiście! To jest idealny sposób na weryfikację i dalszą naukę. Zalogowanie się do usługi, którą właśnie zainstalowałeś, i wykonanie w niej podstawowych operacji to kluczowy element pracy.
Pokażę Ci krok po kroku, jak to zrobić. Użyjemy do tego standardowych narzędzi wiersza poleceń Linuksa.
Krok 1: Połącz się ze swoim serwerem Oracle
To jest nasz punkt wyjścia. Użyj swojego terminala (np. PowerShell), aby zalogować się na serwer przez SSH.
code
Powershell
ssh -i "C:\Users\Jacek\.ssh\oracle_key.key" ubuntu@89.168.116.218
Krok 2: Zostań superużytkownikiem postgres
To jest najważniejszy i najbardziej nieoczywisty krok.
Podczas instalacji, PostgreSQL tworzy specjalnego użytkownika w systemie Linux o nazwie postgres. Domyślna konfiguracja bezpieczeństwa (nazywana peer authentication) działa w ten sposób, że aby zalogować się do bazy danych jako superużytkownik postgres, musisz najpierw być użytkownikiem postgres w systemie operacyjnym Linux.
Ty jesteś aktualnie zalogowany jako użytkownik ubuntu, więc musimy tymczasowo "przełączyć się" na użytkownika postgres.
Będąc zalogowanym na serwerze, wpisz następujące polecenie:
code
Bash
sudo -i -u postgres
sudo: Wykonaj jako administrator.
-i: Symuluj pełne logowanie (to ważne, bo ustawia poprawne środowisko).
-u postgres: Przełącz się na użytkownika postgres.
Zauważysz, że Twój wiersz poleceń się zmienił! Zamiast ubuntu@instance...:~$, zobaczysz coś w stylu:
postgres@instance...:~$
To oznacza, że teraz działasz jako systemowy użytkownik postgres.
Krok 3: Uruchom konsolę PostgreSQL (psql)
Teraz, gdy jesteś już "zaufanym" użytkownikiem, możesz wejść do konsoli bazy danych.
Wpisz proste polecenie:
code
Bash
psql
Ponieważ jesteś użytkownikiem postgres w Linuksie, psql automatycznie zaloguje Cię jako superużytkownik postgres w bazie danych, bez pytania o hasło.
Twój wiersz poleceń ponownie się zmieni i będzie wyglądał tak:
postgres=#
Ten znak # oznacza, że jesteś zalogowany jako superużytkownik. Jesteś teraz wewnątrz bazy danych i możesz wydawać polecenia SQL.
Krok 4: Utwórz bazę danych test
Teraz wykonamy proste polecenie SQL, aby stworzyć nową bazę danych.
W konsoli psql wpisz:
code
SQL
CREATE DATABASE test;
Pamiętaj o średniku (;) na końcu! Jest on wymagany do zakończenia polecenia SQL.
Po naciśnięciu Enter powinieneś zobaczyć komunikat: CREATE DATABASE.
Sprawdźmy, czy baza danych została utworzona. Użyjemy do tego specjalnego polecenia psql (zaczynającego się od \), aby wylistować wszystkie bazy danych:
code
Code
\l
(To jest mała litera L, skrót od \list).
Na liście, która się pojawi, powinieneś zobaczyć swoją nowo utworzoną bazę test!
Krok 5: Wyjdź z konsoli i wróć do swojego użytkownika
Aby wyjść z konsoli psql, wpisz:
code
Code
\q
(Skrót od \quit). To polecenie wróci Cię do wiersza poleceń Linuksa (postgres@...).
Aby wylogować się z użytkownika postgres i wrócić do swojego normalnego użytkownika ubuntu, wpisz:
code
Bash
exit
Twój wiersz poleceń powinien wrócić do ubuntu@....