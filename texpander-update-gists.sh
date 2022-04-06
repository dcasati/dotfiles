#!/usr/bin/env bash
GIST_BASE=https://gist.github.com
GITHUB_USER=(dcasati raykao)
THIS_USER=dcasati

# Store base directory path, expand complete path using HOME environment variable
base_dir=$(realpath "${HOME}/.texpander")

# If ~/.texpander directory does not exist, create it
if [ ! -d ${HOME}/.texpander ]; then
    mkdir ${HOME}/.texpander
fi

get_gists() {
  local _gists
  _gists=$(curl -s ${GIST_URL} | grep -A 1 link-overlay | sed -E 's/.*href="(.*)">/\1/g; s/.*<strong>(.*)<\/strong>.*/\1/g; s/--//g; /^$/d; s/[[:space:]]/-/g' | paste -d , - - )

    for gist in ${_gists}; do
      echo $gist | awk -v BASEDIR="$base_dir" -v USER="${THIS_USER}" -F , '{printf "creating %s/gist-%s-%s\n", BASEDIR, USER, $2}'

      # create the files locally
      echo $gist | \
      sed 's/github/githubusercontent/' | \
      awk -v BASEDIR="$base_dir" -v USER="${THIS_USER}" -F , '{printf "curl -s %s/raw -o %s/gist-%s-%s\n",$1, BASEDIR, USER, $2}' | bash
  done
}

gist_next_page() {
  local next_page

  next_page=$(curl -s ${GIST_URL} | grep Older)

  # if this command worked then it means we have to follow 
  # the next page
  if [[ $? == 0 ]]; then
    GIST_URL=$(echo ${next_page} | sed -E 's/.*href="(.*)">.*/\1/g')
  get_gists
  fi
}

update_local_gists_cache() {
  get_gists
  gist_next_page
}

for user in ${GITHUB_USER[@]}; do
  echo -e "\nfetching gists from $user"
  
  THIS_USER=$user
  GIST_URL=${GIST_BASE}/${user}
  
  update_local_gists_cache
done
