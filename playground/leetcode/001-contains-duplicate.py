# https://leetcode.com/problems/contains-duplicate

class Solution:
    def hasDuplicate(self, nums: list[int]) -> bool:
        seen: set[int] = set()
        
        for num in nums:
            if num in seen:
                return True
            seen.add(num)
        return False
