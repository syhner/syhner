# https://leetcode.com/problems/two-sum

def twoSum(nums: list[int], target: int) -> list[int]:
    seen = {} 

    for i, n in enumerate(nums):
        diff = target - n
        if diff in seen:
            return [seen[diff], i]
        seen[n] = i
    raise Exception("No two sum")
