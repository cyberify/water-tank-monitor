#!/bin/bash

chat_id=""
bot_token=""

curl -s -X POST https://api.telegram.org/$bot_token/sendMessage -d chat_id=$chat_id -d text="$1"
