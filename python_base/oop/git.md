####diff比较
- git diff 查看被跟踪文件未暂存的修改 比较暂存区(Index)和工作区(Worker)
- git diff --cached 查看被跟踪文件暂存的修改 比较暂存区(Index)和上一次commit的差异
- git diff HEAD 查看被跟踪文件 比较工作区(WorkSpace)和上一次commit的差异 HEAD指代最后一次commit
- HEAD 指代最后一次commit
- HEAD^ 指代上一次提交 (最后一次提交的前一次)
- HEAD^^ 指代上上一次提交
- 上n此提交 表示为HEAD~n

#### 检出和重置
- git checkout 列出暂存区(Index)可以被检出的文件
- git checkout file 从暂存区(Index)检出文件到工作区(WorkSpace) 就是覆盖工作区(WorkSpace)文件 可指定检出的文件 但是不清除stage
- git checkout HEAD file  使用当前分支的最后一次commit检出覆盖暂存区(Index)和工作区(WorkSpace)
- git checkout commit file 检出某个commit的指定文件到暂存区(Index)和工作区(WorkSpace)
- git checkout . 检出暂存区(Index)的所有文件到工作区(WorkSpace)

- git reset 列出将被reset的文件
- git reset file 重置文件的暂存区 和上一次commit一致 工作区不影响
- git reset --hard 重置暂存区与工作区 与上一次commit保持一致


- git reflog 显示commit的信息 只要HEAD发生变化 就可以在这里看到
- git reset commit 重置当前分支的HEAD 为指定的commit 同时重置暂存区 但工作区不变
- git reset --hard [commit] 重置当前分支的HEAD为指定commit 同时重置暂存区(Index)和工作区(WorkSpace) 与指定commit一致
- git reset --keep [commit] 重置当前HEAD为指定commit 但保持暂存区(Index)和工作区(WorkSpace)不变

#### 移动和删除
- git mv src dest 改名 直接把改名的改动放入暂存区
- git rm file 会同时在版本库和工作目录中删除文件 真删除
- git rm --cached　file 将文件从暂存区转成未暂存 从版本库中删除  但不删除工作目录的该文件 即文件恢复成不追踪的状态
- 以上都算是改动 必须commit才算真改动


