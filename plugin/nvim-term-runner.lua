--Code runner for nvium written in lua
--
--Runs single files, or projects
--Runs: lua, c/c++, py, java, asm, html(Opens in browser)

print("Plugin loaded")

function main(mode, fileDir)
    --mode 1: runs the single file
    --mode 2: runs the whole project
    --mode 3: runs the first line of the source file
    if (mode == "1") then
        fileType = fileType(fileDir)
        if (fileType == "lua") then
            os.execute("kitty --title 'lua' bash -c 'lua "..fileDir.."; exec bash' &")
        elseif (fileType == "c") then
            os.execute("kitty --title 'c' bash -c 'gcc -o temp/temp "..fileDir.." && ./temp/temp; exec bash' &")
        elseif (fileType == "cpp") then
            os.execute("kitty --title 'cpp' bash -c 'g++ -o temp/temp "..fileDir.." && ./temp/temp; exec bash' &")
        elseif (fileType == "py") then
            os.execute("kitty --title 'py' bash -c 'python "..fileDir.."; exec bash' &")
        elseif (fileType == "java") then
            os.execute("kitty --title 'java' bash -c 'java "..fileDir.."; exec bash' &")
        elseif (fileType == "asm") then
            os.execute("kitty --title 'asm' bash -c 'nasm -felf64 "..fileDir.." && ld temp.o -o temp && ./temp; exec bash' &")
        elseif (fileType == "html") then
            os.execute("firefox "..fileDir.." &")
        else
            print("File type not supported")
            return 1
        end
    elseif (mode == "2") then
        print("Mode still in production")
    elseif (mode == "3") then
        file = io.open(fileDir, "r")
        io.input(file)
        firstLine = io.read()
        command = firstLine.gsub(firstLine, ".*RC:%s?", "")
        os.execute("kitty --title 'RC' bash -c '"..command.."; exec bash' &")
    end
    return 0
end

function fileType(path)
    return path:match("%.([^.]+)$")
end


vim.api.nvim_create_user_command(
    "Trun",
    function()
        print("Test trun command")
    end,
    { nargs = 0 }
)

vim.keymap.set('n', '<F5>', function()
    local fileDir = vim.fn.expand('%')
    local mode = "1"
    
    main(mode, fileDir)
end)
