function trimlogs --description "Trim logs files that are bigger than a given size"
  set -l prev_dir (pwd)
  set -l ag_dirs agency_gateway_api ag-admin ag_client/spec/dummy
  for dir in $ag_dirs
    cd ~/workspace/agency_gateway/$dir/log
    printf "Deleting logs in %s\n" (pwd)
    rm test.log development.log ^ /dev/null
  end
  set -l sms_dirs sms
  for dir in $sms_dirs
    cd ~/workspace/$dir/log
    printf "Deleting logs in %s\n" (pwd)
    rm test.log development.log ^ /dev/null
  end

  cd $prev_dir
end

