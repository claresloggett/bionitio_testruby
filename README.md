[![travis](https://travis-ci.org/claresloggett/bionitio_testruby.svg?branch=master)](https://travis-ci.org/claresloggett/bionitio_testruby)

# Overview 

This repo is to test bionitio-boot.sh for ruby.

This program reads one or more input FASTA files. For each file it computes a variety of statistics, and then prints a summary of the statistics as output.

# Licence

This program is released as open source software under the terms of [MIT License](https://raw.githubusercontent.com/claresloggett/bionitio_testruby/master/LICENSE).

# Installing

1. Ensure you have ruby installed
2. `gem build bionitio_testruby.gemspec`
3. `gem install --user-install bionitio_testruby`
4. `export PATH=$(ruby -rubygems -e 'puts Gem.user_dir')/bin:$PATH`

Run without installing: `./bin/bionitio_testruby`

# General behaviour

Bionitio_testruby accepts zero or more FASTA filenames on the command line. If zero filenames are specified it reads a single FASTA file from the standard input device (stdin). Otherwise it reads each named FASTA file in the order specified on the command line. Bionitio_testruby reads each input FASTA file, computes various statistics about the contents of the file, and then displays a tab-delimited summary of the statistics as output. Each input file produces at most one output line of statistics. Each line of output is prefixed by the input filename or by the text "`stdin`" if the standard input device was used.

Bionitio_testruby processes each FASTA file one sequence at a time. Therefore the memory usage is proportional to the longest sequence in the file.

An optional command line argument `--minlen` can be supplied. Sequences with length strictly less than the given value will be ignored by bionitio_testruby and do not contribute to the computed statistics. By default `--minlen` is set to zero.

These are the statistics computed by bionitio_testruby, for all sequences with length greater-than-or-equal-to `--minlen`:

* *NUMSEQ*: the number of sequences in the file satisfying the minimum length requirement.
* *TOTAL*: the total length of all the counted sequences.
* *MIN*: the minimum length of the counted sequences.
* *AVERAGE*: the average length of the counted sequences rounded down to an integer.
* *MAX*: the maximum length of the counted sequences.

If there are zero sequences counted in a file, the values of MIN, AVERAGE and MAX cannot be computed. In that case bionitio_testruby will print a dash (`-`) in the place of the numerical value. Note that when `--minlen` is set to a value greater than zero it is possible that an input FASTA file does not contain any sequences with length greater-than-or-equal-to the specified value. If this situation arises bionitio_testruby acts in the same way as if there are no sequences in the file.

# Usage 

In the examples below, `%` indicates the command line prompt.

## Help message

Bionitio_testruby can display usage information on the command line via the `-h` or `--help` argument:

```
% bionitio_testruby -h
usage: bionitio_testruby [-h] [--minlen N] [--version] [--log LOG_FILE]
                  [FASTA_FILE [FASTA_FILE ...]]

Print fasta stats

positional arguments:
  FASTA_FILE      Input FASTA files

optional arguments:
  -h, --help      show this help message and exit
  --minlen N      Minimum length sequence to include in stats (default 0)
  --version       show program's version number and exit
  --log LOG_FILE  record program progress in LOG_FILE
```

## Reading FASTA files named on the command line

Bionitio_testruby accepts zero or more named FASTA files on the command line. These must be specified following all other command line arguments. If zero files are named, bionitio_testruby will read a single FASTA file from the standard input device (stdin).

There are no restrictions on the name of the FASTA files. Often FASTA filenames end in `.fa` or `.fasta`, but that is merely a convention, which is not enforced by bionitio_testruby. 

The example below illustrates bionitio_testruby applied to a single named FASTA file called `file1.fa`:
```
% bionitio_testruby file1.fa
FILENAME	NUMSEQ	TOTAL	MIN	AVG	MAX
file1.fa	5264	3801855	31	722	53540
```

The example below illustrates bionitio_testruby applied to three named FASTA files called `file1.fa`, `file2.fa` and `file3.fa`:
```
% bionitio_testruby file1.fa file2.fa file3.fa
FILENAME	NUMSEQ	TOTAL	MIN	AVG	MAX
file1.fa	5264	3801855	31	722	53540
file2.fa	5264	3801855	31	722	53540
file3.fa	5264	3801855	31	722	53540
```

## Reading a single FASTA file from standard input 

The example below illustrates bionitio_testruby reading a FASTA file from standard input. In this example we have redirected the contents of a file called `file1.fa` into the standard input using the shell redirection operator `<`:

```
% bionitio_testruby < file1.fa
FILENAME	NUMSEQ	TOTAL	MIN	AVG	MAX
stdin	5264	3801855	31	722	53540
```

Equivalently, you could achieve the same result by piping a FASTA file into bionitio_testruby:

```
% cat file1.fa | bionitio_testruby
FILENAME	NUMSEQ	TOTAL	MIN	AVG	MAX
stdin	5264	3801855	31	722	53540
```

## Filtering sequences by length 

Bionitio_testruby provides an optional command line argument `--minlen` which causes it to ignore (not count) any sequences in the input FASTA files with length strictly less than the supplied value. 

The example below illustrates bionitio_testruby applied to a single FASTA file called `file`.fa` with a `--minlen` filter of `1000`.
```
% bionitio_testruby --minlen 1000 file.fa
FILENAME	NUMSEQ	TOTAL	MIN	AVG	MAX
file1.fa	4711	2801855	1021	929	53540
```

## Logging

If the ``--log FILE`` command line argument is specified, bionitio_testruby will output a log file containing information about program progress. The log file includes the command line used to execute the program, and a note indicating which files have been processes so far. Events in the log file are annotated with their date and time of occurrence. 

```
% bionitio_testruby --log bt.log file1.fasta file2.fasta 
# normal bionitio_testruby output appears here
# contents of log file displayed below
```
```
% cat bt.log
12/04/2016 19:14:47 program started
12/04/2016 19:14:47 command line: /usr/local/bin/bionitio_testruby.rb --log bt.log file1.fasta file2.fasta
12/04/2016 19:14:47 Processing FASTA file from file1.fasta
12/04/2016 19:14:47 Processing FASTA file from file2.fasta
```


## Empty files

It is possible that the input FASTA file contains zero sequences, or, when the `--minlen` command line argument is used, it is possible that the file contains no sequences of length greater-than-or-equal-to the supplied value. In both of those cases bionitio_testruby will not be able to compute minimum, maximum or average sequence lengths, and instead it shows output in the following way:

The example below illustrates bionitio_testruby applied to a single FASTA file called `empty.fa` which contains zero sequences:
```
% bionitio_testruby empty.fa
FILENAME	NUMSEQ	TOTAL	MIN	AVG	MAX
empty.fa	0	0	-	-	-
```

# Exit status values

Bionitio_testruby returns the following exit status values:

* 0: The program completed successfully.
* 1: File I/O error. This can occur if at least one of the input FASTA files cannot be opened for reading. This can occur because the file does not exist at the specified path, or bionitio_testruby does not have permission to read from the file. 
* 2: A command line error occurred. This can happen if the user specifies an incorrect command line argument. In this circumstance bionitio_testruby will also print a usage message to the standard error device (stderr).
* 3: Input FASTA file is invalid. This can occur if bionitio_testruby can read an input file but the file format is invalid. 


# Error handling

## Invalid input FASTA files

## Incorrect command line arguments

## Memory limits and other resource restrictions

# Testing

## Unit tests

```
ruby test/test_bionitio_testruby.rb
```

## Test suite

A set of sample test input files is provided in the `test_data` folder.
```
% bionitio_testruby two_sequence.fasta
FILENAME        TOTAL   NUMSEQ  MIN     AVG     MAX
two_sequence.fasta      2       357     120     178     237
```

# Bug reporting and feature requests

Please submit bug reports and feature requests to the issue tracker on GitHub:

[bionitio_testruby issue tracker](https://github.com/claresloggett/bionitio_testruby/issues)
