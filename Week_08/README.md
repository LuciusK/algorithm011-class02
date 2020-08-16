学习笔记

位运算解题指将题目巧妙的转换成二进制的方法

布隆过滤器的特点使能判错但是不能不能判对，因为在新的数据
可能是原始数据映射下二进制数组中的不同的数据的1组成的

LRU缓存机制是最近用的放到队列最前面，先进先出

# 冒泡排序
def bubbleSort(nums):
    for i in range(len(nums) - 1):
        for j in range(len(nums) - i - 1):
            if nums[j] > nums[j + 1]:
                nums[j], nums[j + 1] = nums[j + 1], nums[j]
    return nums


# 选择排序
def selectionSort(nums):
    for i in range(len(nums) - 1):
        minIndex = i
        for j in range(i + 1, len(nums)):
            if nums[j] < nums[minIndex]:
                minIndex = j
        nums[i], nums[minIndex] = nums[minIndex], nums[i]
    return nums


# 插入排序
def insertionSort(nums):
    for i in range(len(nums) - 1):
        curNum, preIndex = nums[i + 1], i
        while preIndex >= 0 and curNum < nums[preIndex]:
            nums[preIndex + 1] = nums[preIndex]
            preIndex -= 1
        nums[preIndex + 1] = curNum
    return nums


# 希尔排序
def shellSort(nums):
    lens = len(nums)
    gap = 1
    while gap < lens:
        gap = gap * 3 + 1
    while gap > 0:
        for i in range(gap, lens):
            curNum, preIndex = nums[i], i - gap
            while preIndex >= 0 and curNum < nums[preIndex]:
                nums[preIndex + gap] = nums[preIndex]
                preIndex -= gap
            nums[preIndex + gap] = curNum
        gap //= 3
    return nums