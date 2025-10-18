--[[
LazyLua ver1.0.0.
by ikunactrl.
Starttime: 2025/10/17
Release date of this version: 2025/10/18

This project is licensed under the MIT License. See https://opensource.org/licenses/MIT
for details.
--]]

LazyLua = {}

--[[
初始化 Math 类
--]]
function Mathinit()
    LazyLua.Math = {}

    local function mathadd(a, b)
        a = LazyLua.Math.normalize(a)
        b = LazyLua.Math.normalize(b)
        if LazyLua.Math.lessThan(a, '0') then
            error("mathadd: a must be >= 0, but got a=" .. a)
        end
        if LazyLua.Math.lessThan(b, '0') then
            error("mathadd: b must be >= 0, but got b=" .. b)
        end
        local i = #a
        local c = 1
        local A = {}
        while i > 0 do
            A[c] = string.sub(a, i, i)
            c = c + 1
            i = i - 1
        end
        i = #b
        c = 1
        local B = {}
        while i > 0 do
            B[c] = string.sub(b, i, i)
            c = c + 1
            i = i - 1
        end
        i = 1
        local carry = 0
        local result = {}
        local digitA = 0
        local digitB = 0
        local total = 0
        local digit = 0
        while i <= #A or i <= #B or carry == 1 do
            digitA = 0
            digitB = 0
            if i <= #A then
                digitA = math.floor(A[i])
            end
            if i <= #B then
                digitB = math.floor(B[i])
            end
            total = math.floor(digitA + digitB + carry)
            digit = total % 10
            carry = math.floor(total / 10)
            result[i] = digit
            i = i + 1
        end
        local resstr = ""
        for j = #result, 1, -1 do
            resstr = resstr .. result[j]
        end
        return LazyLua.Math.normalize(resstr)
    end
    local function mathsub(a, b)
        if LazyLua.Math.lessThan(a, b) then
            error("mathsub: a must be >= b, but got a=" .. a .. ", b=" .. b)
        end
        local i = #a
        local c = 1
        local A = {}
        while i > 0 do
            A[c] = string.sub(a, i, i)
            c = c + 1
            i = i - 1
        end
        i = #b
        c = 1
        local B = {}
        while i > 0 do
            B[c] = string.sub(b, i, i)
            c = c + 1
            i = i - 1
        end
        i = 1
        local borrow = 0
        local result = {}
        local digitA = 0
        local digitB = 0
        local diff = 0
        while i <= #A do
            digitA = A[i]
            digitB = 0
            if i <= #B then
                digitB = B[i]
            end
            diff = math.floor(digitA - digitB - borrow)
            if diff < 0 then
                diff = diff + 10
                borrow = 1
            else
                borrow = 0
            end
            result[i] = diff
            i = i + 1
        end
        local resstr = ""
        for j = #result, 1, -1 do
            resstr = resstr .. result[j]
        end
        return LazyLua.Math.normalize(resstr)
    end
    local function mathmul(a, b)
        a = LazyLua.Math.normalize(a)
        b = LazyLua.Math.normalize(b)
        -- 输入检查
        if LazyLua.Math.lessThan(a, '0') then
            error("mathmul: a must be >= 0, but got a=" .. a)
        end
        if LazyLua.Math.lessThan(b, '0') then
            error("mathmul: b must be >= 0, but got b=" .. b)
        end
        a = LazyLua.Math.normalize(a)
        b = LazyLua.Math.normalize(b)

        if a == '0' or b == '0' then
            return '0'
        end

        local lenA, lenB = #a, #b
        local result = {}

        -- 竖式乘法
        for i = 1, lenA do
            local digitA = tonumber(a:sub(lenA - i + 1, lenA - i + 1))
            local carry = 0
            for j = 1, lenB do
                local digitB = tonumber(b:sub(lenB - j + 1, lenB - j + 1))
                local pos = i + j - 1
                local temp = (result[pos] or 0) + digitA * digitB + carry
                result[pos] = temp % 10
                carry = math.floor(temp / 10)
            end
            -- 处理进位
            local pos = i + lenB
            while carry > 0 do
                local temp = (result[pos] or 0) + carry
                result[pos] = temp % 10
                carry = math.floor(temp / 10)
                pos = pos + 1
            end
        end

        -- 转字符串
        local resstr = ""
        local leading = true
        for i = #result, 1, -1 do
            if leading and result[i] == 0 then
            else
                leading = false
                resstr = resstr .. result[i]
            end
        end

        return LazyLua.Math.normalize(resstr)
    end
    local function mathdiv(a, b)
        -- 输入检查
        if b == "0" then
            error("mathdiv: division by zero")
        end
        if a == "0" then
            return "0"
        end

        -- 确保 a >= 0, b > 0（我们只处理正整数）
        a = LazyLua.Math.normalize(a)
        b = LazyLua.Math.normalize(b)

        -- 如果 a < b，商为 0
        if LazyLua.Math.greaterThan(b, a) then
            return "0"
        end

        local quotient = "0" -- 商

        -- 主循环：不断从 a 中减去尽可能大的 b * 10^k
        while LazyLua.Math.greaterThanOrEqual(a, b) do
            local factor = "1" -- 当前倍数，比如 1, 10, 100...
            local currentB = b -- b * factor

            -- 倍增：找到最大的 currentB <= a
            while true do
                local nextB = LazyLua.Math.mul(currentB, "10") -- currentB * 10
                if LazyLua.Math.greaterThan(nextB, a) then
                    break                                      -- 超了，退出
                end

                currentB = nextB
                factor = LazyLua.Math.mul(factor, "10")
            end
            -- 现在 currentB <= a，可以减
            a = LazyLua.Math.sub(a, currentB)
            quotient = LazyLua.Math.add(quotient, factor)
        end
        return LazyLua.Math.normalize(quotient)
    end
    function LazyLua.Math.normalize(s)
        -- 如果是空字符串，返回 "0"
        if s == "" then return "0" end

        local neg = false
        local i = 1

        -- 检查是否有负号
        if string.sub(s, 1, 1) == '-' then
            neg = true
            i = 2 -- 从第2个字符开始看数字部分
        end

        -- 找到第一个非零数字的位置
        while i <= #s and string.sub(s, i, i) == '0' do
            i = i + 1
        end

        -- 如果全是零（比如 "000" 或 "-000"）
        if i > #s then
            return "0"
        end

        -- 提取有效数字部分
        local numPart = string.sub(s, i)

        -- 如果原来是负的，但现在是 "0"，就不加负号
        if numPart == "0" then
            return "0"
        end

        -- 返回带符号的结果
        return (neg and "-" or "") .. numPart
    end

    function LazyLua.Math.greaterThan(a, b) -- 大于。
        if a == b then return false end
        -- 负数一定比正数小
        if string.sub(a, 1, 1) == '-' and string.sub(b, 1, 1) ~= '-' then return false end
        if string.sub(a, 1, 1) ~= '-' and string.sub(b, 1, 1) == '-' then return true end

        --都是负数，开一个分支
        if string.sub(a, 1, 1) == '-' and string.sub(b, 1, 1) == '-' then
            -- 比如， -123 和 -456 比较，
            if #a == #b then
                --位数相同，逐位比较
                for i = 2, #a do
                    local digitA = string.sub(a, i, i)
                    local digitB = string.sub(b, i, i)
                    if digitA < digitB then
                        return true
                    elseif digitA > digitB then
                        return false
                    end
                end
            end
            return #a < #b
        end
        --剩下的都是正数了
        --其实把它们都改成负数，然后结果取反就行了
        return not LazyLua.Math.greaterThan('-' .. a, '-' .. b)
    end

    function LazyLua.Math.lessThan(a, b) -- 小于。
        return not LazyLua.Math.greaterThan(a, b) and a ~= b
    end

    function LazyLua.Math.greaterThanOrEqual(a, b) -- 大于等于。
        return LazyLua.Math.greaterThan(a, b) or a == b
    end

    function LazyLua.Math.lessThanOrEqual(a, b) -- 小于等于。
        return not LazyLua.Math.greaterThan(a, b) or a == b
    end

    --不等于和等于完全可以用字符串比较实现，就不写函数了

    --[[
    这里要考虑一下运算律以支持负数
    比如
    123 + (-456) 就要转换为 123 - 456
    123 - (-456) 就要转换为 123 + 456
    -123 + 456 就要转换为 456 - 123
    -123 - 456 中，预存负号，然后计算 123 + 456，最后加负号
    --]]



    function LazyLua.Math.add(a, b)
        local a1 = string.sub(a, 1, 1)
        local b1 = string.sub(b, 1, 1)
        if a1 == '-' and b1 ~= '-' then
            -- -a + b  => b - a
            return LazyLua.Math.sub(b, string.sub(a, 2))
        end
        if a1 ~= '-' and b1 == '-' then
            -- a + -b  => a - b
            return LazyLua.Math.sub(a, string.sub(b, 2))
        end
        if a1 == '-' and b1 == '-' then
            -- -a + -b => -(a + b)
            return '-' .. mathadd(string.sub(a, 2), string.sub(b, 2))
        end
        return mathadd(a, b)
    end

    function LazyLua.Math.sub(a, b)
        local a1 = string.sub(a, 1, 1)
        local b1 = string.sub(b, 1, 1)
        if a1 == '-' and b1 ~= '-' then
            -- -a - b => -(a + b)
            return '-' .. mathadd(string.sub(a, 2), b)
        end
        if a1 ~= '-' and b1 == '-' then
            -- a - -b => a + b
            return mathadd(a, string.sub(b, 2))
        end
        if a1 == '-' and b1 == '-' then
            -- -a - -b => b - a
            return LazyLua.Math.sub(string.sub(b, 2), string.sub(a, 2))
        end
        -- 两个正数相减，但是减不过，比如 123 - 456
        if LazyLua.Math.greaterThan(b, a) then
            return '-' .. mathsub(b, a)
        end
        return mathsub(a, b)
    end

    function LazyLua.Math.mul(a, b)
        local a1 = string.sub(a, 1, 1)
        local b1 = string.sub(b, 1, 1)
        if a1 == '-' and b1 == '-' then
            -- -a * -b => a * b
            a = string.sub(a, 2)
            b = string.sub(b, 2)
            return mathmul(a, b)
        end
        if a1 == '-' or b1 == '-' then
            -- ±a * ±b (a,b其中必有一个小于0) => -（|a| * |b|)
            if a1 == '-' then a = string.sub(a, 2) end
            if b1 == '-' then b = string.sub(b, 2) end
            return '-' .. mathmul(a, b)
        end

        return mathmul(a, b)
    end

    function LazyLua.Math.div(a, b)
        local a1 = string.sub(a, 1, 1)
        local b1 = string.sub(b, 1, 1)
        if a1 == '-' and b1 == '-' then
            -- -a / -b => -a * -(1/b) => a * 1/b => a / b
            a = string.sub(a, 2)
            b = string.sub(b, 2)
            return mathdiv(a, b)
        end
        if a1 == '-' or b1 == '-' then
            -- ±a / ±b (a,b其中必有一个小于0) => -（|a| / |b|)
            if a1 == '-' then a = string.sub(a, 2) end
            if b1 == '-' then b = string.sub(b, 2) end
            return '-' .. mathdiv(a, b)
        end
        return mathdiv(a, b)
    end
