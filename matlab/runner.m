function runner()
% runner - Executes experiments on matrices sorted by size and saves results
%
% This function scans the matrices folder, sorts the matrix files by size,
% runs the experiment on each matrix, and saves the results to a CSV file
% in the runs folder.
%
% No inputs.
% No outputs.

    addpath(fullfile(pwd, 'utils'));
    osName = system_info();

    matrixFolder = 'matrices';
    resultsFolder = 'runs';

    if ~exist(resultsFolder, 'dir')
        mkdir(resultsFolder);
    end

    timestamp = datestr(now, 'yyyy-mm-dd_HHMMSS');
    csvFileName = sprintf('%s_matlab_%s.csv', osName, timestamp);
    outputCSV = fullfile(resultsFolder, csvFileName);

    matFiles = dir(fullfile(matrixFolder, '*.mat'));
    fprintf('Found %d matrix files.\n', length(matFiles));

    fileList = fullfile(matrixFolder, {matFiles.name});

    % Sort matrix files by size
    sortedFiles = matrix_sort(fileList);

    results = repmat(struct(), length(sortedFiles), 1);  % Temporary prealloc

    for k = 1:length(sortedFiles)
        matPath = sortedFiles{k};
        fprintf('Processing %s...\n', matPath);
    
        if usejava('jvm')
            java.lang.System.gc();
        end
    
        result = run_experiment(matPath);
    
        if k == 1
            % Initialize struct array with the same fields as the first result
            results = repmat(result, length(sortedFiles), 1);
        end
    
        results(k) = result;
    end

    fprintf('All experiments completed.\n');

    resultsTable = struct2table(results);
    writetable(resultsTable, outputCSV);
    fprintf('Results saved to %s\n', outputCSV);
end
