-module(blog).
-behaviour(supervisor).
-behaviour(application).
-export([init/1, start/2, stop/1]).
-export([vendors/2,vendors/3, dummy/0, data_dummy/0,css/2,js/2]).
-include_lib("nitro/include/nitro.hrl").

start(_,_) -> supervisor:start_link({local,blog }, blog,[]).
stop(_)    -> ok.
init([])   -> sup().
sup()      -> { ok, { { one_for_one, 5, 100 }, [] } }.

vendors(T,L) when is_list(L)-> 
  vendors(T,L,"/static/blog"). 
vendors(T,L,B) when is_list(L),is_list(B)->
   wf:render(
   lists:flatten(
   lists:foldr(fun(X,Acc) ->
                [case T of 
                  js -> [#script{src=B++S}||S<-vendor(X,T),S/=[]];
                  css-> [#meta_link{href=B++S,rel="stylesheet"}||S<-vendor(X,T),S/=[]]
                end|Acc]
               end,[],L))).

vendor(blog,css)           -> ["/css/clean-blog.min.css"];
vendor(blog,js)            -> ["/js/jqBootstrapValidation.js","/js/contact_me.js","/js/clean-blog.min.js"];
vendor(jquery,css)         -> [];
vendor(jquery,js)          -> ["/vendor/jquery/jquery.js"];
vendor(bootstrap3,css)     -> ["/vendor/bootstrap/css/bootstrap.min.css"];
vendor(bootstrap3,js)      -> ["/vendor/bootstrap/js/bootstrap.min.js"];
vendor(fontawesome,css)    -> ["/vendor/font-awesome/css/font-awesome.min.css"];
vendor(fontawesome,js)     -> [].

css(_,_) -> [{blog, [bootstrap3,blog,fontawesome]}].
js(_,_) -> [{blog, [jquery,bootstrap3,blog]}].

dummy() ->
   [
    {page,[{css,vendors(css,[bootstrap3,fontawesome,blog])},
           {js,vendors(js,[bootstrap3,fontawesome,jquery,blog])}
          ]}
   ].

data_dummy() ->
  
  Cfg = [{blog_name, <<"Clean Blog">>},
         {blog_desc, <<"A Clean Blog Theme by Start Bootstrap">>},
         {blog_url,  <<"/">>}],

  lists:map(fun({K,V}) -> 
              C = config:new([{key,K},{value,V}]),
              C:save()
            end,Cfg),

  %%%% categories
  Cats=[[{name, <<"home">>},
         {author_id, 1},
         {title, <<"Clean Blog">>},
         {desc,<<"A Clean Blog Theme by Start Bootstrap">>},
         {media, [{<<"bg">>,<<"/static/blog/img/home-bg.jpg">>}]}],

        [{name, <<"about">>},
         {author_id, 1}],

        [{name, <<"post">>},
         {author_id, 1}],

        [{name, <<"contact">>},
         {author_id, 1}]
       ],

  lists:foreach(fun(X)->
                 C = category:new(X),
                 C:save()
                end,Cats),

 %%%% post
 Articles = [
  [{author_id,1},
   {feed_id,<<"contact">>}, 
   {heading,<<"Contact Me">>},
   {subheading,<<"Have questions? I have answers (maybe).">>},
   {content, <<"Want to get in touch with me? Fill out the form below"
               " to send me a message and I will try to get back "
               "to you within 24 hours!">>},
   {media, [{<<"bg">>,<<"/static/img/about-bg.jpg">>}]},
   {publish_date,{{2014,9,24},{8,0,0}}}],

  [{author_id,1},
   {feed_id,<<"about">>}, 
   {heading,<<"About Me">>}, 
   {subheading,<<"This is what I do.">>},
   {content, text()},
   {media, [{<<"bg">>,<<"/static/img/about-bg.jpg">>}]},
   {publish_date,{{2014,9,24},{8,0,0}}}],

  [{author_id,1},
   {feed_id,<<"post">>}, 
   {heading,<<"Man must explore, and this is exploration at its greatest">>},
   {subheading,<<"Problems look mighty small from 150 miles up">>},
   {content,sample()},
   {media, sample_media()},
   {publish_date,{{2014,9,24},{8,0,0}}}],

  [{author_id,1},
   {feed_id,<<"post">>}, 
   {heading,<<"I believe every human has a finite number of "
              "heartbeats. I don't intend to waste any of mine.">>},
   {subheading,<<"">>},
   {content,sample()},
   {media, sample_media()},
   {publish_date,{{2014,9,18},{8,0,0}}}],

  [{author_id,1},
   {feed_id,<<"post">>}, 
   {heading,<<"Science has not yet mastered prophecy">>},
   {subheading,<<"We predict too much for the next year and "
                 "yet far too little for the next ten.">>},
   {content,sample()},
   {media, sample_media()},
   {publish_date,{{2014,8,24},{8,0,0}}}],

  [{author_id,1},
   {feed_id,<<"post">>}, 
   {heading,<<"Failure is not an option">>},
   {subheading,<<"Many say exploration is part of our destiny, "
                 "but it’s actually our duty to future generations.">>},
   {content,sample()},
   {media, sample_media()},
   {publish_date,{{2014,7,8},{8,0,0}}}]
  ],

  lists:foreach(fun(X) ->
                 Article = article:new(X),
                 Article:save()
                end, Articles).

sample_media() -> 
  [{<<"bg">>, <<"/static/img/about-bg.jpg">>},
   {<<"img1">>,<<"/static/img/post-sample-image.jpg">>}].

sample() ->
<<"Never in all their history have men been able truly to conceive of "
  "the world as one: a single sphere, a globe, having the qualities of a globe,"
  " a round earth in which all the directions eventually meet, in which there is"
  " no center because every point, or none, is center — an equal earth which all"
  " men occupy as equals. The airman's earth, if free men make it, will be truly round:"
  " a globe in practice, not in theory.

Science cuts two ways, of course; its products can be used for both good and evil."
" But there's no turning back from science. The early warnings about technological"
" dangers also come from science.

What was most significant about the lunar voyage was not that man set foot on the Moon"
" but that they set eye on the earth.

A Chinese tale tells of some men sent to harm a young girl who, upon seeing her beauty,"
" become her protectors rather than her violators. That's how I felt seeing the Earth for"
" the first time. I could not help but love and cherish her.

For those who have seen the Earth from space, and for the hundreds and perhaps thousands"
" more who will, the experience most certainly changes your perspective. The things that"
" we share in our world are far more valuable than those which divide us.

## The Final Frontier
There can be no thought of finishing for ‘aiming for the stars.’ Both figuratively and "
"literally, it is a task to occupy the generations. And no matter how much progress one"
" makes, there is always the thrill of just beginning.

There can be no thought of finishing for ‘aiming for the stars.’ Both figuratively and "
"literally, it is a task to occupy the generations. And no matter how much progress one "
"makes, there is always the thrill of just beginning.

<blockquote>The dreams of yesterday are the hopes of today and the reality of tomorrow. "
"Science has not yet mastered prophecy. We predict too much for the next year and yet far "
"too little for the next ten.</blockquote>

Spaceflights cannot be stopped. This is not the work of any one man or even a group of men."
" It is a historical process which mankind is carrying out in accordance with the natural "
"laws of human development.

## Reaching for the Stars
As we got further and further away, it [the Earth] diminished in size. Finally it shrank to"
" the size of a marble, the most beautiful you can imagine. That beautiful, warm, living "
"object looked so fragile, so delicate, that if you touched it with a finger it would crumble"
  " and fall apart. Seeing this has to change a man.

![Yes](/media/post-sample-image.jpg)

Space, the final frontier. These are the voyages of the Starship Enterprise. Its five-year "
"mission: to explore strange new worlds, to seek out new life and new civilizations, to boldly"
" go where no man has gone before.

As I stand out here in the wonders of the unknown at Hadley, I sort of realize there’s a fundamental"
" truth to our nature, Man must explore, and this is exploration at its greatest.

Placeholder text by <a href=\"http://spaceipsum.com/\">Space Ipsum</a>. Photographs by "
"<a href=\"https://www.flickr.com/photos/nasacommons/\">NASA on The Commons</a>.">>.

text() ->[
  <<"Lorem ipsum dolor sit amet, consectetur adipisicing elit. Saepe nostrum ullam eveniet pariatur voluptates odit, fuga atque ea nobis sit soluta odio, adipisci quas excepturi maxime quae totam ducimus consectetur?">>,
  <<"Lorem ipsum dolor sit amet, consectetur adipisicing elit. Eius praesentium recusandae illo eaque architecto error, repellendus iusto reprehenderit, doloribus, minus sunt. Numquam at quae voluptatum in officia voluptas voluptatibus, minus!">>,
  <<"Lorem ipsum dolor sit amet, consectetur adipisicing elit. Nostrum molestiae debitis nobis, quod sapiente qui voluptatum, placeat magni repudiandae accusantium fugit quas labore non rerum possimus, corrupti enim modi! Et.">>
 ].

