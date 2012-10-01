% main.m
% Download basic level category images from ImageNet by using wnid

%% SET PARAMETERS! <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%
% Set Synset ID and Label List for all the basic level categories 

% Set download path
home_folder = '/Users/kwang/Documents/MATLAB/ImageNet/basic_categories';

% Set label list and corresponding wnid list
% gets input list from txt file separated by semi-colon.

input_txt_file = [home_folder, '/input_category_list.txt'];
tdfread(input_txt_file, ';');

label_list = cellstr(label_list);
wnid_list = cellstr(wnid_list);
n_categories = length(label_list);

%% Download all the basic level category images

basic_level_categories = struct([]);

disp([char(10), 'Download basic level category images including :'])
disp(label_list);
disp(['The files will be saved in : ', home_folder]);

for idx = 1 : n_categories
    wnid = char(wnid_list(idx));
    label = char(label_list(idx));
    
    disp([char(10), 'Working on basic level category : ', label, '... [', ...
          num2str(idx), ' / ', num2str(n_categories), ']']);
    
    n_of_category_images = download_single_category(home_folder, wnid, label);
    
    % Save the information about the basic level category images
    basic_level_categories(idx).label = label;
    basic_level_categories(idx).wnid = wnid;
    basic_level_categories(idx).n_of_images = n_of_category_images;
    
    % Backup the results (save every time)
    save([home_folder, '/basic_level_categories_info.mat'], 'basic_level_categories');
    
end

%% Write a info.txt file
%
% home_folder/info.txt file includes the information about the n_of_images
% of each basic level category

write_info(home_folder, basic_level_categories);