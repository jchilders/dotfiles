function trimlogs --description "Delete logs from work log directories"
  set -l prev_dir (pwd)
  set -l ag_dirs agency_gateway_api ag-admin ag_client/spec/dummy
  printf "Deleting logs...\n"
  for dir in $ag_dirs
    cd ~/workspace/agency_gateway/$dir/log
    set -l size (ls -lrt | awk '{ total += $5 }; END { print total }' | numfmt --to=si)
    printf " -> %s (%s)\n" (pwd) $size
    rm test.log development.log newrelic_agent.log ^ /dev/null
  end

  set -l sms_dirs sms pam-api remora
  for dir in $sms_dirs
    cd ~/workspace/$dir/log
    set -l size (ls -lrt | awk '{ total += $5 }; END { print total }' | numfmt --to=si)
    printf " -> %s (%s)\n" (pwd) $size
    rm test.log development.log newrelic_agent.log bullet.log ^ /dev/null
  end

  cd $prev_dir
end
