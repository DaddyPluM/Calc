require ("button")

function love.load()
    win_width, win_height = love.window.getDesktopDimensions()
    row_start = 250     --The point where the keypad starts
    button_size = 120
    display = "0"   --What the user will see (The Screen). It will contain all the calculations
    keypad = {1, 2, 3, 4, 5, 6, 7, 8, 9, 0, "-", "/", "."}
    love.graphics.setNewFont(60)    --Sets font size
    
    row = {     --This table contains about the buttons for each row
        one = {1, 2, 3, "c","OFF"},
        two = {4, 5,6, "+","-"},
        three = {7, 8, 9, "*","/"},
        four = {0, ".","^","="}
    }
    
    function click(v)   --Handles the keypad input
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

    function equals()   --Solve equation on screen
        local result = load("return "..display)()   --I can't eplain what this does properly because I don't understand it so you will need to look it up for help
        display = result
    end

    function off()  --Turns off the calculator
        love.event.quit()
    end
    
    function love.mousereleased(x, y, button, isTouch, presses)     --Whenevr the left mouse button is released, check if  it was ove a button and what button it was over
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
        if i ~= 5 and  i ~= 4 then      --We need this for buttons that don't display onto the screen e.g OFF
            row.one[i] = button(tostring(v), click, v )
        else
            row.one[5] = button("OFF", off)     --Special buttons
            row.one[4] = button("c", clear)
        end
    end
    for i, v in ipairs(row.two) do
        row.two[i] = button(tostring(v), click, v)
    end
    for i, v in ipairs(row.three) do
        row.three[i] = button(tostring(v), click, v)
    end
    for i, v in ipairs(row.four) do
        if i ~= 4 then
            row.four[i] = button(tostring(v), click, v)
        else
            row.four[4] = button("=", equals)
        end
    end
end

function love.draw()
    --Drawing the screen
    love.graphics.setColor(.1,.1,.3)
    love.graphics.rectangle("fill",0,0,win_width-10,240)
    --The same system we used for loading the buttons but now used for drawing them instead
    for i, v in ipairs(row.one) do
        if i ~= 5 then  --This is for  special buttons
            row.one[i]:draw((i-.9)*170, row_start)
        else
        row.one[5]:draw((5-.9)*170, row_start,20,nil,.5,0,0,"fill")     --Because the OFF buttons is a different colour, we need to pass in some extra parameters
        end
    end
    for i, v in ipairs(row.two) do
        row.two[i]:draw((i-.9)*170, row_start+130)
    end
    for i, v in ipairs(row.three) do
        row.three[i]:draw((i-.9)*170, row_start+260)
    end
    --This row doesn't use the system because
    for i, v in ipairs(row.four) do
    row.four[i]:draw(((i+1)-.9)*170, row_start+390)
    end 

    love.graphics.print(display,0,80)    --Displaying numbers onto the screen
end


function love.keypressed(key)   --Check which key on the keyboard was pressed
    if key == "escape" then
        off()
    end
    if key == "return"
    or
    key == "=" then
        equals()
    end
    if key == "c" then
        display = "0"
    end
    if key == "backspace" then 
        if display ~= "0"  and string.len(display) > 1 then     --Find the last character in the string "display" and removes it
                display = display:sub(1, -2)
        else
            display = "0"
        end
    end
    for k, v in pairs(keypad) do   --This links the keypad to the keyboard
        if key == tostring(v) then
            if display == "0" then
                    display = ""
                display = display..v
            else
                display = display..v
            end
        end
    end
    display = tostring(display)     --The system set up for deleting doesn't work on numbers, only on strings.
end