# .gitignore for MySQL Data Warehouse Project

# MySQL Database Files
*.sql~
*.sql.bak

# MySQL Configuration Files
my.cnf
my.ini
.my.cnf

# Data Files
*.csv
*.txt
*.dat
datasets/
data/

# MySQL Logs
*.log
mysql-bin.*
mysql-slow.log
error.log

# MySQL Temporary Files
*.tmp
*.temp
#sql*.frm
#sql*.MYD
#sql*.MYI

# Backup Files
backup/
*.backup
*.dump
*.sql.gz

# OS Files
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db

# IDE Files
.vscode/
.idea/
*.swp
*.swo
*~

# Connection Configuration (contains sensitive data)
config/connection.conf
config/mysql_connection.conf
.env
.env.local

# Documentation Build Files
docs/_build/
*.pdf

# Cache Files
.cache/
*.cache

# Test Results
test-results/
*.test

# Local Development Files
local/
dev/
scratch/

# Credentials and Sensitive Data
credentials.txt
passwords.txt
secrets/
