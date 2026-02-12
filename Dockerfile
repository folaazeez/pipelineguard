FROM python:3.11-slim
WORKDIR /app
COPY scripts/ scripts/
CMD ["python","scripts/policy_check.py"]
