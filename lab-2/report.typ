#set text(
  font: "IBM Plex Sans",
  lang: "uk",
  size: 14pt,
)
#show raw: set text(
  font: "IBM Plex Mono",
)
#show raw.where(block: false): set text(
  size: 14pt,
)
#show raw.where(block: true): set text(
  size: 9pt,
)
#set page(
  numbering: "1 / 1",
)
#set par(
  justify: true,
)
#set heading(
  numbering: "1.",
)

#align(center, upper([
  *Київський національний університет*

  *імені Тараса Шевченка*
]))
#align(center, [
  Факультет комп'ютерних наук та кібернетики

  Кафедра математичної інформатики
])
#v(20%)
#align(center, [
  *Звіт до лабораторної роботи №2*

  *з дисципліни "Основи комп'ютерної лінгвістики"*

  *на тему*

  *"Порівняння методів обчислення семантичної схожості"*
])
#v(20%)
#align(right, [
  Виконав студент групи МІ-4

  Віннічук Назар
])
#v(5%)
#align(right, [
  Викладач:

  Тарануха Володимир Юрійович
])
#v(7.5%)
#align(center, [
  Київ -- 2023
])


#pagebreak()

#outline(
  title: [Зміст]
)

#pagebreak()

= Постановка задачі

Необхідно порівняти між собою та з суб'єктивним уявленням про семантичну
схожість оцінки методами Wu Palmer, Resnik, Lin та BERT.

= Технологічний стек

Реалізація оцінок виконана мовою Python з допомогою бібліотек
`transformers`, `pytorch`, `nltk`, `pandas`, `tqdm`.

Візуалізація та статистичний аналіз результатів виконано мовою R
з допомогою бібліотек `readr`, `corrplot` та `parameters`.

= Набір даних

У якості набору даних взято описи новин BBC,
з якого сформовано випадкову вибірку розміром з 251 опис,
де кожен опис складається з одного чи двох речень англійською мовою.

Приклад описів:

- One family spends six months turning their home into a must-see Halloween attraction.
- Liverpool survive a scare against Villarreal to move into the Champions League final - and keep their hopes of winning the quadruple alive.
- The Bolton comedian makes a triumphant return in the first date of his first tour for 12 years.

= Методологія суб'єктивної оцінки.

Суб'єктивна оцінка схожості висувалась на основі схожості через відношення "є"
("snacks" та "wine" є продуктами харчування, "tenure" та "months" є проміжками часу),
абстрагуючись від тематичної схожості ("Ukraine" та "crops", "run" та "knee").

#pagebreak()

= Програмна реалізація

== Загальна схема

#image("flow.svg")

== Примітки

Алгоритм виведення синсету з контексту реалізовано власноруч,
бо якість вбудованого у NLTK методу,
а саме методу Lesk, незадовільна:

#set par(justify: false)
```python
>>> from nltk.wsd import lesk
>>> synset = lesk("I buy food for my cat every day.", "cat", "n")
>>> synset
Synset('kat.n.01')
>>> synset.definition()
'the leaves of the shrub Catha edulis which are chewed like tobacco or used to make tea; has the effect of a euphoric stimulant'
```
#set par(justify: true)

Токени, отримані у модулі BERT,
не пасують до модулю WordNet:

#set par(justify: false)
```python
>>> from bert import tokenizer
>>> tokenizer.tokenize("Chelsea appoint Graham Potter as their new manager following the sacking of Thomas Tuchel.")
['chelsea', 'appoint', 'graham', 'potter', 'as', 'their', 'new', 'manager', 'following', 'the', 'sack', '##ing', 'of', 'thomas', 'tu', '##chel', '.']
```
#set par(justify: true)

Міра схожості Resnik нормалізується шляхом ділення на схожість синсета із самим собою.


== Головний модуль

#raw(read("main.py"), lang: "Python", block: true)

== Модуль BERT

#raw(read("bert.py"), lang: "Python", block: true)

== Модуль WordNet

#raw(read("wordnet.py"), lang: "Python", block: true)

== Допоміжний модуль

#raw(read("unique.py"), lang: "Python", block: true)

= Результати

== Діаграма розсіювання

#image("matrix.png")

#pagebreak()

== Кореляційна матриця

Кореляція значуща з рівнем 0.01 у всіх випадках окрім кореляції показника BERT
з показниками Wu Palmer, Resnik та Lin.

#image("correlation.png")

#pagebreak()

== Кластери

Використано метод К-медоїдів.

#image("cluster.png")
#image("description.png")

#pagebreak()

== Гістограми

#image("my.png")
#image("wp.png")
#image("resnik.png")
#image("lin.png")
#image("bert.png")

== Висновки

Оцінки на основі WordNet сильно корелюють між собою та корелюють
із суб'єктивною оцінкою.
Оцінка BERT не корелює з оцінками WordNet,
але корелює із суб'єктивною оцінкою схожим із WordNet методами чином.

Точність оцінок на основі WordNet страждає від незнання власних назв та не
завжди точних визначень синсету,
наприклад "years" у "Margaret Davidson was bringing up a young family in the Falklands when war broke out 40 years ago" розпізналось як "a body of students who graduate together".
Проте у більшості випадків синсет визначено відмінно.

Можна зробити висновок,
що суб'єктивна оцінка складається з незалежних компонент —
на основі WordNet та на основі BERT.
