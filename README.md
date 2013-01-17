CSL-Ruby
========
CSL-Ruby is a Ruby parser and library for the Citation Style Language (CSL),
an XML-based format to describe the formatting of citations, notes and
bibliographies.

[![Build Status](https://secure.travis-ci.org/inukshuk/csl-ruby.png?branch=master)](http://travis-ci.org/inukshuk/csl-ruby)

Styles and Locales
------------------
You can load CSL styles and locales by passing a respective XML string, file
name, or URL. You can also load styles and locales by name if the
corresponding files are installed in your local styles and locale directories.
By default, CSL-Ruby looks for CSL styles and locale files in

    /usr/local/share/csl/styles
    /usr/local/share/csl/locales

You can change these locations by changing the value of `CSL::Style.root` and
`CSL::Locale.root` respectively.

Alternatively, you can `gem install csl-styles` to install all official CSL
styles and locales.

Development
-----------
The CSL-Ruby source code is [hosted on GitHub](https://github.com/inukshuk/csl-ruby).
You can check out a copy of the latest code using Git:

    $ git clone https://github.com/inukshuk/csl-ruby.git
    
To get started, install the development dependencies and run all tests:

    $ cd csl-ruby
    $ bundle install
    $ rake

If you've found a bug or have a question, please open an issue on the
[issue tracker](https://github.com/inukshuk/csl-ruby/issues).
Or, for extra credit, clone the CSL-Ruby repository, write a failing
example, fix the bug and submit a pull request.


Copyright
---------
Copyright 2012 President and Fellows of Harvard College.

Copyright 2009-2013 Sylvester Keil. All rights reserved.

License
-------
CiteProc is dual licensed under the AGPL and the FreeBSD license.
