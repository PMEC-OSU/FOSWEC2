function theStruct = parseXML(filename)
% PARSEXML Convert XML file to a MATLAB structure.
try
   tree = xmlread(filename);
catch
   error('Failed to read XML file %s.',filename);
end

% Recurse over child nodes. This could run into problems 
% with very deeply nested trees.
theStruct = struct([]);
try
   theStruct = parseChildNodes(tree,theStruct);
catch ex
    ex
    for i=1:length(ex.stack)
        ex.stack(i)
    end
   error('Unable to parse XML file %s.',filename);
end


% ----- Local function PARSECHILDNODES -----
function parent = parseChildNodes(theNode,parent)
% Recurse over node children.
if theNode.hasChildNodes
   childNodes = theNode.getChildNodes;
   numChildNodes = childNodes.getLength;

    for count = 1:numChildNodes
        theChild = childNodes.item(count-1);
        fieldName = genvarname(char(theChild.getNodeName),fields(parent));
        if strcmp(fieldName,'x0x23text')
            continue
        end
        if isempty(parent) %fix weirdness with empty structures
            clear parent
        end
        parent.(fieldName) = makeStructFromNode(theChild);
    end
end

% ----- Local function MAKESTRUCTFROMNODE -----
function nodeStruct = makeStructFromNode(theNode)
% Create structure of node info.

nodeStruct = struct(                        ...
   'Name', char(theNode.getNodeName),       ...
   'Data', '');

if any(strcmp(methods(theNode), 'getData'))
   nodeStruct.Data = char(theNode.getData); 
else
   nodeStruct = rmfield(nodeStruct,'Data');
end

nodeStruct = parseAttributes(theNode,nodeStruct);
nodeStruct = parseChildNodes(theNode,nodeStruct);

% ----- Local function PARSEATTRIBUTES -----
function parent = parseAttributes(theNode,parent)
% Create attributes structure.

if theNode.hasAttributes
   theAttributes = theNode.getAttributes;
   numAttributes = theAttributes.getLength;

   for count = 1:numAttributes
      attrib = theAttributes.item(count-1);
      parent.(char(attrib.getName)) = char(attrib.getValue);
   end
end