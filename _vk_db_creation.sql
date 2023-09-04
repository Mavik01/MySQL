DROP DATABASE IF EXISTS vk;
CREATE DATABASE vk;
USE vk;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
    firstname VARCHAR(50),
    lastname VARCHAR(50) COMMENT 'Фамиль', -- COMMENT на случай, если имя неочевидное
    email VARCHAR(120) UNIQUE,
 	password_hash VARCHAR(100), -- 123456 => vzx;clvgkajrpo9udfxvsldkrn24l5456345t
	phone BIGINT UNSIGNED UNIQUE, 
	
    INDEX users_firstname_lastname_idx(firstname, lastname)
) COMMENT 'юзеры';

/*3. Заполнить 2 таблицы БД vk данными (по 10 записей в каждой таблице) (INSERT)*/

-- Добавляем информацию в поле Users
INSERT INTO `users` 
VALUES ('1','Иванов','Иван','ivan.ivan@yandex.ru','1','89222222222'),
    ('2','Петров','Петр','petrov.petr@yandex.ru','2','89111111111'),
    ('3','Петрова','Евгения','petrova.e@yandex.ru','3','89000000000'),
    ('4','Сидорова','Юлия','sidorova.uliya@yandex.ru','4','89333333333'),
    ('5','Козлов','Александр','kozlov.alexandr@yandex.ru','5','89444444444'),
    ('6','Козлова','Валя','kozlova.valya@yandex.ru','6','89555555555'),
    ('7','Майоров','Владимир','mayorov.vladimir@yandex.ru','7','89666666666'),
    ('8','Майорова','Елизавета','mayorova.elizaveta@yandex.ru','8','89777777777'),
    ('9','Королева','Наташа','koroleva.natasha@yandex.ru','9','89888888888'),
    ('10','Ирина','Алегрова','irina.alegrova@yandex.ru','10','89999999999');

DROP TABLE IF EXISTS `profiles`;
CREATE TABLE `profiles` (
	user_id BIGINT UNSIGNED NOT NULL UNIQUE,
    gender CHAR(1),
    birthday DATE,
	photo_id BIGINT UNSIGNED NULL,
    created_at DATETIME DEFAULT NOW(),
    hometown VARCHAR(100)
	
    -- , FOREIGN KEY (photo_id) REFERENCES media(id) -- пока рано, т.к. таблицы media еще нет
);

/* Добавляем информацию в поле profiles. Честно я так и не разобрался, почему у меня тут выдает ошибку. Подозреваю, что из за пола,
но тогда надо будет делать еще одну новую таблицу где надо будет задавать значения для строки "gender CHAR(1),"? 
В общем пока развожу руки в сторону и не понимаю что мне надо тут делать:( */

INSERT INTO `profiles` 
VALUES ('1','М','2000-01-11',NULL,NOW(),'Москва'),
    ('2','М','2002-02-12',NULL,NOW(),'Тула'),
    ('3','Ж','2001-03-13',NULL,NOW(),'Рязань'),
    ('4','Ж','2019-04-14',NULL,NOW(),'Киров'),
    ('5','М','2014-05-15',NULL,NOW(),'Псков'),
    ('6','Ж','2007-06-16',NULL,NOW(),'Архангельск'),
    ('7','М','2005-07-27',NULL,NOW(),'Санкт-Петербург'),
    ('8','Ж','2010-08-01',NULL,NOW(),'Владивосток'),
    ('9','Ж','2015-09-05',NULL,NOW(),'Воркута'),
    ('10','Ж','2016-10-07',NULL,NOW(),'Севастополь');
   

/*4. Написать скрипт, отмечающий несовершеннолетних пользователей как неактивных (поле is_active = true). 
При необходимости предварительно добавить такое поле в таблицу profiles со значением по умолчанию = false (или 0) (ALTER TABLE + UPDATE)*/

ALTER TABLE profiles 
ADD COLUMN is_active 
BOOLEAN NOT NULL DEFAULT false;


UPDATE profiles
SET is_active = true
WHERE TIMESTAMPDIFF(YEAR, birthday, CURDATE()) >= 18


ALTER TABLE `profiles` ADD CONSTRAINT fk_user_id
    FOREIGN KEY (user_id) REFERENCES users(id)
    ON UPDATE CASCADE -- (значение по умолчанию)
    ON DELETE RESTRICT; -- (значение по умолчанию)

DROP TABLE IF EXISTS messages;
CREATE TABLE messages (
	id SERIAL, -- SERIAL = BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE
	from_user_id BIGINT UNSIGNED NOT NULL,
    to_user_id BIGINT UNSIGNED NOT NULL,
    body TEXT,
    created_at DATETIME DEFAULT NOW(), -- можно будет даже не упоминать это поле при вставке

    FOREIGN KEY (from_user_id) REFERENCES users(id),
    FOREIGN KEY (to_user_id) REFERENCES users(id)
);


