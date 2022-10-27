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
% runTrial - Generates the paths for the four "pure" strategies and
%            mixtures of those strategies for a subject on a given trial.
%   1. Survey
%   2. Route
%   3. Reverse route
%   4. Topological
%
% With the 4 "pure" and combinations, there are 14 potential strategies.
% Note that route then reverse route and vice versa would not make sense.
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
% @return fdRteRev - distance between subject path and route strategy in reverse.
% @return fdSurvRte - distance between subject path and survey then route strategy
% @return fdTopoRte - distance between subject path and topoligical then route strategy
% @return fdSurvRteRev - distance between subject path and survey then route strategy in reverse.
% @return fdTopoRteRev - distance between subject path and topoligical then route strategy in reverse.
% @return fdRteSurv - distance between subject path and route then survey strategy.
% @return fdRteTopo - distance between subject path and route then topological strategy.
% @return fdRteRevSurv - distance between subject path and route in reverse then survey strategy.
% @return fdRteRevTopo - distance between subject path and route in reverse then topological strategy.
% @return fdSurvTopo - distance between subject path and survey then topological strategy.
% @return fdTopoSurv - distance between subject path and topological then survey strategy.
function [fdSurv, fdTopo, fdRt, fdRtRev, fdSurvRte, fdTopoRte, fdSurvRteRev, fdTopoRteRev, fdRteSurv, fdRteTopo, fdRteRevSurv, fdRteRevTopo, fdSurvTopo, fdTopoSurv] = runTrialMixStrat (subNum, trialNum, trials, map, rte, lm, dFlag, trajDir, dspVersion)

subPath = load([trajDir, 's', num2str(subNum), 't', num2str(trialNum), 'v', dspVersion, '.txt']);
t = find(trials(:,1) == trialNum);

rows = 2;
cols = 2;

if dFlag
    disp(' ')
    disp(['Subject ', num2str(subNum), ', Trial ', num2str(trialNum)])
    %     figure;
    subplot(rows, cols, 1)
end

p = surveyStrategy (map, trials(t,2), trials(t,3), trials(t,4), trials(t,5), dFlag);
inx=0;
for i=size(p,2):-1:1
    inx=inx+1;
    pSurv(inx,1)=p(i).x;
    pSurv(inx,2)=p(i).y;
end
[fdSurv, cSq] = DiscreteFrechetDist(pSurv,subPath);

if dFlag
    disp(['   Survey distance = ', num2str(fdSurv)])
end

if dFlag
    subplot(rows,cols,2)
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
    subplot(rows,cols,3)
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
    subplot(rows,cols,4)
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

% spike wave then route
if dFlag
    figure;
    subplot(rows,cols,1)
end
pSurvRte = surveyRouteStrategy (map, rte, pSurv, 0, 0, dFlag);
[fdSurvRte, cSq] = DiscreteFrechetDist(pSurvRte,subPath);
if dFlag
    disp(['   Survey then Route distance = ', num2str(fdSurvRte)])
end

% topo wave then route
if dFlag
    subplot(rows,cols,2)
end
pSurvRte = surveyRouteStrategy (map, rte, pTopo, 1, 0, dFlag);
[fdTopoRte, cSq] = DiscreteFrechetDist(pSurvRte,subPath);
if dFlag
    disp(['   Topo then Route distance = ', num2str(fdTopoRte)])
end

% spike wave then reverse route
if dFlag
    subplot(rows,cols,3)
end
pSurvRte = surveyRouteStrategy (map, rte, pSurv, 0, 1, dFlag);
[fdSurvRteRev, cSq] = DiscreteFrechetDist(pSurvRte,subPath);
if dFlag
    disp(['   Survey then Reverse Route distance = ', num2str(fdSurvRteRev)])
end

% topo wave then reverse route
if dFlag
    subplot(rows,cols,4)
