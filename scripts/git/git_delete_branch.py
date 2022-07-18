import os

print('Option: ')
options = ['UPY-#', 'CS-', 'No Task', 'Sem Tarefa']

for index, text_option in enumerate(options):
    print(str(index) + " - "+ options[index])

option_num = int(input())
option = options[option_num]

print('Branch: ')
list_branch = input()

if type(list_branch) in(str, int):
    list_branch = str(list_branch).split(",")

if list_branch:
    for branch in list_branch:
        os.system("git checkout develop")
        if option_num in [2,3]:
            os.system("git push origin --delete " + str(branch))
        else:
            os.system("git push origin --delete " + str(option) + str(branch))

        print("===== Deleted branch " + str(branch))

