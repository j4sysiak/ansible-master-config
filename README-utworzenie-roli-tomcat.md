
Model
Doskonale! Zaczynamy budowę naszej najbardziej zaawansowanej roli. Będziemy tworzyć pliki krok po kroku, a ja będę wyjaśniał, co robi każda część.
Krok 4: Budowa Roli tomcat
1. Zmienne Domyślne (defaults/main.yml)
Najpierw zdefiniujmy kilka zmiennych, aby nasza rola była elastyczna. Dzięki temu, jeśli w przyszłości wyjdzie nowa wersja Tomcata, wystarczy, że zmienisz numer wersji w jednym miejscu.
Plik: roles/tomcat/defaults/main.yml

---
# Wersja Tomcata, którą chcemy zainstalować
tomcat_version: "10.1.31"
tomcat_major_version: "10"

# Użytkownik i grupa, jako które będzie działał Tomcat
tomcat_user: "tomcat"
tomcat_group: "tomcat"

# Ścieżka instalacji
tomcat_install_dir: "/opt/tomcat"

# Wersja Javy do zainstalowania
java_package: "openjdk-17-jdk"
2. Plik Usługi Systemd (templates/tomcat.service.j2)
To jest szablon, na podstawie którego Ansible stworzy plik usługi dla systemd. Dzięki niemu będziemy mogli zarządzać Tomcatem jak każdą inną usługą systemową (systemctl start tomcat, systemctl enable tomcat itd.).
Plik: roles/tomcat/templates/tomcat.service.j2

Description=Apache Tomcat Web Application Container
After=network.target

[Service]
Type=forking

User={{ tomcat_user }}
Group={{ tomcat_group }}

Environment="JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64"
Environment="CATALINA_PID={{ tomcat_install_dir }}/temp/tomcat.pid"
Environment="CATALINA_HOME={{ tomcat_install_dir }}"
Environment="CATALINA_BASE={{ tomcat_install_dir }}"
Environment="CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC"
Environment="JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom"

ExecStart={{ tomcat_install_dir }}/bin/startup.sh
ExecStop={{ tomcat_install_dir }}/bin/shutdown.sh

RestartSec=10
Restart=always

[Install]
WantedBy=multi-user.target
Zwróć uwagę, jak używamy zmiennych ({{ tomcat_user }}, {{ tomcat_install_dir }}) zdefiniowanych w defaults/main.yml, aby ten plik był uniwersalny.
3. Zadania (tasks/main.yml)
To jest serce naszej roli. Wykonamy tu wszystkie kroki: instalację Javy, stworzenie użytkownika, pobranie i rozpakowanie Tomcata, wdrożenie aplikacji i skonfigurowanie usługi.
Plik: roles/tomcat/tasks/main.yml (wklejaj sekcjami, żeby zrozumieć)
code
Yaml
---
# === ETAP 1: INSTALACJA ZALEŻNOŚCI ===
- name: Install Java JDK
  ansible.builtin.apt:
    name: "{{ java_package }}"
    state: present
    update_cache: yes

# === ETAP 2: STWORZENIE UŻYTKOWNIKA I GRUPY ===
- name: Create a tomcat group
  ansible.builtin.group:
    name: "{{ tomcat_group }}"
    state: present

- name: Create a tomcat user
  ansible.builtin.user:
    name: "{{ tomcat_user }}"
    group: "{{ tomcat_group }}"
    home: "{{ tomcat_install_dir }}"
    shell: /bin/false
    state: present

# === ETAP 3: POBRANIE I INSTALACJA TOMCATA ===
- name: Download and unarchive Tomcat
  ansible.builtin.unarchive:
    src: "https://dlcdn.apache.org/tomcat/tomcat-{{ tomcat_major_version }}/v{{ tomcat_version }}/bin/apache-tomcat-{{ tomcat_version }}.tar.gz"
    dest: "/opt/"
    remote_src: yes
    creates: "/opt/apache-tomcat-{{ tomcat_version }}"

- name: Create a symbolic link to the installation directory
  ansible.builtin.file:
    src: "/opt/apache-tomcat-{{ tomcat_version }}"
    dest: "{{ tomcat_install_dir }}"
    state: link
    owner: "{{ tomcat_user }}"
    group: "{{ tomcat_group }}"

- name: Change ownership of Tomcat directory
  ansible.builtin.file:
    path: "{{ tomcat_install_dir }}"
    state: directory
    owner: "{{ tomcat_user }}"
    group: "{{ tomcat_group }}"
    recurse: yes

# === ETAP 4: KONFIGURACJA USŁUGI I WDROŻENIE APLIKACJI ===
- name: Create a systemd service file for Tomcat
  ansible.builtin.template:
    src: tomcat.service.j2
    dest: /etc/systemd/system/tomcat.service
    mode: '0644'
  notify: Reload systemd and restart Tomcat

- name: Deploy sample WAR application
  ansible.builtin.copy:
    src: sample.war
    dest: "{{ tomcat_install_dir }}/webapps/sample.war"
    owner: "{{ tomcat_user }}"
    group: "{{ tomcat_group }}"
  notify: Restart Tomcat

- name: Start and enable the Tomcat service
  ansible.builtin.service:
    name: tomcat
    state: started
    enabled: yes
4. Handlery (do restartowania usług)
Musimy stworzyć plik handlers/main.yml, aby obsłużyć notify z naszych zadań.
Plik: roles/tomcat/handlers/main.yml
code
Yaml
---
- name: Restart Tomcat
  ansible.builtin.service:
    name: tomcat
    state: restarted

- name: Reload systemd and restart Tomcat
  ansible.builtin.systemd:
    daemon_reload: yes
  notify: Restart Tomcat
Zauważ sprytny trik: handler Reload systemd... sam powiadamia handlera Restart Tomcat. To zapewnia, że usługa jest restartowana po przeładowaniu systemd.
Krok 5: Ostateczne Uruchomienie
Wszystko jest gotowe.
Upewnij się, że wszystkie pliki są zapisane.
W terminalu WSL, w głównym katalogu projektu ansible-master-config, z aktywnym venv, uruchom główny playbook:
code
Bash
ansible-playbook playbooks/setup.yml
Pamiętaj, aby wcześniej dodać tomcat do setup.yml i 8080 do group_vars/all.yml!
Krok 6: Weryfikacja
Playbook powinien zakończyć się sukcesem.
Otwórz przeglądarkę i wejdź na adres:
http://TWOJ_ADRES_IP:8080/sample/
Czyli: http://89.168.116.218:8080/sample/
Powinieneś zobaczyć stronę powitalną Jenkinsa! (Wdrożenie Jenkinsa może chwilę potrwać, więc jeśli zobaczysz błąd 404, odczekaj minutę i odśwież stronę).
To jest kompletny, profesjonalny cykl wdrożenia aplikacji serwerowej. Powodzenia
Use Arrow Up and Arrow Down to select a turn, Enter to jump to it, and Escape to return to the chat.
