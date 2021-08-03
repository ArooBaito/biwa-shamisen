#!/usr/bin/env node
var BiwaScheme = require("biwascheme");
console.globals = {
    http: require("http"),
    ws: require("ws"),
    readline: require("readline"),
    module: module,
    exports: exports
}

BiwaScheme.run_file(__dirname+"/Scheme/shamisen-client.scm");
