#VIM 变量

##vim中的变量类型和大多数高级语言的基本变量类似，大概可以分为： 

1. 数值 
2. 浮点数 
3. 字符串 
4. 函数引用变量 
5. 列表 
6. 字典 

##简单说一下函数引用变量、列表变量、字典变量。 

###一. 函数引用变量 

函数引用变量通过function()函数得到，用在表达式里来代替函数名。例如： 

	:let Fn = function("MyFunc")
	:echo Fn()

函数引用变量必须以大写字母、"s:"、"w:"、"t:"、或"b:"开始，引用变量不能和其他任何函数重名。这些前缀的意思和申请变量时前缀一样，分别表明其作用域(:help internal-variables)： 

* b: 局部于当前缓冲区。	:help buffer-variable 
* w: 局部于当前窗口。	:help window-variable 
* t: 局部于当前标签页。	:help tabpage-variable 
* g: 全局。	 :help global-variable 
* l: 局部于函数。	 :help local-variable 
* s: 局部于 |:source| 的 Vim 脚本。	:help script-variable 
* a: 函数参数 (只限于函数内使用)。	:help function-argument 
* v: Vim 预定义的全局变量。	 :help vim-variable 

二. 列表变量 
列表变量和perl的变量很类似，比如： 
:let mylist = [1, two, 3, "four"] 
:let nestlist = [[11, 12], [21, 22], [31, 32]] 
1. 访问列表项目时同样用索引的办法： 
:let item = mylist[0];	 " 得到第一个项目: 1 
:let item = nestlist[0][1]	" 得到第三个项目: 3 
也可以试用负数索引，它的意思就是列表倒数，比如： 
:let last = mylist[-1] " 得到最后一个项目: "four" 
要避免非法索引值产生的错误，用 |get()| 函数。如果项目不存在，它返回零或者你指定的缺省值: 
:echo get(mylist, idx) 
:echo get(mylist, idx, "NONE") 

2. 列表连接	两个列表可以用 "+" 操作符连接，比如 :let longlist = mylist + [5, 6] 
3. 子列表 列表的一部分可以通过指定首末两个索引获得，方括号内以冒号分隔两者: 
:let shortlist = mylist[2:-1] " 得到列表 [3, "four"] 
:let endlist = mylist[2:] " 从项目 2 到结束: [3, "four"] 
4. 列表同一 如果变量 "aa" 是列表，把它赋给另一个变量 "bb" 后，两个变量指向同一列表。因此，对列表 "aa" 的修改也同时修改了 "bb": 
:let aa = [1, 2, 3] 
:let bb = aa 
:call add(aa, 4) 
:echo bb 
[1, 2, 3, 4] 

|copy()| 函数可以复制列表。如上所述，用 [:] 也可。这种方式建立列表的浅备份: 改变列表中的列表项目仍然会修改复制列表的相应项目: 
:let aa = [[1, 'a'], 2, 3] 
:let bb = copy(aa) 
:call add(aa, 4) 
:let aa[0][1] = 'aaa' 
:echo aa 
[[1, aaa], 2, 3, 4] 
:echo bb 
[[1, aaa], 2, 3] 

可用操作符 "is" 检查两个变量是否指向同一个列表。"isnot" 刚好相反。与此对照，"==" 比较两个列表的值是否相同。 
:let alist = [1, 2, 3] 
:let blist = [1, 2, 3] 
:echo alist is blist 
0 
:echo alist == blist 
1 
比较列表时 注意: 如果长度相同，所有项目用 "==" 的比较的结果也相同，两个列表就认为相同。有一个例外: 数值和字符串总被认为不相同。这里不进行自动类型转换，而在变量间直接用 "==" 却不是如此。例如: 
echo 4 == "4" 
1 
echo [4] == ["4"] 
0 

5. 列表解包 要给列表项目解包，即把它们分别存入单独的变量，用方括号把变量括起来，如同把它们当作列表项目: 
:let [var1, var2] = mylist 
6. 列表修改 要修改列表的指定项目，用:let命令： 
:let list[4] = "four" 
:let listlist[0][3] = item 
VIM内建了大量操作列表的函数，可以查阅:help function-list，找到针对列表操作的函数群，查看其用途。利用这些函数就可以修改列表。 

7. For 循环 就跟perl的for循环遍历列表数据类似： 
:for item in mylist 
: call Doit(item) 
:endfor 
就像 |:let| 命令，|:for| 也可以接受变量的列表。这需要参数是列表的列表。 
:for [lnum, col] in [[1, 3], [2, 8], [3, 0]] 
: call Doit(lnum, col) 
:endfor 
三. 字典变量 
字典是关联数组: 每个项目有一个键和一个值。这和perl的关联数组(%)类似，用键可以定位项目，而项目的存储不能确定任何特定顺序。 
1. 字典建立 
字典通过花括号里逗号分隔的项目列表建立。每个项目包含以冒号分隔的键和值(perl中用"=>"分隔)。一个键只能出现一次。例如: 
:let mydict = {1: 'one', 2: 'two', 3: 'three'} 
键必须是字符串。用数值也可以，但它总被自动转换为字符串。所以字符串 '4' 和数值4 总会找到相同的项目。注意 字符串 '04' 和数值 04 是不一样的，因为后者被转换成字符串 '4'。 
2. 访问项目 
常见的访问项目的方式是把键放入方括号: 
:let val = mydict["one"] 
:let mydict["four"] = 4 
用这种方式可以给已存在的字典增加新项目，这和列表不同。 

如果键只包含字母、数字和下划线，可以使用如下形式 |expr-entry|: 
:let val = mydict.one 
:let mydict.four = 4 

因为项目可以是包括列表和字典的任何类型，你可以反复使用索引和键进行访问: 
:echo dict.key[idx].key 
3. 字典到列表的转换 
你可以循环遍历字典的所有项目。为此，你需要把字典转为列表，然后把它传递给:for 
通常，你期望遍历所有的键，用 |keys()| 函数就可以了: 
:for key in keys(mydict) 
: echo key . ': ' . mydict[key] 
:endfor 
要遍历所有的值，用 |values()| 函数: > 
:for v in values(mydict) 
: echo "value: " . v 
:endfor 

如果你想同时得到键和值，用 |items()| 函数。它返回一个列表，其中每个项目是两个项目的列表: 键和值: 
:for [key, value] in items(mydict) 
: echo key . ': ' . value 
:endfor 
4. 字典同一 
就像列表那样，你需要用 |copy()| 和 |deepcopy()| 来构造字典的备份。否则，赋值产生的结果会引用同一个字典: 
:let onedict = {'a': 1, 'b': 2} 
:let adict = onedict 
:let adict['a'] = 11 
:echo onedict['a'] 
11 
5. 字典修改 
要修改字典已经存在的项目或者增加新的项目，用:let: 
:let dict[4] = "four" 
:let dict['one'] = item 
从字典里删除项目可以通过 |remove()| 或 |:unlet| 完成。从 dict 里删除键 "aaa" 的项目有三种方法: 
:let i = remove(dict, 'aaa') 
:unlet dict.aaa 
:unlet dict['aaa'] 
6. 字典函数