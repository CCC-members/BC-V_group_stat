function  test_vargin(param1, varargin)


for z=1:length(varargin)
    eval([inputname(z+1) '= varargin{z};']);
end



end

