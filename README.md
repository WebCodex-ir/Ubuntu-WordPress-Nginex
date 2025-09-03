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
wget https://raw.githubusercontent.com/WebCodex-ir/Ubuntu-WordPress-Nginex/install_wordpress_nginx.sh
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
---

## 👀 مانیتورینگ منابع سرور

### Netdata
بعد نصب اسکریپت، سرور با Netdata مانیتور می‌شود.
- دسترسی به داشبورد: `http://IP-SERVER:19999`

### Bash Script مانیتورینگ منابع
برای مانیتورینگ سریع منابع (CPU, RAM, Disk, Net):

```bash
wget https://raw.githubusercontent.com/WebCodex-ir/Ubuntu-WordPress-Nginex/server_monitor.sh
chmod +x server_monitor.sh
./server_monitor.sh
```

---

## 💡 نکات امنیتی و سرعت

- SSL رایگان و تمدید خودکار (Certbot)
- پورت SSH اختصاصی و غیرفعال بودن ورود root و پسورد
- UFW و Fail2Ban فعال و تنظیم‌شده
- Redis و Gzip برای کشینگ و افزایش سرعت
- MariaDB Tuning برای سرعت بیشتر دیتابیس
- Netdata برای مانیتورینگ دائم سرور

---

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
