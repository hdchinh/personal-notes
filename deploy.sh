#!/bin/bash
GREEN='\033[0;32m'
NC='\033[0m'

hexo_clean="hexo clean"
hexo_generate="hexo generate"
cd_public="cd public"
push_to_github="git add & git commit -m 'Update' && git push origin master"
# Don't use domain for now
# create_file="touch CNAME"
# add_content="echo "hdchinh.com" >> CNAME"
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
echo "${GREEN}============ Finished Deployment ==============${NC}"

echo "${GREEN}============ Pushing to Github ================${NC}"
eval $push_to_github
echo "${GREEN}============ Finished Pushing =================${NC}"
