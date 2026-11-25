FROM python:3.11-slim AS builder

WORKDIR /build
COPY requirements.txt .
COPY wheels ./wheels
RUN pip install --user --no-cache-dir --no-index --find-links=./wheels -r requirements.txt

FROM python:3.11-slim

WORKDIR /app
COPY --from=builder /root/.local /root/.local
COPY main.py .

ENV PATH=/root/.local/bin:$PATH
ENV PYTHONPATH=/root/.local/lib/python3.11/site-packages

CMD ["python", "main.py"]
