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

function message(){
	local slug line
	slug="${1}"
	shift
	line="$*"
	echo -e "$(utc) [${slug}] ${line}"
}

function e_message(){
	local slug line
	slug="${1}"
	line="${2}"
	message "${slug}" "${line}" >&2
}

function info(){
	local line
	line="$*"
	message "${Bold}${Green}INFO${Reset}" "${line}"
}

function warn(){
	local line
	line="$*"
	message "${Bold}${Yellow}WARN${Reset}" "${line}"
}

function error(){
	local line
	line="$*"
	message "${Red}ERROR${Reset}" "${line}"
}

function fatal(){
	local line
	line="$*"
	message "${Bold}${Red}FATAL${Reset}" "${line}"
}

function e_info(){
	line="${1}"
	e_message "INFO" "${line}"
}

function e_warn(){
	line="${1}"
	e_message "WARN" "${line}"
}

function e_error(){
	line="${1}"
	e_message "ERROR" "${line}"
}

function e_fatal(){
	line="${1}"
	e_message "FATAL" "${line}"
}
