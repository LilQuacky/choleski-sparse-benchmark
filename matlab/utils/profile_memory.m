function memUsedMB = profile_memory(profileInfo)
% profile_memory - Calculates memory usage in MB from profile info
%
% INPUT:
%   profileInfo - Output structure from MATLAB profiler (profile('info'))
%
% OUTPUT:
%   memUsedMB - Memory used in megabytes

    memAllocated = 0;
    memFreed = 0;
    for i = 1:length(profileInfo.FunctionTable)
        memAllocated = memAllocated + profileInfo.FunctionTable(i).TotalMemAllocated;
        memFreed = memFreed + profileInfo.FunctionTable(i).TotalMemFreed;
    end
    memUsedMB = max(0, (memAllocated - memFreed) / 1e6);
end
