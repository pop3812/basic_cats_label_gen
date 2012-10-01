function [ imname, urls ] = wnidToImname( wnid )
%WNIDTOIMNAME - returns the imnames and urls of the images in synset
%               of provided wnid.
% Input :
%       wnid <str>      - wnid of the synset
%
% Output :
%       imname <cell>   - a cell that includes all the image names of
%                         the synset
%       urls <cell>     - a cell that includes all the original urls of
%                         the images

url_que = 'http://www.image-net.org/api/text/imagenet.synset.geturls.getmapping?wnid=%s';
url_que = sprintf(url_que, wnid);
str=urlread(url_que);
names=textscan(str, '%s %s', 'delimiter', ' ');

imname = names{1};
urls = names{2};

end

