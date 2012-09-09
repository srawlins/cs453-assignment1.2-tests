Intro
=====

This repository is where I am keeping tests for assignment 1 for CS 453. There is also a test harness. To get started, just clone this repo:

    git clone https://github.com/srawlins/cs453-assignment1.2-tests

Then add your `myhtml2txt` to your `$PATH`, and run `go-test-now.sh`. Alternatively, you can pass in the desired program to test as the first argument to `go-test-now.sh`.

How it Works
============

The test harness works as follows: `myhtml2txt` must be in your `$PATH` (or must be passed in as the first argument), so that it can be executed against the test files. Inside this repository is a `testcases` directory, with three groups of files inside: (1) a group of `.html` files which will each serve as input, (2) a group of `.txt` files which each contain the expected standard output of running `myhtml2txt` against the respective input file, and (3) a group of `.error_lines` files which will each serve as a newline-separated list of line numbers that your program should print to standard out, upon error. For example, `html_entities.html` is an example input file, and `html_entities.txt` is the sibling expected output file, and `html_entities.error_lines` is the list of lines with errors.

As `myhtml2txt` is run against each input file, the output is compared to the respective expected output file. If the outputs match, you get a fun, green dot. If not, you get a big red F, and a diff at the end, comparing the expected and real output.

Feel free to add your own input and expected output files, and they will be automatically run by the harness.

Error Line Numbers
==================

How were line `tests/\*.error_lines` files generated? I took Debray's reference implementation and scraped the stderr for numbers:

```
../html2txt-2/myhtml2txt < tests/foo.html 2>&1 >/dev/null |sed 's/^\([0-9]\+\).*/\1/;s/.*[^0-9]\([0-9]\+\).*/\1/' > tests/foo.error_lines
```

Contributing
============

To contribute a test back to this repository, make sure to generate the expected output file by running the input file through Debray's provided `myhtml2txt`, and send me a pull request. I have a recording of adding a new test [here](http://ascii.io/a/1054).

To contribute to the harness, make sure to test whatever first.
