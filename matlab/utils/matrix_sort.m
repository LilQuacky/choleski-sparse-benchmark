function sortedFiles = matrix_sort(fileList)
% matrix_sort - Sorts .mat files by the number of non-zero elements in Problem.A
%
% INPUT:
%   fileList - Cell array of file paths (strings)
%
% OUTPUT:
%   sortedFiles - Cell array sorted by increasing number of non-zero entries in Problem.A

    n = numel(fileList);
    nnzCounts = zeros(n, 1);

    for i = 1:n
        try
            S = load(fileList{i});
            if isfield(S, 'Problem') && isfield(S.Problem, 'A')
                A = S.Problem.A;
                if ~issparse(A)
                    A = sparse(A);
                end
                A = double(A);
                nnzCounts(i) = nnz(A);
            else
                error('Matrix A not found in file %s.', fileList{i});
            end
        catch ME
            warning('Error reading %s: %s', fileList{i}, ME.message);
            nnzCounts(i) = inf;  % Mette in fondo i file problematici
        end
    end

    [~, idx] = sort(nnzCounts, 'ascend');
    sortedFiles = fileList(idx);
end
