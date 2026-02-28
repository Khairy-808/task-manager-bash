# 📝 Mini Task Manager

<p align="center">
  <b>A Beautiful CLI Task Manager built with pure Bash</b><br>
  <sub>Structured • Validated • Colored • DevOps-Inspired</sub>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Bash-CLI-blue?style=for-the-badge&logo=gnubash">
  <img src="https://img.shields.io/badge/Linux-Compatible-success?style=for-the-badge">
  <img src="https://img.shields.io/badge/Text%20Processing-awk%20%7C%20sed-orange?style=for-the-badge">
  <img src="https://img.shields.io/badge/Status-Active-brightgreen?style=for-the-badge">
</p>

---

## ✨ Overview

**Mini Task Manager** is a fully interactive command-line application written in pure Bash.

It demonstrates real-world Linux scripting concepts including:

- Structured file-based storage
- Field parsing with `awk`
- In-place editing with `sed`
- Filtering using `grep`
- Date validation & comparison
- Input validation & defensive scripting
- ANSI colored terminal UI

This project reflects practical DevOps scripting foundations.

---

## 🚀 Features

### 🛠 Core Functionality
- ➕ Add Task  
- ✏️ Update Task  
- ❌ Delete Task  
- 🔍 Search by Title  
- 📋 List All Tasks  
- 🎯 Filter by Status  
- 📌 Filter by Priority  

### 📊 Reporting
- 📈 Task Summary by Status  
- ⏰ Overdue Task Detection  
- 🗂 Priority-Based Grouping  

### 🧠 Input Validation
- Title cannot be empty  
- Title allows only letters, numbers & spaces  
- Date must be valid (`YYYY-MM-DD`)  
- ID must exist before update/delete  

### 🎨 User Experience
- ANSI colored output  
- Structured table formatting  
- Clean interactive menu  

---

## 🛠 Technologies Used

| Tool | Purpose |
|------|----------|
| **Bash** | Core scripting language |
| **awk** | Field processing & formatted output |
| **sed** | In-place editing & deletion |
| **grep** | Searching & filtering |
| **date** | Date validation & comparison |
| ANSI Codes | Colored terminal UI |

---

## 📂 Project Structure

```
mini-task-manager/
│
├── task_manager.sh
├── README.md
├── .gitignore
└── tasks.txt (generated automatically)
```

---

## 🗃 Data Storage Format

Tasks are stored in a structured flat-file format:

```
ID|Title|Priority|DueDate|Status
```

### Example

```
1|Study Bash|high|2026-03-10|pending
2|Build DevOps Lab|medium|2026-03-15|done
```

No database required — pure Linux text handling.

---

## ▶️ How to Run

```bash
chmod +x task_manager.sh
bash task_manager.sh
```

---

## 💻 Example Output

```
ID   TITLE               PRIORITY   DATE         STATUS
-----------------------------------------------------------
1    Study Bash          high       2026-03-10   pending
2    Build DevOps Lab    medium     2026-03-12   done
```

*(Colors appear in supported terminals)*

---

## 🧠 Technical Concepts Demonstrated

- Regular expressions in Bash
- Delimiter-based field parsing
- Text stream processing
- Loop control & menu systems
- Defensive scripting
- Structured CLI application design
- File-based data persistence
- Date comparison logic

---

## 🔐 DevOps Relevance

While modern DevOps uses tools like:

- Docker  
- Ansible  
- Terraform  
- Kubernetes  

Bash scripting remains essential for:

- Automation glue scripts  
- CI/CD pipelines  
- Server provisioning  
- Log analysis  
- Production troubleshooting  

This project highlights foundational automation skills required in real infrastructure environments.

---

## 📌 Possible Enhancements

- 📤 CSV Export
- 🔄 Sorting by date/priority
- 🐳 Docker container version
- 🧪 ShellCheck lint integration
- ⚙ GitHub Actions workflow
- 🧩 Modular script structure

---

## 👤 Author

**Mohannad Khairy**  
DevOps Engineer  

---

<p align="center">
  ⭐ If you found this project useful, consider starring it!
</p>
