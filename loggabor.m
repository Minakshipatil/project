function [logGabor] =loggabor(sze, nscale, norient, minWaveLength, mult,sigmaOnf) 

    if length(sze) == 1
        rows = sze; cols = sze;
    else
        rows = sze(1); cols = sze(2);
    end    
    if mod(cols,2)
	xrange = [-(cols-1)/2:(cols-1)/2]/(cols-1);
    else
	xrange = [-cols/2:(cols/2-1)]/cols;	
    end    
    if mod(rows,2)
	yrange = [-(rows-1)/2:(rows-1)/2]/(rows-1);
    else
	yrange = [-rows/2:(rows/2-1)]/rows;	
    end
    [x,y] = meshgrid(xrange, yrange);    
    radius = sqrt(x.^2 + y.^2);      

    radius(fix(rows/2+1),fix(cols/2+1)) = 1;  
    clear x; clear y; clear theta;   
    lp = fftshift(lowpassfilter([rows,cols],.45,10));   
    
    % The main loop...  
for o = 1:2*norient,
    wavelength = minWaveLength;
    for s = 1:nscale,
        fo = 1.0/wavelength;
        logGabor = exp((-(log(radius/fo)).^2) / (2 * log(sigmaOnf)^2));
        logGabor(round(rows/2+1),round(cols/2+1)) = 0;
        logGabor = logGabor.*lp;
        wavelength = wavelength*mult;
    end
end

   