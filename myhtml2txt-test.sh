test_all () {
  if ! which myhtml2txt
  then
    echo "myhtml2txt is not in the PATH. Please add it with \`PATH=\$PATH:<path_to_html2txt_directory>\`"
    exit 1
  fi
  verbose_file=`mktemp -t test_all.XXXX`

  test_count=0
  success_count=0
  failure_count=0
  error_count=0
  for test_file in $(find test -name "*.html")  # $test_file is like test/foo.html
  do
    let test_count++
    test_base=${test_file%.html}                # like test/foo
    test_name=${test_file##*/}                  # like foo
    expected_file=${test_base}.txt              # like test/foo.txt
    if [ ! -f ${expected_file} ]; then
      echo -en "\033[33mE\033[0m"

      let error_count++
      space_out_verbose_file
      echo -e "\033[33mERROR ${error_count}:\033[0m ${test_name}" >> $verbose_file
      echo "    The expected output file, \"${expected_file}\" does not exist." >> $verbose_file
      continue
    fi

    carry_out_test
  done

  echo ""; echo ""

  print_summary

  if [ ! -z $verbose_file ]; then
    echo ""; echo ""
    cat $verbose_file
  fi
  rm "${verbose_file}"
}

print_summary () {
  echo -e "\033[1m${test_count}\033[0m Tests. \033[32m${success_count} Successes.\033[0m \033[31m${failure_count} Failures.\033[0m \033[33m${error_count} Errors.\033[0m"
}

carry_out_test () {
  if diff <(myhtml2txt < ${test_file}) ${expected_file} >/dev/null
  then
    let success_count++
    echo -en "\033[32m.\033[0m"
  else
    let failure_count++
    echo -en "\033[31mF\033[0m"

    space_out_verbose_file
    echo -e "\033[31mFAILURE ${failure_count}:\033[0m ${test_name}" >> $verbose_file
    echo "    The expected output file, \"${expected_file}\" does not match \`./myhtml2txt < ${test_file}\`:" >> $verbose_file
    diff <(./myhtml2txt < ${test_file}) ${expected_file} 2>&1 |sed 's/^/    /' >> $verbose_file
  fi
}

space_out_verbose_file () {
  if [ $(($error_count + $failure_count)) -gt 1 ]; then
    echo "" >> $verbose_file
  fi
}

test_all
