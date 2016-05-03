clear

LIBRARY_DIR = '~/Documents/MATLAB/';
DATA_DIR = '~/Dropbox/thesis/teaching_assistant/stochastique/2015-2016-eng-private/sons-stocha/';

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

% Load outlier data
outlier_directory = sprintf('%s%s', DATA_DIR, 'outliers');

try
    outlier_speechs = load_data(outlier_directory);
catch ME
    rmpath(genpath([LIBRARY_DIR 'HMMall']));
    outlier_speechs = load_data(outlier_directory);
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
code_files = dir(sprintf('%s/code*', code_directory));

for file_id=1:length(code_files)
    fname = code_files(file_id).name;
    out = regexp(fname, '\D*(\d*)\D*.[wav|m4a]', 'tokens');
    code_seq = [];
    for i=1:length(out{1}{1})
        code_seq = [code_seq str2num(out{1}{1}(i))];
    end
    code_ground_truth{length(code_ground_truth) + 1} = code_seq;
end

if length(code_ground_truth) ~= length(code_speechs)
    length(code_ground_truth)
    length(code_speechs)
    error('expected same number of ground truth and code speechs');
end

% Load library

addpath(genpath([LIBRARY_DIR 'rastamat']));
addpath(genpath([LIBRARY_DIR 'HMMall']));
addpath(genpath(['.']));

try
    % Test recognition system on single digits with no outlier
    [pred outlier] = predict(speechs);
    acc_simple = mean(pred(:) == ground_truth(:));
    acc_noreject_digit = mean(1 - outlier(:));

    % Test recognition system on outliers
    [out outlier] = predict(outlier_speechs);
    outlier_acc = mean(outlier);
catch

    % predict has only pred
    pred = predict(speechs);
    acc_simple = mean(pred(:) == ground_truth(:));
    acc_noreject_digit = nan;
    outlier_acc = nan;
end

% Test recognition system on single digits
code_out = predict_code(code_speechs);

acc_code = 0;
hamming_score_code = 0;
ed_code = 0
for i = 1:length(code_speechs)
    if length(code_ground_truth{i}) == length(code_out{i})
        n_errors = sum(code_ground_truth{i}(:) ~= code_out{i}(:));
        if n_errors == 0
            acc_code = acc_code + 1;
        end
        hamming_word = (length(code_ground_truth{i}) - n_errors) / length(code_ground_truth{i});
        hamming_score_code = hamming_score_code + hamming_word;
    end
    ed_code = ed_code + edit_distance_levenshtein(code_ground_truth{i}, code_out{i});
end
acc_code = acc_code / length(code_speechs);
hamming_score_code = hamming_score_code / length(code_speechs);
ed_code = ed_code / length(code_speechs);

% Display results
disp(sprintf('Accuracy on single digits ........ %f',  acc_simple))
disp(sprintf('Accuracy on digits rejectection .. %f',  acc_noreject_digit))
disp(sprintf('Accuracy on outliers detection ... %f',  outlier_acc))
disp(sprintf('Edit distance on code ............ %f', hamming_score_code))
disp(sprintf('Accuracy on codes ................ %f',  acc_code))
disp(sprintf('Hamming score on code ............ %f', hamming_score_code))

rmpath(genpath(['.']));
