function runPCBAnalysis(numBoards)
% runPCBAnalysis generates PCB thermal images, detects defects, 
% compiles a report PDF, and cleans up intermediate files.

import mlreportgen.dom.*

% === Step 1: Setup ===
if nargin < 1 %number of argument inputs < 1
    numBoards = 10; % Default number of PCBs
end

% Cleanup any previous files
delete pcb_defect_*.png
delete pcb_result_*.png
delete pcb_result_*.csv
delete pcb_result_*.txt

% Generate synthetic images
generateMultiplePCBs(numBoards);  % <-- Ensure this accepts numBoards

% Create PDF report
timestamp = datetime("now", "Format", "yyyyMMdd_HHmmss");
reportName = 'PCB_Hotspot_Report_' + string(timestamp) + '.pdf';
d = Document(reportName, 'pdf');
append(d, Paragraph('PCB Hotspot Detection Report'));
append(d, Paragraph(['Generated on: ' char(datetime("now"))]));
append(d, PageBreak);

threshold = 0.8;

for i = 1:numBoards
    % Load image
    filename = sprintf('pcb_defect_%02d.png', i);
    img = imread(filename);

    % Preprocess
    gray = mat2gray(img);
    blurred = imgaussfilt(gray, 2);
    hotMask = blurred > threshold;
    hotMask = bwareaopen(hotMask, 10);

    % Analyze regions
    stats = regionprops(logical(hotMask), 'Centroid', 'Area');

    % Display and save figure
    fig = figure('Visible', 'off');
    imshow(gray, []);
    colormap('hot'); hold on;
    
    for j = 1:length(stats)
        c = stats(j).Centroid;
        plot(c(1), c(2), 'go', 'MarkerSize', 10);
    end
    
    title(sprintf('Detected Hotspots - PCB %02d', i));
    figFilename = sprintf('pcb_result_%02d.png', i);
    saveas(fig, figFilename);
    close(fig);

    % Save data
    centroids = reshape([stats.Centroid], 2, []).';
    areas = [stats.Area].';
    resultsTable = table(centroids(:,1), centroids(:,2), areas, ...
        'VariableNames', {'X_Centroid', 'Y_Centroid', 'Area'});
    csvFilename = sprintf('pcb_result_%02d_data.csv', i);
    writetable(resultsTable, csvFilename);

    txtFilename = sprintf('pcb_result_%02d_summary.txt', i);
    fileID = fopen(txtFilename, 'w');
    fprintf(fileID, 'PCB %02d Hotspot Summary\n', i);
    fprintf(fileID, 'Threshold Used: %.2f\n', threshold);
    fprintf(fileID, 'Number of hotspots detected: %d\n\n', height(resultsTable));
    fprintf(fileID, 'X_Centroid\tY_Centroid\tArea\n');
    for r = 1:height(resultsTable)
        fprintf(fileID, '%.2f\t\t%.2f\t\t%.2f\n', ...
            resultsTable.X_Centroid(r), resultsTable.Y_Centroid(r), resultsTable.Area(r));
    end
    fclose(fileID);

    % Add to PDF
    append(d, Paragraph(sprintf('PCB %02d Results', i)));

    % === Create side-by-side image table ===
    imgTable = Table();  % Initialize empty table
    imgTable.Width = '100%';
    imgTable.HAlign = 'center';
    
    % First image cell (Raw)
    rawImg = Image(filename);
    rawImg.Style = {HAlign('center')};
    rawImg.Height = '3in';
    rawImg.Width = '3in';
    rawEntry = TableEntry();
    append(rawEntry, Paragraph('Raw Thermal Image'));
    append(rawEntry, rawImg);
    
    % Second image cell (Annotated)
    figImage = Image(figFilename);
    figImage.Style = {HAlign('center')};
    figImage.Height = '3in';
    figImage.Width = '3in';
    figEntry = TableEntry();
    append(figEntry, Paragraph('Detected Hotspots'));
    append(figEntry, figImage);
    
    % Row with both entries
    row = TableRow();
    append(row, rawEntry);
    append(row, figEntry);
    
    % Append row to table
    append(imgTable, row);
    
    % Add table to document
    append(d, imgTable);
    append(d, Paragraph(' '));  % Spacer

    append(d, PageBreak);

end

% Finalize PDF
close(d);
disp(['📄 Report saved as: ', reportName]);

% Final cleanup
delete pcb_defect_*.png
delete pcb_result_*.png
delete pcb_result_*.csv
delete pcb_result_*.txt

disp('🧹 Temporary files cleaned. Only the final PDF remains.');
end
