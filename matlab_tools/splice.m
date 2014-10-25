function [outarr,outelem] = splice(inarr,offset,len,varargin)
%FUNCTION splice
%
%-USE:
%
%Removes the elements designated by offset 'O' and length 'L' from
%a string or cell array and replaces them with the expression 'E'.
%
%
%
%-SYNTAX
%A = splice(S,O,L,E)
%
%S: input string (or cell array)
%   
%O: offset
%
%L: length
%
%E: expression
%
%A: output string (or cell array)
%
%
%If offset 'O' is negative it starts that far from the end of the
%string (array). If offset equals zero the expression 'E' is
%appended to the end of the string (array).
%
%If length 'L' is negative, elements from offset and onwards are
%removed except for -L elements at the end of the string (array).
%If length = [] all elements from offset and onwards are removed.
%
%-INFO
%
%Written by:    Per Gröningsson, Vattenfall Nuclear Fuel AB, 2012-04
%

if nargin < 3,
    error('Not enough input arguments.')
elseif nargin < 4,
    elem = '';
end

if offset == 0,
    offset = length(inarr)+1;
    len = 0;
elseif offset < 0,
    offset = length(inarr)+offset+1;
end

if isempty(len),
    len = length(inarr)-offset+1;
elseif len < 0,
    len = len+length(inarr)-offset+1;
end

outelem = inarr(offset:offset+len-1);

if ischar(inarr),
    elem = cell2mat(varargin);
elseif iscell(inarr),
    elem = varargin;
end
    
if size(inarr,1) > 1
    outarr = [inarr(1:offset-1); elem'; inarr(offset+len:end)];
else
    outarr = [inarr(1:offset-1), elem, inarr(offset+len:end)];
end

