function  wnidList = genRecursiveSynsetList(homefolder, wnid, isRecursive) 
    xDoc = xmlread(fullfile(homefolder, 'structure_released.xml'));
    if isRecursive
        if strcmp(wnid, 'gproot')
            query = sprintf('/ImageNetStructure//synset[@wnid="%s"]/descendant::synset', wnid);
        else
            query = sprintf('/ImageNetStructure//synset[@wnid="%s"]/descendant-or-self::synset', wnid);
        end
    else
        query = sprintf('/ImageNetStructure//synset[@wnid="%s"]', wnid);
    end
    result = XPathExecuteQuery(xDoc, query);
    % used to deduplicate the same synset returned multiple times
    query2 = sprintf('/ImageNetStructure//synset[@wnid="%s"]', wnid);
    r = XPathExecuteQuery(xDoc, query2);
    nOccurance = r.getLength();
    
     if (result.getLength() == 0) || (nOccurance == 0)
        error('\nERROR ! %s is not found in structure_released.xml\n Please check your synset WordNet ID !', wnid);
    else
        wnidList = cell(1, result.getLength()/nOccurance);
     end
    
    for i = 0 : result.getLength()/nOccurance - 1
         wnid = char(result.item(i).getAttribute('wnid'));
         wnidList{(i+1)} = wnid;
    end
end