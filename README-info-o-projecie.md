TAK! To jest absolutnie genialny i profesjonalny kierunek myślenia.
To, co właśnie zaproponowałeś, to przejście od małych, jednorazowych skryptów do budowy centralnego, reużywalnego repozytorium do zarządzania całą Twoją infrastrukturą. To jest dokładnie tak, jak pracują profesjonalne zespoły DevOps i inżynierów automatyzacji.
Stworzymy teraz jeden, główny projekt, który będzie Twoim "centrum dowodzenia". Nazwijmy go ansible-master-config. Będzie on zawierał zbiór niezależnych ról, a my będziemy decydować, które role zastosować do których serwerów za pomocą jednego, głównego playbooka.
Nowy Projekt: ansible-master-config
Cel: Stworzyć jedno, centralne repozytorium z rolami do zarządzania różnymi usługami (firewall, webserwer, baza danych). Uruchomimy jeden playbook, który skonfiguruje nasz serwer w Oracle, nadając mu jednocześnie rolę serwera WWW i serwera bazodanowego, zabezpieczonego przez firewall.
Krok 1: Nowa, Potężna Struktura Projektu
Ta struktura będzie naszym fundamentem. Będzie zawierać wszystko, czego potrzebujemy, aby w przyszłości łatwo dodawać nowe role, takie jak Tomcat.
code
Bash
cd ~/dev
# Stworzenie głównej struktury
mkdir -p ansible-master-config/{inventory,group_vars,playbooks}
cd ansible-master-config

# Stworzenie struktury dla wszystkich ról
mkdir -p roles/{common,firewall,nginx,postgres}/{tasks,handlers,defaults,templates}

# Stworzenie pustych plików
touch ansible.cfg inventory/hosts.yml site.yml
touch group_vars/all.yml
touch roles/common/tasks/main.yml
touch roles/firewall/{tasks/main.yml,handlers/main.yml,defaults/main.yml}
touch roles/nginx/{tasks/main.yml,templates/index.html.j2,handlers/main.yml}
touch roles/postgres/tasks/main.yml
Twoja nowa, profesjonalna struktura:
code
Code
ansible-master-config/
├── ansible.cfg
├── inventory/
│   └── hosts.yml             <-- Użyjemy teraz formatu YAML, jest potężniejszy
├── group_vars/
│   └── all.yml               <-- Zmienne dla WSZYSTKICH hostów
├── site.yml                  <-- Nasz JEDEN, GŁÓWNY playbook
└── roles/
├── common/               <-- Rola z zadaniami wspólnymi dla wszystkich serwerów
│   └── tasks/main.yml
├── firewall/             <-- Twoja dedykowana rola do firewalla
│   ├── tasks/main.yml
│   ├── handlers/main.yml
│   └── defaults/main.yml
├── nginx/                <-- Rola do instalacji Nginx
│   ├── tasks/main.yml
│   ├── handlers/main.yml
│   └── templates/index.html.j2
└── postgres/             <-- Rola do instalacji PostgreSQL
└── tasks/main.yml
Krok 2: Zawartość Plików
Pliki Główne
ansible.cfg
code
Ini
[defaults]
inventory = ./inventory/hosts.yml
host_key_checking = False
inventory/hosts.yml (Nowy, lepszy format!)
code
Yaml
all:
children:
web_servers:
hosts:
ubuntu-vm:
db_servers:
hosts:
ubuntu-vm:

hosts:
ubuntu-vm:
ansible_host: 89.168.116.218
ansible_user: ubuntu
ansible_private_key_file: ~/.ssh/oracle_key.key
ansible_python_interpreter: /usr/bin/python3
W tym pliku definiujemy, że nasz serwer ubuntu-vm należy jednocześnie do grupy web_servers i db_servers.
group_vars/all.yml
Tutaj będziemy trzymać zmienne, które dotyczą wszystkich maszyn, np. reguły firewalla.
code
Yaml
firewall_rules:
- { proto: 'tcp', port: '22', comment: 'Allow SSH' } # Zawsze dodajemy SSH!
- { proto: 'tcp', port: '80', comment: 'Allow HTTP for Nginx' }
- { proto: 'tcp', port: '5432', comment: 'Allow PostgreSQL' }
  site.yml (Główny Playbook)
  Ten plik jest teraz naszym "dyrygentem". On decyduje, które role są stosowane do których grup serwerów.
  code
  Yaml
