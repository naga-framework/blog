-module(blog_custom_filters).
-compile(export_all).

dateformat({{_,_,_},_}=T) ->  erlydtl_dateformat:format(T,"E d, Y").

background(Media) ->
   case proplists:get_value(<<"bg">>,Media,[]) of 
    [] -> [];
    U  -> <<"background-image: url('",U/binary,"');">> end.