end
pSurvRte = surveyRouteStrategy (map, rte, pTopo, 1, 1, dFlag);
[fdTopoRteRev, cSq] = DiscreteFrechetDist(pSurvRte,subPath);
if dFlag
    disp(['   Topo then Reverse Route distance = ', num2str(fdTopoRteRev)])
end

% route then spike wave
if dFlag
    figure;
    subplot(rows,cols,1)
end
pRteSurv = routeSurveyStrategy (map, lm, pRte, 0, 0, dFlag);
[fdRteSurv, cSq] = DiscreteFrechetDist(pRteSurv,subPath);
if dFlag
    disp(['   Route then Survey distance = ', num2str(fdRteSurv)])
end

% route then topological wave
if dFlag
    subplot(rows,cols,2)
end
pRteTopo = routeSurveyStrategy (map, lm, pRte, 1, 0, dFlag);
[fdRteTopo, cSq] = DiscreteFrechetDist(pRteTopo,subPath);
if dFlag
    disp(['   Route then Topo distance = ', num2str(fdRteTopo)])
end

% reverse route then spike wave
if dFlag
    subplot(rows,cols,3)
end
pRteRevSurv = routeSurveyStrategy (map, lm, pRteRev, 0, 1, dFlag);
[fdRteRevSurv, cSq] = DiscreteFrechetDist(pRteRevSurv,subPath);
if dFlag
    disp(['   Reverse Route then Survey distance = ', num2str(fdRteRevSurv)])
end

% reverse route then topological wave
if dFlag
    subplot(rows,cols,4)
end
pRteRevTopo = routeSurveyStrategy (map, lm, pRteRev, 1, 1, dFlag);
[fdRteRevTopo, cSq] = DiscreteFrechetDist(pRteRevTopo,subPath);
if dFlag
    disp(['   Reverse Route then Topo distance = ', num2str(fdRteRevTopo)])
end

% survey then topological wave
if dFlag
    figure;
    subplot(rows,cols,1)
end
pSurvTopo = routeSurveyStrategy (map, lm, pSurv, 1, 0, dFlag);
if dFlag
    title(['Surv+Topo S(', num2str(pSurvTopo(1,1)), ',', num2str(pSurvTopo(1,2)), ') E(', num2str(pSurvTopo(end,1)), ',', num2str(pSurvTopo(end,2)), ')'])
end
[fdSurvTopo, cSq] = DiscreteFrechetDist(pSurvTopo,subPath);
if dFlag
    disp(['   Survey then Topo distance = ', num2str(fdSurvTopo)])
end

% topological then spike wave
if dFlag
    subplot(rows,cols,2)
end
pTopoSurv = routeSurveyStrategy (map, lm, pTopo, 0, 0, dFlag);
if dFlag
    title(['Topo+Surv S(', num2str(pTopoSurv(1,1)), ',', num2str(pTopoSurv(1,2)), ') E(', num2str(pTopoSurv(end,1)), ',', num2str(pTopoSurv(end,2)), ')'])
end
[fdTopoSurv, cSq] = DiscreteFrechetDist(pTopoSurv,subPath);
if dFlag
    disp(['   Topological then Survey distance = ', num2str(fdTopoSurv)])
end

if dFlag
    figure;
    subplot(2,1,1)
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
    subplot(2,1,2)
    bar([fdSurv fdTopo fdRt, fdRtRev, fdSurvRte, fdTopoRte, fdSurvRteRev, fdTopoRteRev, fdRteSurv, fdRteTopo, fdRteRevSurv, fdRteRevTopo, fdSurvTopo, fdTopoSurv])
    set(gca,'XTickLabel',{'Sur', 'Top', 'Rte', 'Rev', 'SurvRte', 'TopoRte', 'SurvRev', 'TopoRev', 'RteSur', 'RteTopo', 'RevSur', 'RevTopo', 'SurvTopo', 'TopoSurv'})
    title(['Subject ', num2str(subNum), ' - Frechet Distance'])
end

end
