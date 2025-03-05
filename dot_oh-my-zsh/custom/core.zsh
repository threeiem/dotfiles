function utc(){
  local ts
  ts="${1}"

  # Return current UTC time
  if [[ -z "${ts}" ]]; then
    date --utc "+%Y-%m-%dT%H:%M:%SZ"
    return
  fi

  # Return UTC time for a specific unix timestamp
  date --utc -d ${ts} "+%Y-%m-%dT%H:%M:%SZ"

}
