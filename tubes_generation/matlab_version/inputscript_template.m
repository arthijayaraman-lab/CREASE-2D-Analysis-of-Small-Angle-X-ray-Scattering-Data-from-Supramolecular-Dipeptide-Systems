%Input Script
params=struct(...
    "seed",SEED,...        %Random Seed
    "boxlength",BOXLEN*[1 1 1],...     %Length of the box
    "tube_meanL",MEANTUBELEN,...           %Mean dipeptide tube length
    "tube_sdL",SDTUBELEN,...              %Standard Deviation of dipeptide tube length
    "tube_meanD",MEANTUBEDIA,...           %Mean tube diameter
    "tube_sdD",SDTUBEDIA,...               %Standard Deviation of tube diameter
    "tube_meanE",MEANECC,...             %Mean eccentricity of tube crossection (-1 to 1)
    "tube_fracsdE",FRACSDECC,...         %Relative Standard Deviation (0 to 1) of eccentricity of tube crossection 
    "tube_t",TUBETHICKNESS,...                 %Tube shell thickness
    "tube_meanorientangles",[ORIENTTHETA ORIENTPHI],...          %Mean Orientation angles of herd theta and phi
    "tube_kappa",10^KAPPAEXP,...            %Orientational anisotropy parameter for tubes
    "herd_coneangle",CONEANGLE,...        %Coneangle for herding tube variation
    "herd_dims",[HERDDIA*HERDLEN*MEANTUBELEN HERDLEN*MEANTUBELEN],... %Diameter and length of herding tube (tube tortuosity and tube stiffness)
    "herd_numextranodes",HERDEXTRANODES,...      %A node is already placed at end of herding tubes, this determines extra nodes inside each herd.
    "particle_len",PARTLEN,...
    "scat_dens",SCATDENS,...
    "volfrac",VOLFRAC);         %Target volume fraction
currentfolder=pwd;
restart=struct(...
    "scatteringflag",RESTART_FLAG,...
    "path",[currentfolder '/'],...
    "mainfile",'restart.mat',...
    "scatteringfile",'scattering.mat');
relaxmd=struct(...
    "should_relax_flag",0,...
    "relaxed_flag",0,...
    "mdinput_datafile",'cgbeads.data',...
    "mdoutput_dumpfile",'cgbeads_relaxed.dump',...
    "path",[currentfolder '/lammps_relaxation/']);
output=struct(...
    "q_and_theta_info",[301 31 -2.1 -0.9],... %Values: [nq ntheta qmin_exponent qmax_exponent]
    "herdingfile_flag",HERDDUMP_FLAG,...
    "scattererfile_flag",SCATTERERSDUMP_FLAG,...
    "mainprefix",'SAMPLEINFO',...
    "path",[currentfolder '/']);
cd('../matlabfiles/'); 
main(params,restart,relaxmd,output);
cd(currentfolder);
