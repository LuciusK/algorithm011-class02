学习笔记

Deque<String>deque = new LinkedList<String>();

deque.addfirst("a");
deque.addlast("b");
deque.addlast("c");
System.out.println(deque);



Queue里的add和offer都是添加元素，但是offer会在添加不成功返回false
当队列为空是remove会抛出异常，而poll则返回null


优先队列可以传入多种参数，比如有序数组和优先队列，优先的定义等等
add和offer同queue，contain为查找某元素是否存在
toarray将无排序的元素输出一个数组
iterator将优先队列迭代
clear清空所有元素
comparator返回排序元素的类型



学习总结

python中的数组一般使用列表来表示

链表节点用类进行表示，其中链表可以写成Node(3, Node(5, (...)))

数组和链表的操作过于，在此不赘述

跳表以有序的方式在层次化的链表中保存元素，
效率和平衡树媲美 —— 查找、删除、添加等操作都可以在对数期望时间下完成，
并且比起平衡树来说， 跳跃表的实现要简单直观得多。

跳表是以空间换时间，通常链表的查询是O(n)的，但是跳表在链表上方用指针层层
叠加，具体为上一层的指针个数比下一层少一倍，因此，在查询的时候会比普通的
链表更加快，时间复杂度为O(logn)

栈在python中操作十分简单，直接建立一个空列表，如何append和pop操作即可，
实际上在应用中会用Deque来代替栈的使用。

双端队列在python在python的collections中，队首元素剔除用popleft，队尾则用
pop，插入为insertfront以及insertlast

优先队列为按照某一特定优先级进行剔除元素的队列









