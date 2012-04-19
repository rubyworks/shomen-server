---
source:
- meta
authors:
- name: trans
  email: transfire@gmail.com
copyrights: []
requirements:
- name: shomen
- name: shomen-yard
- name: rdoc-shomen
- name: qed
  groups:
  - test
  development: true
- name: ae
  groups:
  - test
  development: true
- name: detroit
  groups:
  - build
  development: true
- name: fire
  groups:
  - build
  development: true
dependencies: []
alternatives: []
conflicts: []
repositories:
- uri: git://github.com/rubyworks/shomen-server.git
  scm: git
  name: upstream
resources:
- uri: http://rubyworks.github.com/shomen-server
  name: home
  type: home
- uri: http://github.com/rubyworks/shomen-server/wiki
  name: docs
  type: doc
- uri: http://github.com/rubyworks/shomen-server
  name: code
  type: code
- uri: http://github.com/rubyworks/shomen-server/issues
  name: bugs
  type: bugs
- uri: http://groups.google.com/groups/rubyworks-mailinglist
  name: mail
  type: mail
- uri: http://chat.us.freenode.net/rubyworks
  name: chat
  type: chat
extra: {}
load_path:
- lib
revision: 0
created: '2010-07-01'
summary: Real-Time Documentation Server
title: Shomen Server
version: 0.1.0
name: shomen-server
description: ! 'Shomen Server is a front end for viewing API documentation of locally

  installed gems. It is a dynamic server and will generate the documentation

  as needed. Shomen server support a number of different interface themes

  selectable from the main menu to suite different tastes.'
organization: rubyworks
date: '2012-04-19'
