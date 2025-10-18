# LazyLua
[英文文档或许并不可靠，点击查看中文版文档](#zh-cn)

LazyLua is a library that provides extended functionality for Lua, including high-precision mathematical operations, enhanced string processing, and sorting algorithms. It is designed to handle large integer calculations and complex string manipulations, while also offering flexible sorting capabilities.

## Features

- **High-Precision Mathematical Operations**: Supports addition, subtraction, multiplication, and division of arbitrarily large non-negative integers, avoiding precision limitations of Lua's native number types.
- **Enhanced String Processing**: Provides correct handling of UTF-8 encoded strings, including character-by-character access, length calculation, substring search, splitting, and replacement.
- **Sorting Algorithms**: Offers index-based bubble sort and quicksort with support for ascending and descending order.
- **MIT License**: Open-source and freely usable.

## Installation

Download the `LazyLua.lua` file into your project directory, then include it in your Lua script using `require` or `dofile`.





```lua
-- If the file is in the same directory
dofile("LazyLua.lua")

-- Or if package.path is configured
require("LazyLua")
```

## Usage Examples

### Mathematical Operations

```lua
Mathinit() -- Initialize the math module

-- High-precision addition
local result = LazyLua.Math.add("12345678901234567890", "98765432109876543210")
print(result) -- Output: 111111111011111111100

-- High-precision multiplication
local product = LazyLua.Math.mul("123456789", "987654321")
print(product) -- Output: 121932631112635269
```

### String Processing

```lua
Stringinit() -- Initialize the string module

local str = "Hello, 世界! 🌍"
print(LazyLua.String.len(str)) -- Output character count: 9
print(LazyLua.String.at(str, 8)) -- Output the 8th character: 界
print(LazyLua.String.substr(str, 1, 5)) -- Output substring: Hello
```

### Sorting

```lua
Sortinit() -- Initialize the sorting module

local numbers = {"5", "2", "8", "1"}
local sorted_indices = LazyLua.Sort.quick(numbers, LazyLua.Sort.ASC)
print(LazyLua.Sort.applyIndices(sorted_indices, numbers)) -- Output sorted array: 1, 2, 5, 8
```

## API Reference

### LazyLua.Math

- `add(a, b)`: High-precision addition
- `sub(a, b)`: High-precision subtraction
- `mul(a, b)`: High-precision multiplication
- `div(a, b)`: High-precision division (integer part)
- `greaterThan(a, b)`: Check if a > b
- `lessThan(a, b)`: Check if a < b
- `lessThanOrEqual(a, b) `:Check if a ≤ b
- `greaterThanOrEqual(a, b)`: Check if a ≥ b
- `normalize(s)`: Normalize a number string

### LazyLua.String

- `len(str)`: Get the character length of a string
- `at(str, index)`: Get the character at the specified index
- `substr(str, start, end_)`: Get a substring
- `split(str, delimiter)`: Split a string
- `replace(str, old, new, limit)`: Replace substrings
- `includes(str, substr)`: Check if a string contains a substring

### LazyLua.Sort

- `bubble(arr, method)`: Bubble sort (returns indices)
- `quick(arr, method)`: Quick sort (returns indices)
- `applyIndices(indices, arr)`: Apply indices to reorder an array
- `Sort.ASC`, `Sort.DESC`: Sorting direction constants

## Contributing

Feel free to submit Issues and Pull Requests to improve LazyLua.

## Changelog

### v1.0.0 (2025/10/18)

- Initial release
- Implemented high-precision math operations (`Math` module)
- Implemented enhanced string processing (`String` module)
- Implemented sorting algorithms (`Sort` module)

---

<a id="zh-cn"></a>
# LazyLua

LazyLua 是一个为 Lua 提供扩展功能的库，包含高精度数学运算、增强字符串处理和排序算法等功能。该库设计用于处理大整数运算和复杂字符串操作，同时提供了灵活的排序功能。

## 特性

- **高精度数学运算**：支持任意长度的非负整数加、减、乘、除运算，避免了 Lua 原生数字类型的精度限制。
- **增强字符串处理**：提供对 UTF-8 编码字符串的正确处理，包括按字符索引访问、长度计算、子串查找、分割、替换等。
- **排序算法**：提供冒泡排序和快速排序的索引排序功能，支持升序和降序排列。
- **MIT 许可证**：开源且自由使用。

## 安装

将 `LazyLua.lua` 文件下载到你的项目目录中，然后在你的 Lua 脚本中使用 `require` 或 `dofile` 引入即可。

```lua
-- 如果文件在同一目录下
dofile("LazyLua.lua")

-- 或者如果已配置好 package.path
require("LazyLua")
```

## 使用示例

### 数学运算

```lua
Mathinit() -- 初始化数学模块

-- 高精度加法
local result = LazyLua.Math.add("12345678901234567890", "98765432109876543210")
print(result) -- 输出: 111111111011111111100

-- 高精度乘法
local product = LazyLua.Math.mul("123456789", "987654321")
print(product) -- 输出: 121932631112635269
```

### 字符串处理

```lua
Stringinit() -- 初始化字符串模块

local str = "Hello, 世界! 🌍"
print(LazyLua.String.len(str)) -- 输出字符数: 9
print(LazyLua.String.at(str, 8)) -- 输出第8个字符: 界
print(LazyLua.String.substr(str, 1, 5)) -- 输出子串: Hello
```

### 排序

```lua
Sortinit() -- 初始化排序模块

local numbers = {"5", "2", "8", "1"}
local sorted_indices = LazyLua.Sort.quick(numbers, LazyLua.Sort.ASC)
print(LazyLua.Sort.applyIndices(sorted_indices, numbers)) -- 输出排序后的数组: 1, 2, 5, 8
```

## API 参考

### LazyLua.Math

- `add(a, b)`：高精度加法
- `sub(a, b)`：高精度减法
- `mul(a, b)`：高精度乘法
- `div(a, b)`：高精度除法（整数部分）
- `greaterThan(a, b)`：判断 a > b
- `lessThan(a, b)`：判断 a < b
- `lessThanOrEqual(a, b) `:判断 a ≤ b
- `greaterThanOrEqual(a, b)`: 判断 a ≥ b
- `normalize(s)`：标准化数字字符串

### LazyLua.String

- `len(str)`：获取字符串字符长度
- `at(str, index)`：获取指定索引的字符
- `substr(str, start, end_)`：获取子串
- `split(str, delimiter)`：分割字符串
- `replace(str, old, new, limit)`：替换子串
- `includes(str, substr)`：检查是否包含子串

### LazyLua.Sort

- `bubble(arr, method)`：冒泡排序（返回索引）
- `quick(arr, method)`：快速排序（返回索引）
- `applyIndices(indices, arr)`：应用索引重新排列数组
- `Sort.ASC`, `Sort.DESC`：排序方向常量

## 贡献

欢迎提交 Issue 和 Pull Request 来改进 LazyLua。

## 更新日志

### v1.0.0 (2025/10/18)
- 初始版本发布
- 实现高精度数学运算 (`Math` 模块)
- 实现增强字符串处理 (`String` 模块)
- 实现排序算法 (`Sort` 模块)

```
