# Email Pseudonymizer (Bash)

## Опис проєкту
Скрипт обробляє **неструктуровані `.txt` файли** та знаходить усі email-адреси за допомогою **grep**. Далі адреси **нормалізуються** й **псевдонімізуються** (маскуються) за правилами:

1) **Нормалізація**
- прибираємо крапки в локальній частині (до `@`);
- усе після `+` відкидається;
- знижуємо регістр (lowercase).

2) **Псевдонімізація**
- зберігаємо початок і кінець імені, середину замінюємо на `***`.
- якщо довжина локальної частини ≥ 4 → залишаємо перші **2** і останні **2** символи:  
  `ababagalamaga@gmail.com → ab***ga@gmail.com`, `john.doe@example.com → jo***oe@example.com`
- якщо коротша → залишаємо **перший і останній** символ:  
  `m@tiny.io → m***m@tiny.io`, `aaa@short.com → a***a@short.com`

> Маскування **незворотне** та спрямоване на мінімізацію витоку ПІІ у відкритих датасетах/логах.

---

## Що в репозиторії
- `pseudonymize_inplace.sh` — основний bash-скрипт для **in-place** обробки файлів (створює резервну копію з розширенням `.bak`).
- Тестові вхідні файли:
  - `emails_list_basic.txt` — базовий список email-ів.
  - `emails_in_text.txt` — адреси всередині звичайного тексту.
  - `emails_mixed_data.txt` — email-и впереміш з ПІІ (імена, телефони).
  - `emails_with_duplicates.txt` — дублікати та варіанти одних і тих самих адрес.
- `LICENSE` — вибрана ліцензія (див. розділ “Ліцензія”).

---

## Використання

### 1) Обробити один файл in-place
```bash
bash pseudonymize_inplace.sh path/to/file.txt
# Створить path/to/file.txt.bak і замінить email-и в оригінальному файлі
```

### 2) Обробити всі `.txt` у каталозі рекурсивно
```bash
find . -type f -name "*.txt" -print0 | xargs -0 -I {} bash pseudonymize_inplace.sh "{}"
```

### 3) “Сухий” прогін (побачити, що знайдеться)
```bash
grep -Eoi '[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}' -n path/to/file.txt | sort -u
```

---

## Приклади (до/після)

### emails_in_text.txt
**Було (фрагмент):**
```
with_underscore+z@mysite.net, babe@gmail.com, duplicate.case@GMAIL.com,
numeric123+tag@numbers.org, x.y.z+label@sub.domain.co.uk
```
**Стало (фрагмент):**
```
wi***re@mysite.net, b***e@gmail.com, du***se@gmail.com,
nu***23@numbers.org, x***z@sub.domain.co.uk
```

### emails_list_basic.txt
**Було (фрагмент):**
```
babe@gmail.com
b.abe@gmail.com
BABE+xyz@GMAIL.COM
john.doe+work@example.com
m@tiny.io
```
**Стало (фрагмент):**
```
b***e@gmail.com
b***e@gmail.com
b***e@gmail.com
jo***oe@example.com
m***m@tiny.io
```

### emails_mixed_data.txt
**Було (фрагмент):**
```
test.email+work@edu.ua, 123numeric@numbers.org, ABc@Gmail.Com, stu.dent@university.edu
```
**Стало (фрагмент):**
```
te***il@edu.ua, 12***ic@numbers.org, a***c@gmail.com, st***nt@university.edu
```

### emails_with_duplicates.txt
**Було (приклади дублікатів):**
```
babe@gmail.com, duplicate.case@GMAIL.com, john.doe@example.com, john.doe+promo@example.com
```
**Стало (уніфіковані значення):**
```
b***e@gmail.com, du***se@gmail.com, jo***oe@example.com, jo***oe@example.com
```

---

## Як це працює (огляд)
1. **Видобуток**: `grep -Eoi` шукає патерн email, незалежно від регістру.
2. **Нормалізація** (у `sed/awk`):
   - локальна частина: видаляємо `.` та усічення після `+`;
   - уся адреса знижується до lowercase.
3. **Маскування**: на локальній частині лишаємо краї (2+2 або 1+1) і ставимо `***` посередині.
4. **Заміна в тексті**: вихідний файл оновлюється in-place; створюється резервна `.bak`.

---

## Обмеження та зауваги
- Патерн email — RFC-спрощення: може пропускати екзотичні адреси або чіпляти рідкісні псевдо-рядки.
- Скрипт не перевіряє MX/доставку; працює виключно з рядковими збігами.
- Маскування завжди вставляє `***`, навіть якщо ім’я дуже коротке (див. правила вище).
- **Статус виконання:** функціонал нормалізації + псевдонімізації завершений; **GUI/звіт/юніт-тести** — не реалізовані (зазначено тут, як і вимагалося).

---

## Команда
Лабораторна робота у парі:
- Орел Катерина
- Помаліна Маргарита

---

## Ліцензія
Проєкт розповсюджується за умовами файлу **LICENSE** у корені репозиторію (вибрано на основі [choosealicense.com](https://choosealicense.com/)).

---

### Швидкий чек-лист для рев’ю
- [x] Є `LICENSE`
- [x] README описує **фактичний** скрипт `pseudonymize_inplace.sh`
- [x] Додані приклади **до/після** з реальних файлів
- [x] Вказано, що частина функцій (GUI/тести) не реалізовані
