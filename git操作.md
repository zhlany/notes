# 日常操作

```shell
git clone http://xxx.com
git branch
git branch -d xxx # 删除分支
git branch -m xxx1:xxx2 # 分支重名
git log --oneline --graph --decorate --all
git log --oneline

# 1. 基于当前分支创建分支并命名xxx
git checkout -b xxx

# 2. 添加、提交
git add .
git commit -m"[ADD]xxxx"
# 如果已经有一次提交了，则使用以下命令合并提交
git commit --amend --no-edit

# 3. 更新本分支代码为最新代码
git checkout master # 切换主干
git pull            # 拉去最新代码
git checkout -      # 切换上次一切换的分支
git rebase master   # 同步主干代码

# 4. 合并冲突（如果有）
git diff               # 查看冲突
git add .              # 暂存
git rebase --continue  # 保存修改

# 3.推送远端
# 首次提交可以用push -u, 之后推送到这条分支时可以直接使用git push就可以推送上去
git push -u origin 本地分支名 #（默认在远端创建一样的分支名）
git push -u origin 本地分支名:远端分支名

# 或者使用强制提交
git push -f origin 分支名
```

# 撤回，取消修改

```sh
#             工作区的撤销，未git add .
# ---------------------------------
# 撤销单个文件的修改
git checkout -- filename.txt
# 撤销所有文件的修改（⚠️危险！）
git checkout -- .
# 交互式选择要撤销的修改块
git checkout -p filename.txt


#             暂存区的撤销，已 git add .
# ---------------------------------
# 将单个文件移出暂存区，但保留修改
git reset HEAD filename.txt
# 将所有文件移出暂存区
git reset HEAD

# ---------------------------------
# 例：移除某个已提交的文件
git reset HEAD xxx.txt
git checkout -- xx.txt
# 或者
git reset --hard HEAD filename.txt


#             提交的撤销
# ----------------------------------
# 撤销提交，修改回到暂存区
git reset --soft HEAD~1
# 撤销提交，修改回到工作区
git reset HEAD~1

#             撤销分支合并
# 方法1：使用revert（推荐，不重写历史）
git revert -m 1 <merge-commit-hash>

# 方法2：使用reset（会重写历史，仅限本地）
git reset --hard HEAD~1
```

# 暂存

```sh
# 查看所有stash
git stash list
# 添加说明信息（强烈推荐！）
git stash push -m "正在开发用户登录功能"

# 恢复最近一次stash（并从栈中删除）
git stash pop

# 恢复指定stash（从栈中删除）
git stash pop stash@{1}

# 恢复但不删除（stash保留在栈中）
git stash apply
git stash apply stash@{2}
```



# 记录

```shell
git rebase ## 同步上游分支（master）到本分支
git rebase -i HEAD~3 ## 多个提交合成一个提交（需另开分支）

```

# 回退，修改提交

```sh
git reset --soft ##退回到某个版本，只退回commit的信息，本地代码不变
git reset --soft HEAD~1 ## 退回到上个版本
git reset --hard ##(强制)彻底撤回到某个版本，本地代码也撤回到版本的内容
git revert  ## 创建新提交，撤销指定提交的更改

git commit --amend ##修改最近一次提交的内容（未提交远端回退提交）
```



# 基本信息配置

```shell
git config --global user.name "xxx"
git config --global user.email "xxx@example.com"
git config --global --list

# SSH密钥配置
# 生成
ssh-keygen -t ed25519 -C "xxx@example.com"
# 查看
cat ~/.ssh/id_ed25519.pub

# 添加到github后
# 测试连接
ssh -T git@github.com

git remote -v
```



# 远程仓库配置

```shell
# 查看远程仓库
git remote -v

# 添加多个远程仓库
git remote add origin1 https://github.com/original/repo.git
git remote add origin2 https://github.com/team/repo.git

# 显示特定远程仓库信息
git remote show origin

# 将 origin 改名为 upstream
git remote rename origin upstream

# 修改已有的远程仓库地址
git remote set-url origin https://github.com/newusername/repo.git

# 修改特定操作（只修改push地址）
git remote set-url --push origin https://github.com/yourfork/repo.git

# 删除名为 upstream 的远程仓库
git remote remove upstream
# 或
git remote rm upstream
```