# GitHub Pages 部署指南

本项目已配置好 GitHub Actions 自动部署，需要你手动启用 GitHub Pages 功能。

## 启用步骤

1. 进入仓库页面：https://github.com/fupsec/Sec-Interview
2. 点击 **Settings**（设置）标签页
3. 在左侧菜单找到并点击 **Pages**
4. 在 **Build and deployment** 部分：
   - Source 选择 **GitHub Actions**
5. 点击 **Save** 保存

## 部署原理

- 当代码推送到 `main` 分支时，GitHub Actions 会自动触发
- 工作流会自动将网站内容部署到 GitHub Pages
- 首次部署可能需要几分钟时间
- 部署完成后，你可以通过 `https://fupsec.github.io/Sec-Interview/` 访问网站

## 手动配置 GitHub Actions（可选）

如果你的 GitHub Personal Access Token 没有 `workflow` 权限，可以手动创建工作流文件：

1. 在仓库中创建 `.github/workflows/` 目录
2. 创建 `deploy.yml` 文件，内容如下：

```yaml
name: Deploy to GitHub Pages

on:
  push:
    branches: [ main, master ]
  workflow_dispatch:

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: "pages"
  cancel-in-progress: false

jobs:
  deploy:
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4
      
      - name: Setup Pages
        uses: actions/configure-pages@v5
      
      - name: Upload artifact
        uses: actions/upload-pages-artifact@v3
        with:
          path: '.'
      
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4
```
