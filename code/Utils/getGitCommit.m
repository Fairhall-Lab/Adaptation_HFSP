function [commit] = getGitCommit()

[a,commit] = system('git rev-parse HEAD');

if(a ~= 0)
    error('Could not retrieve git commit revision hash.');
end