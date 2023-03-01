#! /usr/bin/env bash

command=$1;
file_name=users.db
file_dir=$(realpath "${BASH_SOURCE:-$0}" | xargs dirname)/../data
db_file=$file_dir/$file_name

validateLattinLatters() {
  if [[ $1 =~ ^[[:alpha:]]+$ ]]; then
      return 0;
  else
      return 1;
  fi
}

add() {
  read -p "Enter username : " name

  if ! validateLattinLatters $name; then
      echo "Invalid name. Try again"
      exit 1
  fi

  read -p "Enter role : " role

  if ! validateLattinLatters $role; then
      echo "Invalid role. Try again"
      exit 1
  fi
  
  echo "$name, $role" >> $db_file 
}

list() {
  cat $db_file | awk '{print NR". " $1 " " $2}'
}

help() {
  echo "Manages users in db file."
  echo 
  echo "usage db.sh [command]"
  echo 
  echo "add       Adds a new line to the users.db.
                  The script must prompt a user to type the username of a new entity.
                  After entering the username, the user must be prompted to type a role"
  echo "backup    Creates a new file, named %date%-users.db.backup which is a copy of current users.db"
  echo "restore   Takes the last created backup file and replaces users.db with it.
                  If there are no backups - script should print: “No backup file found”"
  echo "find      Prompts the user to type a username, then prints username and role if such exists in users.db.
                  If there is no user with the selected username, the script must print: “User not found”.
                  If there is more than one user with such a username, print all found entries."
  echo "list      Prints the content of the users.db in the format: #. username, role
                  Accepts an additional optional parameter --inverse
                  which allows results in the opposite order – from bottom to top. Running the command"
}

case $command in
    add)           add;;
    list)          list;;
    help | '' | *) help;;
esac
