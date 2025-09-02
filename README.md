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
- مانیتورینگ سرور با Netdata
- مناسب برای حرفه‌ای‌ها و تازه‌کارها!

---

## 📝 آموزش نصب سریع و اتوماتیک

### 1️⃣ دانلود اسکریپت و اجرای آن

```bash
wget https://raw.githubusercontent.com/WebCodex-ir/Ubuntu-WordPress-Nginex/main/install_wordpress_nginx.sh
chmod +x install_wordpress_nginx.sh
sudo ./install_wordpress_nginx.sh
```
در ابتدای اجرا، اطلاعات زیر را وارد کنید:
- **دامنه** (مثال: webcodex.ir)
- **ایمیل مدیر** (برای دریافت SSL)
- **نام دیتابیس وردپرس**
- **یوزر دیتابیس وردپرس**
- **پسورد دیتابیس وردپرس**
- **پسورد root دیتابیس**

---

### 2️⃣ انتقال سایت قبلی با SFTP

- با نرم‌افزارهایی مثل WinSCP یا FileZilla به سرور متصل شوید
- پورت SSH: `2222` (یا هر پورتی که انتخاب کردی)
- یوزر: `root` یا یوزر خودت
- انتقال فایل‌ها به `/var/www/دامنه‌ات/`

---

### 3️⃣ انتقال دیتابیس قبلی (Navicat/SQL)

- IP سرور و پورت `3306` را وارد کن
- یوزر دیتابیس و پسورد را وارد کن
- دیتابیس قبلی را ایمپورت کن

---

### 4️⃣ مدیریت افزونه‌های وردپرس با WP-CLI

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

## 👨‍💻 نکات امنیتی و سرعت

- **SSL رایگان و تمدید خودکار:** با Certbot و Let's Encrypt
- **پورت SSH اختصاصی و غیر فعال بودن ورود root و پسورد**
- **UFW و Fail2Ban** فعال و کانفیگ شده
- **Redis و Gzip** برای کشینگ و کاهش فشار سرور
- **MariaDB Tuning** برای سرعت بیشتر دیتابیس
- **Netdata** برای مانیتورینگ سرور

---

## ❓ سوالات رایج (FAQ)

#### اتصال دیتابیس با Navicat؟
- پورت: 3306
- یوزر/پسورد: همان اطلاعاتی که هنگام نصب وارد کردی
- bind-address روی `0.0.0.0` تنظیم شده

#### انتقال سایت قبلی؟
- SFTP با پورت SSH (2222 یا دلخواه)
- فایل‌ها را در مسیر سایت جدید کپی کن

#### اجرای دوباره اسکریپت؟
- فقط کافیست اسکریپت را مجدد اجرا کنی و اطلاعات جدید وارد کنی

#### کرش یا مشکل؟
- لاگ‌های Nginx: `/var/log/nginx/error.log`
- لاگ‌های MariaDB: `/var/log/mysql/error.log`
- اگر مشکلی بود، در Issues همین مخزن بنویس!

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
