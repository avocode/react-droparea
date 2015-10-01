#!/bin/bash

# Launch chromedriver
${CHROMEDRIVER_PATH:=./node_modules/.bin/chromedriver} &

# Save chromedriver PID
CHROMEDRIVER_PID=$!

# Launch server
webpack-dev-server --hot --progress --colors --port 3000 &

# Save server PID
SERVER_PID=$!

# Launch mocha tests
./node_modules/.bin/wdio wdio.config.js

kill $CHROMEDRIVER_PID
kill $SERVER_PID
