'''https://stepik.org/lesson/265115/step/9?thread=solutions&unit=246063

Задача
	Вводятся 3 строки в случайном порядке. Напишите программу, которая выясняет можно ли из длин этих строк построить возрастающую арифметическую прогрессию.
'''
	
a, b, c = input(), input(), input()
sum_abc = len(a) + len(b) + len(c)
x3 = max(len(a), len(b), len(c))
x1 = min(len(a), len(b), len(c))
x2 = sum_abc - x1 - x3
d = x2 - x1
if x3 == x1 + (2 * d):
    print('YES')
else:
    print('NO')