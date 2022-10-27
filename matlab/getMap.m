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
% getMap - Generates a 2D grid map from input coordinates. Each row of 
%    input parameter mxy should be the 3-tuple (x,y,cost). Assumes the map
%    is a square matrix (13x13, 32x32, etc.)
%
% @param mxy - input coordinates of map with cost (x,y,cost).
% @param lm - list of landmark coordinates. Strictly used to display the
%             map. Not used or returned for generating the map.
% @param dispMap - plots the map.
% @return path - 2D matrix representing the map of the environment.
function m = getMap (mxy, lm, dispMap)

% assumes a square matrix
if floor(sqrt(size(mxy,1))) ~= sqrt(size(mxy,1))
    disp(['ERROR: map must be a square matrix. sqrt(mxy) = ', num2str(size(mxy,1))])
    return
end

m = zeros(sqrt(size(mxy,1)));

for i=1:size(mxy,1)
    if dispMap
        % assumes these values when plotting the map
        if mxy(i,3) == 1
            plot(mxy(i,1),mxy(i,2),'b*')
        elseif mxy(i,3) == 100
            plot(mxy(i,1),mxy(i,2),'ks')
        elseif mxy(i,3) == 120
            plot(mxy(i,1),mxy(i,2),'rs')
        else
            disp('bad value')
        end
        hold on
    end

    % set map value for each (x,y) coordinate
    m(mxy(i,1),mxy(i,2)) = mxy(i,3);
end

if dispMap
    for i=1:size(lm,1)
        plot(lm(i,1),lm(i,2),'gx')
    end
    set(gca,'Ydir','reverse')
    hold off
end
end
