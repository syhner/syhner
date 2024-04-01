#!/usr/bin/env bash

if [[ "$OSTYPE" == "linux-gnu"* ]] || [[ "$OSTYPE" == "cygwin"* ]]; then
  return # TODO
elif [[ "$OSTYPE" == "darwin"* ]]; then
  return # TODO
elif [[ "$OSTYPE" == "msys" ]]; then
  return # TODO
fi
