function ostop
  echo -n 'Stopping Docker Oracle container...'
  docker ps | ag oracle | awk '{print $1}' | xargs docker stop > /dev/null
  echo 'done.'
end

