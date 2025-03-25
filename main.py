import os
import logging
import asyncio
from aiogram import Bot, Dispatcher, types
from dotenv import load_dotenv

# Загружаем переменные из .env
load_dotenv()
API_TOKEN = "7550451235:AAGdRpBOP1XVal3fckxUEN7HbWY76ZVLVVA"
if not API_TOKEN:
    raise Exception("Не задан TELEGRAM_BOT_TOKEN в файле .env")

logging.basicConfig(level=logging.INFO)

bot = Bot(token=API_TOKEN)
dp = Dispatcher()

@dp.message()
async def echo_handler(message: types.Message):
    # Отправляем обратно то же сообщение
    await message.reply(message.text)

async def main():
    await dp.start_polling(bot, skip_updates=True)

if __name__ == '__main__':
    asyncio.run(main())
