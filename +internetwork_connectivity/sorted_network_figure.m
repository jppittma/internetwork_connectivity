function [figure,color_range]=sorted_network_figure(network, color_range)
%figure=SORTED_NETWORK_FIGURE(network,caxis)
%generates quick figure in the correct order for sorted networks
%mostly for convenience. Colors in networks can be deteremed by passing 
%a second input in the form of an array. E.g. sorted_network_figure(network, [0 1])
%would produce the hottest output for values 1 and above, and the coolest for values
%0 and below.  
%The function returns the color range it used for convenience.

arguments
    network double;
    color_range = 'auto';
end
    


figure = imagesc(network);
colorbar;
caxis(color_range)
xticklabels({'DMN', 'CEN', 'DAN', 'MOT', 'SN', 'BG', 'VIS', 'OFC'});
yticklabels({'DMN', 'CEN', 'DAN', 'MOT', 'SN', 'BG', 'VIS', 'OFC'});

color_range=caxis;

end
