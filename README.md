django_deploy
=============
Vagrant and chef cookbook for deploying django apps with nginx, gunicorn, memcache, celery ...

###### Steps for deploying on Windows (for local dev env):

1. Download and install [Git shell](git-scm.com/download/win)
2. Download and install [Vagrant](www.vagrantup.com/downloads.html)
3. Download and install [Virtualbox](https://www.virtualbox.org/wiki/Download_Old_Builds_4_3)
4. Download and install [Ruby](http://dl.bintray.com/oneclick/rubyinstaller/rubyinstaller-1.9.3-p545.exe?direct)
5. Download [Ruby Dev Kit](https://github.com/downloads/oneclick/rubyinstaller/DevKit-tdm-32-4.5.2-20111229-1559-sfx.exe)
6. Extract Ruby Dev Kit somewhere for permanent use
7. Position to extracted folder
8. Run cmd: ruby dk.rb init
9. Run cmd: ruby dk.rb install
10. Run Git Bash with admin privileges
11. Run cmd: gem install chef --no-ri --no-rdoc
12. Run cmd: gem install librarian
13. Run cmd: gem install librarian-chef
14. Run cmd: vagrant plugin install vagrant-omnibus
15. Run cmd: vagrant plugin install vagrant-librarian-chef
16. Run cmd: vagrant plugin install vagrant-vbguest
17. Choose path on disk for django_deploy repo from git
18. Run cmd: git clone https://github.com/devArena/django_deploy.git
19. Run cmd: cd django_deploy
20. Run cmd: librarian-chef install
21. Modify vagrantfile
22. Run cmd: vagrant up
