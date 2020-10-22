function [output,metadata]=sort_by_network(subjects,reference, options)
%sorted_avg=SORT_BY_NETWORK(flist) Takes a flist and applies sorting of regional or voxel-based adjacency
%matricies placing adjacency of common networks together, then averaging them. 
%It returns an array of average adjacency matricies.It optionally writes them to a file given by the second
%argument. It assumes any adjacency matrix of size > 5000 is voxel based.
%This can be overridden with the optional third argument.
%
%The order of the output networks is:
%DMN, CEN, DAN, MOT, SN, BG, VIS, OFC"
%
%author JP Pittman

arguments
    fIn char
    fOut char = [];
    options.calculateAverage logical = false;
    options.atlas char = []
end

%Threshold after which this function guesses a network is voxel based
ATLAS_THRESHOLD = 5000;
SHEN_FILENAME = 'shen_atlas_network_data.mat';
VOXEL_FILENAME = 'voxel_network_data.mat';

atlas = options.atlas;
calculateAverage = options.calculateAverage;

flist = wfu_read_flist(fIn,1);
num_subj = length(flist);

[aij,pointer] = parse_aij_filename( flist{1} );

switch atlas
	case []
		metadata = SHEN_FILENAME;
		if ( length(aij) > ATLAS_THRESHOLD )
			metadata = VOXEL_FILENAME;
		end
	case {'Shen','shen','Yale','yale'}
		metadata = SHEN_FILENAME;
	case 'voxel'
		metadata = VOXEL_FILENAME;
end
reg_dict = load(metadata, 'reg_dict');


sort_fcn = @(input_aij,input_pointer) sort_network(input_aij, input_pointer,reg_dict);
if (calculateAverage)
	sort_fcn = @(input_aij, input_pointer) avg_sorted_network(...
											sort_network(input_aij,input_pointer,reg_dict) );
end

%preallocate
sorted_aij_struct(1:num_subj) = sort_fcn(aij, pointer);

for i = 2:num_subj
	[aij,pointer] = parse_aij_filename( flist{i} );
    sorted_aij_struct(i) = sort_fcn(aij, pointer);
end

if(~isempty(fOut))
    save(fOut,'output','metadata');
end


end
