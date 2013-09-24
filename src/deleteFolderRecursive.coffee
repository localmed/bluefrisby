fs = require 'fs'

deleteFolderRecursive = (path) ->
    files = [];
    if fs.existsSync(path)
        files = fs.readdirSync(path);
        files.forEach (file,index) ->
            curPath = path + "/" + file;
            if fs.statSync(curPath).isDirectory()
                deleteFolderRecursive(curPath);
            else
                fs.unlinkSync(curPath);
        fs.rmdirSync(path);

module.exports = deleteFolderRecursive
