#!/bin/bash

circleci config pack src > orb.yml
circleci orb publish orb.yml circleci/gcp-gcr@dev:alpha
rm -rf orb.yml
