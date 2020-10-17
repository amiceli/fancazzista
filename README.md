# fancazzista

My perl command line tool for technology news website scrapping.

For now I will get news from : 

- korben.info
- presse-citron.fr
- jster

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

To build project : 

    sh scripts/build.sh

## Config

Example : 

~~~json
{
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

