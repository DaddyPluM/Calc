require ("button")

function love.load()
    win_width, win_height = love.window.getDesktopDimensions()
    row_start = 250     --The point where the keypad starts
    button_size = 120
    display = "0"   --What the user will see (The Screen). It will contain all the calculations
    calc_keypad = {1, 2, 3, 4, 5, 6, 7, 8, 9, 0, "-", "/", "."}
    pc_keypad = {"kp1", "kp2", "kp3", "kp4", "kp5", "kp6", "kp7", "kp8", "kp9", "kp0", "kp+", "kp-", "kp/", "kp*","kp."}
    love.graphics.setNewFont(60)    --Sets font size
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
            display = display..v
        else
            display = display..v
        end
    end

    function clear()    --Clears the display
        display = "0"
    end

    function equals()   --Solves the equation on screen
        local result = load("return "..display)()   --This is how the calculator calculates. I can't explain it properly. Load turns a string (display) into code that is then executed. E.g. if display = "3+3", load will turn it into code and execute 3+3
        display = result
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

function love.draw()
    --Drawing the screen
    love.graphics.setColor(.1,.1,.3)
    love.graphics.rectangle("fill",0,0,win_width-10,240)
    --The same system we used for loading the buttons but now used for drawing them instead
    for i, v in ipairs(row.one) do
        if i ~= 5 then  --Checks if the button it is about to draw is not the OFF button
            row.one[i]:draw((i-.9)*170, row_start)
        else    --If it is the OFF button
            row.one[5]:draw((5-.9)*170, row_start,20,nil,.5,0,0,"fill")     --Because the OFF buttons is a different colour, we need to pass in some extra parameters
        end
    end
    for i, v in ipairs(row.two) do
        row.two[i]:draw((i-.9)*170, row_start+130)
    end
    for i, v in ipairs(row.three) do
        row.three[i]:draw((i-.9)*170, row_start+260)
    end
    for i, v in ipairs(row.four) do
        row.four[i]:draw(((i+.5)-.9)*170, row_start+390)
    end

    love.graphics.print(display,0,80)    --Displays numbers onto the screen
end


function love.keypressed(key)   --Checks which key on the keyboard was pressed
    if key == "escape" then
        off()
    elseif key == "return" or key == "="  or key == "kpenter" then
        equals()
    elseif key == "c" then
        clear()
    elseif key == "x" then
        display = display.."*"
    elseif key == "backspace" then      --Deletes the last typed number
        if display ~= "0"  and string.len(display) > 1 then     --Finds the last character in the string "display" and removes it
                display = display:sub(1, -2)
        else
            display = "0"
        end
    end
    for k, v in pairs(calc_keypad) do   --Links the calculator's keypad to the keyboard
        if key == tostring(v) then
            if display == "0" then
                    display = ""
                    display = display..v
            else
                display = display..v
            end
        end
    end
    for i,v in pairs(pc_keypad) do      --Links the calculator's keyapd to the keyboard's keypad
        if key == v then
                key = string.gsub(v, "kp", "")      --If the 9 key on the keyboard's keypad was pressed, it will detect it as "kp9" was pressed. This line of code removes the first two characters, kp, from the string. Remove this line and you will see what I mean.
                if display == "0" then
                        display = ""
                        display = display..key
                else
                    display = display..key
                end
        end
    end
end
