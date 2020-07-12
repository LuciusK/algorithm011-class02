#
# @lc app=leetcode id=169 lang=python3
#
# [169] Majority Element
#

# @lc code=start
class Solution:
    def majorityElement(self, nums: List[int]) -> int:
        count = 0
        candidate = None

        for num in nums:
            if count == 0:
                candidate = num
            count += (1 if num == candidate else -1)
        
        return candidate

    def majorityElement1(self, nums: List[int]) -> int:
        def majority_element_rec(low, high):
            # base case; the only element in an array of size 1 is the majority element.
            if low == high:
                return nums[low]

            # recurse on left and right halves of this slice.
            mid = (high - low) // 2 + low
            left = majority_element_rec(low, mid)
            right = majority_element_rec(mid+1, high)

            # if the two halves agree on the majority element, return it.
            if left == right:
                return left
            
            # otherwise, count each element and return the "winner".
            left_count = sum(1 for i in range(low, high + 1) if nums[i] == left)
            right_count = sum(1 for i in range(low, high + 1) if nums[i] == right)

            return left if left_count > right_count else right
        
        return majority_element_rec(0, len(nums) - 1)

    def majorityElement2(self, nums: List[int]) -> int:
        majority_count = len(nums) // 2
        while True:
            candidate = random.choice(nums)
            if sum(1 for elem in nums if elem == candidate) > majority_count:
                return candidate

    def majorityElement3(self, nums: List[int]) -> int:
        nums.sort()
        return nums[len(nums) // 2]

    def majorityElement4(self, nums: List[int]) -> int:
        counts = collections.Counter(nums)
        return max(counts.keys(), key = counts.get)

        
# @lc code=end

