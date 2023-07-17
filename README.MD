# HTML to PDF Web Service

This service is built using Flask, a lightweight web framework for Python. We designed the service to accept HTML input and convert it to a PDF document.

We are using `pdfkit` and `wkhtmltopdf` to handle the HTML to PDF conversion, which provides a lot of flexibility in terms of the HTML and CSS that can be handled. Even complex layouts with images, fonts, and other assets are well supported. The generated PDF is then encoded in base64, which provides a convenient, standard format for transmitting binary data in a text format.

## Features

- **Simple API**: The service provides a single POST endpoint that accepts HTML and returns a base64 encoded PDF.
- **Auth Protected**: To ensure the security of the service, we are using Basic HTTP Authentication. You can easily configure the username and password via environment variables.
- **Dockerized Application**: The service is containerized using Docker, which makes it straightforward to run in any environment that supports Docker.
- **Environment Variables**: Configuration of the service is handled via environment variables, making it easy to configure the service for different environments without changing the application code.
- **Gunicorn for Production-Ready Deployment**: Gunicorn, a Python WSGI HTTP Server, is used for serving the application in production. It provides good performance and can handle concurrent requests, thanks to its worker process model.


## Prerequisites

To run this application, you will need:

- Docker (Download from [here](https://www.docker.com/products/docker-desktop))

## Setup

Clone the repository:

```bash
git clone https://github.com/mctlisboa/html2pdf.git
cd html2pdf
```
Set up your environment variables for Basic Authentication in a .env file in your project root:

```env
BASIC_AUTH_USERNAME=<your-username>
BASIC_AUTH_PASSWORD=<your-password>
```

Replace <your-username> and <your-password> with your desired username and password.

## Running with Docker Compose
We have included a `docker-compose.yml` file for running the service using Docker Compose. Docker Compose allows defining and running multi-container Docker applications. In our case, the application runs with Gunicorn, a Python WSGI HTTP Server, as the server.

The Docker Compose file specifies the configuration of the service. It tells Docker to build an image from the Dockerfile, use the `.env` file for environment variables, and start the application using Gunicorn with 4 worker processes. The application is served on port 4000 both inside the container and on the host machine.

To run the application with Docker Compose, follow these steps:

1. Install Docker and Docker Compose on your system.
2. Navigate to the directory of the cloned repository.
3. Build and start the service with Docker Compose:
```bash
docker-compose up --build
```

This command will start the application with Gunicorn as the server. Gunicorn will start 4 worker processes (adjustable as needed) to handle requests concurrently. It will listen on port 4000 inside the container, which we map to port 4000 on the host.

You can adjust the number of worker processes by modifying the `-w 4` argument in the command directive of the `docker-compose.yml` file. A common formula is `(2 x $num_cores) + 1`, where `$num_cores` is the number of CPU cores on your server.

## Run the Service with Docker Run

First, build the Docker image:

```bash
docker build -t html2pdf:latest .
```

Then, start the service using docker run:

```bash
docker run -p 4000:4000 --env-file .env -t html2pdf:latest
```

The service will be accessible at http://localhost:4000.

## Using the Service

Make a POST request to http://localhost:4000/ with the following JSON body structure:

```json

{
    "html": "<!DOCTYPE html><html><head><style>body {background-color: powderblue;} h1 {color: blue;} p {color: red;}</style></head><body><h1>This is a heading</h1><p>This is a paragraph.</p></body></html>",
    "title": "<your-pdf-title>"
}
```

Replace `<your-pdf-title>` with your desired title for the PDF. You should receive a response with the base64-encoded PDF.

## Advanced HTML Example

A more complex example of HTML with a table, an image, and a Google font:

```json

{
    "html": "<!DOCTYPE html><html><head><link href='https://fonts.googleapis.com/css?family=Roboto' rel='stylesheet'><style>body {font-family: 'Roboto';}</style></head><body><h1 style='color: blue;'>This is a heading</h1><p style='color: red;'>This is a paragraph.</p><table style='width:50%'><tr><th>Firstname</th><th>Lastname</th></tr><tr><td>John</td><td>Doe</td></tr><tr><td>Jane</td><td>Doe</td></tr></table><img src='https://via.placeholder.com/150'></body></html>",
    "title": "<your-pdf-title>"
}
```

## Stopping the Service

To stop the service, use the following command:

```bash
docker-compose down
```

Or if you used `docker run`, find the container ID with `docker ps`, then stop it with `docker stop <container-id>`.

## Running in Production
For production use, we recommend using a reverse proxy like Nginx or a load balancer in front of the service. For managing the Docker containers in production, consider using a container orchestration system like Kubernetes or Docker Swarm.

## Troubleshooting

### Issue: JSON Syntax Error due to Double Quotes in HTML Content

When sending a JSON payload to the microservice, you may encounter an issue where double quotes (") within the HTML content interfere with the JSON syntax, causing a syntax error. This happens because in JSON, string values must be written with double quotes. If your HTML content includes double quotes (for example, to define attribute values in HTML tags), these could conflict with the JSON formatting.

### Solution
To resolve this issue, you must ensure that the double quotes within the HTML string are properly escaped. This is typically achieved by prefixing the double quotes with a backslash `(\")`.

However, if you're constructing the JSON payload using a built-in function in your programming language, like `json.dumps()` in Python or `JSON.stringify()` in JavaScript, these functions should automatically escape the double quotes for you.

If you're still encountering issues despite properly escaping the double quotes in your HTML, please verify that you're constructing your JSON payload correctly and that the rest of your HTML content is properly formatted.

## License
This project is open source, under the terms of the MIT license.