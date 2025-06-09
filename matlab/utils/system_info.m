function osName = system_info()
% system_info - Detects the operating system
%
% OUTPUT:
%   osName - Operating system name as a string

    if ispc
        osName = "windows";
    elseif ismac
        osName = "macOS";
    elseif isunix
        osName = "linux";
    else
        osName = "unknownOS";
    end
end
