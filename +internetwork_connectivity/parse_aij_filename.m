function [aij,pointer] = parse_aij_filename(filename)
	data = load(filename);
	if(isfield(data, 'aij'))
		aij = data.aij;
	else
		aij = data.mij;
	end
	pointer = data.pointer;
end
