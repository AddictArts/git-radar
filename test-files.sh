scriptDir="$(cd "$(dirname "$0")"; pwd)"

source "$scriptDir/git-base.sh"

tmpfile=""

cd_to_tmp() {
  tmpfile="/tmp/git-prompt-tests-$(time_now)$1"
  mkdir -p "$tmpfile"
  cd "$tmpfile"
}

rm_tmp() {
  cd $scriptDir
  rm -rf /tmp/git-prompt-tests*
}

test_untracked_files() {
  cd_to_tmp
  git init --quiet

  assertEquals "0" "$(untracked_files)"
  
  touch foo
  assertEquals "1" "$(untracked_files)"

  git add .
  assertEquals "0" "$(untracked_files)"

  rm_tmp
}

test_staged_added_files() {
  cd_to_tmp
  git init --quiet

  assertEquals "0" "$(staged_added_changes)"

  touch foo
  git add .
  assertEquals "1" "$(staged_added_changes)"

  touch bar
  git add .
  assertEquals "2" "$(staged_added_changes)"

  rm_tmp
}

test_staged_modified_files() {
  cd_to_tmp
  git init --quiet

  assertEquals "0" "$(staged_modified_changes)"

  touch foo
  touch bar
  git add .
  git commit -m "foo and bar" >/dev/null

  echo "foo" >> foo
  git add .
  assertEquals "1" "$(staged_modified_changes)"

  echo "bar" >> bar
  git add .
  assertEquals "2" "$(staged_modified_changes)"

  rm_tmp
}

test_staged_deleted_files() {
  cd_to_tmp
  git init --quiet

  assertEquals "0" "$(staged_deleted_changes)"

  touch foo
  touch bar
  git add .
  git commit -m "foo and bar" >/dev/null

  rm foo
  git add .
  assertEquals "1" "$(staged_deleted_changes)"

  rm bar
  git add .
  assertEquals "2" "$(staged_deleted_changes)"

  rm_tmp
}

test_staged_renamed_files() {
  cd_to_tmp
  git init --quiet

  assertEquals "0" "$(staged_renamed_changes)"

  touch foo
  touch bar
  git add .
  git commit -m "foo and bar" >/dev/null

  mv foo foo2
  git add .
  assertEquals "1" "$(staged_renamed_changes)"

  mv bar bar2
  git add .
  assertEquals "2" "$(staged_renamed_changes)"

  rm_tmp
}

. ./shunit/shunit2
