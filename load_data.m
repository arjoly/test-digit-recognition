function speechs = load_data(data_dir, LIBRARY_DIR)
% Load speechs from the data_dir directory

files = dir(sprintf('%s/*.wav', data_dir));
speechs = {};

for file_id=1:length(files)
    % disp(sprintf('Loaded %s', files(file_id).name));
    fname = sprintf('%s/%s', data_dir, files(file_id).name);
    [speech, fs] = audioread(fname);

    if fs ~= 44100
        error(sprintf('Expected signal %s to be in 44100 hz, got %d', ...
                      files(file_id).name, fs));
    end

    if size(speech, 2) == 2
        % We take ony one of the two audio signal
        speechs{length(speechs) + 1} = speech(:, 1);
    else
        % Mono audio signal
        speechs{length(speechs) + 1} = speech;
    end

end

end
