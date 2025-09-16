czy można sprawdzić coś w postgresie np w konsolce Oracla zalogować się i utworzyć bazę test ?
 
Tak, oczywiście! To jest idealny sposób na weryfikację i dalszą naukę. Zalogowanie się do usługi, którą właśnie zainstalowałeś, i wykonanie w niej podstawowych operacji to kluczowy element pracy.
Pokażę Ci krok po kroku, jak to zrobić. Użyjemy do tego standardowych narzędzi wiersza poleceń Linuksa.
Krok 1: Połącz się ze swoim serwerem Oracle
To jest nasz punkt wyjścia. Użyj swojego terminala (np. PowerShell), aby zalogować się na serwer przez SSH.
 
ssh -i "C:\Users\Jacek\.ssh\oracle_key.key" ubuntu@89.168.116.218


Krok 2: Zostań superużytkownikiem postgres
 
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
 
psql

 
Krok 4: Utwórz bazę danych test

Teraz wykonamy proste polecenie SQL, aby stworzyć nową bazę danych.
W konsoli psql wpisz:
 
CREATE DATABASE test;

 
\l
(To jest mała litera L, skrót od \list).
Na liście, która się pojawi, powinieneś zobaczyć swoją nowo utworzoną bazę test!


Krok 5: Wyjdź z konsoli i wróć do swojego użytkownika
Aby wyjść z konsoli psql, wpisz:
 
\q
(Skrót od \quit). To polecenie wróci Cię do wiersza poleceń Linuksa (postgres@...).
Aby wylogować się z użytkownika postgres i wrócić do swojego normalnego użytkownika ubuntu, wpisz:
 
exit

Twój wiersz poleceń powinien wrócić do ubuntu@....



////////////////////////////////////////////////////////////////////////



Metoda 1: Logowanie jako Nowy Użytkownik ansible_admin (Rekomendowana)
Ta metoda potwierdzi, że nasza nowa konfiguracja z hasłem działa.
Zaloguj się na swój serwer w Oracle przez SSH (jeśli jeszcze nie jesteś zalogowany):
code
Powershell
ssh -i "C:\Users\Jacek\.ssh\oracle_key.key" ubuntu@89.168.116.218
Teraz, będąc zalogowanym jako ubuntu, uruchomimy konsolę psql i poprosimy o zalogowanie się jako nasz nowy superużytkownik ansible_admin:
 
psql -U ansible_admin -d postgres -W

-U ansible_admin: Połącz jako użytkownik ansible_admin.
-d postgres: Połącz się z domyślną bazą administracyjną postgres.
-W: Wymuś pytanie o hasło.

System poprosi Cię o hasło: Password for user ansible_admin:. Wpisz hasło, które zdefiniowaliśmy w playbooku:
SuperSecurePassword123!
(Pamiętaj, że podczas wpisywania hasła w terminalu nic nie będzie widać). Naciśnij Enter.
Jeśli wszystko poszło dobrze, Twój wiersz poleceń zmieni się na:
postgres=> lub postgres=#
Jesteś teraz zalogowany do bazy danych!
Wykonaj polecenie listowania baz danych:

Wykonaj polecenie listowania baz danych:
 
\l


postgres-# \l
List of databases
Name    |     Owner     | Encoding | Collate |  Ctype  |   Access privileges
-----------+---------------+----------+---------+---------+-----------------------
postgres  | postgres      | UTF8     | C.UTF-8 | C.UTF-8 |
template0 | postgres      | UTF8     | C.UTF-8 | C.UTF-8 | =c/postgres          +
|               |          |         |         | postgres=CTc/postgres
template1 | postgres      | UTF8     | C.UTF-8 | C.UTF-8 | =c/postgres          +
|               |          |         |         | postgres=CTc/postgres
test      | ansible_admin | UTF8     | C.UTF-8 | C.UTF-8 |
(4 rows)

postgres-#



Ta metoda sprawdzi, czy peer authentication nadal działa dla użytkownika postgres.
Będąc zalogowanym na serwerze jako ubuntu, przełącz się na użytkownika postgres:
 
sudo -i -u postgres
Uruchom konsolę psql:
 
psql
Wykonaj polecenie listowania baz danych:
 
\l
Na liście również powinieneś zobaczyć bazę test.
Wyjdź z psql (\q) i z sesji użytkownika postgres (exit).
