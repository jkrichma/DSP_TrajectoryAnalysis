%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  
% Copyright(c) 2022 
% Regents of the University of California. All rights reserved.
%  
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions
% are met:
%  
% 1. Redistributions of source code must retain the above copyright
%    notice, this list of conditions and the following disclaimer.
%  
% 2. Redistributions in binary form must reproduce the above copyright
%    notice, this list of conditions and the following disclaimer in the
%    documentation and/or other materials provided with the distribution.
%  
% 3. The names of its contributors may not be used to endorse or promote
%    products derived from this software without specific prior written
%    permission.
%
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
% "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
% LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
% A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT 
% OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
% SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED 
% TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
% PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
% LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
% NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
% SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Jeff Krichmar, UC Irvine
%
%
% topoWave - Calculates a topological path from landmark to landmark
%   using a spiking neuron wave front algorithm.
%
%   Details of the algorithm can be found in: 
%      Hwu, T., Wang, A.Y., Oros, N., and Krichmar, J.L. (2018). 
%      Adaptive Robot Path Planning Using a Spiking Neuron Algorithm With 
%      Axonal Delays. IEEE Trans Cogn Dev Syst 10, 126-137.
%
% @param map - grid map. values in map reflect cost of traversal.
% @param lm - list of landmark coordinates
% @param sX - x coordinate of starting location.
% @param sY - y coordinate of starting location.
% @param eX - x coordinate of goal location.
% @param eY - y coordinate of goal location.
% @param dispWave - displays spike wave and path if set to true.
% @return path - path generated for the topological strategy.
function path = topologicalStrategy (map, lm, sX, sY, eX, eY, dFlag)

LARGE_NUM = 999999;

% get distance to goal from agent
last = false;
path = [];
aX = sX;
aY = sY;

while ~last

    % find a landmark that takes the agent closer to the goal and is the
    % closest landmark to the agent.
    distAgentToGoal = norm([aX aY] - [eX eY]);
    minDistToLM = LARGE_NUM;
    for lmInx = 1:size(lm,1)
        distToLm = norm([lm(lmInx,1) lm(lmInx,2)] - [aX aY]);
        distLmToGoal = norm([lm(lmInx,1) lm(lmInx,2)] - [eX eY]);
        if distToLm < distAgentToGoal && distLmToGoal < distAgentToGoal && distToLm < minDistToLM && distToLm > 0
            minDistToLM = distToLm;
            minLMInx = lmInx;
        end
    end

    % if there is no more close landmarks plan path to the goal.
    if minDistToLM == LARGE_NUM
        topoX = eX;
        topoY = eY;
    else
        topoX = lm(minLMInx,1);
        topoY = lm(minLMInx,2);
    end

    % generate a survey strategy path from the current agent position to
    % the next landmark (topoX,topoY).
    pTopoSeg=surveyStrategy (map, aX, aY, topoX, topoY, 0);
    path = [pTopoSeg(2:end),path];
    if topoX == eX && topoY == eY
        last = true;
    else
        aX=topoX;
        aY=topoY;
    end
end
path(2:end+1)=path(1:end);
path(1).x = eX;
path(1).y = eY;

if dFlag
    pathLen = size(path,2);
    map(path(1).x,path(1).y) = 75;
    for i = 2:pathLen
        map(path(i).x,path(i).y) = 20;
    end
    map(path(end).x,path(end).y) = 50;
    imagesc(map);
    axis square;
    axis off;
    title(['Topological S(', num2str(sX), ',', num2str(sY), ') E(', num2str(eX), ',', num2str(eY), ')'])
end

