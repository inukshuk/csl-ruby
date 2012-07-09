CSL-Ruby
========
CSL-Ruby is a Ruby parser and library for the Citation Style Language (CSL),
an XML-based format to describe the formatting of citations, notes and
bibliographies.

[![Build Status](https://secure.travis-ci.org/berkmancenter/csl-ruby.png?branch=master)](http://travis-ci.org/berkmancenter/csl-ruby)

Development
-----------
The CSL-Ruby source code is [hosted on GitHub](https://github.com/berkmancenter/csl-ruby).
You can check out a copy of the latest code using Git:

    $ git clone https://github.com/berkmancenter/csl-ruby.git
    
To get started, install the development dependencies, fetch the latest CSL
styles and locales, and run all tests:

    $ cd csl-ruby
    $ git submodule init
    $ git submodule update
    $ bundle install
    $ rake

If you've found a bug or have a question, please open an issue on the
[issue tracker](https://github.com/berkmancenter/csl-ruby/issues).
Or, for extra credit, clone the CSL-Ruby repository, write a failing
example, fix the bug and submit a pull request.


Copyright
---------
Copyright 2012 President and Fellows of Harvard College.

Copyright 2009-2012 Sylvester Keil. All rights reserved.

License
-------
CiteProc is dual licensed under the AGPL and the FreeBSD license.
