--Code runner for nvium written in lua
--
--Runs single files, or projects
--Runs: lua, c/c++, py, java, asm, html(Opens in browser)
function main(mode, fileDir)
    --mode 1: runs the single file
    --mode 2: runs the whole project
    --mode 3: runs the first line of the source file
    if (mode == "1") then
        fileLang = getFileType(fileDir)
        if (fileLang == "lua") then
            os.execute("kitty --title 'lua' bash -c 'lua "..fileDir.."; exec bash' &")
        elseif (fileLang == "c") then
            os.execute("kitty --title 'c' bash -c 'gcc -o temp/temp "..fileDir.." && ./temp/temp; exec bash' &")
        elseif (fileLang == "cpp") then
            os.execute("kitty --title 'cpp' bash -c 'g++ -o temp/temp "..fileDir.." && ./temp/temp; exec bash' &")
        elseif (fileLang == "py") then
            os.execute("kitty --title 'py' bash -c 'python "..fileDir.."; exec bash' &")
        elseif (fileLang == "java") then
            os.execute("kitty --title 'java' bash -c 'java "..fileDir.."; exec bash' &")
        elseif (fileLang == "cs") then
            os.execute("kitty --title 'java' bash -c 'dotnet new console -o tempRun --use-program-main --force > /dev/null && cp "..fileDir.." tempRun/Program.cs && dotnet run --project tempRun && rm -rf
 tempRun; exec bash' &")
        elseif (fileLang == "asm") then
            os.execute("kitty --title 'asm' bash -c 'nasm -felf64 "..fileDir.." && ld temp.o -o temp && ./temp; exec bash' &")
        elseif (fileLang == "html") then
            os.execute("firefox "..fileDir.." &")
        else
            print("File type not supported")
            return 1
        end
    elseif (mode == "2") then
        print("Mode still in production")
    elseif (mode == "3") then
        currentFile = io.open(fileDir, "r")
        io.input(currentFile)
        firstLine = io.read()
        command = firstLine.gsub(firstLine, ".*RC:%s?", "")
        os.execute("kitty --title 'RC' bash -c '"..command.."; exec bash' &")
    end
    return 0
end

function getFileType(path)
    return path:match("%.([^.]+)$")
end


vim.api.nvim_create_user_command(
    "Trun",
    function()
        local fileDir = vim.fn.expand('%')
        local mode = "1"

        currentFile = io.open(fileDir, "r")
        io.input(currentFile)
        firstLine = io.read()
        if string.find(string.lower(firstLine), "rc:") then
            mode = "3"
        end


        main(mode, fileDir)
    end,
    { nargs = 0 }
)
