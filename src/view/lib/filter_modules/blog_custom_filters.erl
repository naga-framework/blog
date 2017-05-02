-module(blog_custom_filters).
-compile(export_all).

dateformat({{_,_,_},_}=T) ->  erlydtl_dateformat:format(T,"E d, Y").

