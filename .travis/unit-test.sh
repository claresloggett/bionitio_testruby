#!/bin/bash

set -e
errors=0

# Run unit tests
ruby test/test_bionitio_testruby.rb || {
    echo "'test/test_bionitio_testruby.rb' failed"
    let errors+=1
}

[ "$errors" -gt 0 ] && {
    echo "There were $errors errors found"
    exit 1
}

echo "Ok : Ruby specific tests"
