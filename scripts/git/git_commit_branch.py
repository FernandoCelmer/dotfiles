import os

print('Option: ')
options = ['UPY-#', 'CS-', 'No Task', 'Sem Tarefa']

for index, text_option in enumerate(options):
    print(str(index) + " - "+ options[index])

option_num = int(input())
option = options[option_num]

print('Branch: ')
branch = input()

print('Description: ')
description = str(input())

if branch and description:
    os.system("git checkout develop")
    os.system("git stash")

    if option_num in [2,3]:
        os.system("git checkout " + str(branch))
    else:
        os.system("git checkout " + str(option) + str(branch))

    os.system("git pull")
    os.system("git stash apply")
    os.system("git add .")
    os.system("git status")

    if option_num in [2,3]:
        os.system("git commit -m '" + str(option) + " - " + str(description) + "'")
    else:
        os.system("git commit -m '" + str(option) + str(branch) + " - " + str(description) + "'")

    os.system("git push")
    print("===== Commited branch " + str(branch))