/*5. Написать скрипт, удаляющий сообщения «из будущего» (дата позже сегодняшней) (DELETE)*/
INSERT INTO messages (id, from_user, to_user, messages, created_at) 
VALUES (NULL, '1', '1', '2', 'Тестовое сообщение', '2023-09-04'), 
(NULL, '2', '3', '4', 'Тест старое сообщение', '2023-01-01'), 
(NULL, '3', '3', '4', 'Тест сообщение из будущего!', '2024-01-01');

DELETE FROM messages WHERE created_at > NOW();

DROP TABLE IF EXISTS friend_requests;
CREATE TABLE friend_requests (
	-- id SERIAL, -- изменили на составной ключ (initiator_user_id, target_user_id)
	initiator_user_id BIGINT UNSIGNED NOT NULL,
    target_user_id BIGINT UNSIGNED NOT NULL,
    `status` ENUM('requested', 'approved', 'declined', 'unfriended'), # DEFAULT 'requested',
    -- `status` TINYINT(1) UNSIGNED, -- в этом случае в коде хранили бы цифирный enum (0, 1, 2, 3...)
	requested_at DATETIME DEFAULT NOW(),
	updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP, -- можно будет даже не упоминать это поле при обновлении
	
    PRIMARY KEY (initiator_user_id, target_user_id),
    FOREIGN KEY (initiator_user_id) REFERENCES users(id),
    FOREIGN KEY (target_user_id) REFERENCES users(id)-- ,
    -- CHECK (initiator_user_id <> target_user_id)
);
-- чтобы пользователь сам себе не отправил запрос в друзья
-- ALTER TABLE friend_requests 
-- ADD CHECK(initiator_user_id <> target_user_id);

DROP TABLE IF EXISTS communities;
CREATE TABLE communities(
	id SERIAL,
	name VARCHAR(150),
	admin_user_id BIGINT UNSIGNED NOT NULL,
	
	INDEX communities_name_idx(name), -- индексу можно давать свое имя (communities_name_idx)
	FOREIGN KEY (admin_user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS users_communities;
CREATE TABLE users_communities(
	user_id BIGINT UNSIGNED NOT NULL,
	community_id BIGINT UNSIGNED NOT NULL,
  
	PRIMARY KEY (user_id, community_id), -- чтобы не было 2 записей о пользователе и сообществе
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (community_id) REFERENCES communities(id)
);

DROP TABLE IF EXISTS media_types;
CREATE TABLE media_types(
	id SERIAL,
    name VARCHAR(255), -- записей мало, поэтому в индексе нет необходимости
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS media;
CREATE TABLE media(
	id SERIAL,
    media_type_id BIGINT UNSIGNED NOT NULL,
    user_id BIGINT UNSIGNED NOT NULL,
  	body VARCHAR(255),
    filename VARCHAR(255),
    -- file BLOB,    	
    size INT,
	metadata JSON,
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (media_type_id) REFERENCES media_types(id)
);

DROP TABLE IF EXISTS likes;
CREATE TABLE likes(
	id SERIAL,
    user_id BIGINT UNSIGNED NOT NULL,
    media_id BIGINT UNSIGNED NOT NULL,
    created_at DATETIME DEFAULT NOW()

    -- PRIMARY KEY (user_id, media_id) – можно было и так вместо id в качестве PK
  	-- слишком увлекаться индексами тоже опасно, рациональнее их добавлять по мере необходимости (напр., провисают по времени какие-то запросы)  

/* намеренно забыли, чтобы позднее увидеть их отсутствие в ER-диаграмме
    , FOREIGN KEY (user_id) REFERENCES users(id)
    , FOREIGN KEY (media_id) REFERENCES media(id)
*/
);

/*2. Написать скрипт, добавляющий в созданную БД vk 2-3 новые таблицы (с перечнем полей, указанием индексов и внешних ключей) (CREATE TABLE)*/

DROP TABLE IF EXISTS comment;
CREATE TABLE comment (
    id SERIAL,
    user_id BIGINT UNSIGNED NOT NULL,
    body TEXT,
    created_at DATETIME DEFAULT NOW(), -- можно будет даже не упоминать это поле при вставке

    FOREIGN KEY (user_id) REFERENCES users(id)
) COMMENT 'комментарий к медиа файлу';

DROP TABLE IF EXISTS comment_to_media;
CREATE TABLE comment_to_media (
    id SERIAL,
    media_id BIGINT UNSIGNED NOT NULL,
    comment_id BIGINT UNSIGNED NOT NULL,

    FOREIGN KEY (media_id) REFERENCES media(id),
    FOREIGN KEY (comment_id) REFERENCES comment(id)
) COMMENT 'связь media и comment';

ALTER TABLE vk.likes 
ADD CONSTRAINT likes_fk 
FOREIGN KEY (media_id) REFERENCES vk.media(id);

ALTER TABLE vk.likes 
ADD CONSTRAINT likes_fk_1 
FOREIGN KEY (user_id) REFERENCES vk.users(id);

ALTER TABLE vk.profiles 
ADD CONSTRAINT profiles_fk_1 
FOREIGN KEY (photo_id) REFERENCES media(id);