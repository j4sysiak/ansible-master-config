1.
# source ~/ansible-venv/bin/activate

2. Doinstaluj kolekcję community.docker. W Twoim środowisku WSL (venv):
# ansible-galaxy collection install community.docker --force

3.
# (ansible-venv) jacek@BERLIN:~/dev/ansible-master-config$ ansible-playbook playbooks/teardown.yml

Tagi: Dodałem tag docker do wszystkich tych zadań. 
Dzięki temu, jeśli w przyszłości będziesz chciał wyczyścić tylko i wyłącznie Dockera, będziesz mógł uruchomić:
# (ansible-venv) jacek@BERLIN:~/dev/ansible-master-config$ ansible-playbook playbooks/teardown.yml --tags "docker"

4
# (ansible-venv) jacek@BERLIN:~/dev/ansible-master-config$ ansible-playbook playbooks/setup.yml

Tagi: Dodałem tag docker do wszystkich tych zadań. 
Dzięki temu, jeśli w przyszłości będziesz chciał wyczyścić tylko i wyłącznie Dockera, będziesz mógł uruchomić:
# (ansible-venv) jacek@BERLIN:~/dev/ansible-master-config$ ansible-playbook playbooks/setup.yml --tags "docker"

# *****************************   checking *****************************
1.
Nasza rola dodała użytkownika ubuntu do grupy docker. Ta zmiana nie jest widoczna w Twojej obecnej, aktywnej sesji SSH. 
Aby uprawnienia zaczęły działać, musisz się wylogować i zalogować ponownie.

2.
systemctl status docker

3.
docker --version

4.
docker run hello-world


