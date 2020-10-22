function sorted_aij_struct=sort_network(aij,pointer,reg_dict) 

arguments
	%single precision is signifcant to 6-9 digits, but uses half the space for voxel based networks
	aij single
	pointer uint32
	reg_dict containers.Map
end

netpointer = zeros( size(pointer), 'like', pointer);
for i=1:length(netpointer)
	netpointer(i) = reg_dict( pointer(i) );
end

sorted_aij_struct = struct();
[network_pointer, sorted_index] = sort(net_pointer);

%Sort according to associated network and assign to output 
sorted_aij = aij(sorted_index,sorted_index);

sorted_aij_struct = struct('sorted_aij', sorted_aij, 'network_pointer', network_pointer);

end

