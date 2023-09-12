/* 1. Подсчитать количество групп (сообществ), в которые вступил каждый пользователь. */
SELECT u_c.user_id, COUNT(*) 'Количество групп'
FROM `vk`.`users_communities` u_c
INNER JOIN `vk`.`messages` m ON m.id=u_c.community_id
GROUP BY u_c.user_id

/* 2. Подсчитать количество пользователей в каждом сообществе. */
SELECT c.name, COUNT(u_c.user_id)
FROM `vk`.`communities` c
INNER JOIN `vk`.`users_communities` u_c on u_c.community_id=c.id
GROUP BY c.name

/* 3. Пусть задан некоторый пользователь. Из всех пользователей соц. сети найдите человека, который больше всех общался с выбранным пользователем (написал ему сообщений). */
SELECT u.id, u.firstname, u.lastname
FROM `vk`.`messages` m
INNER JOIN `vk`.`users` u ON u.id=m.from_user_id
WHERE m.to_user_id = '1'
GROUP BY m.from_user_id
ORDER BY m.from_user_id DESC 
LIMIT 1;

/* 4. Подсчитать общее количество лайков, которые получили пользователи младше 18 лет.. */
SELECT COUNT(l.id) 'Количество лайков'
FROM `vk`.`likes` l
INNER JOIN `vk`.`media` m ON m.id=l.media_id
INNER JOIN `vk`.`profiles` p ON p.user_id=m.user_id
WHERE TIMESTAMPDIFF(YEAR, p.birthday, NOW()) < '18';

/* 5. Определить кто больше поставил лайков (всего): мужчины или женщины. */
/* Ответ: Женщины - 10 лайков. */
SELECT gender,COUNT(l.id) 'Количество лайков'
FROM `vk`.`likes` l
INNER JOIN `vk`.`profiles` p ON p.user_id=l.user_id
GROUP BY gender