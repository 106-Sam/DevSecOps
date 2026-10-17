# Git and GitHub 

**Index of Content**

1. [Day 1 - Version Control System in Git](https://github.com/106-Sam/DevSecOps/tree/main/Git%20%26%20Github#day-1---version-control-system-in-git)
2. [Day 2 - Merge Conflicts and Branching Strategies](https://github.com/106-Sam/DevSecOps/tree/main/Git%20%26%20Github#day-2---merge-conflicts-and-branching-strategies)
3. [Day 3 - Git Merge and Square Rebase](https://github.com/106-Sam/DevSecOps/tree/main/Git%20%26%20Github#day-3---git-merge-and-square-rebase)




## DAY 1 - Version Control System in Git
Version Control: A version control system (VCS) is the software that records changes made to source code, including separate files, sets of files, and any digital assets and related project metadata. This way, the system enables tracking of all project changes and allows developers to revert files to specific versions as needed. Without version control, projects risk becoming disorganized with numerous file versions.

link - [click here](https://www.devart.com/blog/centralized-vs-distributed-version-control.html)

Version control are of 2 types:

- Centralized Version Control: Server & Client
    
    svn: subversion


- Distributed Version Control: Server & Client
    
    git, github

    ![alt text](files/image.png)

### What is Git ?

Git is a local software application, where you can track the version control (change in our code) locally.


### What is GitHub?

GitHub is a cloud-based platform that hosts those code repositories so teams can collaborate online.

| Feature | GIt | GitHub |
|---|---|---|
| Define | Git is a standalone *Version Control System* (VCS) | GitHub is a *cloud based hosting service* built for git |
| Environment | Runs *locally* on our computers | Lives in the *Cloud* (accessible via browsers) |
| Interface | Primary a *command line interface (CLI)* | A visual *Graphical User Interface (GUI)* |
| Internet | Works *offline* | Requires an *Internet connection* |
| Ownership | OpenSource (maintained by the Linux Community) | Owned by *Microsoft* |


### Installation of Git

- Firstly, go to https://git-scm.com/install download as per your operating system.
- git commands can be executed from powershell, command prompt, vs code, git bash, etc.
- *README.MD* file used for documentation of the repo.
- *.gitignore* file is used for not tracking that file. Basically, it will not allow push those file to the GitHub.
- Whenever you see a .git directory (which is hidden) it means it is a git project. 
- Internally git server will be running over there.
  
1. To work on the existing Repo Clone that repository `git clone <url of the repo>`
- by default, we will have multiple stages. 
  - *Working area* - Whenever we make some new changes or create file in the git project it will be in the working area. 
    - You need to use `git status`, it isn't able to track those changes or file. (red color)
    - To add it to the git project, use `git add .` or `git add <filespathwithnames>`it wil make all the file in track. These changes will be moved to the index/stage area.
  - *Stage/Index area* - Now, `git status` shows it is able to track those changes or file (green color) 
    - Use `git commit -m "<message descp>"` -m means message box and now it will take the tracked file / changes /files to commit area
  - *Commit area* - `git log` These all commits are maintained locally. it shows us the commits and those changes aren't yet pushed to GitHub so they will not be appear on the repo. 
    - before push command
        ![alt text](files/image1.png)

    - we can authenticate via the username/password, but we will authenticate with the token:
    - `git push` 


### How to get the authentication token 

Step 1: Click on the project picture > Settings > Developer Setting (scroll down)
Step 2: Personal access tokens (PAT)  > Token (classic)
Step 3: Generate new token classic > it will prompt for password > Note (write something) > expire date > Select the scope are per you requirement. > generate > copy the token.
Step 4: It will prompt auth during `git push` choose token > paste the token and sign in


### Git logs commands 

- `git log` - proivde us complete information of the logs.
- `git log --oneline` - provides us with short descp informaton of the logs.

- `git pull` - When we execute git pull it will update the code in the local so that it is same on the repo
- We use `git pull` before `git push` to have prevent the error and issue that will occur later.
- And while pulling we might get the merge conflicts.


## Day 2 - Merge Conflicts and Branching Strategies

2. We are going to create a new repo and then work on it.

- `git init` - it will initialize the current working directory and create .git directory
- `git add .` - to track all the current working directory files then,
- `git commit -m " "`  - it will move the changes to commit area locally
- when we try to push the code it doesn't work as there is no destination for that so, first we create an repo on the GitHub site and use the command `git remote add origin <url>`
 ex: `git remote add origin https://github.com/106-sam/Acube.git`
 - `git remote -v` - to check the destination details.
 - `git push -u origin main/master` - push the code for the first time.


### Merge Conflicts 

Merge conflicts often happen when people make different changes to the same line of the same file, or when one person edits a file and another person deletes the same file.

[click here](https://docs.github.com/en/pull-requests/reference/merge-conflicts)

To resolve the conflicts, the two persons need to sit together and decide which changes are right and keep them. After that they pull the repo

Once solved just do this 
`git rebase --continue` 
`git push -u origin main/master`


### Branching Strategy




## Day 3 - Git Merge and Square Rebase