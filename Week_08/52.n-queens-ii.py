class Solution:
    def totalNQueens(self, n: int) -> int:
        if n < 1:
            return 
        self.count = 0
        self.DFS(n, 0, 0, 0, 0)
        return self.count

    def DFS(self, n, row, cols, lfs, rfs):
        if row >= n:
            self.count += 1
            return 
        
        bits = (~(cols | lfs | rfs)) & ((1 << n) - 1) # 得到当前所有的空位

        while bits:
            p = bits & -bits # 取到最低位的1
            bits = bits & (bits - 1) # 表示在p位置上放入皇后
            self.DFS(n, row + 1, cols | p, (lfs | p) << 1, (rfs | p) >> 1)
            # 不需要revert  cols, lfs, rfs 的状态