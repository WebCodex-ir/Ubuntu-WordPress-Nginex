# 🚀 نصب وردپرس حرفه‌ای روی Ubuntu 24 + Nginx  
by [WebCodex.ir](https://github.com/WebCodex-ir)

---

## 🔥 ویژگی‌ها
- نصب اتوماتیک وردپرس، Nginx، MariaDB، PHP، Redis، SSL رایگان
- امنیت بالا (UFW, Fail2Ban, SSH Hardening, SSL)
- سرعت بهینه (کشینگ Redis, Gzip, MariaDB Tuning)
- اتصال دیتابیس ریموت برای Navicat و ابزارهای مدیریت
- انتقال سایت قبلی با SFTP و بکاپ آسان
- مدیریت افزونه‌ها از طریق WP-CLI
- مانیتورینگ منابع سرور (CPU, RAM, Disk, Net) با اسکریپت اختصاصی و Netdata
- مناسب برای حرفه‌ای‌ها و تازه‌کارها!

---

## 🛠 آموزش نصب سریع و اتوماتیک

### 1️⃣ اجرای اسکریپت نصب

```bash
wget https://raw.githubusercontent.com/WebCodex-ir/Ubuntu-WordPress-Nginex/main/install_wordpress_nginx.sh
chmod +x install_wordpress_nginx.sh
sudo ./install_wordpress_nginx.sh
```
در ابتدای اجرا، اطلاعات زیر را وارد کنید:
- **دامنه** (مثال: webcodex.ir)
- **ایمیل مدیر** (برای SSL)
- **نام دیتابیس وردپرس**
- **یوزر دیتابیس وردپرس**
- **پسورد دیتابیس وردپرس**
- **پسورد root دیتابیس**

---

## 🎯 انتقال سایت قبلی با SFTP و Navicat

- با نرم‌افزار WinSCP یا FileZilla با پورت SSH (`2222`) متصل شو و فایل‌ها را به `/var/www/دامنه‌ات/` منتقل کن.
- با Navicat به دیتابیس ریموت (پورت `3306`) وصل شو و دیتابیس قبلی را ایمپورت کن.

---

## ⚡ مدیریت افزونه‌های وردپرس با WP-CLI

#### نصب WP-CLI:
```bash
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp
```

#### فعال یا غیرفعال کردن افزونه:
```bash
wp plugin activate plugin-slug --path=/var/www/دامنه‌ات
wp plugin deactivate plugin-slug --path=/var/www/دامنه‌ات
```

#### لیست افزونه‌ها:
```bash
wp plugin list --path=/var/www/دامنه‌ات
```

---

## 👀 مانیتورینگ منابع سرور

### Netdata
بعد نصب اسکریپت، سرور با Netdata مانیتور می‌شود.
- دسترسی به داشبورد: `http://IP-SERVER:19999`

### Bash Script مانیتورینگ منابع
برای مانیتورینگ سریع منابع (CPU, RAM, Disk, Net):

```bash
wget https://raw.githubusercontent.com/WebCodex-ir/Ubuntu-WordPress-Nginex/main/server_monitor.sh
chmod +x server_monitor.sh
./server_monitor.sh
```

نمونه اسکریپت:
```bash
#!/bin/bash
while true; do
    clear
    echo "========= مانیتورینگ منابع سرور ========="
    echo "زمان: $(date '+%Y-%m-%d %H:%M:%S')"
    echo "------ مصرف CPU ------"
    top -b -n 1 | grep \"Cpu(s)\" | awk '{print $2 + $4}' | xargs printf \"CPU Usage: %.2f%%\\n\"
    echo \"------ مصرف RAM ------\"
    free -h | awk '/Mem:/ {print \"RAM Used: \"$3 \" / \" $2}'
    echo \"------ مصرف دیسک ------\"
    df -h / | awk 'NR==2 {print \"Disk Used: \"$3 \" / \" $2}'
    echo \"------ مصرف شبکه ------\"
    ifstat 1 1 | awk 'NR==3 {print \"Network IN: \"$1\" KB/s | OUT: \"$2\" KB/s\"}'
    echo \"------ ۵ سرویس پرمصرف ------\"
    ps -eo pid,comm,%cpu,%mem --sort=-%cpu | head -n 6
    sleep 5
done
```

---

## 🚦 بررسی باز و بسته بودن پورت‌ها

برای چک کردن وضعیت پورت‌ها و فایروال:
```bash
sudo ss -tuln
sudo netstat -tuln
sudo ufw status numbered
nc -zv SERVER_IP PORT
# مثال:
nc -zv your.server.ip 3306
```

---

## ⚡ اتصال افزونه LiteSpeed Cache وردپرس به Redis

### ۱. نصب Redis روی سرور
```bash
sudo apt install redis-server php-redis -y
sudo systemctl enable redis-server
sudo systemctl start redis-server
```

### ۲. تنظیمات LiteSpeed Cache برای Redis
1. افزونه LiteSpeed Cache را نصب و فعال کن.
2. مسیر: LiteSpeed Cache > Cache > Object
3. گزینه‌ها:
   - Enable Object Cache: ON
   - Method: Redis
   - Host: localhost
   - Port: 6379
   - ذخیره تنظیمات و مشاهده وضعیت اتصال (Connected)

### نکات امنیتی Redis:
- مقدار bind در `/etc/redis/redis.conf` روی `127.0.0.1` باشد.
- برای باز کردن پورت (در صورت نیاز):  
  `sudo ufw allow 6379/tcp`
- اضافه کردن پسورد به Redis:  
  ```
  requirepass YourStrongPassword
  ```
  و ری‌استارت Redis:
  ```bash
  sudo systemctl restart redis-server
  ```

---

## 📦 بکاپ‌گیری از دیتابیس و فایل‌های سایت

### بکاپ دیتابیس وردپرس با mysqldump:
```bash
mysqldump -u USER -p'PASSWORD' DATABASE > /home/backup/wp-db-$(date +%Y-%m-%d_%H-%M-%S).sql
```
> قبلش پوشه بکاپ را بساز:
> ```bash
> mkdir -p /home/backup
> ```

### بکاپ فایل‌های وردپرس با tar:
```bash
tar -czvf /home/backup/wp-files-$(date +%Y-%m-%d_%H-%M-%S).tar.gz /var/www/yourdomain
```

### بکاپ اتوماتیک با اسکریپت و Cronjob

**اسکریپت بکاپ دیتابیس:**
```bash
#!/bin/bash
mysqldump -u USER -p'PASSWORD' DATABASE > /home/backup/wp-db-$(date +%Y-%m-%d_%H-%M-%S).sql
find /home/backup/ -type f -name \"wp-db-*.sql\" -mtime +7 -delete
```

**اسکریپت بکاپ فایل‌ها:**
```bash
#!/bin/bash
tar -czvf /home/backup/wp-files-$(date +%Y-%m-%d_%H-%M-%S).tar.gz /var/www/yourdomain
find /home/backup/ -type f -name \"wp-files-*.tar.gz\" -mtime +7 -delete
```

**ساخت Cronjob:**
```bash
crontab -e
# هر روز ساعت ۳ صبح دیتابیس و ساعت ۳:۳۰ فایل‌ها:
0 3 * * * /bin/bash /path/to/backup_db.sh
30 3 * * * /bin/bash /path/to/backup_files.sh
```

**نکته امنیتی:**
```bash
chmod 700 /home/backup
```

### افزونه بکاپ ابری (UpdraftPlus)
- نصب از پیشخوان وردپرس > افزونه‌ها > افزودن > جستجو UpdraftPlus

---

---

## 🤔 سوال مهم: آیا اسکریپت نصب کرش نمی‌کند و مصرف منابع بهینه است؟

- مناسب سرورهای 1 تا 4 گیگ رم و CPU معمولی
- سرویس‌های سنگین مثل Netdata را فقط در مواقع نیاز فعال کن
- اندازه کش‌ها و تنظیمات دیتابیس را بسته به منابع سرور کم/زیاد کن
- با اسکریپت مانیتورینگ و Netdata مصرف منابع را همیشه چک کن

---

## 🌐 اضافه کردن دامنه و ساب‌دامنه به nginx (قدم‌به‌قدم)

### دامنه جدید:
```bash
sudo mkdir -p /var/www/yourdomain.ir
sudo nano /etc/nginx/sites-available/yourdomain.ir
# قرار دادن کانفیگ بالا
sudo ln -s /etc/nginx/sites-available/yourdomain.ir /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
sudo certbot --nginx -d yourdomain.ir -d www.yourdomain.ir --email youremail@example.com --agree-tos --redirect --non-interactive
```

### ساب دامنه:
```bash
sudo mkdir -p /var/www/blog.yourdomain.ir
sudo nano /etc/nginx/sites-available/blog.yourdomain.ir
# قرار دادن کانفیگ بالا
sudo ln -s /etc/nginx/sites-available/blog.yourdomain.ir /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
sudo certbot --nginx -d blog.yourdomain.ir --email youremail@example.com --agree-tos --redirect --non-interactive
```

---

## 🎲 گراف زنده منابع سرور با Netdata

برای نصب Netdata و مشاهده گراف منابع سرور در داشبورد تحت وب:

## 🚦 نصب Netdata و حل مشکل نصب

اگر دستور زیر خطای html یا ری‌دایرکت داد:
```bash
bash <(curl -Ss https://my-netdata.io/kickstart.sh)
```
از آدرس رسمی جدید یا نصب مستقیم با apt استفاده کن:

### نصب جدید با اسکریپت:
```bash
bash <(curl -Ss https://raw.githubusercontent.com/netdata/netdata/master/packaging/installer/kickstart.sh)
```

### یا نصب با apt:
```bash
sudo apt update
sudo apt install netdata -y
sudo systemctl start netdata
sudo systemctl enable netdata
```

داشبورد:  
http://your-server-ip:19999
و همه منابع را به صورت گراف زنده ببین!


## 🎲 گراف زنده منابع در ترمینال

### نصب و اجرا glances:
```bash
sudo apt install glances -y
glances
```
### نصب و اجرا bashtop:
```bash
sudo apt install bashtop -y
bashtop
```
-------------------------------------------------

## 📊 سوالات رایج

#### اتصال دیتابیس با Navicat؟
- پورت: 3306
- یوزر/پسورد: همان اطلاعاتی که هنگام نصب وارد کردی
- bind-address روی `0.0.0.0` تنظیم شده

#### انتقال سایت قبلی؟
- SFTP با پورت SSH (`2222`)
- فایل‌ها را در مسیر سایت جدید کپی کن

#### کرش یا مشکل؟
- لاگ‌های Nginx: `/var/log/nginx/error.log`
- لاگ‌های MariaDB: `/var/log/mysql/error.log`
- اگر مشکلی بود، Issue ثبت کن!

---

## 🌟 مشارکت و توسعه

خوشحال می‌شویم اگر تجربه یا پیشنهاد جدیدی داشتی، Pull Request یا Issue ثبت کنی!

---

## ✨ راه ارتباطی

- [وب‌سایت WebCodex.ir](https://webcodex.ir)
- ایمیل: meisamshadkam@gmail.com

---

## 📄 لایسنس
[MIT License](LICENSE)
