## 记录

```shell
如果在分支的话，直接
git push -f
git pull --rebase origin master   #从远端获取最新代码
git branch   #产看分支
git branch -d "分支名"   #删除分支
git checkout master    切换分支到主干

git checkout master     切换分支到主干
git merge 分支       将本地分支合并到本地主干

#提交
git push -f origin master
```



## 基本信息

```shell
git fetch     将远程主机最新的内容拉倒本地，用户检查之后在选择手动合并(要先回到主干git checkout master)
git pull      拉下并合并

git config user.name
git config user.password
git config user.email
git config --list  #查看配置信息
git remote -v`
```



### 分支操作

git remote add origin git@gitee.com:zhlOnly_0/zhl-go.git

```shell
git remote -v # 查看本地已经关联的远程仓库
git remote rm name  # # 删除远程仓库
git remote rename old_name new_name  # # 修改仓库名
git remote add name 远程仓库地址 # name 为要取的仓库名字 远程仓库地址 为要关联的远程仓库地址
```

### 回退，修改提交

```shell
git reset --soft ##退回到某个版本，只退回commit的信息，本地代码不变
git reset --soft HEAD~1 ## 退回到上个版本
git reset --hard ##(强制)彻底撤回到某个版本，本地代码也撤回到版本的内容
git revert  ## 创建新提交，撤销指定提交的更改

git commit --amend ##修改最近一次提交的内容（未提交远端回退提交）
```

### 合并

```shell
git rebase  的使用
git rebase -i HEAD~2  #合并提交，2表示合并两个
git rebase {ID}
```

### 提交日志查看

```shell
git log --oneline --graph --decorate --all
```



### rebase信息同步

```shell
git rebase ## 同步上游分支（master）到本分支

git rebase -i HEAD~3 ## 多个提交合成一个提交（需另开分支）
```



### 差异解决

```shell
git diff ## 查看差异
##解决完差异之后
git add .
git rebase --continue
```

