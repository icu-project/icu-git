if [ $# -ne 1 ];
then
    echo "usage: $0 repo-path"
    exit 1
fi

svn log --quiet "$1" | grep "^r" | awk '{print $3}' | sort | uniq > scripts/authors-all.txt
