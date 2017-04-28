-module(blog).
-behaviour(supervisor).
-behaviour(application).
-export([init/1, start/2, stop/1]).
-export([vendors/2,vendors/3]).
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

