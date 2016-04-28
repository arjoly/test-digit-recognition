clear

LIBRARY_DIR = '~/Documents/MATLAB/';
DATA_DIR = '~/Documents/MATLAB/stocha-digit-data/';

% Load single data
% speechs = {};
% ground_truth = []
%
% for class_digit = 0:9
%     class_directory =  sprintf('%s%d', DATA_DIR, class_digit);
%     try
%         new_speechs = load_data(class_directory)
%     catch ME
%         rmpath(genpath([LIBRARY_DIR 'HMMall']));
%         new_speechs = load_data(class_directory);
%     end
%
%     ground_truth = [ground_truth class_digit * ones(1, length(new_speechs))];
%     speechs = [speechs new_speechs];
% end

% Load code data
code_directory = sprintf('%s%s', DATA_DIR, 'codes')
try
    codes_speech = load_data(code_directory)
catch ME
    rmpath(genpath([LIBRARY_DIR 'HMMall']));
    codes_speech = load_data(code_directory);
end

codes_ground_truth = {};
codes_files = dir(sprintf('%s/*.wav', code_directory));
for file_id=1:length(codes_files)
    fname = codes_files(file_id).name;
    out = regexp(fname, '\D*(\d*)\D*.wav', 'tokens');
    code_seq = [];
    for i=1:length(out{1}{1})
        code_seq(i) = str2num(out{1}{1}(i));
    end
    codes_ground_truth{length(codes_ground_truth) + 1} = code_seq;
end





% Load library

addpath(genpath([LIBRARY_DIR 'rastamat']));
addpath(genpath([LIBRARY_DIR 'HMMall']));


% Load some digit sequence
% ------------------------

% Test recognition system
% -----------------------

% code accuracy function taking
% code a random predict function
% code a random predict_code function
