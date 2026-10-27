# Данные для Lab 12–15

В файлах из Drive приведены запросы к `employees`, `products` и другим таблицам, но полных наборов записей для них нет. Там же рекомендуется DataLemur. Поэтому для практики я взял опубликованные строки из его примеров. Имена, суммы и даты не придумывал. Запросы из методичек адаптированы к этим столбцам; все перечисленные темы сохранены.

| Таблица | Источник | Объём |
| --- | --- | --- |
| `employee` | [Well Paid Employees](https://datalemur.com/questions/sql-well-paid-employees) | 8 строк из Example Input |
| `purchases` | [Aggregate Functions](https://datalemur.com/sql-tutorial/sql-aggregate-functions) | 7 видимых строк Sample Data |
| `artists`, `songs` | [SQL JOINS](https://datalemur.com/sql-tutorial/sql-joins-inner-outer-left-right) | 3 артиста и 4 песни из Example Input |
| `users`, `trades` | [SQL JOINS](https://datalemur.com/sql-tutorial/sql-joins-inner-outer-left-right) | 5 пользователей и 7 сделок из Example Input |

Это учебные примеры, а не реальные персональные или финансовые записи. Таблицы находятся в отдельной схеме `lab_data` базы `university`. Для one-to-one и many-to-many в Lab 14 использованы существующие таблицы Lab 8.

В `employee` есть ссылки на руководителей 9 и 11, которых нет в опубликованном наборе. Я сохранил это ограничение источника и не добавлял выдуманных руководителей. В таблице песен нет Mia, хотя она встречается ниже в примере результата DataLemur: исходные четыре песни оставлены без дополнений.

Итоги на этом подмножестве отличаются от результата для полной базы на сайте: у меня 7 покупок на 1401.69, а не 15 покупок. Проверено 27 октября 2026 года.
