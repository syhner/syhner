# https://leetcode.com/problems/top-k-frequent-elements

def topKFrequent(nums: list[int], k: int) -> list[int]:
	count = {}
	freq = [[] for _ in range(len(nums) + 1)]

	for num in nums:
		count[num] = 1 + count.get(num, 0)
	for num, cnt in count.items():
		freq[cnt].append(num)
	
	res = []
	for i in range(len(freq) - 1, 0, -1):
		for num in freq[i]:
			res.append(num)
			if len(res) == k:
				return res
