# LazyLua
[英文文档或许并不可靠，点击查看中文版文档](#zh-cn)

LazyLua is a library that provides extended functionality for Lua, including high-precision mathematical operations, enhanced string processing, and sorting algorithms. It is designed to handle large integer calculations and complex string manipulations, while also offering flexible sorting capabilities.

## Features

- **High-Precision Mathematical Operations**: Supports addition, subtraction, multiplication, and division of arbitrarily large integers (including negative numbers), avoiding precision limitations of Lua's native number types. Optimized for performance with both small and large numbers.
- **Enhanced String Processing**: Provides correct handling of UTF-8 encoded strings, including character-by-character access, length calculation, substring search, splitting, and replacement.
- **Sorting Algorithms**: Offers index-based bubble sort and quicksort with support for ascending and descending order.
- **MIT License**: Open-source and freely usable.

## Installation

Download the `LazyLua.lua` file into your project directory, then include it in your Lua script using `require` or `dofile`.

lua
-- If the file is in the same directory
dofile("LazyLua.lua")

-- Or if package.path is configured
require("LazyLua")
Usage Examples
Mathematical Operations

lua
Mathinit() -- Initialize the math module

-- High-precision addition
local result = LazyLua.Math.add("12345678901234567890", "98765432109876543210")
print(result) -- Output: 111111111011111111100

-- High-precision multiplication
local product = LazyLua.Math.mul("123456789", "987654321")
print(product) -- Output: 121932631112635269

-- Negative number operations
local result2 = LazyLua.Math.add("-123", "456")
print(result2) -- Output: 333

-- Division with precision control
local div_result = LazyLua.Math.div("100000000000000000000", "3", 10) -- 10 decimal places
print(div_result) -- Output: 33333333333333333333

-- Performance optimized for large numbers (>12 digits for add, >51 for sub, >100 for mul)
local big_result = LazyLua.Math.mul("123456789012345678901234567890", "987654321098765432109876543210")
print(big_result)
String Processing

lua
Stringinit() -- Initialize the string module

local str = "Hello, 世界! 🌍"
print(LazyLua.String.len(str)) -- Output character count: 9
print(LazyLua.String.at(str, 8)) -- Output the 8th character: 界
print(LazyLua.String.substr(str, 1, 5)) -- Output substring: Hello

-- String splitting and joining
local parts = LazyLua.String.split("apple,banana,cherry", ",")
print(LazyLua.String.join(parts, " ")) -- Output: apple banana cherry

-- Find substring
print(LazyLua.String.indexof(str, "世界")) -- Output: 7
print(LazyLua.String.includes(str, "🌍")) -- Output: true
Sorting

lua
Sortinit() -- Initialize the sorting module

local numbers = {"5", "2", "8", "1"}
local sorted_indices = LazyLua.Sort.quick(numbers, LazyLua.Sort.ASC)
print(LazyLua.Sort.applyIndices(sorted_indices, numbers)) -- Output sorted array: 1, 2, 5, 8

-- For descending order
local desc_indices = LazyLua.Sort.quick(numbers, LazyLua.Sort.DESC)
print(LazyLua.Sort.applyIndices(desc_indices, numbers)) -- Output sorted array: 8, 5, 2, 1
API Reference
LazyLua.Math
add(a, b): High-precision addition of integers (supports negative numbers)
sub(a, b): High-precision subtraction of integers (supports negative numbers, requires a >= b for positive result)
mul(a, b): High-precision multiplication of integers (supports negative numbers)
div(a, b, up_to): High-precision division (integer part only, up_to specifies decimal places, defaults to 50)
greaterThan(a, b): Check if a > b (supports negative numbers)
lessThan(a, b): Check if a < b (supports negative numbers)
lessThanOrEqual(a, b): Check if a ≤ b (supports negative numbers)
greaterThanOrEqual(a, b): Check if a ≥ b (supports negative numbers)
normalize(s): Normalize a number string (removes leading zeros, handles negative signs)
LazyLua.String
len(str): Get the character length of a UTF-8 string
at(str, index): Get the character at the specified index (1-based, supports UTF-8)
charat(str, index): Get the character at the specified index (0-based, supports UTF-8)
substr(str, start, end_): Get a substring (1-based indices, supports UTF-8)
split(str, delimiter): Split a string by delimiter
join(list, separator): Join an array of strings with separator
replace(str, old, new, limit): Replace substrings (with optional limit)
includes(str, substr): Check if a string contains a substring
indexof(str, substr, start): Find first occurrence of substring
lastindexof(str, substr): Find last occurrence of substring
left(str, n): Get leftmost n characters
right(str, n): Get rightmost n characters
Repeat(str, n): Repeat string n times
to2DTable(text, rowSep, colSep): Convert text to 2D table
column(table2D, index, default): Extract column from 2D table
LazyLua.Sort
bubble(arr, method): Bubble sort (returns indices, stable sort)
quick(arr, method): Quick sort (returns indices, faster for large arrays)
applyIndices(indices, arr): Apply indices to reorder an array
Sort.ASC, Sort.DESC: Sorting direction constants
Performance Notes
Addition: Optimized for numbers > 12 digits using chunked processing with base 10^12
Subtraction: Optimized for numbers > 51 digits using chunked processing
Multiplication: Uses naive algorithm for numbers ≤ 100 digits, Karatsuba algorithm for larger numbers
Division: Implements long division algorithm with configurable precision
Contributing

Feel free to submit Issues and Pull Requests to improve LazyLua.
Changelog
v1.2.0 (2025/11/8)
Major performance optimizations for Math module
Chunked addition for numbers > 12 digits using base 10^12
Chunked subtraction for numbers > 51 digits (note: base was incorrectly set to 1^12 in code, should be 10^12)
Karatsuba multiplication algorithm for numbers > 100 digits
Optimized division algorithm
Added support for negative numbers in all math operations
Improved error handling and validation
Minor bug fixes in string processing functions
v1.0.0 (2025/10/18)
Initial release
Implemented high-precision math operations (Math module)
Implemented enhanced string processing (String module)
Implemented sorting algorithms (Sort module)

<a id="zh-cn"></a>
LazyLua

LazyLua 是一个为 Lua 提供扩展功能的库，包含高精度数学运算、增强字符串处理和排序算法等功能。该库设计用于处理大整数运算和复杂字符串操作，同时提供了灵活的排序功能。
特性
高精度数学运算：支持任意长度的整数加、减、乘、除运算（包括负数），避免了 Lua 原生数字类型的精度限制。针对大小数字进行了性能优化。
增强字符串处理：提供对 UTF-8 编码字符串的正确处理，包括按字符索引访问、长度计算、子串查找、分割、替换等。
排序算法：提供冒泡排序和快速排序的索引排序功能，支持升序和降序排列。
MIT 许可证：开源且自由使用。
安装

将 LazyLua.lua 文件下载到你的项目目录中，然后在你的 Lua 脚本中使用 require 或 dofile 引入即可。

lua
-- 如果文件在同一目录下
dofile("LazyLua.lua")

-- 或者如果已配置好 package.path
require("LazyLua")
使用示例
数学运算

lua
Mathinit() -- 初始化数学模块

-- 高精度加法
local result = LazyLua.Math.add("12345678901234567890", "98765432109876543210")
print(result) -- 输出: 111111111011111111100

-- 高精度乘法
local product = LazyLua.Math.mul("123456789", "987654321")
print(product) -- 输出: 121932631112635269

-- 负数运算
local result2 = LazyLua.Math.add("-123", "456")
print(result2) -- 输出: 333

-- 除法精度控制
local div_result = LazyLua.Math.div("100000000000000000000", "3", 10) -- 10位小数
print(div_result) -- 输出: 33333333333333333333

-- 针对大数的性能优化 (>12位加法, >51位减法, >100位乘法)
local big_result = LazyLua.Math.mul("123456789012345678901234567890", "987654321098765432109876543210")
print(big_result)
字符串处理

lua
Stringinit() -- 初始化字符串模块

local str = "Hello, 世界! 🌍"
print(LazyLua.String.len(str)) -- 输出字符数: 9
print(LazyLua.String.at(str, 8)) -- 输出第8个字符: 界
print(LazyLua.String.substr(str, 1, 5)) -- 输出子串: Hello

-- 字符串分割和连接
local parts = LazyLua.String.split("apple,banana,cherry", ",")
print(LazyLua.String.join(parts, " ")) -- 输出: apple banana cherry

-- 查找子串
print(LazyLua.String.indexof(str, "世界")) -- 输出: 7
print(LazyLua.String.includes(str, "🌍")) -- 输出: true
排序

lua
Sortinit() -- 初始化排序模块

local numbers = {"5", "2", "8", "1"}
local sorted_indices = LazyLua.Sort.quick(numbers, LazyLua.Sort.ASC)
print(LazyLua.Sort.applyIndices(sorted_indices, numbers)) -- 输出排序后的数组: 1, 2, 5, 8

-- 降序排列
local desc_indices = LazyLua.Sort.quick(numbers, LazyLua.Sort.DESC)
print(LazyLua.Sort.applyIndices(desc_indices, numbers)) -- 输出排序后的数组: 8, 5, 2, 1
API 参考
LazyLua.Math
add(a, b)：高精度加法（支持负数）
sub(a, b)：高精度减法（支持负数，要求 a >= b 得到正结果）
mul(a, b)：高精度乘法（支持负数）
div(a, b, up_to)：高精度除法（仅整数部分，up_to 指定小数位数，默认50）
greaterThan(a, b)：判断 a > b（支持负数）
lessThan(a, b)：判断 a < b（支持负数）
lessThanOrEqual(a, b)：判断 a ≤ b（支持负数）
greaterThanOrEqual(a, b)：判断 a ≥ b（支持负数）
normalize(s)：标准化数字字符串（去除前导零，处理负号）
LazyLua.String
len(str)：获取 UTF-8 字符串的字符长度
at(str, index)：获取指定索引的字符（1基，支持UTF-8）
charat(str, index)：获取指定索引的字符（0基，支持UTF-8）
substr(str, start, end_)：获取子串（1基索引，支持UTF-8）
split(str, delimiter)：按分隔符分割字符串
join(list, separator)：用分隔符连接字符串数组
replace(str, old, new, limit)：替换子串（可选限制次数）
includes(str, substr)：检查是否包含子串
indexof(str, substr, start)：查找子串首次出现位置
lastindexof(str, substr)：查找子串最后出现位置
left(str, n)：获取左边n个字符
right(str, n)：获取右边n个字符
Repeat(str, n)：重复字符串n次
to2DTable(text, rowSep, colSep)：将文本转为二维表
column(table2D, index, default)：从二维表提取列
LazyLua.Sort
bubble(arr, method)：冒泡排序（返回索引，稳定排序）
quick(arr, method)：快速排序（返回索引，大数据集更快）
applyIndices(indices, arr)：应用索引重新排列数组
Sort.ASC, Sort.DESC：排序方向常量
性能说明
加法：对 > 12 位数字使用 10^12 基的分块处理优化
减法：对 > 12 位数字使用分块处理优化
乘法：≤ 100 位使用朴素算法，> 100 位使用 Karatsuba 算法
除法：实现长除法算法，支持可配置精度
贡献

欢迎提交 Issue 和 Pull Request 来改进 LazyLua。
更新日志
v1.2.0 (2025/11/8)
数学模块重大性能优化
> 12 位数字的分块加法（使用 10^12 基）
> 12 位数字的分块减法
> 100 位数字的 Karatsuba 乘法算法
优化的除法算法
改进错误处理和验证
修复字符串处理函数中的小错误
v1.0.0 (2025/10/18)
初始版本发布
实现高精度数学运算 (Math 模块)
实现增强字符串处理 (String 模块)
实现排序算法 (Sort 模块)
