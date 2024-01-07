require ("button")

function love.load()
    font = "Inconsolata-Regular.ttf"
    cursor = {
        width = 20,
        height = 2,
        x = 0,
        offset = 0,
    }
    win_width, win_height = love.window.getMode()
    row_start = 125    --The point where the keypad starts
    button_size = 60
    display = "0"   --What the user will see (The Screen). It will contain all the calculations
    calc_keypad = {1, 2, 3, 4, 5, 6, 7, 8, 9, 0, "-", "/", "."}
    pc_keypad = {"kp1", "kp2", "kp3", "kp4", "kp5", "kp6", "kp7", "kp8", "kp9", "kp0", "kp+", "kp-", "kp/", "kp*","kp."}
    love.graphics.setFont(love.graphics.newFont(font, 40))    --Sets font size
     row = {     --This table contains about the buttons for each row
        one = {7, 8, 9, "C","OFF"},
        two = {4, 5,6, "+","-"},
        three = {1, 2, 3, "x","÷"},
        four = {0, ".","^","="}
    }

    function click(v)   --Handles the keypad input
        if v == "x" then    --Computers don't use "x" for multiplication
            v = "*"
        elseif v == "÷" then    --Computers don't use "÷" for multiplication
            v = "/"
        elseif v == "C" then
            clear()
            v = "0"
        elseif v == "=" then
            equals()
            v = ""
        end
        if display == "0" then
            display = ""
            input_character(v)
        else
            input_character(v)
        end
    end
    
    function input_character(character)     --This function handles adding or removing text from the screen
        display = display:sub(1, (#display + cursor.offset)) .. character ..display:sub((#display + cursor.offset) + 1)     --It copies the part of the string from the cursor to the left, add the character that is supposed to be added then add the rest of the string after the cursor and displays it on the screem
    end

    function clear()    --Clears the display
        display = "0"
        cursor.offset = 0
    end

    function equals()   --Solves the equation on screen
        if load("return "..display) == nil then
            display = "Error"
        else
            local result = load("return "..display)()   --This is how the calculator calculates. I can't explain it properly. Load turns a string (display) into code that is then executed. E.g. if display = "3+3", load will turn it into code and execute 3+3
            display = tostring(result)
        end
    end

    function off()  --Turns off the calculator
        love.event.quit()
    end

    function love.mousereleased(x, y, button, isTouch, presses)     --Whenever the left mouse button is released, check if it was over a button and what button it was over
        if button == 1 then
            for buttonIndex in pairs(row.one) do
                row.one[buttonIndex]:checkPressed(x, y)
            end
            for buttonIndex in pairs(row.two) do
                row.two[buttonIndex]:checkPressed(x, y)
            end
            for buttonIndex in pairs(row.three) do
                row.three[buttonIndex]:checkPressed(x, y)
            end
            for buttonIndex in pairs(row.four) do
                row.four[buttonIndex]:checkPressed(x, y)
            end
        end
    end
    --[[This makes loading buttons easier
    It reads through a table and for every value, it gets its position in the table and the value itself]]
    for i, v in ipairs(row.one) do
        if i ~= 5 then      --We need this for buttons that don't display onto the screen e.g OFF
            row.one[i] = button(tostring(v), click, v )
        else
            row.one[5] = button("OFF", off)     --Special button
        end
    end
    for i, v in ipairs(row.two) do
        row.two[i] = button(tostring(v), click, v)
    end
    for i, v in ipairs(row.three) do
        row.three[i] = button(tostring(v), click, v)
    end
    for i, v in ipairs(row.four) do
            row.four[i] = button(tostring(v), click, v)
    end
end

function love.update()
    cursor.x = ((#display - 1) + cursor.offset) * (cursor.width - 1) * 1.05     --Updates the position of the cursor
end

function love.draw()
    --Drawing the screen
    love.graphics.setColor(.1,.1,.3)
    love.graphics.rectangle("fill",0,0,win_width,120)
    --The same system we used for loading the buttons but now used for drawing them instead
    for i, v in ipairs(row.one) do
        if i ~= 5 then  --Checks if the button it is about to draw is not the OFF button
            row.one[i]:draw((i-.9)*85, row_start)
        else    --If it is the OFF button
            row.one[5]:draw((5-.9)*85, row_start,10,nil,.5,0,0,"fill")     --Because the OFF buttons is a different colour, we need to pass in some extra parameters
        end
    end
    for i, v in ipairs(row.two) do
        row.two[i]:draw((i-.9)*85, row_start+65)
    end
    for i, v in ipairs(row.three) do
        row.three[i]:draw((i-.9)*85, row_start+130)
    end
    for i, v in ipairs(row.four) do
        row.four[i]:draw(((i+.5)-.9)*85, row_start+195)
    end

    love.graphics.print(display,0,70)    --Displays numbers onto the screen
    
    love.graphics.setColor(.0,.8,.4, .7)
    love.graphics.rectangle("fill",cursor.x,112,cursor.width,cursor.height)     -- Draws the cursor onto the screen
end


function love.keypressed(key)   --Checks which key on the keyboard was pressed
    if key == "escape" then
        off()
    elseif (love.keyboard.isDown "lshift") or (love.keyboard.isDown "rshift")then     --If Left Shift is being held down
        if display == "0" then
            display = ""
        end
        if key == "=" then 
            input_character("+")
        elseif key == "8" then
            input_character("*")
        elseif key == "6" then
            input_character("^")
        elseif key == "9" then
            input_character("(")
        elseif key == "0" then
            input_character(")")
        end
    elseif key == "return" or key == "="  or key == "kpenter" then
        equals()
    elseif key == "c" then
        clear()
    elseif key == "x" then
        input_character("*")
    elseif key == "backspace" then      --Deletes the character at the position of the cursor
        if display ~= "0"  and string.len(display) > 1 then     --If the only number on screen is not 0
                display = display:sub(1, (#display + cursor.offset ) - 1) .. display:sub((#display + cursor.offset) + 1)    --Copy the characters on the left and right of the curosor and join(caoncatenate) them together thereby removing the character at the current position of the cursor
                if cursor.offset * -1 == #display then  --If the current position of the curso is off screen
                    cursor.offset = cursor.offset + 1
                end
        else
            display = "0"
        end
    elseif key == "left" then
        if (cursor.offset*-1) < (#display - 1) then
            cursor.offset = cursor.offset - 1   --Move cursor left
        end
    elseif key == "right" then
        if cursor.offset < 0 then
            cursor.offset = cursor.offset + 1   --Move cursor right
        end
    end
    for k, v in pairs(calc_keypad) do   --Links the calculator's keypad to the keyboard
            if (love.keyboard.isDown "lshift") or (love.keyboard.isDown "rshift") then  --Beacuse of the way the calculator is programmed, holding either of the shift buttons and clicking a number actually adds the operator on that key to the number on that same key. For example, holding Left Shift and pressing 8 should actually display "*8" but this line of code prevents that by checking if Left or Right Shift is being held down and if so, don't add any new character
            
            elseif key == tostring(v) then
                if display == "0" then
                    if key == "." then  --I don't actully know what this does
                        
                    end
                    display = ""
                    input_character(v)
                else
                    input_character(v)
                end
            end
    end
    for i,v in pairs(pc_keypad) do      --Links the calculator's keyapd to the keyboard's keypad
        if key == v then
                key = string.gsub(v, "kp", "")      --If the 9 key on the keyboard's keypad was pressed, it will detect it as "kp9" was pressed. This line of code removes the first two characters, kp, from the string. Remove this line and you will see what I mean.
                if display == "0" then
                        display = ""
                        input_character(key)
                else
                        input_character(key)
                end
        end
    end
end
