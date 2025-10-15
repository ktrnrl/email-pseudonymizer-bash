# email-pseudonymizer-bash
A Bash-based tool that scans unstructured .txt files for email addresses and pseudonymizes them using grep and sed (or awk).
The script removes dots (.) and + descriptors from the local part of each email address and replaces the middle characters with *** to protect privacy.

For example:
ababagalamaga@gmail.com → ab***ga@gmail.com
