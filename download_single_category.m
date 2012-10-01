function [n_of_total_images] = download_single_category(home_folder, wnid, label)
% DOWNLOAD_SINGLE_CATEGORY - Download a single category images from ImageNet
%                           by using WordNet ID (wnid).
%
% Input :
%       home_folder <sting> : the path of local folder you want to download
%                             images
%       wnid <string>       : WordNet ID of image synset e.g. n11978233
%       label <string>      : the label of the category (can be arbitrary)
%
% Output :
%       This function downloads all the images in the synset node (including
%       subnodes of the node) into home_folder/label path of your computer.
%       n_of_total_images <int> : the number of total images in synset

%% Set parameters for downloading from ImageNet

% Parameters for downloading images from the imagenet
local_folder = [home_folder, '/',label];

if ~exist(local_folder, 'dir')
    mkdir(local_folder)
end

username = 'kwang';
accesskey = '436c8fc67077aac5cd7c99edc19b5eb969787fda';
recursiveFlag = 1;

% Download Images
downloadImages(local_folder, username, accesskey, wnid, recursiveFlag);
disp(['Download was completed.', char(10)])

%% Save the information file

% Get the information about subnodes
subnodes = dir(fullfile([local_folder,'/*.tar']));
n_of_subnodes = length(subnodes);
n_of_total_images = 0; % the number of total images including all the subnode images
% extract subnode image files and delete compressed file

for idx = 1:n_of_subnodes
    node_name = strrep(subnodes(idx).name, '.tar', '');
    zip_file_name = [local_folder, '/', subnodes(idx).name];
    
    disp(['Extracting synset ', node_name, '... [', num2str(idx), ' / ', num2str(n_of_subnodes), ']']);
    unzip_folder_name = [local_folder, '/', node_name];
    untar(zip_file_name, unzip_folder_name);
    
    list_of_jpeg = dir(fullfile([unzip_folder_name, '/*.JPEG']));
    n_of_images = length(list_of_jpeg);
    
    % Get subnode information and save it
    sub_node_def = wnidToDefinition(fullfile(home_folder, ...
                   'structure_released.xml'), node_name);
    subnodes(idx).words = sub_node_def.words;
    subnodes(idx).gloss = sub_node_def.gloss;
    subnodes(idx).n_of_images = n_of_images;
    
    n_of_total_images = n_of_total_images + n_of_images;
    
    delete(zip_file_name);
end

% Save the category information
definitionStruct = wnidToDefinition(fullfile(home_folder, ...
                   'structure_released.xml'), wnid);
definitionStruct.lebel = label;
definitionStruct.wnid = wnid;
definitionStruct.n_of_subnodes = n_of_subnodes;
definitionStruct.subnodes = subnodes;
definitionStruct.n_of_total_images = n_of_total_images;

save_path = [local_folder, '/label_info.mat'];
disp([char(10), 'Save node information to ... ', save_path])
save(save_path, 'definitionStruct');

% Delete Unnecessary xml files from the disk
delete([local_folder, '/structure_released.xml']);

%% Show the log
disp(char(10));
disp('Information about synset :');
disp([char(9), 'Label : ', label]);
disp([char(9), 'WordNet ID : ', wnid]);
disp([char(9), '# of subnodes : ', num2str(n_of_subnodes)]);
disp([char(9), '# of total images : ', num2str(n_of_total_images), char(10)]);

end