end

--[[
初始化 String 类
--]]
function Stringinit()
    LazyLua.String = {}
    --- 返回字符串的第 index 个字符（支持 UTF-8 中文）
    --- @param str string 要操作的字符串
    --- @param index integer 字符索引（从 1 开始）
    --- @return string? char 找到的字符，越界返回 nil
    function LazyLua.String.at(str, index)
        local a = 0
        -- 先纠正index 因为字母和汉字的字节数不一样！
        local count = 1
        local add = 0
        local x = 0 --经过的字符数
        while count <= #str do
            a = string.byte(str, count)
            if a < 128 then
                add = 1
            elseif a >= 194 and a <= 223 then
                add = 2
            elseif a >= 224 and a <= 239 then
                add = 3
            else        -- a >= 240 and a <= 244
                add = 4 -- emoji, 如 😊
            end
            x = x + 1
            if x == index then
                index = count
                break
            else
                count = count + add
            end
        end
        return string.sub(str, index, index + add - 1)
    end

    --- 返回字符串的第 index 个字符（支持 UTF-8 中文）
    --- @param str string 要操作的字符串
    --- @param index integer 字符索引（从 0 开始）
    --- @return string? char 找到的字符，越界返回 nil
    function LazyLua.String.charat(str, index) return LazyLua.String.at(str, math.max(index + 1, 1)) end

    function LazyLua.String.len(str)
        local a = 0
        local count = 1
        local add = 0
        local x = 0 --经过的字符数
        while count <= #str do
            a = string.byte(str, count)
            if a < 128 then
                add = 1
            elseif a >= 194 and a <= 223 then
                add = 2
            elseif a >= 224 and a <= 239 then
                add = 3
            else        -- a >= 240 and a <= 244
                add = 4 -- emoji, 如 😊
            end
            x = x + 1
            count = count + add
        end
        return x
    end

    --- 返回一个迭代器，用于遍历字符串的每个字符（支持 UTF-8）
    --- @param str string 要遍历的字符串
    --- @return function 迭代器函数
    --- @return string 状态（str）
    --- @return nil 初始值（无）
    function LazyLua.String.chars(str)
        local len = LazyLua.String.len(str) -- 预先计算总字符数
        local index = 1                     -- 当前字符索引（从1开始）

        -- 迭代器闭包
        local function iterator(state)
            if index > len then
                return nil -- 遍历结束
            end
            local char = LazyLua.String.at(state, index)
            index = index + 1
            return char
        end

        return iterator, str, nil
    end

    function LazyLua.String.substr(str, start, end_)
        if end_ == nil then end_ = LazyLua.String.len(str) end
        local result = ""
        local i = start
        while i <= end_ do
            result = result .. LazyLua.String.at(str, i)
            i = i + 1
        end
        return result
    end

    function LazyLua.String.indexof(str, substr, start)
        if #str < #substr then return -1 end
        if #str == #substr then return 1 end
        if start == nil then start = 1 end
        local i      = start
        local len    = LazyLua.String.len(str)
        local sublen = LazyLua.String.len(substr)
        while i <= len do
            if LazyLua.String.substr(str, i, i + sublen - 1) == substr then
                return i
            end
            i = i + 1
        end
        return -1
    end

    function LazyLua.String.left(str, n)
        return LazyLua.String.substr(str, 1, n)
    end

    function LazyLua.String.right(str, n)
        return LazyLua.String.substr(str, LazyLua.String.len(str) - n, n)
    end

    function LazyLua.String.split(str, delimiter)
        local i = 1
        local result = {}
        local j = 1
        local start = i
        local delimiterlen = LazyLua.String.len(delimiter)
        while i <= LazyLua.String.len(str) do
            if LazyLua.String.substr(str, i, i + delimiterlen - 1) == delimiter then
                result[j] = LazyLua.String.substr(str, start, i - 1)
                start = i + delimiterlen
                j = j + 1
            end
            i = i + 1
        end
        result[j] = LazyLua.String.substr(str, start)
        return result
    end

    function LazyLua.String.join(list, separator)
        local result = ""
        for i = 1, #list do
            result = result .. list[i]
            if i < #list then
                result = result .. separator
            end
        end
        return result
    end

    function LazyLua.String.lastindexof(str, substr)
        if #str < #substr then return -1 end
        if #str == #substr then if str ~= substr then return -1 else return 1 end end
        local i      = LazyLua.String.len(str)
        local sublen = LazyLua.String.len(substr)
        while i >= sublen do
            if LazyLua.String.substr(str, i - sublen + 1, i) == substr then
                return i - sublen + 1
            end
            i = i - 1
        end
        return -1
    end

    function LazyLua.String.includes(str, substr)
        return LazyLua.String.indexof(str, substr) ~= -1
    end

    function LazyLua.String.Repeat(str, n)
        local result = ""
        for i = 1, n do
            result = result .. str
        end
        return result
    end

    function LazyLua.String.replace(str, old, new, limit)
        limit = limit or -1
        local result = ""
        local i = 1
        local count = 0
        local oldlen = LazyLua.String.len(old)
        while i <= LazyLua.String.len(str) do
            if LazyLua.String.substr(str, i, i + oldlen - 1) == old and (limit == -1 or count < limit) then
                result = result .. new
                i = i + oldlen
                count = count + 1
            else
                result = result .. LazyLua.String.at(str, i)
                i = i + 1
            end
        end
        return result
    end

    function LazyLua.String.to2DTable(text, rowSep, colSep)
        rowSep = rowSep or "\n"
        colSep = colSep or ","
        local rows = LazyLua.String.split(text, rowSep)
        local tableResult = {}
        for i = 1, #rows do
            tableResult[i] = LazyLua.String.split(rows[i], colSep)
        end
        return tableResult
    end
    --- 从二维表的每个子表中取出指定索引的值，返回一个一维数组
    --- @param table2D table 二维表（如 LazyLua.String.to2DTable 返回的结构）
    --- @param index number|string 索引（数字表示位置，支持负数从末尾计；字符串表示键）
    --- @param default any 可选，若子表缺少该索引则使用此默认值（默认 nil）
    --- @return table values 结果数组
    function LazyLua.String.column(table2D, index, default)
        if type(table2D) ~= "table" then error("column: table2D must be a table") end
        local result = {}
        for i = 1, #table2D do
            local row = table2D[i]
            local value = default
            if type(row) == "table" then
                if type(index) == "number" then
                    local pos = index
                    if pos < 0 then
                        pos = #row + pos + 1
                    end
                    value = row[pos]
                else
                    value = row[index]
                end
                if value == nil then value = default end
            end
            result[#result + 1] = value
        end
        return result
    end
end

--[[
初始化 Sort 类
--]]
function Sortinit()
    LazyLua.Sort      = {}
    --升序：从小到大
    LazyLua.Sort.ASC  = 1
    --降序：从大到小
    LazyLua.Sort.DESC = 2

    --- 冒泡排序。简单的稳定排序
    --- @param arr table 要排序的数组
    --- @return table arrindex 排序后数组应当变换的下标映射表
    function LazyLua.Sort.bubble(arr, method)
        local n = #arr
        if n == 0 then return {} end

        -- 初始化下标映射：{1,2,3,...,n}
        local arrindex = {}
        for i = 1, n do
            arrindex[i] = i
        end

        -- 冒泡排序：通过 arrindex 间接访问原数组
        for i = 1, n - 1 do
            local isSorted = true
            for j = 1, n - i do
                local idx1 = arrindex[j] -- 原数组索引
                local idx2 = arrindex[j + 1]
                local val1 = arr[idx1]
                local val2 = arr[idx2]
                local a1 = false
                if method == LazyLua.Sort.ASC then
                    a1 = LazyLua.Math.greaterThan(val1, val2)
                elseif method == LazyLua.Sort.DESC then
                    a1 = LazyLua.Math.lessThan(val1, val2)
                else
                    error("Invalid sort method: " .. tostring(method))
                end
                -- 升序：如果前面 > 后面，就交换
                if a1 then
                    arrindex[j], arrindex[j + 1] = arrindex[j + 1], arrindex[j]
                    isSorted = false
                end
            end
            if isSorted then
                break
            end
        end

        return arrindex
    end

    --- 快速排序。高效的不稳定排序
    --- @param arr table 要排序的数组
    --- @param method number 排序方向，ASC 或 DESC
    --- @return table arrindex 排序后数组应当变换的下标映射表
    function LazyLua.Sort.quick(arr, method)
        if method == nil then
            method = LazyLua.Sort.ASC
        end

        local n = #arr
        if n == 0 then
            return {}
        end

        local a = {}        -- 值副本
        local arrindex = {} -- 下标映射
        for i = 1, n do
            a[i] = arr[i]
            arrindex[i] = i
        end

        local function swap(i, j)
            a[i], a[j] = a[j], a[i]
            arrindex[i], arrindex[j] = arrindex[j], arrindex[i]
        end

        local function partition(lo, hi)
            local pivot = a[hi]
            local i = lo

            for j = lo, hi - 1 do
                local shouldInclude = false
                if method == LazyLua.Sort.ASC then
                    shouldInclude = LazyLua.Math.lessThanOrEqual(a[j], pivot)
                elseif method == LazyLua.Sort.DESC then
                    shouldInclude = LazyLua.Math.greaterThanOrEqual(a[j], pivot)
                else
                    error("Invalid sort method: " .. tostring(method))
                end

                if shouldInclude then
                    swap(i, j)
                    i = i + 1
                end
            end

            swap(i, hi)
            return i
        end

        local function qsort(lo, hi)
            if lo >= hi then
                return
            end
            local p = partition(lo, hi)
            qsort(lo, p - 1)
            qsort(p + 1, hi)
        end

        qsort(1, n)
        return arrindex
    end

    --- 根据下标映射表重新排列数组
    --- @param indices table 下标映射表，如 {2,1,3}
    --- @param arr table 原数组
    --- @return table result 重排后的新数组
    function LazyLua.Sort.applyIndices(indices, arr)
        local result = {}
        for i = 1, #indices do
            result[i] = arr[indices[i]]
        end
        return result
    end
end

Mathinit()
Stringinit()
Sortinit()

return LazyLua