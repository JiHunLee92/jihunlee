#!/bin/bash

# set_parameter() { aws ssm put-parameter --overwrite --name "${1}" --value "${2}" --type String --query "''" --output text; }
# set_secure_parameter() { aws ssm put-parameter --overwrite --name "${1}" --value "${2}" --type SecureString --query "''" --output text; }
set_parameter() { aws ssm put-parameter --profile ${PROFILE} --overwrite --query "''" --output text --cli-input-json '{"Name":"'${1}'","Value":"'$(echo -ne "${2}" | perl -pe 's/(\\(\\\\)*)/$1$1/g; s/(?!\\)(["\x00-\x1f])/sprintf("\\u%04x",ord($1))/eg;')'","Type": "String"}'; }
set_secure_parameter() { aws ssm put-parameter --profile ${PROFILE} --overwrite --query "''" --output text --cli-input-json '{"Name":"'${1}'","Value":"'$(echo -ne "${2}" | perl -pe 's/(\\(\\\\)*)/$1$1/g; s/(?!\\)(["\x00-\x1f])/sprintf("\\u%04x",ord($1))/eg;')'","Type": "SecureString"}'; }

if [[ "${1}" = "-h" || "${1}" = "--help" || ( -z "${1}" && -z "${2}" && -z "${3}" ) ]]
then
  echo -e 'Example usage:\n  ./dotenv-to-ssm.sh [INPUT_FILE] [SSM_PARAMETER_PREFIX] [PROFILE]'
  exit 0
fi

INPUT_FILE="${1}"
SSM_PARAMETER_PREFIX="$(echo "${2}" | sed -E 's/^\/?/\//g; s/\/?$/\//g;')"
PROFILE="${3:-default}"

echo "Reading from '${INPUT_FILE}' and writing to '${SSM_PARAMETER_PREFIX}' using profile '${PROFILE}'"

while IFS="" read -r LINE || [ -n "${LINE}" ]
do
  MATCHES=$(echo "${LINE}" | perl -ne 'print if s/^([^#][\w\d_]+)\s*=\s*(['"\"'"']?)((?:(?=(\\?))\4.)*)(\2)/\1\n\3/')

  if [[ ! -z "${MATCHES}" ]]
  then
    IFS=$'\n' RESULT=(${MATCHES})

    if [[ "${RESULT[0]}" =~ _(KEY|PASS|PASSWORD|SALT|SECRET|USER|USERNAME)$ ]]
    then
      set_secure_parameter "${SSM_PARAMETER_PREFIX}${RESULT[0]}" "${RESULT[1]}"
      echo "Parameter (SecureString): '${SSM_PARAMETER_PREFIX}${RESULT[0]}' defined as '${RESULT[1]}'"
    else
      set_parameter "${SSM_PARAMETER_PREFIX}${RESULT[0]}" "${RESULT[1]}"
      echo "Parameter (String):       '${SSM_PARAMETER_PREFIX}${RESULT[0]}' defined as '${RESULT[1]}'"
    fi
  fi
done < "${INPUT_FILE}"

