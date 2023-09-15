/* 1. Создайте представление с произвольным SELECT-запросом из прошлых уроков [CREATE VIEW]. */
CREATE VIEW `vk`.`it_profiles` AS
SELECT *
FROM `vk`.`profiles` 
WHERE gender = 'm' 
    AND TIMESTAMPDIFF(YEAR, birthday, NOW()) > '35';

/* 2. Выведите данные, используя написанное представление [SELECT]. */
SELECT *
FROM `vk`.`it_profiles`

/* 3. Удалите представление [DROP VIEW]. */
DROP VIEW `vk`.`it_profiles`

/* 4. Сколько новостей (записей в таблице media) у каждого пользователя? 
Вывести поля: news_count (количество новостей), user_id (номер пользователя), user_email (email пользователя). 
Попробовать решить с помощью CTE или с помощью обычного JOIN.. */
WITH CTE AS (
    SELECT user_id, count(id) news_count
    FROM `vk`.`media`  
    GROUP BY user_id
)

SELECT CTE.news_count, CTE.user_id, u.email user_email
FROM CTE
INNER JOIN `vk`.`users` u on u.id = CTE.user_id