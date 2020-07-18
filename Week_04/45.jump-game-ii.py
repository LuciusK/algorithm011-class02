#
# @lc app=leetcode id=45 lang=python3
#
# [45] Jump Game II
#

# @lc code=start
class Solution:
    def jump(self, nums: List[int]) -> int:
        end = 0
        maxPosition = 0
        steps = 0
        for i in range(len(nums)-1):
            maxPosition = max(maxPosition, nums[i] + i)
            if i == end:
                end = maxPosition
                steps += 1
        return steps


        
# @lc code=end

