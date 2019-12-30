---
title: Deploy My Blog Use Script
date: 2019-12-01
tags: ["TIL"]
label: "[@til]"
---

## 1. Example

```bash
#!/bin/bash
GREEN='\033[0;32m'
NC='\033[0m'

hexo_clean="hexo clean"
hexo_generate="hexo generate"
cd_public="cd public"
create_file="touch CNAME"
add_content="echo "hdchinh.com" >> CNAME"
deploy="hexo deploy"

echo "${GREEN}============ Starting Gengerate ===============${NC}"
eval $hexo_clean
eval $hexo_generate
eval $cd_public

echo "${GREEN}============ Starting Create CNAME ============${NC}"
eval $create_file
eval $add_content

echo "${GREEN}============ Starting Deploy ==================${NC}"
eval $deploy
echo "${GREEN}============ Done =============================${NC}"

```

## 2. Use multiple command in oneline

We have two commands need to execute:

eg: A, B

We have three ways to execute A, B in one line.

```bash
A; B (always run A, B)

A && B (run B if A execute successful)

A || B (run B if A execute failure)
```
