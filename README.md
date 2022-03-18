MATLAB scripts provided to analyze subject navigation strategies in the dual-solution paradigm (DSP). These scripts and tools were developed for the following paper:

	Krichmar, J.L. and He, C. (2022), Importance of Path Planning Variability: A Simulation Study. Top. Cogn. Sci.. https://doi.org/10.1111/tops.12568

In this paper, the DSP data from prior studies (Boone et al., 2018, 2019) were analyzed using path planning algorithms developed for robotics. For more details on the DSP human subjects, see:
 
	Boone, A. P., Gong, X., & Hegarty, M. (2018). Sex differences in navigation strategy and efficiency. Memory & Cognition, 46(6), 909–922. https://doi.org/10.3758/s13421-018-0811-y

	Boone, A. P., Maghen, B., & Hegarty, M. (2019). Instructions matter: Individual differences in navigation strategy and ability. Memory & Cognition, 47(7), 1401–1414. https://doi.org/10.3758/s13421-019-00941-5



These scripts will take raw subject trajectory data (rd_examples.csv) from the Boone et al., 2018, 2019 studies and convert them to a 13x13 grid environment suitable for analyzing with path planning algorithms. Note that these scripts are specific to the Boone et al. studies and would need to be altered for different studies. The CSV file has a header with first column is subject id, the second column is trial type (0=goto goal; 1=shortcut), the third column is trial id, then the following columns are for time, x, and z values

	createSubjectTrialData.m
	createTrajectory.m
	getMap.m
	rd_examples.csv

These scripts are path planning algorithms to analyze trajectories. They include a survey strategy, route strategy, and topological strategy to plan paths. The topological strategy uses landmarks to create a topology. Also included are combinations of these strategies. For example, routeSurveyStrategy starts on the route and switches to a survey strategy around halfway to reach the goal. More details can be found in Krichmar and He, 2022.

	routeStrategy.m
	routeSurveyStrategy.m
	runSubjectTrials.m
	runTrial.m
	runTrialMixStrat.m
	surveyRouteStrategy.m
	surveyStrategy.m
	topologicalStrategy.m

To measure how close a subject trajectory follows a particular strategy, we use the discrete Frechet distance (T. Eiter and H. Mannila. Computing discrete Frechet distance. Technical Report 94/64, Christian Doppler Laboratory, Vienna University of Technology, 1994).

	DiscreteFrechetDist.m

These are data files for setting up the analysis of the Boone et al., 2018, 2019 data. They include map coordinates, learned route coordinates, landmark coordinates, and trial numbers.

	dsp_coords.txt
	learnedRoute.txt
	lmOnPath.txt
	trials.txt

To try out the analysis, we provide a script that re-creates Figures 3, 4, and 7 from Krichmar and He, 2022. It has the option of creating the subject trajectory data from the rd_examples.csv file. Note that creating these files, which include every trial for every subject, takes a long time and only needs to be done once.

	repExamples.m
