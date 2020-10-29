function [sorted_aij_struct,metadata,groupAvg]=sort_by_network_RL(aij_flist,output_filename, options)
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
    aij_flist
    output_filename char = [];
    %RL% options.calculateAverage logical = false;
    options.atlas char = []
end

import internetwork_connectivity.avg_sorted_network;
import internetwork_connectivity.parse_aij_filename;
import internetwork_connectivity.sort_network;

%Threshold after which this function guesses a network is voxel based
ATLAS_THRESHOLD = 5000;
LOCATION = '/isilon/datalake/lcbn_research/final/software/LCBN/distributions/LCBN/internetwork_connectivity/+internetwork_connectivity/';
SHEN_FILENAME = [LOCATION 'shen_atlas_network_data.mat'];
VOXEL_FILENAME = [LOCATION 'voxel_network_data.mat'];

atlas = options.atlas;
%RL% calculateAverage = options.calculateAverage;

switch class(aij_flist)
    %Assume any string input is a file name.
    case {'string', 'char'}
        aij_flist = char(aij_flist);
        [~,~,ext] = fileparts(aij_flist);
        %Handle file based on extension
        switch ext
            case '.mat'
                flist{1} = aij_flist;
            case '.flist'
                flist = wfu_read_flist(aij_flist,1);
        end
        
        num_subj = length(flist);
        [aij,pointer] = parse_aij_filename( flist{1} );    
    %Support cell array input - e.g. an already read flist
    case {'cell'}
        flist = aij_flist;
        num_subj = length(flist);
        [aij,pointer] = parse_aij_filename( flist{1} );
    %Support a loaded Aij.mat file
    case {'struct'}
        aij = aij_flist.aij;
        pointer = aij_flist.pointer;
        num_subj = 1;
    otherwise
        error(['Unrecognized Input Type.' newline 'Supported types include '...
        'flists, cell arrays, .mat adjacency files, and structs containing '...
        'aij and pointer data.']);
        
end




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
load_struct = load(metadata, 'reg_dict');
reg_dict = load_struct.reg_dict;


%RL% sort_fcn = @(input_aij,input_pointer) sort_network(input_aij, input_pointer,reg_dict);
%RL% if (calculateAverage)
%RL%	sort_fcn = @(input_aij, input_pointer) avg_sorted_network(...
%RL%											sort_network(input_aij,input_pointer,reg_dict) );
%RL% end


groupAvg = zeros(length(pointer));

for x = 1:num_subj
	[aij,pointer] = parse_aij_filename( flist{x} );
    sortedAij_full = sort_network(aij,pointer,reg_dict);%RL%
    groupAvg = groupAvg + sortedAij_full.sorted_aij;%RL%
    if x == 1
        %preallocate
        sorted_aij_struct(1:num_subj) = avg_sorted_network(sortedAij_full);
    else
        sorted_aij_struct(x) = avg_sorted_network(sortedAij_full);
    end
end

groupAvg = groupAvg ./ num_subj;%RL%
if(~isempty(output_filename))
    save(output_filename,'sorted_aij_struct','metadata', 'groupAvg');%RL%
end


end
