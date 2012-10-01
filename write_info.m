function write_info(home_folder, basic_level_categories)
%WRITE_INFO Summary of this function goes here
%   Detailed explanation goes here

fid = fopen([home_folder, '/info.txt'], 'w');
n_categories = length(basic_level_categories);

fwrite(fid, ['label_list;n_of_images', char(10)])

for idx = 1 : n_categories
    write_info = [basic_level_categories(idx).label, ';', ...
                  num2str(basic_level_categories(idx).n_of_images), char(10)]; 
    fwrite(fid, write_info);
end

fclose(fid);