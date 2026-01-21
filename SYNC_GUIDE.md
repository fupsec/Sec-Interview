# 上游题目同步指南

## 仓库说明

- **你的仓库**: https://github.com/fupsec/Sec-Interview
- **上游仓库**: https://github.com/duckpigdog/Sec-Interview
- **同步内容**: 仅同步章节题目（Chapter1-31），保留自定义的网站文件

## 方式一：使用自动同步脚本（推荐）

### 首次设置

脚本已配置好，直接运行即可：

```bash
./SYNC.sh
``

### 脚本功能

1. 自动获取上游仓库最新更新
2. 备份你的自定义文件（index.html, chapter.html, DEPLOYMENT.md, .github/）
3. 合并上游题目更新
4. 恢复自定义文件
5. 自动提交同步结果

### 定期同步

每当上游仓库有新题目时，运行：

```bash
git pull origin main
./SYNC.sh
git push origin main
```

## 方式二：手动同步

### 步骤1：获取上游更新

```bash
git fetch upstream
```

### 步骤2：查看上游变更

```bash
git log upstream/main --oneline -10
git diff main..upstream/main --stat
```

### 步骤3：合并上游更新

```bash
git merge upstream/main --no-edit
``

### 步骤4：如果有冲突，只保留题目更新

如果合并时自定义文件有冲突：

```bash
# 查看冲突文件
git status

# 保留自己的版本（对于自定义文件）
git checkout --ours index.html chapter.html DEPLOYMENT.md .github/

# 使用上游版本（对于章节题目）
git checkout --theirs Chapter1/ Chapter2/ ... Chapter31/
```

### 步骤5：提交并推送

```bash
git add -A
git commit -m "sync: 同步上游题目更新"
git push origin main
```

## 方式三：仅同步特定章节

如果只想同步某个章节：

```bash
# 获取上游文件到临时目录
curl -o /tmp/chapter.md https://raw.githubusercontent.com/duckpigdog/Sec-Interview/main/Chapter1/README.md

# 复制到你的仓库
cp /tmp/chapter.md Chapter1/README.md

# 提交更新
git add Chapter1/README.md
git commit -m "sync: 同步Chapter1题目"
git push origin main
```

## 已添加的远程仓库

```bash
# 查看远程仓库
git remote -v

# output:
# origin    https://github.com/fupsec/Sec-Interview.git (fetch)
# origin    https://github.com/fupsec/Sec-Interview.git (push)
# upstream  https://github.com/duckpigdog/Sec-Interview.git (fetch)
# upstream  https://github.com/duckpigdog/Sec-Interview.git (push)
```

## 自定义文件列表

以下文件不会被上游覆盖（会保留你的自定义版本）：

- `index.html` - 自定义首页
- `chapter.html` - 自定义章节详情页
- `DEPLOYMENT.md` - 部署指南
- `SYNC.sh` - 同步脚本
- `.github/` - GitHub Actions 配置

## 注意事项

1. **定期同步**：建议每周或每两周同步一次上游更新
2. **测试同步**：第一次同步前建议先在测试分支测试
3. **查看变更**：同步前先查看上游的变更内容
4. **备份重要文件**：虽然脚本会自动备份，但建议定期备份仓库

## 临时禁用上游同步

如果想临时不获取上游更新：

```bash
git remote remove upstream
```

需要同步时重新添加：

```bash
git remote add upstream https://github.com/duckpigdog/Sec-Interview.git
git fetch upstream
```
