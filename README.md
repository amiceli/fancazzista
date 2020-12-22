# fancazzista

My perl command line tool for technology news website scrapping.

## Install tools

First you need to install [carton](https://metacpan.org/pod/Carton) : 

    cpanm Carton

After your to install [pp](https://metacpan.org/pod/pp) : 

    cpan install PAR::Packer

## Development

Install dependencies : 

    carton install

To run project : 

    carton exec -- perl index.pl --config=scrap.json

It's better with less : 

    carton exec -- perl index.pl --config=scrap.json | less

Or with markdown : 

    carton exec -- perl index.pl --config=scrap.json --markodw > index.md

Or with HTML : 

    carton exec -- perl index.pl --config=scrap.json --html > index.html

I use halfmoon css framework, dark mode is currently enabled by default.

To build project : 

    sh scripts/build.sh

## Config

Example : 

~~~json
{
    "subreddits" : [
        {
            "name" : "javascript",
            "limit" : 5
        },
        {
            "name" : "php",
            "limit" : 5
        }
    ],
    "websites" : [
        {
            "name" : "Korben",
            "url" : "https://korben.info",
            "selector" : ".status-publish  .entry-title",
            "linkSelector" : "a",
            "textSelector" : "a"
        },
        {
            "name" : "presse-citron",
            "url" : "https://presse-citron.net",
            "selector" : ".mvp-blog-story-wrap",
            "linkSelector" : "a",
            "textSelector" : "h2"
        },
        {
            "name" : "jster",
            "url" : "http://jster.net/",
            "selector" : ".entry",
            "linkSelector" : "a",
            "textSelector" : ".title"
        }
    ]
}
~~~

## How I use it

I created a CRON every morning, using fancazzista to generate a markdown file.
I tranform [markdown to HTML](https://github.com/mixu/markdown-styles) and serve it with nginx.

Fresh news every day !!

## Fancazzista::Scrap

For scrap website and reddit posts I use a module I made [Fancazzista::Scrap](https://github.com/amiceli/Fancazzista-Scrap). Currently it isn't publish on CPAN, I waiting my account.

But you install it, see instructions in [Fancazzista::Scrap](https://github.com/amiceli/Fancazzista-Scrap) README.

## TODO

- [ ] Add unit tests.
- [ ] Add Fancazzista::Scrap in cpanfile when it will be published.