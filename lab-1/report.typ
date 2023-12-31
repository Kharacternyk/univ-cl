#set text(
  font: "IBM Plex Sans",
  lang: "uk",
)
#show raw: set text(
  font: "IBM Plex Mono",
)
#set page(
  numbering: "1 / 1",
)
#set par(
  justify: true,
)

#align(center, [
  *Звіт до лабораторної роботи №1*

  *Стиснення тексту за допомогю генеративної моделі*

  _В. Заводник, Н. Нестерук, Н. Віннічук. Група МІ-4._
])

Програмну реалізацію виконано мовою Python у вигляді бібліотеки
та двох виконуваних файлів для стиснення та розтиснення відповідно.
Реалізація підтримує велику кількість генеративних моделей від OpenAI @openai.
У роботі було використано дві сторонні бібліотеки:

/ openai: дозволяє виконувати API запити до OpenAI. @openai-pip
/ tiktoken: дозволяє виконувати бієктивне перетворення між текстом та послідовністю
  токенів для конкретної генеративної моделі. @tiktoken

Процеси стиснення та розтиснення зображені на @activity.
Крок стиснення за допомогою ZIP можна вимкнути,
що дозволяє перевірити те,
що саме повноцінне стиснення дає найкращі результати.

#figure(
  supplement: "Рис.",
  grid(
    columns: 2,
    image("compression.svg"),
    image("decompression.svg"),
  ),
  caption: [
    Процеси стиснення та розтиснення.
  ],
)<activity>

Програма підтримує певну кількість параметрів, що описані у @options.
Параметри передаються програмі через назву файлу, наприклад
`input.txt.babbage-002,w10,a1,t1.zip9`.

#figure(
  supplement: "Табл.",
  table(
    columns: (auto, auto, auto),
    [*Опис параметру*], [*Тип параметру*], [*Приклад значення*],
    [Назва OpenAI моделі], [Рядок], [babbage-002],
    [Розмір вікна контексту], [Ціле число], [10],
    [Кількість запитів до OpenAI на один набір токенів], [Ціле число], [1],
    [Кількість токенів, що стискаються за один запит до OpenAI], [Ціле число], [1],
    [Рівень стиснення ZIP], [Ціле число], [9],
  ),
  caption: [
    Підтримувані параметри.
  ],
)<options>

На виході програма друкує розмір входу,
розмір стиснення без ZIP,
та фінальний розмір.
Можна помітити,
що для короткого та очевидного тексту англійською мовою ZIP лише шкодить.

```
$ cat test.txt
London is the capital of the United Kingdom.
$ python compress.py test.txt.babbage-002,w10,a2,t5.zip9
44 -> 11 -> 16
```

Проте у більшості випадків ZIP принаймні не завадить,
як наприклад у випадку довгого тексту українською мовою.
```
$ python compress.py \
> data/A_alumni.krok.edu.ua_Prokopenko_Vidrodzhennia_velotreku.txt.babbage-002,w10,a1,t1.zip9
1732 -> 1582 -> 1064
```

Розмір тексту обчислюється у символах,
а не у байтах,
тож наведений вище приклад стиснення українською мовою насправді кращий,
якщо брати до уваги розмір файлів у байтах.

Програмний код реалізації бібліотеки стиснення та розтиснення наступний:

#raw(read("lib.py"), lang: "Python")

Програмний код реалізації виконуваного файлу стиснення наступний:

#raw(read("compress.py"), lang: "Python")

Програмний код реалізації виконуваного файлу розтиснення наступний:

#raw(read("decompress.py"), lang: "Python")

Посилання:

#bibliography("bib.yaml", title: none)
