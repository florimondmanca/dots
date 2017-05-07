Matrix = require('matrix')
luaunit = require('luaunit')
math.randomseed(os.time())

testNew = function()
    m = Matrix(45, 23)
    for i = 1, 45 do for j = 1, 23 do
        luaunit.assertEquals(m:get(i, j), 0)
    end end
end

testIter = function()
    local m = Matrix(4, 4)
    for i = 1, 4 do for j = 1, 4 do
        m:set(i, j, i + j)
    end end
    local size = 0
    items = {}
    for i, j, item in m:iter() do
        size = size + 1
        table.insert(items, item)
    end
    luaunit.assertEquals(items, {
        2, 3, 4, 5,
        3, 4, 5, 6,
        4, 5, 6, 7,
        5, 6, 7, 8
    })
    luaunit.assertEquals(size, 4*4)
end

testRow = function()
    local m = Matrix(4, 4)
    for i = 1, 4 do
        m:set(i, i, i) -- fill diagonal
    end
    m:set(1, 2, 1)  -- m[first row, second column] = 1
    luaunit.assertEquals(m:row(1), {1, 1, 0, 0})
    luaunit.assertEquals(m:row(2), {0, 2, 0, 0})
    luaunit.assertEquals(m:row(3), {0, 0, 3, 0})
    luaunit.assertEquals(m:row(4), {0, 0, 0, 4})
end

testColumn = function()
    local m = Matrix(4, 4)
    for i = 1, 4 do
        m:set(i, i, i)
    end
    m:set(2, 1, 1) -- m[second row, first column] = 1
    luaunit.assertEquals(m:column(1), {1, 1, 0, 0})
    luaunit.assertEquals(m:column(2), {0, 2, 0, 0})
    luaunit.assertEquals(m:column(3), {0, 0, 3, 0})
    luaunit.assertEquals(m:column(4), {0, 0, 0, 4})
end

testRollRow = function()
    local m = Matrix(4, 4)
    for i = 1, 4 do m:set(1, i, i) end
    m:roll(1, 1, 1)
    luaunit.assertEquals(m:row(1), {4, 1, 2, 3})
    m:roll(1, 1, -1)
    m:roll(1, 1, -1)
    luaunit.assertEquals(m:row(1), {2, 3, 4, 1})
end

testRollColumn = function()
    local m = Matrix(4, 4)
    for j = 1, 4 do m:set(j, 1, j) end
    m:roll(2, 1, 1)
    luaunit.assertEquals(m:column(1), {4, 1, 2, 3})
    m:roll(2, 1, -1)
    m:roll(2, 1, -1)
    luaunit.assertEquals(m:column(1), {2, 3, 4, 1})
end


os.exit(luaunit.LuaUnit.run())
