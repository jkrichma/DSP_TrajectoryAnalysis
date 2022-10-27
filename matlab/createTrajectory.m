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
% createTrajectory - creates the trajectory files for a given subject. The
% file name structure is: sSUB#tTRIAL#.txt
%
% The files contain the coordinates of the subject trajectory compatible
% with the 2D grid map.

% @param trajDir - trajectory directory
% @param sNum - subject number.
% @param dspVersion - version of DSP (1 or 2)
% @param map - grid map coordinates.
% @param rd - raw data file containing multiple subjects and trials.
% @param dFlag - will display trajectories if true.
function createTrajectory (trajDir, sNum, dspVersion, map, rd, dFlag)

% get all the entries matching the subject number
sdat = rd(rd(:,1) == sNum,:);

% assumes 25 trials maximum
for i = 1:25

    % get all the entries matching the trial number
    inx = find(sdat(:,3) == i);
    if size(inx,1) > 0

        % WARNING: these steps are specific to He & Krichmar using DSP data
        % from the Hegarty lab.  It also assumes a 13x13 grid.  You will
        % need to change this to create files for other studies.
        fid = fopen([trajDir, filesep, 's', num2str(sNum), 't', num2str(i), 'v', num2str(dspVersion), '.txt'], 'w');
        pinx = 1;
        
        if dspVersion == '1'
            px(pinx) = floor(sdat(inx(1),5)/20)+2;
            py(pinx) = 14-(floor(sdat(inx(1),6)/20)+2);
        elseif dspVersion == '2'
            px(pinx) = 14-(floor(sdat(inx(1),5)/20)+2);
            py(pinx) = floor(sdat(inx(1),6)/20)+2;
        end
        
        [px(pinx), py(pinx)] = checkMapIndex(px(pinx), py(pinx),map);
        sMap = map;
        sMap(px(pinx),py(pinx)) = 20;
        fprintf(fid,'%i %i\n', px(pinx), py(pinx));

        for j = 2:size(inx,1)
            
           
            if dspVersion == '1'

                if (max(2,min(12,floor(sdat(inx(j),5)/20)+2)) ~= px(pinx)) || (max(2,min(12,14-(floor(sdat(inx(j),6)/20)+2))) ~= py(pinx))
                    pinx = pinx + 1;
                    px(pinx) = max(2,min(12,floor(sdat(inx(j),5)/20)+2));
                    py(pinx) = max(2,min(12,14-(floor(sdat(inx(j),6)/20)+2)));
                    
                end

            elseif dspVersion == '2'

                if (max(2,min(12,14-(floor(sdat(inx(j),5)/20)+2))) ~= px(pinx)) || (max(2,min(12,floor(sdat(inx(j),6)/20)+2)) ~= py(pinx))
                    pinx = pinx + 1;
                    px(pinx) = max(2,min(12,14-(floor(sdat(inx(j),5)/20)+2)));
                    py(pinx) = max(2,min(12,floor(sdat(inx(j),6)/20)+2));
                end
            end
            
            fprintf(fid,'%i %i\n', px(pinx), py(pinx));
            sMap(px(pinx),py(pinx)) = 20;

        end
        fclose(fid);
        if dFlag
            figure;
            imagesc(sMap);
        end
    end
end
end

% checkMapIndex - Ensures subject coordinate stays within the path 
% boundaries. Assumes path on the grid map is equal to 1.
% @param xIn,yIn - map coordinates.
% @param m - grid map.
% @param xOut,yOut - corrected (if necessary) map coordinates.
function [xOut,yOut] = checkMapIndex(xIn, yIn, m)

if m(xIn,yIn) == 1
    xOut=xIn;
    yOut=yIn;
else
    minDist = 99999;
    for i=1:size(m,1)
        for j = 1:size(m,2)
            if (norm([i j] - [xIn yIn]) < minDist) && (m(i,j) == 1)
                minDist = norm([i j] - [xIn yIn]);
                xOut = i;
                yOut = j;
            end
        end
    end
end
end