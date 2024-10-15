# https://leetcode.com/problems/contains-duplicate

def hasDuplicate(nums: list[int]) -> bool:
    seen = set()
    
    for num in nums:
        if num in seen:
            return True
        seen.add(num)
    return False
