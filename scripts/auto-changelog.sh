echo "Changes since last tag: "
echo

git log $(git describe --tags --abbrev=0 @^)..@ --oneline | sed "s/^[^ ]* //" | sed "/Merge [branch|tag|pull request]/d" | sed "s/^/- /"