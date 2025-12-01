FROM --platform=linux/amd64 python:3.13-slim
ENV PYTHONUNBUFFERED 1
WORKDIR /app
COPY . /app/
ENV SYSIDE_LICENSE_FILE=/app/syside-license.lic
RUN pip install -r requirements.txt
EXPOSE 80
CMD ["python", "webapp_main.py"]
