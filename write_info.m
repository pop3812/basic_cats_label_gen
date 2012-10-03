function write_info(home_folder, category)
%WRITE_INFO Summary of this function goes here
%   Detailed explanation goes here

label = category.label;
wnid = category.wnid;
n_subcategories = length(category.sub_categories);
n_of_imgs = category.n_of_imgs;
super_category = category.super_category;

%% [1] Write info.txt

txt_name = sprintf('%s_info.txt', label);
fid = fopen([home_folder, '/basic_category_info/' , txt_name], 'w');

txt_output = sprintf('%s_wnids.txt', label);
fid_out = fopen([home_folder, '/packaged_output/' , txt_output], 'w');

fwrite(fid, ['== Basic Category Information ==', char(10), char(10)]);
fwrite(fid, ['label : ', label, char(10)]);
fwrite(fid, ['WordNet ID : ', wnid, char(10)]);
fwrite(fid, ['Super-category : ', super_category, char(10)]);
fwrite(fid, ['# of subcategories : ', num2str(n_subcategories), char(10)]);
fwrite(fid, ['# of images in category : ', num2str(n_of_imgs), char(10)]);

fwrite(fid, char(10));

fwrite(fid, ['/Sub-categories : ', char(10)]);
fwrite(fid, [char(9), 'label / wnid / # of images', char(10), char(10)]);

for idx = 1 : n_subcategories
    sub_label = category.sub_categories(idx).label;
    sub_wnid = category.sub_categories(idx).wnid;
    sub_n_of_imgs = category.sub_categories(idx).n_of_imgs;
    
    write_info = [char(9), sub_label, ' / ', sub_wnid, ' / ', ...
                  num2str(sub_n_of_imgs), char(10)]; 
    fwrite(fid, write_info);
    fwrite(fid_out, [sub_wnid, char(10)]);
end

fclose(fid);

%% [2] Write imname.txt and urls.txt

txt_name = sprintf('%s_imname.txt', label);
txt_name_url = sprintf('%s_urls.txt', label);

txt_name = ([home_folder, '/basic_category_info/' , txt_name]);
txt_name_url = ([home_folder, '/basic_category_info/' , txt_name_url]);

% Delete original files and rewrite info files
delete(txt_name, txt_name_url);

for idx = 1 : n_subcategories
    % sub_n_of_imgs = category.sub_categories(idx).n_of_imgs;
    
    % Write image name information
    write_info = category.sub_categories(idx).imname_list;
    dlmcell(txt_name, write_info, '\n', '-a');
    
    % Write urls information
    write_info = category.sub_categories(idx).urls;
    dlmcell(txt_name_url, write_info, '\n', '-a');
end

%% [3] Write packaged output for next pipeline
