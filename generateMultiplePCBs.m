function generateMultiplePCBs(numBoards)


    for k = 1:10
        randomDefects = randi([1, 10], randi([1, 3]), 2);  % Random 1–3 defects
        img = generateSyntheticPCB(256, [10, 10], 5, randomDefects);
        filename = sprintf('pcb_defect_%02d.png', k);
        imwrite(img, filename);
    end
    
disp(['Generated ' num2str(numBoards) ' synthetic PCB images.']);

end