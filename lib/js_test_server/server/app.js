var path = require("path");
var libDir = path.join(path.dirname(__filename), "express/lib");
require.paths.unshift(libDir)

var kiwi = require('kiwi'),
    sys = require('sys');

var express = require('express')
get('/', function(){
  this.contentType('html')
  return '<h1>Welcome To Express</h1>'
})

run()
