name              'django_deploy'
maintainer        'devarena'
maintainer_email  'vedran.ivanac@gmail.com'
license           'Apache 2.0'
description       'Installs django app with nginx, psql, gunicorn, celery, memcache'
version           '0.1.1'

depends "apt"
depends "git"
depends "vim"
depends "nginx"
depends "postgresql"
depends "database"
depends "application"
depends "application_python"
