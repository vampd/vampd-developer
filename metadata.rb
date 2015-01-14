name             "vampd-developer"
maintainer       "Alex Knoll"
maintainer_email "arknoll@gmail.com"
license          "Apache 2.0"
description      "Installs/configures developer friendly tools"
version          "0.2.0"
recipe           "vampd-developer::default", "Installs/configures something"
recipe           "vampd-developer::codesniff", "Install php and drupal codesniffs"

depends 'php'
