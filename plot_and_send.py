import matplotlib.pyplot as plt
import datetime
import requests

BOT_TOKEN = "7912379057:AAFANpcaAkb1MraBEagXs2-_V8Q4XnHipnw"
CHAT_ID = "589666764"

timestamps = []
statuses = []

with open("/data/status.csv", "r") as file:
    for line in file:
        time_str, site, status = line.strip().split(",")
        if site == "google.com":
            time_obj = datetime.datetime.strptime(time_str, "%Y-%m-%d %H:%M:%S")
            timestamps.append(time_obj)
            statuses.append(1 if status == "up" else 0)

plt.figure(figsize=(10, 4))
plt.plot(timestamps, statuses, marker='o', linestyle='-', color='green')
plt.ylim(-0.1, 1.1)
plt.yticks([0, 1], ["down", "up"])
plt.xlabel("Время")
plt.ylabel("Статус")
plt.title("Доступность google.com")
plt.grid(True)
plt.tight_layout()
plt.savefig("/data/status_plot.png")

# Отправка изображения в Telegram
with open("/data/status_plot.png", "rb") as photo:
    requests.post(
        f"https://api.telegram.org/bot{BOT_TOKEN}/sendPhoto",
        data={"chat_id": CHAT_ID},
        files={"photo": photo}
    )
