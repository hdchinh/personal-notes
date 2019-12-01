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
