FROM python:3.9-slim

COPY requirements.txt .
RUN pip install --target=/app -r requirements.txt

WORKDIR /app
COPY ./main.py .

# ENV PYTHONPATH /app
# ENTRYPOINT ["python", "-m", "main.py"]
ENTRYPOINT ["/app/main.py"]
