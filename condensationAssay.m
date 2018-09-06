function condensationAssay(folderName)

% PERFORM CONDENSATION ASSAY ON IMAGES

%% Change directory to access files within folder
% Call function on name of folder containing fluorescent and brightfield
%images of an experiment (ex. one strain, one condition, one timepoint)
% basename = name of folder, and presumably the basename occurs in the 
% individual filenames, though this is not necessary
    directory = cd;
    
    cd(folderName)

    % Get conditions and baseName by parsing names of subbfolders
    conditions = regexp(folderName,'/','split');
    baseName = conditions{size(conditions,2)}; %last subfolder

%% Get names of image files
    % assumes that image files have the same basename, with a different channel suffix
    % ex. "YYYYMMDD_strain_time_num_BF.tif" and "YYYYMMDD_strain_time_num_RFP.tif" 
    bfImages = dir(['*', 'BF.tif']);
    fluorImages = dir(['*', 'RFP.tif']);
    
    % remove hidden files
    bfImages = bfImages(arrayfun(@(x) ~strcmp(x.name(1),'.'),bfImages));
    fluorImages = fluorImages(arrayfun(@(x) ~strcmp(x.name(1),'.'),fluorImages));
    
%% Toggle testing mode
%     test = 1; % run only one image for testing
    test = 0; % run all images in folder for real analysis

    if(test)
        i = 1;
    else
        i = 1:length(bfImages);
    end

%% Create variables
    
    % Define threshold values
        thresholds = [0.2, 0.35, 0.5, 0.65, 0.8, 0];  % include 1 to get denominator for total intensity

    % Create variables to store pooled data
        pooled_total = [];              %total number of pixels in cell
        pooled_foreground = [];         %number of pixles above threshold
        pooled_background = [];         %number of pixles below threshold
        pooled_meanIntensity = [];      %mean intensity in foreground
        pooled_stdIntensity = [];       %standard deviation of intensity in foreground
        pooled_totalIntensity = [];     %total intensity in foreground
        pooled_fractionArea = [];       %fraction of total pixels in the foreground
        pooled_cellID = [];
        fileID = {};
        condition = {};
        segmentedImage = {};
        
%% Loop over files
for f = i

    % Segment cells using BF stack to produce binary image "bw"
    [bw] = PhaseContrast_BW(bfImages(f).name);
    figure, imshow(bw)
    
    % Label individual cells
    L = bwlabel(~bw);
    numObjs = max(L(:));
       
    % Read in corresponding fluorescence image
    image = tiffread2(fluorImages(f).name);
    
    % For 3D stacks, take maximum intensity projection
    I = zeros([size(image(1).data), size(image,2)]);
    for z = 1:length(image)
        I(:,:,z) = image(z).data;
    end
    I = mat2gray(max(I,[],3),[0 2^16-1]); % mat2gray scales to min/max of image, so set min = 0 and max = 65535
    figure, imshow(I,[])
    
    % Calculate object properties
    p = regionprops(L,I,'PixelValues', 'Perimeter', 'Area', 'Eccentricity');
    
    a = [p.Area];
    
    % Remove round and small objects
    L(ismember(L,find([p.Eccentricity]<0.7)))=0;
    L(ismember(L,find([p.Area]<200)))=0;
    %L(ismember(L,find(mean(a)<(mean(a)+2.*std(a)))))=0;
    %L(ismember(L,find(mean(a)>(mean(a)+2.*std(a)))))=0;
    L(ismember(L,find([p.Area]>1750)))=0;
    L2 = bwlabel(L);
    numCells = max(L2(:));
    figure, imshow(L2)
        
    p = regionprops(L2,I,'PixelValues', 'Perimeter', 'Area', 'Eccentricity');
    
        
    % Create variables to store data for individual cells within an image file
    total = zeros(numCells,1);
    foreground = zeros(numCells, length(thresholds));
    background = zeros(numCells, length(thresholds));   
    meanIntensity = zeros(numCells, length(thresholds));
    stdIntensity = zeros(numCells, length(thresholds));
    totalIntensity = zeros(numCells, length(thresholds));
    fractionArea = zeros(numCells, length(thresholds));
   
    cellID = [];
    
        % Loop over cells
        for c = 1:numCells 
            
            % Rescale pixels in each cell from 0 to 255
            pixels = p(c).PixelValues;
            minInt = min(pixels);
            maxInt = max(pixels);
            rescaled_pixels = (pixels-minInt).*(255./(maxInt-minInt));
            
            % For each cell, count # of pixels above/below thresholds
            for t = 1:length(thresholds)
                thresh = rescaled_pixels>(thresholds(t).*255); %BW image                
                foreground(c,t) = sum(thresh);    % number of pixels in foreground
                background(c,t) = sum(~thresh);   % number of pixels in background
                total(c,1)= length(thresh);           % total number of pixels in cell
                meanIntensity(c,t) = mean(pixels(thresh)).*65535; % convert back to full-scale
                stdIntensity(c,t) = std(pixels(thresh)).*65535;
                totalIntensity(c,t) = sum(pixels(thresh)).*65535;
                
            end
            
            cellID = [cellID;c];
            fileID = [fileID; {fluorImages(f).name}];
            condition = [condition; conditions];
            segmentedImage{f,c} = rescaled_pixels>(thresholds(3).*255);
            
        end
        fractionArea = background./(total.*ones(size(background)))*100;
        
        % Add data from current file to growing pool
        pooled_foreground = [pooled_foreground; foreground];
        pooled_background = [pooled_background; background];
        pooled_total = [pooled_total; total];
        pooled_meanIntensity = [pooled_meanIntensity; meanIntensity];
        pooled_stdIntensity = [pooled_stdIntensity; stdIntensity];
        pooled_totalIntensity = [pooled_totalIntensity; totalIntensity];
        pooled_fractionArea = [pooled_fractionArea; fractionArea];
        pooled_cellID = [pooled_cellID; cellID];
        
end

%% Export pooled data to Excel file
    
% Make table
T = table(fileID, pooled_cellID, pooled_fractionArea, pooled_total, pooled_foreground, pooled_background, pooled_meanIntensity, pooled_stdIntensity, pooled_totalIntensity, condition);

% Write table to file
writetable(T,[baseName, '_data.xlsx'])  

% each row is a cell

%% Save data to mat file

save([baseName, '.mat'])

cd(directory)