#! /bin/bash

STIRLING_PORT=9000

docker run -d \
  -p $STIRLING_PORT:8080 \
  -v $HOME/Work/dev-config.d/stirling-pdf/trainingData:/usr/share/tessdata \
  -v $HOME/Work/dev-config.d/stirling-pdf/extraConfigs:/configs \
  -v $HOME/Work/dev-config.d/stirling-pdf/logs:/logs \
  -e DOCKER_ENABLE_SECURITY=false \
  -e INSTALL_BOOK_AND_ADVANCED_HTML_OPS=false \
  -e LANGS=en_GB \
  --name stirling-pdf \
  frooodle/s-pdf:latest

echo "Serving stirling pdf at :$STIRLING_PORT"
