CREATE TABLE IF NOT EXISTS `db`.`USERS` (

    ID INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    EMAIL VARCHAR(255) NOT NULL UNIQUE,
    PWD VARCHAR(255) NOT NULL,
    CONFIRMED BOOLEAN DEFAULT false
);

CREATE TABLE IF NOT EXISTS `db`.`TOKENS` (

    ID INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    USER_ID INT UNSIGNED NOT NULL,
    TOKEN TEXT NOT NULL,
    CREATION_TIME TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONFIRMATION_TIME TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    IP_ADDRESS VARCHAR(255) DEFAULT false,
    USER_AGENT VARCHAR(255) DEFAULT false,
    FOREIGN KEY (USER_ID) REFERENCES USERS(ID)
);

INSERT INTO `db`.`USERS` (EMAIL, PWD, CONFIRMED) VALUES ('john@gmail.com', '$2y$10$.vGA1O9wmRjrwAVXD98HNOgsNpDczlqm3Jq7KnEd1rVAGv3Fykk1a', true);
INSERT INTO `db`.`USERS` (EMAIL, PWD, CONFIRMED) VALUES ('benjamin@gmail.com', '$2y$10$.vGA1O9wmRjrwAVXD98HNOgsNpDczlqm3Jq7KnEd1rVAGv3Fykk1a', false);