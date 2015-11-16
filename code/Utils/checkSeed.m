function seed = checkSeed(seed)

useSeed = (nargin >= 0 && ~isempty(seed));
if(~useSeed)
    %if a seed is not given, uses the current global seed
    v = version('-release'); %version check because matlab changed the method name for this default random number generator stream
    if(str2double(v(1:4)) >= 2012)
        seed = RandStream.getGlobalStream();
    else
        seed = RandStream.getDefaultStream(); 
    end
    warning('No random seed given. Using default/global seed.');
end
%makes sure the seed is a RandStream object
if(isnumeric(seed))
    seed = RandStream.create('mt19937ar','seed',seed);
    warning('The random seed given is a number instead of a RandStream object - if this function is called again with the same number as seed, it will produce the same stimulus.');
elseif(~isa(seed,'RandStream'))
    error('seed is not a valid RandStream object.');
end