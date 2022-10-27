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

%
% runTrial - Generates the paths for the four "pure" strategies for a
%            subject on a given trial.
%   1. Survey
%   2. Route
%   3. Reverse route
%   4. Topological
%
% @param subNum - subject number
% @param trialNum - trial number
% @param trials - list of trial numbers
% @param map - grid map. values in map reflect cost of traversal.
% @param rte - set of (x,y) coordinates that follow the learned route.
% @param pWav - path for survey or topological strategy.
% @param topo - pWav is topological if true, otherwise it is a survey strategy.
% @param rev - follow the route in reverse order if true.
% @param dFlag - displays the path and table of distances if set to true.
% @return fdSurv - distance between subject path and survey strategy
% @return fdTopo - distance between subject path and topological strategy
% @return fdRt - distance between subject path and route strategy
% @return fdRtRev - distance between subject path and route strategy in reverse.
function [fdSurv, fdTopo, fdRt, fdRtRev] = runTrial (subNum, trialNum, trials, map, rte, lm, dFlag, trajDir, dspVersion)

subPath = load([trajDir filesep 's', num2str(subNum), 't', num2str(trialNum), 'v', dspVersion, '.txt']);
t = find(trials(:,1) == trialNum);

rows = 3;
cols = 2;

if dFlag
    subplot(rows,cols,1)
    subMap = map;
    subMap(subPath(1,1),subPath(1,2)) = 50;
    for i=2:size(subPath,1)-1
        subMap(subPath(i,1),subPath(i,2)) = 20;
    end
    subMap(subPath(end,1),subPath(end,2)) = 75;
    imagesc(subMap);
    axis square;
    axis off;
    title(['Subject ', num2str(subNum), ', Trial ', num2str(trialNum)])
    disp(' ')
    disp(['Subject ', num2str(subNum), ', Trial ', num2str(trialNum)])
    subplot(rows,cols,3)
end

p = surveyStrategy (map, trials(t,2), trials(t,3), trials(t,4), trials(t,5), dFlag);
inx=0;
for i=size(p,2):-1:1
    inx=inx+1;
    pSW(inx,1)=p(i).x;
    pSW(inx,2)=p(i).y;
end
[fdSurv, cSq] = DiscreteFrechetDist(pSW,subPath);

if dFlag
    disp(['   Survey distance = ', num2str(fdSurv)])
end

if dFlag
    subplot(rows,cols,4)
end
p = topologicalStrategy (map, lm, trials(t,2), trials(t,3), trials(t,4), trials(t,5), dFlag);
inx=0;
for i=size(p,2):-1:1
    inx=inx+1;
    pTopo(inx,1)=p(i).x;
    pTopo(inx,2)=p(i).y;
end
[fdTopo, cSq] = DiscreteFrechetDist(pTopo,subPath);

if dFlag
    disp(['   Topological distance = ', num2str(fdTopo)])
end

if dFlag
    subplot(rows,cols,5)
end
p = routeStrategy (map, trials(t,2), trials(t,3), trials(t,4), trials(t,5), rte, 0, dFlag);
inx=0;
for i=1:size(p,2)
    inx=inx+1;
    pRte(inx,1)=p(i).x;
    pRte(inx,2)=p(i).y;
end
[fdRt, cSq] = DiscreteFrechetDist(pRte,subPath);

if dFlag
    disp(['   Route distance = ', num2str(fdRt)])
end

if dFlag
    subplot(rows,cols,6)
end
p = routeStrategy (map, trials(t,2), trials(t,3), trials(t,4), trials(t,5), rte, 1, dFlag);
inx=0;
for i=1:size(p,2)
    inx=inx+1;
    pRteRev(inx,1)=p(i).x;
    pRteRev(inx,2)=p(i).y;
end
[fdRtRev, cSq] = DiscreteFrechetDist(pRteRev,subPath);

if dFlag
    disp(['   Route Reverse distance = ', num2str(fdRtRev)])
end

if dFlag
    subplot(rows,cols,2)
    bar([fdSurv fdTopo fdRt, fdRtRev])
    set(gca,'XTickLabel',{'Sur', 'Top', 'Rte', 'Rev'})
    title(['Subject ', num2str(subNum), ' - Frechet Distance'])
end
end
