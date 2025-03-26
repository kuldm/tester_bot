#FROM python:3.13.2-slim
#
## Задаём рабочую директорию
#WORKDIR /app
#
## Если пакетный менеджер uv требуется установить через pip, можно выполнить:
#RUN pip install uv
#
## Enable bytecode compilation
#ENV UV_COMPILE_BYTECODE=1
#
## Install the project's dependencies using the lockfile and settings
##RUN --mount=type=cache,target=/root/.cache/uv \
##    --mount=type=bind,source=uv.lock,target=uv.lock \
##    --mount=type=bind,source=pyproject.toml,target=pyproject.toml \
##    uv sync --frozen --no-install-project --no-dev
#COPY pyproject.toml uv.lock /app/
#RUN uv pip install .
#
## Then, add the rest of the project source code and install it
## Installing separately from its dependencies allows optimal layer caching
#ADD .. /app
#RUN --mount=type=cache,target=/root/.cache/uv \
#    uv sync --frozen --no-dev
#
## Place executables in the environment at the front of the path
#ENV PATH="/app/.venv/bin:$PATH"
#
## Reset the entrypoint, don't invoke `uv`
#ENTRYPOINT []
#
#RUN ls -lah /app
#
## Если uv умеет запускать модуль, можно использовать:
#CMD ["uv", "run", "main.py"]
#
## Если запуск через uv вызывает сложности, можно заменить на стандартный запуск:
## CMD ["python", "bot.py"]
FROM python:3.13.2-slim

# Устанавливаем рабочую директорию
WORKDIR /app

# Устанавливаем uv
RUN pip install uv

# Оптимизируем компиляцию
ENV UV_COMPILE_BYTECODE=1

# Копируем файлы зависимостей
COPY pyproject.toml uv.lock /app/

# Создаём виртуальное окружение и устанавливаем зависимости
RUN uv venv && uv pip install --system .

# Копируем весь проект
COPY . /app/

# Указываем команду для запуска бота
CMD ["python", "main.py"]