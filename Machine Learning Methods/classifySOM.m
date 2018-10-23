function [classes] = classifySOM(net, x)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


[y,Xf,Af] = net(x);
%classes = size(c)
%view(net)
classes = vec2ind(y);
classes = classes';

end

