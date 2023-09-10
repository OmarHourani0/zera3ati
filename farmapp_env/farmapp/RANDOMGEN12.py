#generate a random 10 number long string and copy it to clip board

import random

def randomgen():
    randomstring = ''
    for i in range(10):
        randomstring = randomstring + str(random.randint(0,9))
    return randomstring

print(randomgen())