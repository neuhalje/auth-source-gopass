#!/usr/bin/env bash

echo "# CHANGELOG for auth-source-gopass"
echo ""
echo "_newest tag first, each tag sorted in chronological order (oldest first)_"
echo

previous_tag=0
for current_tag in HEAD $(git tag --sort=-creatordate)
do

if [ "$previous_tag" != 0 ];then
    tag_date=$(git log -1 --pretty=format:'%ad' --date=short ${previous_tag})
    printf "## ${previous_tag} (${tag_date})\n\n"
    git log ${current_tag}...${previous_tag} --pretty=format:'*  %s (/%aN <%ae>/) [View](https://git.convex-hull.org/jens/P018_auth_sources_gopass/commit/%H)' --reverse | grep -v Merge
    printf "\n\n"
fi
previous_tag=${current_tag}
done
