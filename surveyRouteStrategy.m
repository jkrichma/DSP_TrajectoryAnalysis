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
% surveyRouteStrategy - Generates a path between two points using where the 
%   first half uses the survey or topological strategy and the second
%   half follows the learnedRoute in the forward or reverse directions.
%
%
% @param map - grid map. values in map reflect cost of traversal.
% @param rte - set of (x,y) coordinates that follow the learned route.
% @param pWav - path for survey or topological strategy.
% @param topo - pWav is topological if true, otherwise it is a survey strategy.
% @param rev - follow the route in reverse order if true.
% @param dFlag - displays spike wave and path if set to true.
% @return pWavRte - path generated survey/topo and route.
function pWavRte = surveyRouteStrategy (map, rte, pWav, topo, rev, dFlag)

% get first half of survey or topological strategy path
inx = round(size(pWav,1)/2);

% find a point on the survey path that is on the learned route.
while sum(find(rte(:,1) == pWav(inx+1,1) & rte(:,2) == pWav(inx+1,2))) == 0
    inx = inx + 1;
end

% the remainder of the path is based on a route strategy in the forward or
% reverse direction.
if inx < size(pWav,1)
    if rev
        p = routeStrategy (map, pWav(inx+1,1), pWav(inx+1,2), pWav(end,1), pWav(end,2), rte, 1, dFlag);
    else
        p = routeStrategy (map, pWav(inx+1,1), pWav(inx+1,2), pWav(end,1), pWav(end,2), rte, 0, dFlag);
    end
    
    pWavRte = pWav(1:inx,:);
    for i=1:size(p,2)
        inx=inx+1;
        pWavRte(inx,1)=p(i).x;
        pWavRte(inx,2)=p(i).y;
    end
    
    if dFlag
        dispMap = map;
        for i = 2:size(pWavRte,1)
            dispMap(pWavRte(i,1),pWavRte(i,2)) = 20;
        end
        dispMap(pWavRte(end,1),pWavRte(end,2)) = 75;
        dispMap(pWavRte(1,1),pWavRte(1,2)) = 50;
        imagesc(dispMap);
        axis square;
        axis off;
        if ~topo && ~rev
            title(['Surv+Route S(', num2str(pWavRte(1,1)), ',', num2str(pWavRte(1,2)), ') E(', num2str(pWavRte(end,1)), ',', num2str(pWavRte(end,2)), ')'])
        elseif ~topo && rev
            title(['Surv+RevRoute S(', num2str(pWavRte(1,1)), ',', num2str(pWavRte(1,2)), ') E(', num2str(pWavRte(end,1)), ',', num2str(pWavRte(end,2)), ')'])
        elseif topo && ~rev
            title(['Topo+Route S(', num2str(pWavRte(1,1)), ',', num2str(pWavRte(1,2)), ') E(', num2str(pWavRte(end,1)), ',', num2str(pWavRte(end,2)), ')'])
        else
            title(['Topo+RevRoute S(', num2str(pWavRte(1,1)), ',', num2str(pWavRte(1,2)), ') E(', num2str(pWavRte(end,1)), ',', num2str(pWavRte(end,2)), ')'])
        end
    end
else
    pWavRte = [];
end

end