function avg_network_struct = avg_sorted_network(aij_struct)

	sorted_aij = aij_struct.sorted_aij;
	network_pointer = aij_struct.network_pointer;

	network = @(num1,num2) sorted_aij(network_pointer == num1,network_pointer == num2);
	networks_of_interest = unique( network_pointer );
	num_nets = length(networks_of_interest);
	avg_network = zeros(num_nets);

	for i=1:num_nets
	   for j=1:num_nets
		   noi1 = networks_of_interest(i);
		   noi2 = networks_of_interest(j);
		   avg_network(i,j) = mean(network(noi1,noi2),'all' );
	   end
	end
	
	avg_network_struct = struct('avg_sorted_aij',avg_network, 'network_pointer', networks_of_interest);

end
