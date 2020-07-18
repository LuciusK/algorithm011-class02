#
# @lc app=leetcode id=55 lang=python3
#
# [55] Jump Game
#

# @lc code=start
class Solution:
    def canJump(self, nums: List[int]) -> bool:
        length = len(nums)
        des = 0
        for i in range(length):
            if i > des:
                return False
            if des >= length - 1:
                return True
            des = max(des, i + nums[i])
        return True

    def canJump1(self, nums: List[int]) -> bool:
        if nums == [0]:
            return True
        maxDist = 0
        end_index = len(nums) - 1
        for i, jump in enumerate(nums):
            if maxDist >= i and i + jump > maxDist:
                maxDist = i + jump
                if maxDist >= end_index:
                    return True
        
        return False

        
# @lc code=end

