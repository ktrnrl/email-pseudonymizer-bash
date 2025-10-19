# 📧 Email Pseudonymizer (Bash version)

## Project Description
This project processes **unstructured `.txt` files** and finds all email addresses using **grep** and **sed/awk**. It then **pseudonymizes** them according to the following rules:  
- Removes dots (`.`) from the local part (before `@`).  
- Removes everything after `+` (the descriptor).  
- Lowercases the email address.  
- Replaces the middle characters of the cleaned name with `***`.  

Example:  
```
ababagalamaga@gmail.com → ab***ga@gmail.com  
b.abe+promo@gmail.com → ba***be@gmail.com
```

---

## Tools Used
- **grep** — to extract all email addresses from the text.  
- **sed** or **awk** — to clean and pseudonymize the emails.  
- **bash** — to automate file input/output.

---

## Task Summary
- The work is done **in pairs**.  
- Each team chooses their **variant** according to interests and abilities.  
- Test `.txt` files are **created manually or using AI tools**.  
- Submit the project as a **GitHub/GitLab repository**.  
- If the repository is private — **add the instructor as a collaborator**.  
- Include a **LICENSE** file (see [choosealicense.com](https://choosealicense.com/)).  
- Describe clearly in this README what was done, and if something is not fully completed, note that explicitly.

---

## Test Files
Several `.txt` files were generated for testing:
- `emails_list_basic.txt` — a plain list of different email addresses.  
- `emails_in_text.txt` — emails inside sentences.  
- `emails_mixed_data.txt` — emails mixed with other personal data (names, phone numbers, etc.).  
- `emails_with_duplicates.txt` — repeated and variant email addresses to check normalization.

---

## Usage
1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/email-pseudonymizer-bash.git
   cd email-pseudonymizer-bash
   ```
2. Run the script:
   ```bash
   bash pseudonymize_emails.sh input.txt output.txt
   ```
3. The pseudonymized text will be saved in `output.txt`.

---

## Example
### Input:
```
Please contact us at ababagalamaga@gmail.com or b.abe+promo@gmail.com.
```

### Output:
```
Please contact us at ab***ga@gmail.com or ba***be@gmail.com.
```

---

## Authors
This work was completed **in pairs** as part of a laboratory assignment on text data processing.  

Pair members:  
- Student 1 — Orel Kateryna
- Student 2 — Pomalina Margarita

---

## License
This project is distributed under the [MIT License](LICENSE).
