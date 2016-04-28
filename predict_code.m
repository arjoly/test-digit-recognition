function out = predict_code(speechs)
% Predict the digit sequence associated to each cell element of speech.
%
% Parameters
% ----------
% speechs : cell of arrays of float/double
%       Each element of speechs contains the audio signal associated to a sequence of digits
%       as obtained by the audioread function.
%
% Returns
% -------
% out : cell array of arrays of int
%       The predicted digit sequence associated to an element of speechs.
%

% Here, we do nothing clever

out = {};
for i=1:length(speechs)
    out{i} = [1, 9, 7, 5];
end

end
