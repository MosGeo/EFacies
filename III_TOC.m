% TOC
tocfile = fullfile(wellFolder,'Carb.xlsx');
tocdata = loaddata(tocfile);
clear tocfile

toc     = interp1(tocdata.Depth, tocdata.TOCPerc, depth);

