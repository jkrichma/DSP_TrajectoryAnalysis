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
% createFdTables - creates a CSV where each row is one trial from one
% subject and the 4 strategies distances from the 'pure' strategies coding.
%
% @param trajDir - folder name for the trajectories created using createSubjectTrials.
% @param fnOut - file name for the location to store the output.
% @param mixed - run the combination of strategies if true. Only 4 "pure" strategies otherwise.
% @param dTrialNum - display paths and distance information for the given trial number.  If set to 999, all trials will be displayed.
%
function [fdTableAll] = createFdTables (trajDir, fnOut, mixed, dTrialNum)

% Get all subject unique subject numbers from the trajectories directory
subjFiles = dir([trajDir, filesep, '*.txt']);
subs = [];

for sub = 1:length(subjFiles)
    id = split(subjFiles(sub).name,'t');
    id = id{1}(2:end);
    subs(end+1) = str2double(id);
end

subs = unique(subs);

% Initiate the table that will store all data for all subjects.
% Each row will be that subject's strategy scores for each trial.
colnames = {'subject','trial','Sur', 'Top', 'Rte', 'Rev','dspVersion'};
fdTableAll = table([],[],[],[],[],[],[],'VariableNames',colnames);

% Loop through each subject, grab their fdTable (strats) and a list of
% their trial numbers. Convert this to a form that can be stored easily as
% a CSV. 
for dspVersion = 1:2
    for i = 1:length(subs)
        [strats,trialNum] = runSubjectTrials(subs(i), mixed, 0, dTrialNum, trajDir, dspVersion);
        
        ids = repmat({num2str(subs(i))},size(strats,1),1);
        dspVersions = repmat({num2str(dspVersion)},size(strats,1),1);
        trialNum = nonzeros(trialNum);
        fdTable = table(ids, trialNum, strats(:,1), strats(:,2), strats(:,3), strats(:,4),dspVersions,'VariableNames',colnames);
        fdTableAll = [fdTableAll; fdTable];
        
        fprintf('Subject %d complete\n', subs(i));
    end
end

% Save the file to the output folder.
writetable(fdTableAll,fnOut);

end