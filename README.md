# Slack Scratcher

[![Build Status][travis_image]][travis_link]

[travis_image]: https://travis-ci.org/freeatnet/slack_scratcher.svg?branch=master
[travis_link]: https://travis-ci.org/freeatnet/slack_scratcher

## Installation

use gem command,

```
$ gem install slack_scratcher
```

or use bundle directive in Gemfile.

```
gem 'slack_scratcher'
```

## Usage

Export dir to Elasticsearch.

```
require 'slack_scratcher'
hosts = ['http://192.168.59.103:9200']

adapter = SlackScratcher::Adapter::Elasticsearch.new(hosts, index: 'slack', type: 'logs')
loader = SlackScratcher::Loader::File.new('./tmp/infovis-2015-03-06/')
router = SlackScratcher::Router.new(loader, adapter)

route.route
```

## Contributors

* Daekwon Kim (nacyot)
* Arseniy Ivanov (freeatnet)

## LICENSE

The MIT License (MIT)

Copyright (c) 2015 Daekwon Kim, Arseniy Ivanov

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
