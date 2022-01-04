#!/bin/sh -ue

sam local invoke HelloFunction \
	  -e events/event.json
