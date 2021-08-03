#!/usr/bin/env node

var BiwaScheme = require("biwascheme");

console.globals = {
    biwa: BiwaScheme,
    http: require("http"),
    ws: require("ws"),
    module: module,
    exports: exports
}

BiwaScheme.run_file(__dirname+"/Scheme/shamisen-server.scm");
