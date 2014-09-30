function  abs_path = absolutepath( path, base )
%ABSOLUTEPATH  returns the absolute path relative to a given startpath (base).
%   The startpath is optional, if omitted the current dir is used instead.
%   Both argument must be strings.
%
%   Syntax:
%      abs_path = ABSOLUTEPATH( path, base )
%   
%   Parameters:
%      path               - Relative path
%      base               - Start for relative path  (optional, default = current dir)
%
%   Examples:
%      absolutepath('./data/matlab'        , '/local' ) = '/local/data/matlab'
%      absolutepath('/MyProject/'          , '/local/') = '/MyProject/'
%
%      absolutepath('./data/matlab'        , cd         ) is the same as
%      absolutepath('./data/matlab'                     )
%
%   Uses the function 'join'
%
%   Info:
%   Written by:    Per Gröningsson, Vattenfall Nuclear Fuel AB, 2013-01

% Check if first input parameter is an absolute path
if isequal(path(1),'/')
    abs_path = path;
    if nargin > 1
        warning('Given path is absolute');
    end
    return;
end

% 2nd parameter is optional:
if  nargin < 2
   base = pwd;
end

% Make sure strings end by a filesep character:
if  length(base) == 0 | ~isequal(base(end),filesep)
    base = [base filesep];
end
if  length(path) == 0 | ~isequal(path(end),filesep)
    path = [path filesep];
end

% Take out file parts:
base = fileparts(base);
path = fileparts(path);

% Create a cell-array containing the directory levels:
base_cell = regexp(base,filesep,'split');
path_cell = regexp(path,filesep,'split');

% Combine both paths level by level:
abs_path_cell = base_cell;
try
    while length(path_cell) > 0
        if isequal(path_cell{1}, '.')
            path_cell(1) = [];
        elseif isequal(path_cell{1}, '..')
            abs_path_cell(end) = [];
            path_cell(1) = [];
        else
            abs_path_cell{end+1} = path_cell{1};
            path_cell(1) = [];
        end
    end
    abs_path = join(abs_path_cell,filesep);
catch err
    if isequal(err.identifier,'MATLAB:badsubscript')
        error('Relative path exceeded base path');
    else
        error(err.message);
    end
end
