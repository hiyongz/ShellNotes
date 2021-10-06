

import random
from functools import reduce

class Solution:
    def SplitInteger(self, sum, count, minNum):

        sum = sum - count*minNum
        num_list = [0, sum]

        for _ in range(count-1):
            round_num = round(random.random()*sum)
            num_list.append(round_num)

        print(num_list)
        num_list = sorted(num_list)
        print(num_list)
        
        new_list = []
        for i in range(len(num_list)-1):
            new_list.append(num_list[i+1] - num_list[i])

        new_list = list(map(lambda x: x+minNum, new_list))

        print(new_list)
        sum = reduce(lambda x, y: x + y, new_list)
        print(sum)


if __name__ == "__main__":
    Solu = Solution()
    result = Solu.SplitInteger(100, 5, 0)
    print(result)