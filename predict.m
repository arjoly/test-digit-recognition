function [out outlier] = predict(speechs)
% Predict the digits associated to each cell element of speech.
%
% Parameters
% ----------
% speechs : cell array of arrays of float/double
%       Each element of speechs contains the audio signal associated to a digit
%       as obtained by the audioread function.
%
% Returns
% -------
% out : array of int
%       The predicted digits associated to an element of speechs.
%
% outlier : array of bool
%       True elements of the array indicate the presences of an outlier
%       for the associated speech signal.

% Here, we do nothing clever

out = ones(size(speechs));
outlier = zeros(size(speechs));

end
