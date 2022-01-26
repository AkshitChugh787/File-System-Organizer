// We will be creating a File System Organizer////Features of the Project -//If you have numerous Files in a folder and they are not Properly arranged//So you can use this tool to arrange them in specific directory according to their extension// like text files will go into text File Folder .exe files will go into application folder and so on// so at the end you will have a arranged set of files in specific folders

//let input = process.argv[2] // node index0, FO.js index1, command index2, that's why argv[2]

const fs = require("fs");

const path = require("path");

let input = process.argv.slice(2); // node filename command folder-path
// input will slice it and show as array like ['command','folder-path']

let command = input[0]; // command
// console.log(command)

switch (command) {
  case "tree":
    console.log("Tree Implemented");
    break;
  case "organize":
    organizeFn(input[1]);
    break;
  case "help":
    helpFn();
    break;
  default:
    console.log("Please enter a valid command");
}
// help function will list all the ways by which you can run the commands of this project
function helpFn() {
  console.log(`List of all commands ->
                        1) tree - node FO.js tree <dirPath>
                        2) organize - node FO.js organize <dirPath>
                        3) help - node FO.js help            `);
}

function organizeFn(dirPath) {
  let destPath;
  if (dirPath == undefined) {
    console.log("Please enter a valid directory path");
    return;
  }
  let doesExist = fs.existsSync(dirPath); // check if path exists or not
  if (doesExist) {
    destPath = path.join(dirPath, "organizedFiles"); // if true, now make a path inside it as organizedFiles
    if (fs.existsSync(destPath) == false) {
      // this is to check if the folder created above doesn't already exists, if not then create it by mkdir
      fs.mkdirSync(destPath);
    } else {
      console.log("Folder already exists"); // else it means my folder already exists
    }
  }
}
