function vector = thirdDimToVector( array, x, y )
% return value is the vector of the array at position (x,y)

[~,~,z] = size(array);
vector = zeros(1,z);
for k = 1:z
    vector(k) = array(x,y,k);
end

end

