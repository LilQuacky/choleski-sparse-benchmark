function result = run_experiment(matFile)
% run_matrix - Executes Cholesky factorization experiment on a matrix file
%
% INPUT:
%   matFile - path to the .mat file containing the matrix (string)
%
% OUTPUT:
%   result - struct containing timing, memory, and error metrics

    fprintf('--- Starting experiment on file: %s ---\n', matFile);

    osName = system_info();

    [~, name, ext] = fileparts(matFile);  % Extract just file name + extension

    result = struct( ...
        'os', osName, ...
        'timestamp', string(datetime('now','Format','yyyy-MM-dd HH:mm:ss')), ...
        'matrixName', string([name ext]), ...
        'rows', NaN, 'cols', NaN, 'nonZeros', NaN, ...
        'loadTime', NaN, 'loadMem', NaN, ...
        'decompTime', NaN, 'decompMem', NaN, ...
        'solveTime', NaN, 'solveMem', NaN, ...
        'relativeError', NaN, ...
        'exception', "");

    try
        % --- Loading profiling ---
        profile clear;
        profile -memory on;
        t1 = tic;
        S = load(matFile);
        loadTime = toc(t1);
        p = profile('info');
        loadMem = profile_memory(p);
        profile off;

        if isfield(S, 'Problem') && isfield(S.Problem, 'A')
            A = S.Problem.A;
            if ~issparse(A)
                A = sparse(A);
            end
            A = double(A);
        else
            error('Matrix A not found in .mat file.');
        end

        [m, n] = size(A);
        if m ~= n
            error('Matrix is not square.');
        end

        fprintf('Matrix size: %d x %d with %d non-zeros\n', m, n, nnz(A));

        result.rows = m;
        result.cols = n;
        result.nonZeros = nnz(A);
        result.loadTime = loadTime;
        result.loadMem = loadMem;

        % --- Cholesky decomposition profiling ---
        profile clear;
        profile -memory on;
        t2 = tic;
        [R, flag, perm] = chol(A, 'vector');
        decompTime = toc(t2);
        p = profile('info');
        decompMem = profile_memory(p);
        profile off;

        if flag ~= 0
            error('Cholesky failed: matrix is not symmetric positive definite.');
        end

        % --- Solve system profiling ---
        xe = ones(n, 1);
        b = A * xe;

        profile clear;
        profile -memory on;
        t3 = tic;
        bp = b(perm);
        y = R' \ bp;
        xp = R \ y;
        x = zeros(n, 1);
        x(perm) = xp;
        solveTime = toc(t3);
        p = profile('info');
        solveMem = profile_memory(p);
        profile off;

        result.decompTime = decompTime;
        result.decompMem = decompMem;
        result.solveTime = solveTime;
        result.solveMem = solveMem;
        result.relativeError = norm(x - xe) / norm(xe);
        result.exception = "";

        fprintf('Experiment completed successfully.\n');

    catch ME
        fprintf('Exception caught: %s\n', ME.message);
        result.exception = ME.message;
    end
end
