#
# @lc app=leetcode id=51 lang=python3
#
# [51] N-Queens
#

# @lc code=start
class Solution:
    def solveNQueens(self, n: int) -> List[List[str]]:
        res = []
        if n == 0:
            return res
        
        col = set()
        master = set()
        slave = set()
        stack = []

        self.__backtracking(0, n, col, master, slave, stack, res)
        return res
    
    def __backtracking(self, row, n, col, master, slave, stack, res):
        if row == n:
            board = self.__convert2board(stack, n)
            res.append(board)
            return
        
        for i in range(n):
            if i not in col and row + i not in master and row - i not in slave:
                stack.append(i)
                col.add(i)
                master.add(row+i)
                slave.add(row-i)

                self.__backtracking(row+1, n, col, master, slave, stack, res)

                slave.remove(row-i)
                master.remove(row+i)
                col.remove(i)
                stack.pop()
    
    def __convert2board(self, stack, n):
        return ["." * stack[i] + "Q" + "." * (n - stack[i] - 1) for i in range(n)]
        


        
# @lc code=end

