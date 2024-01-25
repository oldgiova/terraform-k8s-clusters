#!/bin/bash
jq -n \
    --arg ssh_connection "ssh://${KIND_REMOTE_USER}@${KIND_REMOTE_HOST}" \
    --arg api_server_address "${KIND_REMOTE_HOST}" \
    '{"DOCKER_HOST": $ssh_connection, "TF_VAR_api_server_address": $api_server_address}'
