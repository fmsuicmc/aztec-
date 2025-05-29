# Aztec Node Installer (Interactive & Dockerized)

این ریپازیتوری شامل یک اسکریپت Bash تعاملی برای نصب و راه‌اندازی نود Sequencer شبکه Aztec بر روی سیستم‌های مبتنی بر Ubuntu است. اسکریپت به‌صورت خودکار وابستگی‌ها را نصب کرده، Docker را پیکربندی می‌کند، ابزارهای Aztec را نصب می‌کند، و نود را با استفاده از Docker Compose اجرا می‌کند.

## ⚙️ ویژگی‌ها

- نصب خودکار وابستگی‌های سیستم
- نصب و پیکربندی امن Docker
- دریافت تعاملی اطلاعات مورد نیاز از کاربر
- ایجاد خودکار فایل‌های `.env` و `docker-compose.yml`
- راه‌اندازی نود Aztec با استفاده از Docker
- پیکربندی فایروال و باز کردن پورت‌های مورد نیاز

## 🖥️ پیش‌نیازها

- سیستم‌عامل Ubuntu 20.04 یا بالاتر
- دسترسی به کاربر `sudo` یا `root`
- پورت‌های باز `22`, `40400`, `8080`
- اطلاعات زیر:
  - `ETHEREUM_RPC_URL`: آدرس RPC لایه ۱
  - `CONSENSUS_BEACON_URL`: آدرس Beacon لایه ۱
  - `VALIDATOR_PRIVATE_KEY`: کلید خصوصی اعتبارسنج
  - `COINBASE`: آدرس کیف پول برای دریافت پاداش
  - `P2P_IP`: آدرس IP عمومی سرور

## 🚀 شروع سریع

### 1. کلون کردن ریپازیتوری

```bash
git clone https://github.com/fmsuicmc/aztec-.git
cd aztec-
```

### 2. اجرایی کردن اسکریپت

```bash
chmod +x install_aztec_node.sh
```

### 3. اجرای اسکریپت

```bash
./install_aztec_node.sh
```

در حین اجرا، اسکریپت از شما اطلاعات مورد نیاز را دریافت کرده و فایل‌های پیکربندی را ایجاد می‌کند.

### 4. بررسی وضعیت نود

```bash
docker ps
```

### 5. مشاهده لاگ‌ها

```bash
docker logs -f aztec-sequencer
```

## 🔐 نکات امنیتی

- فایل `.env` حاوی اطلاعات حساس مانند کلید خصوصی است. لطفاً این فایل را به‌صورت عمومی به‌اشتراک نگذارید.
- مسیر داده‌های نود در Docker به `/root/.aztec/alpha-testnet/data/` تنظیم شده است. در صورت نیاز می‌توانید این مسیر را تغییر دهید.

## 🛠️ به‌روزرسانی نود

برای به‌روزرسانی نود، مراحل زیر را دنبال کنید:

1. توقف نود:

```bash
docker compose down
```

2. به‌روزرسانی ابزارهای Aztec:

```bash
aztec-up alpha-testnet
```

3. حذف داده‌های قدیمی (در صورت نیاز):

```bash
rm -rf ~/.aztec/alpha-testnet/data/
```

4. اجرای مجدد نود:

```bash
docker compose up -d
```

## 📚 منابع مفید

- [مستندات رسمی Aztec](https://docs.aztec.network/)
- [راهنمای اجرای نود Sequencer](https://docs.aztec.network/the_aztec_network/guides/run_nodes/how_to_run_sequencer)
- [انجمن Aztec در Discord](https://discord.gg/aztec)

## 📄 مجوز

MIT © 2025 [fmsuicmc](https://github.com/fmsuicmc)

---

> برای سوالات یا مشکلات، لطفاً یک Issue در ریپازیتوری ایجاد کنید یا از طریق Discord با ما در ارتباط باشید.
