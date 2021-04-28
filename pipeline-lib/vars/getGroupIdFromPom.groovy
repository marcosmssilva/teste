#!/usr/bin/env groovy

def call() {
  if (readMavenPom().getParent() == null) {
    readMavenPom().getGroupId()
  } else {
    readMavenPom().getParent().getGroupId()
  }
}
