--[[
LazyLua ver1.2.0
by ikunactrl.
Starttime: 2025/10/17
Release date of this version: 2025/11/8

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

        -- 直接对大于20位的数字进行超长分块处理最大化效率！！！！
        if #a > 12 or #b > 12 then
            local base = 10 ^ 12
            local width = 12
            local function split_chunks(s)
                local chunks = {}
                local len = #s
                local i = len
                local c = 1
                while i > 0 do
                    local start = math.max(1, i - width + 1)
                    chunks[c] = tonumber(s:sub(start, i))
                    c = c + 1
                    i = i - width
                end
                return chunks
            end

            local A = split_chunks(a)
            local B = split_chunks(b)

            local lenA, lenB = #A, #B
            local result = {}

            for i = 1, math.max(lenA, lenB) do
                local digitA = A[i] or 0
                local digitB = B[i] or 0
                result[i] = (result[i] or 0) + digitA + digitB
            end

            -- 处理进位（按 base）
            local carry = 0
            for i = 1, #result do
                local total = (result[i] or 0) + carry
                result[i] = total % base
                carry = math.floor(total / base)
            end
            while carry > 0 do
                result[#result + 1] = carry % base
                carry = math.floor(carry / base)
            end

            -- 转字符串，每块宽度为 width，最高位不补零
            local resstr = ""
            local started = false
            for i = #result, 1, -1 do
                local v = result[i] or 0
                if not started then
                    if v ~= 0 then
                        resstr = resstr .. tostring(v)
                        started = true
                    end
                else
                    resstr = resstr .. string.format("%0" .. width .. "d", v)
                end
            end
            if resstr == "" then resstr = "0" end
            return LazyLua.Math.normalize(resstr)
        end

        -- 传统逐位加法
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

        -- 直接对大于12位的数字进行超长分块处理最大化效率！！！！
        if #a > 12 or #b > 12 then
            local base = 10 ^ 12
            local width = 12
            local function split_chunks(s)
                local chunks = {}
                local len = #s
                local i = len
                local c = 1
                while i > 0 do
                    local start = math.max(1, i - width + 1)
                    chunks[c] = tonumber(s:sub(start, i))
                    c = c + 1
                    i = i - width
                end
                return chunks
            end

            local A = split_chunks(a)
            local B = split_chunks(b)

            local lenA, lenB = #A, #B
            local result = {}

            -- 将A复制到result中
            for i = 1, lenA do
                result[i] = A[i] or 0
            end

            -- 从低位开始减法，处理借位
            local borrow = 0
            for i = 1, lenA do
                local digitA = result[i] or 0
                local digitB = (i <= lenB) and B[i] or 0
                local diff = digitA - digitB - borrow
                if diff < 0 then
                    diff = diff + base
                    borrow = 1
                else
                    borrow = 0
                end
                result[i] = diff
            end

            -- 转字符串，每块宽度为 width，最高位不补零
            local resstr = ""
            local started = false
            for i = #result, 1, -1 do
                local v = result[i] or 0
                if not started then
                    if v ~= 0 then
                        resstr = resstr .. tostring(v)
                        started = true
                    end
                else
                    resstr = resstr .. string.format("%0" .. width .. "d", v)
                end
            end
            if resstr == "" then resstr = "0" end
            return LazyLua.Math.normalize(resstr)
        end

        -- 传统逐位减法
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
        if a == '0' or b == '0' then return '0' end
        if a == '1' then return b end
        if b == '1' then return a end

        -- 小数字：直接朴素乘（< 100 位）
        if #a <= 100 and #b <= 100 then
            local lenA, lenB = #a, #b
            local res = {}
            for i = 1, lenA do
                local da = a:byte(lenA - i + 1) - 48
                local carry = 0
                for j = 1, lenB do
                    local db = b:byte(lenB - j + 1) - 48
                    local pos = i + j - 1
                    local sum = (res[pos] or 0) + da * db + carry
                    res[pos] = sum % 10
                    carry = math.floor((sum - res[pos]) / 10)
                end
                local pos = i + lenB
                while carry > 0 do
                    local sum = (res[pos] or 0) + carry
                    res[pos] = sum % 10
                    carry = math.floor((sum - res[pos]) / 10)
                    pos = pos + 1
                end
            end
            local s = {}
            local i = #res
            while i > 0 and res[i] == 0 do i = i - 1 end
            if i == 0 then return '0' end
            for k = i, 1, -1 do s[#s + 1] = string.char(res[k] + 48) end
            return table.concat(s)
        end

        -- === 大数处理：分块 + Karatsuba ===
        local BASE = 1000000 -- 10^6，安全整数
        local WIDTH = 6

        -- 字符串 → 块数组（低位在前）
        local function to_chunks(s)
            local chunks = {}
            local i = #s
            while i > 0 do
                local start = math.max(1, i - WIDTH + 1)
                chunks[#chunks + 1] = tonumber(s:sub(start, i))
                i = start - 1
            end
            return chunks
        end

        -- 块数组 → 字符串
        local function from_chunks(chunks)
            if #chunks == 0 then return '0' end
            local parts = {}
            parts[1] = tostring(chunks[#chunks])
            for i = #chunks - 1, 1, -1 do
                parts[#parts + 1] = string.format("%06d", chunks[i])
            end
            return table.concat(parts)
        end

        -- 块数组加法（a += b）
        local function add_chunks(a, b)
            local carry = 0
            local n = math.max(#a, #b)
            for i = 1, n do
                local sum = (a[i] or 0) + (b[i] or 0) + carry
                if sum >= BASE then
                    a[i] = sum - BASE
                    carry = 1
                else
                    a[i] = sum
                    carry = 0
                end
            end
            if carry > 0 then a[n + 1] = carry end
            return a
        end

        -- 块数组减法（a -= b，要求 a >= b）
        local function sub_chunks(a, b)
            local borrow = 0
            for i = 1, #b do
                local diff = a[i] - b[i] - borrow
                if diff < 0 then
                    a[i] = diff + BASE
                    borrow = 1
                else
                    a[i] = diff
                    borrow = 0
                end
            end
            local i = #b + 1
            while borrow > 0 do
                local diff = a[i] - borrow
                if diff < 0 then
                    a[i] = diff + BASE
                    borrow = 1
                else
                    a[i] = diff
                    borrow = 0
                end
                i = i + 1
            end
            -- 移除前导零
            while #a > 1 and a[#a] == 0 do
                a[#a] = nil
            end
            return a
        end

        -- 朴素分块乘法（用于小块）
        local function mul_naive(x, y)
            local res = {}
            for i = 1, #x do
                local carry = 0
                for j = 1, #y do
                    local pos = i + j - 1
                    local prod = (res[pos] or 0) + x[i] * y[j] + carry
                    carry = math.floor(prod / BASE)
                    res[pos] = prod - carry * BASE
                end
                local pos = i + #y
                while carry > 0 do
                    local sum = (res[pos] or 0) + carry
                    carry = math.floor(sum / BASE)
                    res[pos] = sum - carry * BASE
                    pos = pos + 1
                end
            end
            return res
        end

        -- Karatsuba 乘法
        local function karatsuba(x, y)
            if #x < 32 or #y < 32 then
                return mul_naive(x, y)
            end

            local n = math.max(#x, #y)
            local half = math.floor((n + 1) / 2)

            -- 拆分 x = x1 * B^half + x0
            local x0, x1 = {}, {}
            for i = 1, half do x0[i] = x[i] or 0 end
            for i = half + 1, #x do x1[i - half] = x[i] end
            while #x0 > 1 and x0[#x0] == 0 do x0[#x0] = nil end
            while #x1 > 1 and x1[#x1] == 0 do x1[#x1] = nil end

            -- 拆分 y = y1 * B^half + y0
            local y0, y1 = {}, {}
            for i = 1, half do y0[i] = y[i] or 0 end
            for i = half + 1, #y do y1[i - half] = y[i] end
            while #y0 > 1 and y0[#y0] == 0 do y0[#y0] = nil end
            while #y1 > 1 and y1[#y1] == 0 do y1[#y1] = nil end

            -- 递归计算
            local z0 = karatsuba(x0, y0) -- x0 * y0
            local z2 = karatsuba(x1, y1) -- x1 * y1

            local x0_copy = {}
            for i = 1, #x0 do x0_copy[i] = x0[i] end
            local x01 = add_chunks(x0_copy, x1)

            local y0_copy = {}
            for i = 1, #y0 do y0_copy[i] = y0[i] end
            local y01 = add_chunks(y0_copy, y1)

            local z1 = karatsuba(x01, y01) -- (x0+x1)*(y0+y1)
            z1 = sub_chunks(z1, z0)        -- z1 - z0
            z1 = sub_chunks(z1, z2)        -- z1 - z0 - z2

            -- 结果 = z2 * B^(2*half) + z1 * B^half + z0
            local res = {}
            -- z0
            for i = 1, #z0 do res[i] = z0[i] end
            -- z1 * B^half
            for i = 1, #z1 do
                local idx = i + half
                res[idx] = (res[idx] or 0) + z1[i]
            end
            -- z2 * B^(2*half)
            for i = 1, #z2 do
                local idx = i + 2 * half
                res[idx] = (res[idx] or 0) + z2[i]
            end

            -- 处理进位
            local carry = 0
            for i = 1, #res do
                local total = (res[i] or 0) + carry
                carry = math.floor(total / BASE)
                res[i] = total - carry * BASE
            end
            while carry > 0 do
                res[#res + 1] = carry % BASE
                carry = math.floor(carry / BASE)
            end

            return res
        end

        -- 主逻辑
        local A = to_chunks(a)
        local B = to_chunks(b)
        local C = karatsuba(A, B)
        return from_chunks(C)
    end


    local function mathdiv(a, b, up_to)
        up_to = up_to or 50
        a = LazyLua.Math.normalize(a)
        b = LazyLua.Math.normalize(b)

        if b == "0" then error("Division by zero") end
        if a == "0" then return "0" end

        local lenA, lenB = #a, #b

        -- 快速判断：如果 a < b，商为 0
        if lenA < lenB or (lenA == lenB and LazyLua.Math.lessThan(a, b)) then
            return "0"
        end

        -- 计算商的位数（整数部分）
        local quotient_digits_needed = lenA - lenB + 1
        if lenA >= lenB and LazyLua.Math.lessThan(a:sub(1, lenB), b) then
            quotient_digits_needed = quotient_digits_needed - 1
        end

        -- 如果商总共都不足 up_to 位，就全算
        local total_digits_to_produce = math.min(up_to, quotient_digits_needed)
        if total_digits_to_produce <= 0 then
            return "0"
        end

        -- 关键：确定从 a 的哪一位开始能产生第一个商位
        local start_pos = lenA - quotient_digits_needed + 1 -- 第一个商位对应 a 的起始消费位置

        -- 初始化 remainder 为 a 的前 (start_pos - 1) 位？不，更简单：
        local remainder = a:sub(1, start_pos - 1) -- 可能为空
        if remainder == "" then remainder = "0" end
        remainder = LazyLua.Math.normalize(remainder)

        local quotient_digits = {}

        -- 从第 start_pos 位开始，产生 total_digits_to_produce 位商
        for i = 0, total_digits_to_produce - 1 do
            local pos = start_pos + i
            if pos <= lenA then
                remainder = remainder .. a:sub(pos, pos)
            else
                remainder = remainder .. "0" -- 补零（虽然整数除法通常不需要）
            end
            remainder = LazyLua.Math.normalize(remainder)

            local q_digit = "0"
            for try = 9, 1, -1 do
                local prod = mathmul(b, try) -- 安全的 ×0~9
                if not LazyLua.Math.lessThan(remainder, prod) then
                    q_digit = tostring(try)
                    remainder = mathsub(remainder, prod)
                    break
                end
            end
            table.insert(quotient_digits, q_digit)
        end

        local result = table.concat(quotient_digits)
        -- 注意：这里不会有多余前导零，因为我们从第一个有效位开始
        return result
    end

    function LazyLua.Math.normalize(s_)
        -- 如果是空字符串，返回 "0"
        local s = tostring(s_)
        if s == "" then return "0" end

        local neg = false
        local i = 1

        -- 检查是否有负号
        if string.sub(s, 1, 1) == '-' then
            neg = true
            i = 2 -- 从第2个字符开始看数字部分
        end

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

    function LazyLua.Math.div(a, b, up_to)
        local a1 = string.sub(a, 1, 1)
        local b1 = string.sub(b, 1, 1)
        if a1 == '-' and b1 == '-' then
            -- -a / -b => -a * -(1/b) => a * 1/b => a / b
            a = string.sub(a, 2)
            b = string.sub(b, 2)
            return mathdiv(a, b, up_to or 50)
        end
        if a1 == '-' or b1 == '-' then
            -- ±a / ±b (a,b其中必有一个小于0) => -（|a| / |b|)
            if a1 == '-' then a = string.sub(a, 2) end
            if b1 == '-' then b = string.sub(b, 2) end
            return '-' .. mathdiv(a, b, up_to or 50)
        end
        return mathdiv(a, b, up_to or 50)
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
