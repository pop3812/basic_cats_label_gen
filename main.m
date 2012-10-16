% main.m
% Download basic level category images from ImageNet by using wnid

%% SET PARAMETERS! <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%
% Set Synset ID and Label List for all the basic level categories 

% Set download path and output summary file path
home_folder = './basic_categories';
struct_xml = [home_folder, '/structure_released.xml'];

summary_name = 'summary.txt';
fid_summary = fopen([home_folder, '/' , summary_name], 'w');
fwrite(fid_summary, ['label_list;num_of_images_on_synset', char(10)]);

% Set label list and corresponding wnid list
% gets input list from txt file separated by semi-colon.

input_txt_file = [home_folder, '/raw_input.txt'];
tdfread(input_txt_file, '\t');

super_category_list = cellstr(super_category_list);
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
    super_category = char(super_category_list(idx));
    n_of_total_imgs = 0;
    
    disp([char(10), 'Working on basic level category : ', label, '... [', ...
          num2str(idx), ' / ', num2str(n_categories), ']']);
    
    sub_list = genRecursiveSynsetList(home_folder, wnid, 1);
    sub_list = unique(sub_list);
    
    % Save the information about the basic level category images
    basic_level_categories(idx).label = label;
    basic_level_categories(idx).wnid = wnid;
    basic_level_categories(idx).super_category = super_category;
    sub_categories = struct([]);
    n_subcategories = length(sub_list);
    
    for sub_idx = 1 : n_subcategories
        sub_wnid = char(sub_list(sub_idx));
        [imname, urls] = wnidToImname(sub_wnid);
        n_of_imgs = length(imname);
        definition = wnidToDefinition(struct_xml, sub_wnid);
        
        % Set info about the subcategories
        sub_categories(sub_idx).wnid = sub_wnid;
        sub_categories(sub_idx).label = definition.words;
        sub_categories(sub_idx).gloss = definition.gloss;
        
        sub_categories(sub_idx).imname_list = imname;
        sub_categories(sub_idx).urls = urls;
        sub_categories(sub_idx).n_of_imgs = n_of_imgs;
        n_of_total_imgs = n_of_total_imgs + n_of_imgs;
    end
    
    basic_level_categories(idx).sub_categories = sub_categories;   
    basic_level_categories(idx).n_of_imgs = n_of_total_imgs;
    % Backup the results (save every time)
    fwrite(fid_summary, [label, ';', num2str(n_of_total_imgs), char(10)]);
    save([home_folder, '/basic_level_categories_info.mat'], 'basic_level_categories');
   
    % Write a info txt files
    %
    % home_folder/info.txt file includes the information about the n_of_images
    % of each basic level category
    write_info(home_folder, basic_level_categories(idx));
    
end

fclose(fid_summary);