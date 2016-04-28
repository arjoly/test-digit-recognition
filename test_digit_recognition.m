clear

LIBRARY_DIR = '~/Documents/MATLAB/';
DATA_DIR = '~/Documents/MATLAB/stocha-digit-data/';

% Load single data
speechs = {};
ground_truth = [];

for class_digit = 0:9
    class_directory =  sprintf('%s%d', DATA_DIR, class_digit);
    try
        new_speechs = load_data(class_directory);
    catch ME
        rmpath(genpath([LIBRARY_DIR 'HMMall']));
        new_speechs = load_data(class_directory);
    end

    ground_truth = [ground_truth class_digit * ones(1, length(new_speechs))];
    speechs = [speechs new_speechs];
end

% Load code data
code_directory = sprintf('%s%s', DATA_DIR, 'codes');
try
    code_speechs = load_data(code_directory);
catch ME
    rmpath(genpath([LIBRARY_DIR 'HMMall']));
    code_speechs = load_data(code_directory);
end

code_ground_truth = {};
code_files = dir(sprintf('%s/*.wav', code_directory));
for file_id=1:length(code_files)
    fname = code_files(file_id).name;
    out = regexp(fname, '\D*(\d*)\D*.wav', 'tokens');
    code_seq = [];
    for i=1:length(out{1}{1})
        code_seq(i) = str2num(out{1}{1}(i));
    end
    code_ground_truth{length(code_ground_truth) + 1} = code_seq;
end

% Load library

addpath(genpath([LIBRARY_DIR 'rastamat']));
addpath(genpath([LIBRARY_DIR 'HMMall']));

% Test recognition system on single digits with no outlier
[out outlier] = predict(speechs);
acc = mean((1 - outlier) .* (out == ground_truth));

% Test recognition system on single digits
code_out = predict_code(code_speechs);

acc_code = 0;
for i = 1:length(code_speechs)
    if length(code_ground_truth{i}) == length(code_out{i})
        n_errors = sum(code_ground_truth{i} ~= code_out{i});
        if n_errors == 0
            acc_code = acc_code + 1;
        end
    end
end
acc_code = acc_code / length(code_speechs);

% Display results
disp(sprintf('Accuracy on single digits %d',  acc))
disp(sprintf('Accuracy on codes sequence %d %', acc_code))
