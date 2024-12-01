while IFS= read -r line; do
  package=`echo $line | awk -F ',' '{ print $1 }'`
  desired=`echo $line | awk -F ',' '{ print $2 }'`
  echo "$package = $desired"
done <asdf-list.txt
