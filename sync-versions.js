const fs = require("fs");

const { version } = require("./package.json");

fs.readdirSync("charts").forEach((dir) => {
    const filename = `./charts/${dir}/Chart.yaml`;
    let str = fs.readFileSync(filename).toString();
    str = str.replace(/version: (.*)/m, `version: ${version}`);
    fs.writeFileSync(filename, str);
});
