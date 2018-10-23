function [M] = showSomTraining(net, x, somEpochs, nSampleSteps)
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here

opengl('software')
net = init(net);
nSamples = size(x,2);
nRuns = somEpochs*floor(nSamples/nSampleSteps);

dataSet = repmat((1:nSamples),1,somEpochs);
nRandom = randperm(numel(dataSet));
dataSet = dataSet(nRandom);

for i =1:nRuns
    close
    %r= ceil(rand(nSampleSteps,1)*nSamples);
    startIndex = (i-1)*nSampleSteps+1;
    r = dataSet(startIndex:startIndex +nSampleSteps-1);
    [net, tr] = adapt(net,x(:,r));
    out1 = plotsomplanes(net)
    %plotsompos(net) 
    refresh
    set(gcf, 'units','normalized','outerposition',[0 0 1 1], 'Color', 'White')
    M(i) = getframe(out1);
    i
end
close

clear writerObj
writerObj = VideoWriter('SOM.mp4', 'MPEG-4');
writerObj.FrameRate = 8;
open(writerObj);
for j=1:length(M)
   frame = M(j);
   writeVideo(writerObj,frame);
end
close(writerObj);


[output_args] = showSomTraining(net, x, somEpochs, 500);
movie(M,5)

% figure
% hold on
% net = init(net);
% for i =1:800
% [net, tr] = adapt(net,x(:,i));
%     plotsompos(net) 
%     pause(.05)
% end


% 
% figure, plotsomtop(net)
% figure, plotsomnc(net)
% figure, plotsomnd(net)
% figure, plotsomhits(net,x)
% figure, plotsompos(net,x)
% figure, plotsomplanes(net)

end

