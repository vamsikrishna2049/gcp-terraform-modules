import os
import logging
from http.server import HTTPServer, BaseHTTPRequestHandler
from google.cloud import secretmanager

logging.basicConfig(level=logging.INFO)

PROJECT_ID = os.getenv("PROJECT_ID")
SECRET_ID = os.getenv("SECRET_ID")
CLOUD_SQL_INSTANCE = os.getenv("CLOUD_SQL_INSTANCE")
PORT = int(os.getenv("PORT", "8080"))


def rotate_secret():
    if not PROJECT_ID or not SECRET_ID:
        logging.warning("PROJECT_ID or SECRET_ID not set; skipping rotation")
        return "Skipped"
    client = secretmanager.SecretManagerServiceClient()
    secret_name = f"projects/{PROJECT_ID}/secrets/{SECRET_ID}/versions/latest"
    response = client.access_secret_version(name=secret_name)
    payload = response.payload.data.decode("UTF-8")
    logging.info("Secret rotation triggered for instance %s", CLOUD_SQL_INSTANCE)
    logging.info("Secret value length: %d", len(payload))
    return "OK"


class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.end_headers()
        self.wfile.write(b"OK")

    def do_POST(self):
        rotate_secret()
        self.send_response(200)
        self.end_headers()
        self.wfile.write(b"Rotated")


if __name__ == "__main__":
    logging.info("Starting HTTP server on port %d", PORT)
    HTTPServer(("0.0.0.0", PORT), Handler).serve_forever()