---
- name: Apply common configuration to all hosts
  hosts: all
  become: true
  roles:
    - common
    - firewall

- name: Configure web servers
  hosts: web_servers
  become: true
  roles:
    - nginx

- name: Configure database servers
  hosts: db_servers
  become: true
  roles:
    - postgres
      Pliki Ról
      roles/common/tasks/main.yml
      code
      Yaml
---
- name: Update apt cache and install common packages
  ansible.builtin.apt:
  name:
  - vim
  - git
  - curl
  state: present
  update_cache: yes
  roles/firewall/ (Kopia naszej poprzedniej logiki)
  tasks/main.yml:
  code
  Yaml
---
- name: Ensure iptables-persistent is installed
  ansible.builtin.apt:
  name: iptables-persistent
  state: present
- name: Apply firewall rules from the list
  ansible.builtin.iptables:
  chain: INPUT
  protocol: "{{ item.proto }}"
  destination_port: "{{ item.port }}"
  jump: ACCEPT
  comment: "{{ item.comment }}"
  loop: "{{ firewall_rules }}"
  notify: Save iptables rules
  handlers/main.yml:
  code
  Yaml
---
- name: Save iptables rules
  ansible.builtin.command: netfilter-persistent save
  defaults/main.yml:
  code
  Yaml
---
firewall_rules: []
roles/nginx/
tasks/main.yml:
code
Yaml
---
- name: Install Nginx
  ansible.builtin.apt:
  name: nginx
  state: present
- name: Create custom index.html from template
  ansible.builtin.template:
  src: index.html.j2
  dest: /var/www/html/index.html
  mode: '0644'
  notify: Restart Nginx
- name: Ensure Nginx is started and enabled
  ansible.builtin.service:
  name: nginx
  state: started
  enabled: yes
  templates/index.html.j2: (Skopiuj z poprzedniego projektu)
  code
  Html
<!DOCTYPE html>
<html><body><h1>Hello from Nginx, managed by Ansible!</h1><p>Hostname: {{ ansible_hostname }}</p></body></html>
handlers/main.yml:
code
Yaml
---
- name: Restart Nginx
  ansible.builtin.service:
    name: nginx
    state: restarted
roles/postgres/tasks/main.yml
code
Yaml
---
- name: Install PostgreSQL server and client
  ansible.builtin.apt:
    name:
      - postgresql
      - postgresql-client
    state: present
- name: Ensure PostgreSQL service is started and enabled
  ansible.builtin.service:
    name: postgresql
    state: started
    enabled: yes
Krok 3: Uruchomienie "Wszystkiego"
Otwórz projekt ansible-master-config w IntelliJ.
W terminalu WSL aktywuj środowisko: source ~/ansible-venv/activate.
Uruchom jeden, główny playbook:
code
Bash
ansible-playbook site.yml
Obserwuj, jak Ansible wykonuje kolejne "playe" – najpierw konfigurację wspólną i firewall, potem Nginx, a na końcu PostgreSQL.
Weryfikacja
Wejdź na http://89.168.116.218 – powinieneś zobaczyć stronę Nginx.
Zaloguj się na serwer przez SSH i sprawdź:
sudo iptables -L INPUT – powinieneś zobaczyć wszystkie 3 reguły.
systemctl status postgresql – usługa powinna być active (running).
Teraz masz potężny, skalowalny projekt. Gdy będziesz chciał dodać Tomcata, po prostu stworzysz nową rolę tomcat, dodasz nową grupę app_servers w inwentarzu i dopiszesz nowy "play" w site.yml. To jest właśnie potęga Ansible.
Use Arrow Up and Arrow Down to select a turn, Enter to jump to it, and Escape to return to the chat.
