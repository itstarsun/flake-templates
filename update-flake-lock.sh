#!/usr/bin/env bash
find . -name flake.lock -exec bash -c 'cd "$(dirname "{}")" && nix flake update' \;
