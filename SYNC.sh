#!/bin/bash
# 从上游仓库同步题目内容，保留自定义文件

set -e

echo "开始从上游仓库同步题目..."

# 添加上游远程仓库（如果还没添加）
if ! git remote | grep -q upstream; then
    git remote add upstream https://github.com/duckpigdog/Sec-Interview.git
fi

echo "获取上游仓库更新..."
git fetch upstream

echo "备份当前自定义文件..."
# 备份自定义文件
mkdir -p /tmp/sec-interview-backup
cp index.html chapter.html DEPLOYMENT.md /tmp/sec-interview-backup/ 2>/dev/null || true
if [ -d .github ]; then
    cp -r .github /tmp/sec-interview-backup/
fi

echo "合并上游更新..."
git merge upstream/main --no-edit || true

echo "恢复自定义文件..."
# 恢复自定义文件
cp /tmp/sec-interview-backup/index.html . 2>/dev/null || true
cp /tmp/sec-interview-backup/chapter.html . 2>/dev/null || true
cp /tmp/sec-interview-backup/DEPLOYMENT.md . 2>/dev/null || true
if [ -d /tmp/sec-interview-backup/.github ]; then
    rm -rf .github
    cp -r /tmp/sec-interview-backup/.github .
fi

echo "提交同步更新..."
git add -A
git commit -m "sync: 同步上游题目更新

- 从 duckpigdog/Sec-Interview 同步最新题目
- 保留自定义网站文件和部署配置" || echo "没有新更新需要提交"

echo "同步完成！"
echo "查看变更: git diff upstream/main"
