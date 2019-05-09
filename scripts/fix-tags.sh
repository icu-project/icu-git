!#/bin/sh
cd git/cldr.git

for ref in $(git for-each-ref --format='%(refname)' refs/heads/origin/tags);
do
    tag=$(basename ${ref})
    git tag "${tag}" "${ref}"
    #git branch -D "${ref}"
done
