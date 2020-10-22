function [aij,pointer] = parse_aij_filename(filename)
	aij = load(filename);
	if(isfield(aij, 'aij'))
		aij = aij.aij;
	else
		aij = aij.mij;
	end
	pointer = aij.pointer
end
