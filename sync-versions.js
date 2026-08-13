const fs = require("fs");

const { version } = require("./package.json");

const filename = "./Chart.yaml";
let str = fs.readFileSync(filename).toString();
str = str.replace(/version: (.*)/m, `version: ${version}`);
fs.writeFileSync(filename, str);
