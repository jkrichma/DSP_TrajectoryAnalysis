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
% repExamples - Creates figures for representative examples given in
% figures 3, 4, and 7 of:
%    Krichmar, J.L. and He, C. (2022), Importance of Path Planning Variability:
%       A Simulation Study. Top. Cogn. Sci.. https://doi.org/10.1111/tops.12568
%
% @param createTrials - will create subject trajectories for trials if
%   true. This takes a long time but only needs to be run once.
% @param templateDirectory - the directory to find the templates required.

function repExamples (createTrials,templateDir)

cd(templateDir);
testDir = horzcat(templateDir,filesep,'..',filesep,'tests',filesep);

if createTrials
    dspVersion = '1';
    createSubjectTrialData (horzcat(testDir,'rd_examples_version_',dspVersion,'.csv'),...,
                            horzcat(templateDir,filesep,'..',filesep,'templates', filesep,'dsp_coords_version_',dspVersion,'.txt'),...,
                            horzcat(templateDir,filesep,'..',filesep,'templates', filesep,'lmOnPath_version_',dspVersion,'.txt'),...,
                            testDir);
                        
    dspVersion = '2';
    createSubjectTrialData (horzcat(testDir,'rd_examples_version_',dspVersion,'.csv'),...,
                            horzcat(templateDir,filesep,'..',filesep,'templates', filesep,'dsp_coords_version_',dspVersion,'.txt'),...,
                            horzcat(templateDir,filesep,'..',filesep,'templates', filesep,'lmOnPath_version_',dspVersion,'.txt'),...,
                            testDir);
end

% figure 3 - always survey (subject 604)
runSubjectTrials(604,0,1,13,testDir,1);

% figure 4 - always route (subject 324BOSS)
runSubjectTrials(3241,0,1,13,testDir,1);

% figure 7 - route then survey (subject 416BOSS)
runSubjectTrials(4161,1,1,3,testDir,1);

% The second version of the DSP example
runSubjectTrials(205,0,1,3,testDir,2);

