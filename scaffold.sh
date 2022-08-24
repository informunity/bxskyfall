#!/usr/bin/env bash

main() {
    echo "[~] Start..."
    localDir
    add_composer
    git init
}

localDir() {
    mkdir 'local' && cd 'local'
    touch .env
    touch .gitignore && fillGitignore
    mkdir classes 
    mkdir classes/InformUnity

    mkdir php_interface 
    touch php_interface/init.php
    fillInit php_interface/init.php

    mkdir ajax
    mkdir js
    mkdir css

    mkdir components 
    mkdir components/iu

    mkdir templates
}

add_composer() {
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
    php composer-setup.php
    php -r "unlink('composer-setup.php');"

    cat > composer.json <<EOF
{
    "autoload": {
        "psr-4": {"InformUnity\\\\": "classes/informunity/"}
    },
    "require": {
        "arrilot/bitrix-migrations": "dev-master"
    },
    "repositories": [
        {
            "type": "vcs",
            "url":  "git@github.com:informunity/bitrix-migrations.git"
        }
    ]

}
EOF
    php composer.phar clear-cache
    php composer.phar selfupdate
    php composer.phar dump-autoload
    php composer.phar require vlucas/phpdotenv
    # php composer.phar require informunity/bitrix-migrations --dev
    php composer.phar require kint-php/kint --dev
    php composer.phar require nesbot/carbon

    cp vendor/arrilot/bitrix-migrations/migrator ./
    php migrator install
}

fillGitignore() {
    cat > .gitignore <<EOF
vendor
.env
EOF
}

fillInit() {
    FILE_WRITE=$1
    cat > $FILE_WRITE <<EOF
<?php
require \$_SERVER['DOCUMENT_ROOT'] . '/local/vendor/autoload.php';
\$dotenv = Dotenv\Dotenv::createImmutable(__DIR__.'/../');
\$dotenv->load();
EOF
}


## Main programm ##
main 