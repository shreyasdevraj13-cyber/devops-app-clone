# Stage 1: The Builder
FROM python:3.11-slim AS builder
WORKDIR /app
COPY requirements.txt .
# Install dependencies into a specific local folder
RUN pip install --user -r requirements.txt

# Stage 2: The Final Production Container
FROM python:3.11-slim
WORKDIR /app
# Copy only the installed libraries from Stage 1, leaving the build junk behind
COPY --from=builder /root/.local /root/.local
COPY . .

# Tell the container where to find the installed libraries
ENV PATH=/root/.local/bin:$PATH
EXPOSE 8000

# The command to start your Uvicorn server when the container turns on
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]