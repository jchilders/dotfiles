function lint
  printf 'linting...\n'
  set -l chgd_files (git diff HEAD --name-only)
  for file in $chgd_files
    # reek begin
    set -l reek_results (reek --config config.reek --format json $file) 1>/dev/null 2>&1
    for ctx in (echo $reek_results | jq -c -M '.[]')
      set -e line_nums
      set -l lint_type (echo $ctx | jq -c -M '.smell_type' | tr -d '"')

      set -l lines (echo $ctx | jq -c -M '.lines')
      for line_num in (echo $lines | tr -d '[]' | string split ',')
        set -a line_nums $line_num
      end

      for line_num in $line_nums
        printf '\treek: %s in %s:%d\n' $lint_type $file $line_num
        read --prompt-str '(e)dit, (s)kip, (q)uit? ' --local action

        switch $action
          case q
            return 0
          case s
            continue
          case e
            __edit_in_vim $file $line_num $lint_type
            return 0
        end
      end

      set -e reek_results
    end

    # rubocop begin
    set -l rubocop_results (rubocop --format json $file)
    for ctx in (echo $rubocop_results | jq -c -M '.files[0].offenses[]')
      set -l lint_type (echo $ctx | jq -c -M '.cop_name' | tr -d '"')
      set -l line_num (echo $ctx | jq -c -M '.location.line')

      printf 'rubocop: %s in %s:%d\n' $lint_type $file $line_num
      read --prompt-str '(e)dit, (s)kip, (q)uit? ' --local action
      switch $action
        case q
          return 0
        case s
          continue
        case e
          __edit_in_vim $file $line_num $lint_type
          return 0
        case '*'
          echo 'here we are'
      end
    end
  end
end

function __edit_in_vim -a file -a line_num -a lint_type
  tmux send-keys -t right Escape C-w j
  tmux send-keys -t right Escape :e ' ' $file Enter
  tmux send-keys -t right : $line_num Enter
  tmux send-keys -t right :echo '\'rubocop: ' $lint_type '\'' Enter
  tmux select-pane -t right
end
