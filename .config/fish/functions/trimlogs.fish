function trimlogs --description "Trim logs files that are bigger than a given size"
  set -l logdir ~/workspace/agency_gateway/agency_gateway_api/log
  cd $logdir
  printf "Trimming logs in %s" $logdir
  set -l logsize (du development.log | awk '{print $1}')
  if test $logsize -gt 10000
    tail -n 2000 development.log > development.log.tmp
    # mv development.log.tmp development.log
  end
end

