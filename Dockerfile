# Use an official Python runtime as a parent image
FROM python:3.8-slim-buster

WORKDIR /app

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    wget \
    xz-utils \
    libxrender1 \
    fontconfig \
    libjpeg62-turbo \
    libxext6 \
    xfonts-75dpi \
    xfonts-base && \
    wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.buster_amd64.deb && \
    dpkg -i wkhtmltox_0.12.5-1.buster_amd64.deb && \
    rm wkhtmltox_0.12.5-1.buster_amd64.deb && \
    apt-get remove -y wget xz-utils && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install any needed packages specified in requirements.txt
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# Copy the current directory contents into the container at /app
COPY . /app

# Make port 4000 available to the world outside this container
EXPOSE 4000

# Run gunicorn when the container launches
CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:4000", "app:app"]
