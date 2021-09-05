# FROM python:3-slim AS builder
# ADD . /app
# WORKDIR /app

# RUN pip install --target=/app requests

# FROM gcr.io/distroless/python3-debian10
# COPY --from=builder /app /app
# WORKDIR /app
# ENV PYTHONPATH /app
# CMD ["/app/main.py"]

FROM python:3.9-slim

COPY requirements.txt .
RUN pip install --target=/app -r requirements.txt

WORKDIR /app
COPY ./main.py main.py

ENV PYTHONPATH /app
ENTRYPOINT ["python", "-m", "main.py"]
