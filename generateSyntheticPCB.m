function img = generateSyntheticPCB(imgSize, padGrid, padRadius, defectCoords)
% generateSyntheticPCB Creates a synthetic thermal PCB image
%   img = generateSyntheticPCB(imgSize, padGrid, padRadius, defectCoords)
%   - imgSize: scalar (e.g. 256)
%   - padGrid: [rows, cols]
%   - padRadius: radius of each pad
%   - defectCoords: Nx2 matrix of [row, col] positions of defective pads

    img = zeros(imgSize, imgSize);
    rows = padGrid(1);
    cols = padGrid(2);
    rowStep = imgSize / (rows + 1);
    colStep = imgSize / (cols + 1);

    for i = 1:rows
        for j = 1:cols
            centerY = round(i * rowStep);
            centerX = round(j * colStep);
            isDefect = any(ismember(defectCoords, [i, j], 'rows'));
            value = 255 * isDefect + 180 * (~isDefect);  % Brighter if defective
            [X, Y] = meshgrid(1:imgSize, 1:imgSize);
            mask = sqrt((X - centerX).^2 + (Y - centerY).^2) <= padRadius;
            img(mask) = value;
        end
    end

    % Add Gaussian noise
    noise = uint8(randn(imgSize, imgSize) * 5);
    img = uint8(img) + noise;
end