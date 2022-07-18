import os

print('Option: ')
options = ['UPY-#', 'CS-', 'No Task', 'Sem Tarefa']

for index, text_option in enumerate(options):
    print(str(index) + " - "+ options[index])

option_num = int(input())
option = options[option_num]

print('Branch: ')
branch = input()

if branch:
    os.system("git checkout develop")

    if option_num in [2,3]:
        os.system("git checkout " + str(branch))
    else:
        os.system("git checkout " + str(option) + str(branch))
    
    os.system("git pull")
    print("===== Checkout branch " + str(branch))

