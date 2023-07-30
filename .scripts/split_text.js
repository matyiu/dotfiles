#!/usr/bin/node

const fs = require("fs");

const getFileName = () => {
  const fileName = process.argv.slice(-1);

  return fileName;
};

try {
  const file = fs.readFileSync("./" + getFileName(), "utf8");

  const uniqueWords = new Set(file.split(/[\s.,;:\d]+/));

  fs.writeFileSync("vocab.json", JSON.stringify(Array.from(uniqueWords)));
} catch (error) {
  console.error(error);
}
