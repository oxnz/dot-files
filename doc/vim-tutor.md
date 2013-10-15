#Vim tutor

##1.命令行多窗口参数 
 
	vim -o file1 file2 ...  #水平打开多窗口，
	vim -O file1 file2 ...  #垂直打开多窗口,
	vim -d file1 file2 ...  #垂直打开多窗口,并且进行比较
	vimdiff file1 file2 ..  #等同于上一句


##2.VIM 多窗口命令

在已经打开编辑界面时，如果要进行多窗口操作，可用如下命令操作
  
	split           #打开一个水平窗口.新窗口打开也是当前编辑文件
	split file1     #打开一个水平窗口.新窗口打开是file1
	vsplit          #打开一个垂直窗口.新窗口打开也是当前编辑文件
	vsplit file1    #打开一个垂直窗口.新窗口打开是file1

	diffsplit file2 #水平打开一个窗口编辑file2 ,并且与当前窗口进行比较
	vert diffsplit file2  #垂直打开一个窗口编辑file2,并且与当前窗口进行比较

如果已经用split打开文档，需要比较两个窗口，在每一个窗口分别执行 diffthis 
  

关闭窗口

	q  或 close   #关闭当前窗口
	only          #保留当前窗口，关闭其它所有窗口
	qall          #退出所有窗口
	wall          #保存所有窗口

##3.多窗口快捷键

	ZZ            #关闭当前窗口
	Ctrl ww       #将焦点移至下一个窗口

##4.多页标签的命令
 
VIM的页标签会在上面用文本形成一个类型图形界面常见的类标签。

	tabnew        #打开一个页标签
	tabnew file2  #打开一个页标签,并在标签中编辑file2
	tabc          #关闭当前的tab
	tabo          #关闭所有其他的tab
	tabs          #查看所有打开的tab
	tabp          #光标移到前一个tab
	tabn          #光标移到后一个tab
