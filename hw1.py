conversion = ['a', 'b', 'c', 'd', 'p', 'q', 'r', 'x', 'y']
'''
for i in range(1, 82):
    second = i % 9
    first = (i // 9)
    print(f'{i} = x_{conversion[first]}{conversion[second]}')
'''
    
count = 1
for item1 in conversion:
    for item2 in conversion:
        print(f'{count}: {item1}{item2}')
        count += 1
