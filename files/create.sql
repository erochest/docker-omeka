
CREATE USER 'omeka'@'localhost' IDENTIFIED BY 'omeka';
CREATE USER 'omeka'@'%' IDENTIFIED BY 'omeka';

CREATE DATABASE omeka CHARACTER SET='utf8' COLLATE='utf8_unicode_ci';

GRANT ALL PRIVILEGES ON omeka.* TO 'omeka'@'localhost';
GRANT ALL PRIVILEGES ON omeka.* TO 'omeka'@'%';

CREATE DATABASE test_omeka CHARACTER SET='utf8' COLLATE='utf8_unicode_ci';

GRANT ALL PRIVILEGES ON test_omeka.* TO 'omeka'@'localhost';
GRANT ALL PRIVILEGES ON test_omeka.* TO 'omeka'@'%';
