%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (C) rtQC Dev-Team
%
% This program is free software; you can redistribute it and/or
% modify it under the terms of the GNU General Public License
% as published by the Free Software Foundation; either version 3
% of the License, or (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307,USA.
%
% Author: Stephan Heunis, <j.s.heunis@tue.nl>, 2018
%
% Function rtQC_display
%
% Description: rtQC GUI
%
% Parameters:
%
% Returns:
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function rtQC_display()

% Open SPM
% spm fmri
% Create main GUI figure
fig = figure('Visible','off',...
    'Name', 'rtQC',...
    'NumberTitle','off',...
    'units','normalized',...
    'outerposition', [0 0 1 1],...
    'MenuBar', 'none',...
    'ToolBar', 'none');
% Main data structure
gui_data = guidata(fig);
% Get rtQC defaults
defaults = rtQC_defaults();
fields = fieldnames(defaults);
for i=1:numel(fields)
    gui_data.(fields{i}) = defaults.(fields{i});
end

% Setup all UIcontrols and GUI components
rtQC_display_setup;
% Set callbacks
gui_data.tgroup.SelectionChangedFcn = @tabChangedCallback;
gui_data.pb_help.Callback = @linkToGithub;
gui_data.pb_docs.Callback = @linkToDocs;
gui_data.edit_fd_threshold_defaults.Callback = @editFDthreshold;
gui_data.edit_spm_defaults.Callback = @editSPMdir;
gui_data.pb_spm_defaults.Callback = @setSPMdir;
gui_data.edit_structural.Callback = @editStructural;
gui_data.pb_structural.Callback = @setStructural;
gui_data.edit_functional.Callback = @editFunctional;
gui_data.pb_functional.Callback = @setFunctional;
gui_data.edit_fd_threshold.Callback = @editFDthreshold;
gui_data.pb_initialize.Callback = @initialize;
gui_data.pb_startRT.Callback = @startRT;
gui_data.pb_stopRT.Callback = @stopRT;
gui_data.popup_setDim.Callback = @setDim;
gui_data.sld_slice.Callback = @changeSlice;
gui_data.popup_setImg.Callback = @setImg;

gui_data.edit_structural_pre.Callback = @editStructural;
gui_data.pb_structural_pre.Callback = @setStructural;
gui_data.edit_functional_pre.Callback = @editFunctional;
gui_data.pb_functional_pre.Callback = @setFunctional;
gui_data.pb_preproc.Callback = @runPreProc;

set(findall(fig, '-property', 'Interruptible'), 'Interruptible', 'on')

% Make figure visible after normalizing units
set(findall(fig, '-property', 'Units'), 'Units', 'Normalized')
fig.Visible = 'on';
% Save GUI data to workspace
gui_data = guidata(fig);
assignin('base', 'gui_data', gui_data)
end


function tabChangedCallback(hObject, eventdata)
% Get the Title of the previous tab
tabName = eventdata.OldValue.Title;
% tabName = eventdata.NewValue.Title;
assignin('base', 'eventdata', eventdata)
assignin('base', 'src', hObject)
switch tabName
    case hObject.Children(1).Title
        %
    case hObject.Children(2).Title
        %
    case hObject.Children(3).Title
        %
    case hObject.Children(4).Title
        %
    otherwise
        %
end
end


function linkToGithub(hObject,eventdata)
url = 'https://github.com/rtQC-group/rtQC';
web(url, '-browser')
end

function linkToDocs(hObject,eventdata)
f = msgbox('This button could link to a readthedocs page that serves as rtQC documentation');
end



function editFDthreshold(hObject,eventdata)
fig = ancestor(hObject,'figure');
gui_data = guidata(fig);
txt = get(hObject, 'String');
gui_data.FD_threshold = str2double(txt);
if isnan(gui_data.FD_threshold)
    %     set(hObject, 'String', 0.25);
    gui_data.edit_fd_threshold.String = '0.25';
    gui_data.edit_fd_threshold_defaults.String = '0.25';
    gui_data.FD_threshold = 0.25;
    errordlg('Input must be a number','Error');
else
    gui_data.edit_fd_threshold.String = txt;
    gui_data.edit_fd_threshold_defaults.String = txt;
end

assignin('base', 'gui_data', gui_data)
guidata(fig,gui_data)
end


function editSPMdir(hObject,eventdata)
fig = ancestor(hObject,'figure');
gui_data = guidata(fig);
end

function setSPMdir(hObject,eventdata)
fig = ancestor(hObject,'figure');
gui_data = guidata(fig);
% cd(gui_data.root_dir)
dirname = uigetdir(gui_data.root_dir, 'Select the SPM12 toolbox directory');
if dirname ~= 0
    gui_data.spm_dir = dirname;
    gui_data.edit_spm_defaults.String = dirname;
end
assignin('base', 'gui_data', gui_data)
guidata(fig, gui_data);
end



function editStructural(hObject,eventdata)
fig = ancestor(hObject,'figure');
gui_data = guidata(fig);
end

function setStructural(hObject,eventdata)
fig = ancestor(hObject,'figure');
gui_data = guidata(fig);
cd(gui_data.root_dir)
[filename, pathname] = uigetfile('*.nii', 'Select the STRUCTURAL IMAGE file');
if filename ~= 0
    gui_data.structural_fn = [pathname filename];
    gui_data.edit_structural.String = gui_data.structural_fn;
    gui_data.edit_structural_pre.String = gui_data.structural_fn;
end
assignin('base', 'gui_data', gui_data)
guidata(fig, gui_data);
end

function editFunctional(hObject,eventdata)
fig = ancestor(hObject,'figure');
gui_data = guidata(fig);
end

function setFunctional(hObject,eventdata)
fig = ancestor(hObject,'figure');
gui_data = guidata(fig);
cd(gui_data.root_dir)
[filename, pathname] = uigetfile('*.nii', 'Select the 4D FUNCTIONAL IMAGE file');
if filename ~= 0
    gui_data.functional4D_fn = [pathname filename];
    gui_data.edit_functional.String = gui_data.functional4D_fn;
    gui_data.edit_functional_pre.String = gui_data.functional4D_fn;
end
assignin('base', 'gui_data', gui_data)
guidata(fig, gui_data);
end






function runPreProc(hObject,eventdata)
fig = ancestor(hObject,'figure');
gui_data = guidata(fig);
gui_data.functional0_fn = [gui_data.functional4D_fn ',1'];
% Preprocess structural and f0 images
[d, f, e] = fileparts(gui_data.structural_fn);
if exist([d filesep 'rc1' f e], 'file')
    % 1) If preprocessing has already been done, assign variables
    gui_data.preProc_status = 1;
    gui_data.forward_transformation = [d filesep 'y_' f e];
    gui_data.inverse_transformation = [d filesep 'iy_' f e];
    gui_data.gm_fn = [d filesep 'c1' f e];
    gui_data.wm_fn = [d filesep 'c2' f e];
    gui_data.csf_fn = [d filesep 'c3' f e];
    gui_data.bone_fn = [d filesep 'c4' f e];
    gui_data.soft_fn = [d filesep 'c5' f e];
    gui_data.air_fn = [d filesep 'c6' f e];
    gui_data.rstructural_fn = [d filesep 'r' f e];
    gui_data.rgm_fn = [d filesep 'rc1' f e];
    gui_data.rwm_fn = [d filesep 'rc2' f e];
    gui_data.rcsf_fn = [d filesep 'rc3' f e];
    gui_data.rbone_fn = [d filesep 'rc4' f e];
    gui_data.rsoft_fn = [d filesep 'rc5' f e];
    gui_data.rair_fn = [d filesep 'rc6' f e];
    gui_data.preProc_step1_status = 1;
    gui_data.txt_preproc1_status.String = char(hex2dec('2713'));
    gui_data.preProc_step2_status = 1;
    gui_data.txt_preproc2_status.String = char(hex2dec('2713'));
    gui_data.preProc_step3_status = 1;
    gui_data.txt_preproc3_status.String = char(hex2dec('2713'));
else
    % 2) If not done, run scripts to get data in correct formats for
    % real-time processing
    gui_data.preProc_status = 0;
    guidata(fig,gui_data);
    output = preRtPreProc(fig, gui_data.functional0_fn, gui_data.structural_fn, gui_data.spm_dir);
    for fn = fieldnames(output)'
        gui_data.(fn{1}) = output.(fn{1});
    end
    gui_data.preProc_status = 1;
end
guidata(fig,gui_data);
end



function initialize(hObject,eventdata)
fig = ancestor(hObject,'figure');
gui_data = guidata(fig);
% Check preprocessing of structural and f0 images
if gui_data.preProc_status ~= 1
    errordlg('Please first complete the preprocessing in the PRE-NF QC tab','Preprocessing not done!');
    return;
end
gui_data.functional0_fn = [gui_data.functional4D_fn ',1'];
gui_data.f4D_img = spm_read_vols(spm_vol(gui_data.functional4D_fn));
[gui_data.Ni, gui_data.Nj, gui_data.Nk, gui_data.Nt] = size(gui_data.f4D_img);
gui_data.Ndims = [gui_data.Ni; gui_data.Nj; gui_data.Nk];
gui_data.slice_number = floor(gui_data.Nk/2);
[dir, fn, ext] = fileparts(gui_data.functional4D_fn);
if ~exist([dir filesep fn '_00001' ext],'file')
    gui_data.f4D_img_spm = spm_file_split(gui_data.functional4D_fn);
end
% real-time realign and reslice parameters
gui_data.use_rt = 1;
gui_data.flagsSpmRealign = struct('quality',.9,'fwhm',5,'sep',4,...
    'interp',4,'wrap',[0 0 0],'rtm',0,'PW','','lkp',1:6);
gui_data.flagsSpmReslice = struct('quality',.9,'fwhm',5,'sep',4,...
    'interp',4,'wrap',[0 0 0],'mask',1,'mean',0,'which', 2);
gui_data.infoVolTempl = spm_vol(gui_data.functional0_fn);
gui_data.imgVolTempl  = spm_read_vols(gui_data.infoVolTempl);
gui_data.dimTemplMotCorr     = gui_data.infoVolTempl.dim;
gui_data.matTemplMotCorr     = gui_data.infoVolTempl.mat;
gui_data.dicomInfoVox   = sqrt(sum(gui_data.matTemplMotCorr(1:3,1:3).^2));
gui_data.A0=[];gui_data.x1=[];gui_data.x2=[];gui_data.x3=[];gui_data.wt=[];gui_data.deg=[];gui_data.b=[];
gui_data.R(1,1).mat = gui_data.matTemplMotCorr;
gui_data.R(1,1).dim = gui_data.dimTemplMotCorr;
gui_data.R(1,1).Vol = gui_data.imgVolTempl;
gui_data.nrSkipVol = 0;
gui_data.F_dyn_img = gui_data.f4D_img(:,:,:,1);
gui_data.tSNR_dyn_img = gui_data.f4D_img(:,:,:,1);
gui_data.FD_outliers = []; % Outlier volumes
gui_data.FD_sum = 0;
gui_data.outlier_counter = 0; % Outlier counter
gui_data.FD_dynamic_average = 0;
gui_data.t = 1:gui_data.Nt;
gui_data.MP1 = zeros(1,gui_data.Nt);
gui_data.MPall = cell(1,6);
for p = 1:6
    gui_data.MPall{p} =  gui_data.MP1;
end
gui_data.FD = nan(gui_data.Nt,1);
gui_data.DVARS = nan(1,gui_data.Nt);
gui_data.T = zeros(gui_data.Nt,8); % Timing vector: 1)realignment, 2)FD, 3)DVARS, 4)smoothing, 5)detrending, 6)PSC, 7)draw stuff, 8)total
% Create binary GM, WM and CSF masks
[gui_data.GM_img_bin, gui_data.WM_img_bin, gui_data.CSF_img_bin] = createBinarySegments(gui_data.rgm_fn, gui_data.rwm_fn, gui_data.rcsf_fn, 0.1);
% Initialize variables for real-time processing
gui_data.I_GM = find(gui_data.GM_img_bin);
gui_data.I_WM = find(gui_data.WM_img_bin);
gui_data.I_CSF = find(gui_data.CSF_img_bin);
gui_data.mask_reshaped = gui_data.GM_img_bin | gui_data.WM_img_bin | gui_data.CSF_img_bin;
gui_data.I_mask = find(gui_data.mask_reshaped);
gui_data.N_maskvox = numel(gui_data.I_mask);
gui_data.N_vox = gui_data.Ni*gui_data.Nj*gui_data.Nk;
gui_data.line1_pos = numel(gui_data.I_GM);
gui_data.line2_pos = numel(gui_data.I_GM) + numel(gui_data.I_WM);
% Initialize variables to be updated during each real-time iteration
gui_data.F_realigned = zeros(gui_data.N_vox, gui_data.Nt);
gui_data.F_smoothed = zeros(gui_data.N_vox, gui_data.Nt);
gui_data.F_dyn = zeros(gui_data.N_vox, gui_data.Nt);
gui_data.F_dyn_img = zeros(gui_data.Ni, gui_data.Nj, gui_data.Nk);
gui_data.F_dyn_detrended = zeros(gui_data.N_vox, gui_data.Nt);
gui_data.F_perc_signal_change = zeros(gui_data.N_vox, gui_data.Nt);
gui_data.F_theplot = zeros(gui_data.N_vox, gui_data.Nt+1);
gui_data.F_cumulative_mean = zeros(gui_data.N_vox, gui_data.Nt);
gui_data.F_cumulative_sum = zeros(gui_data.N_vox, gui_data.Nt);
gui_data.F_stdev = zeros(gui_data.N_vox, gui_data.Nt);
gui_data.F_tSNR = zeros(gui_data.N_vox, gui_data.Nt);
gui_data.tSNR_dyn_img = zeros(gui_data.Ni, gui_data.Nj, gui_data.Nk);
gui_data.tSNR = nan(1, gui_data.Nt);
gui_data.tSNR_gm = nan(1, gui_data.Nt);
gui_data.tSNR_wm = nan(1, gui_data.Nt);
gui_data.tSNR_csf = nan(1, gui_data.Nt);
gui_data.X_MP_detrending = (1:gui_data.Nt)';
gui_data.X_MP_detrending = gui_data.X_MP_detrending - mean(gui_data.X_MP_detrending); % demean non-constant regressors
gui_data.X_MP_detrending = [gui_data.X_MP_detrending ones(gui_data.Nt,1)]; % add constant regressor
gui_data.X_Func_detrending = gui_data.X_MP_detrending;
gui_data.MP = zeros(gui_data.Nt,6);
gui_data.MP_detrended = zeros(gui_data.Nt,6);
gui_data.MP_mm = zeros(gui_data.Nt,6);
% gui_data.outlier_reg = zeros(1, gui_data.Nt);
% gui_data.outlier_reg_Ydata = zeros(2, gui_data.Nt);
% Initialize axes
gui_data.plot_FD = plot(gui_data.ax_FD, gui_data.t, gui_data.FD, 'c', 'LineWidth', 2);
gui_data.fd_line1 = line(gui_data.ax_FD, [1 gui_data.Nt],[gui_data.FD_threshold gui_data.FD_threshold],  'Color', 'r', 'LineWidth', 1.5 );
gui_data.ax_FD.XLim = [0 (gui_data.Nt+1)]; gui_data.ax_FD.YLim = [0 2];
gui_data.ax_FD.XGrid = 'on'; gui_data.ax_FD.YGrid = 'on';
gui_data.ax_FD.Color = 'k';
gui_data.ax_FD.Title.String = gui_data.ax_FD_title;
gui_data.ax_FD.YLabel.String = 'mm';
removeAxesXTickLabels(gui_data.ax_FD)
gui_data.plot_tSNR = plot(gui_data.ax_tSNR, gui_data.t, gui_data.tSNR, 'c', 'LineWidth', 2);
gui_data.ax_tSNR.XLim = [0 (gui_data.Nt+1)]; gui_data.ax_tSNR.YLim = [0 100];
gui_data.ax_tSNR.XGrid = 'on'; gui_data.ax_tSNR.YGrid = 'on';
gui_data.ax_tSNR.Color = 'k';
gui_data.ax_tSNR.Title.String = gui_data.ax_tSNR_title;
gui_data.ax_tSNR.YLabel.String = 'a.u.';
removeAxesXTickLabels(gui_data.ax_tSNR)
GM_img = gui_data.F_theplot(gui_data.I_GM, :);
WM_img = gui_data.F_theplot(gui_data.I_WM, :);
CSF_img = gui_data.F_theplot(gui_data.I_CSF, :);
all_img = [GM_img; WM_img; CSF_img];
gui_data.img_thePlot = imagesc(gui_data.ax_thePlot, all_img); colormap(gray); caxis([-5 5]);
hold on;
gui_data.plot_line1 = line([1 gui_data.Nt],[gui_data.line1_pos gui_data.line1_pos],  'Color', 'b', 'LineWidth', 2 );
gui_data.plot_line2 = line([1 gui_data.Nt],[gui_data.line2_pos gui_data.line2_pos],  'Color', 'g', 'LineWidth', 2 );
hold off;
removeAxesTicks(gui_data.ax_volumes);
gui_data.RT_status = 'initialized';
[gui_data.pb_initialize.Enable, gui_data.pb_startRT.Enable, gui_data.pb_stopRT.Enable] = rtControlsDisplay(gui_data.RT_status);
assignin('base', 'gui_data', gui_data)
guidata(fig,gui_data);
msgbox('Initialized for real-time operation');
end





function startRT(hObject,eventdata)

fig = ancestor(hObject,'figure');
gui_data = guidata(fig);

if ~strcmp(gui_data.RT_status, 'stopped')
    gui_data.i = 1;
end
gui_data.RT_status = 'running';
[gui_data.pb_initialize.Enable, gui_data.pb_startRT.Enable, gui_data.pb_stopRT.Enable] = rtControlsDisplay(gui_data.RT_status);

guidata(fig,gui_data);
assignin('base', 'gui_data', gui_data)
[d, f, e] = fileparts(gui_data.functional4D_fn);


% Start/continue real-time simulation run
while gui_data.i < (gui_data.Nt+1)
    
    gui_data = guidata(fig);
    t0_start = clock;
    txt_dyn.String = ['#' num2str(gui_data.i)];
    
    % 0: Load dynamic functional image
    fdyn_fn = [d filesep f '_' sprintf('%05d',gui_data.i) e]; % filename of dynamic functional image
    currentVol = spm_vol(fdyn_fn);
    gui_data.F_dyn_img = spm_read_vols(currentVol); % this is the unprocessed image to be used for DVARS and THEPLOT
    gui_data.F_dyn(:,gui_data.i) = gui_data.F_dyn_img(:);
    
    
    % 1:    rtFD - REAL-TIME FRAMEWISE DISPLACEMENT
    % Real-time calculation of estimated absolute displacement of
    % brain, per dynamic. This can help to identify outliers.
    % a) First realign each dynamic image data to functional0 to
    % get Head Movement/Motion Parameters (HMPs / MPs)
    t1_start = clock;
    if gui_data.use_rt == 1
        % Access current 'real-time' volume and assign to second index of R
        gui_data.R(2,1).mat = currentVol.mat;
        gui_data.R(2,1).dim = currentVol.dim;
        gui_data.R(2,1).Vol = gui_data.F_dyn_img;
        
        % realign (FROM OPENNFT: preprVol.m)
        [gui_data.R, gui_data.A0, gui_data.x1, gui_data.x2, gui_data.x3, gui_data.wt, gui_data.deg, gui_data.b, gui_data.nrIter] = spm_realign_rt(gui_data.R, gui_data.flagsSpmRealign, gui_data.i, gui_data.nrSkipVol + 1, gui_data.A0, gui_data.x1, gui_data.x2, gui_data.x3, gui_data.wt, gui_data.deg, gui_data.b);
        
        % MC params (FROM OPENNFT: preprVol.m). STEPHAN NOTE: I don't understand this part, but it runs fine
        tmpMCParam = spm_imatrix(gui_data.R(2,1).mat / gui_data.R(1,1).mat);
        if (gui_data.i == gui_data.nrSkipVol + 1)
            gui_data.P.offsetMCParam = tmpMCParam(1:6);
        end
        gui_data.P.motCorrParam(gui_data.i,:) = tmpMCParam(1:6)-gui_data.P.offsetMCParam; % STEPHAN NOTE: I changed indVolNorm to indVol due to error, not sure if this okay or wrong?
        gui_data.MP(gui_data.i,:) = gui_data.P.motCorrParam(gui_data.i,:);
        % Reslice (FROM OPENNFT: preprVol.m)
        gui_data.reslVol = spm_reslice_rt(gui_data.R, gui_data.flagsSpmReslice);
    else
        r_fdyn_fn = rtRealignReslice(gui_data.functional0_fn, fdyn_fn);
        mp = load([d filesep 'rp_' f '.txt']); % stuff todo
        gui_data.MP(gui_data.i,:) = mp(end,:);
    end
    gui_data.T(gui_data.i,1) = etime(clock,t1_start);
    
    % b) Then load MPs, calculate FD, and load figure data
    t2_start = clock;
    gui_data.MP_mm(gui_data.i,:) = gui_data.MP(gui_data.i,:);
    gui_data.MP_mm(gui_data.i,4:6) = gui_data.MP(gui_data.i,4:6)*50; % 50mm = assumed radius of subject head; from Power et al paper (2014) [1].
    
    if gui_data.i == 1
        mp_diff = zeros(1, 6); % if first dynamic is realigned to functional0, this is technically not correct. TODO
    else
        mp_diff = diff(gui_data.MP_mm(gui_data.i-1:gui_data.i, :));
    end
    fd = sum(abs(mp_diff),2);
    gui_data.FD(gui_data.i) = fd;
    for k = 1:6
        gui_data.MPall{k}(gui_data.i) =  gui_data.MP(gui_data.i,k);
    end
    gui_data.T(gui_data.i,2) = etime(clock,t2_start);
    
    
    % 2:    rtDVARS - REAL-TIME ROOT MEAN VARIANCE OF IMAGE INTENSITY DIFFERENCE
    % Real-time calculation of the variance of difference images,
    % which is an indication of how much the image intensity
    % changes between frames and can help to identify outliers.
    % Description from Power et al paper (2014) [1].
    % Method from Chris Rorden's scripts [2].
    t3_start = clock;
    if gui_data.i == 1
        f_diff = (zeros(1, gui_data.N_vox))';
    else
        f_diff = diff((gui_data.F_dyn(:, gui_data.i-1:gui_data.i))');
        f_diff = f_diff';
    end
    dvars = var(f_diff); % Root Mean Variance across voxels
    gui_data.DVARS(:, gui_data.i) = dvars;
    gui_data.T(gui_data.i,3) = etime(clock,t3_start);
    
    
    % 3:    rtTHEPLOT
    % Real-time calculation of datapoints for customized Matlab version of THEPLOT (from Power, 2017 [3]).
    % This heatmap shows percentage signal change of unprocessed
    % BOLD signal alongside quality traces like FD, DVARS and
    % physiological data, and allows visual inspection of data
    % quality issues.
    % a) First smooth dynamic functional data (see paper) using
    % specified Gaussian kernel fwhm.
    t4_start = clock;
    if gui_data.use_rt == 1
        s_fdyn_img = zeros(gui_data.Ni, gui_data.Nj, gui_data.Nk);
        gKernel = [6 6 6] ./ gui_data.dicomInfoVox;
        spm_smooth(gui_data.reslVol, s_fdyn_img, gKernel);
    else
        s_fdyn_fn = rtSmooth(fdyn_fn, [6 6 6]);
        s_fdyn_img = spm_read_vols(spm_vol(s_fdyn_fn));
    end
    gui_data.F_smoothed(:,gui_data.i) = s_fdyn_img(:);
    gui_data.T(gui_data.i,4) = etime(clock,t4_start);
    % b) Then detrend masked data using cumulative GLM. Mask uses
    % combination of GM, WM and CSF masks as derived in
    % preRtPreProc step. Write last iteration's functional data to
    % static value matrix (but growing in size on each iteration).
    % Data detrending is necessary for THEPLOT because (reference)
    t5_start = clock;
    x_func_detrending = gui_data.X_Func_detrending(1:gui_data.i, :);
    beta_func = x_func_detrending\gui_data.F_smoothed(gui_data.I_mask,1:gui_data.i)'; % func = X*beta + e ==> beta = X\func ==> func_detrended = mp - X(i)*beta(i)
    F_detrended = gui_data.F_smoothed(gui_data.I_mask,1:gui_data.i)' - x_func_detrending(:, 1)*beta_func(1, :); % remove effects of all regressors except constant
    F_detrended = F_detrended';
    gui_data.F_dyn_detrended(gui_data.I_mask,gui_data.i) = F_detrended(:,gui_data.i);
    gui_data.T(gui_data.i,5) = etime(clock,t5_start);
    % c) Then calculate percentage signal change for THEPLOT display
    % purposes, using cumulative mean.
    t6_start = clock;
    if gui_data.i == 1
        gui_data.F_cumulative_mean(gui_data.I_mask,gui_data.i) = gui_data.F_dyn_detrended(gui_data.I_mask,gui_data.i);
    else
        gui_data.F_cumulative_mean(gui_data.I_mask,gui_data.i) = ((gui_data.i-1)*gui_data.F_cumulative_mean(gui_data.I_mask,gui_data.i-1) + gui_data.F_dyn_detrended(gui_data.I_mask,gui_data.i))/gui_data.i;
    end
    
    f_perc_signal_change = 100*(gui_data.F_dyn_detrended(gui_data.I_mask,gui_data.i)./gui_data.F_cumulative_mean(gui_data.I_mask,gui_data.i)) - 100;
    f_perc_signal_change(isnan(f_perc_signal_change))=0;
    gui_data.F_perc_signal_change(gui_data.I_mask, gui_data.i) = f_perc_signal_change;
    gui_data.F_theplot(gui_data.I_mask, gui_data.i) = gui_data.F_perc_signal_change(gui_data.I_mask, gui_data.i);
    gui_data.T(gui_data.i,6) = etime(clock,t6_start);
    
    
    % 4:    STATISTICS AND COUNTERS
    gui_data.F_stdev(gui_data.I_mask, gui_data.i) = std(gui_data.F_dyn(gui_data.I_mask, 1:gui_data.i), 0, 2);
    gui_data.F_tSNR(gui_data.I_mask, gui_data.i) = gui_data.F_cumulative_mean(gui_data.I_mask,gui_data.i)./gui_data.F_stdev(gui_data.I_mask, gui_data.i);
    gui_data.tSNR_dyn_img = reshape(gui_data.F_tSNR(:, gui_data.i), gui_data.Ni, gui_data.Nj, gui_data.Nk);
    
    gui_data.tSNR(gui_data.i) = mean(gui_data.F_tSNR(gui_data.I_mask, gui_data.i));
    gui_data.tSNR_gm(gui_data.i) = mean(gui_data.F_tSNR(gui_data.I_GM, gui_data.i));
    gui_data.tSNR_wm(gui_data.i) = mean(gui_data.F_tSNR(gui_data.I_WM, gui_data.i));
    gui_data.tSNR_csf(gui_data.i) = mean(gui_data.F_tSNR(gui_data.I_CSF, gui_data.i));
    
    if fd >= gui_data.FD_threshold
        gui_data.outlier_counter = gui_data.outlier_counter + 1;
        gui_data.FD_outliers = [gui_data.FD_outliers gui_data.i];
        %         gui_data.outlier_reg(gui_data.i) = 1;
        %         gui_data.outlier_reg_Ydata(1, gui_data.i) = gui_data.ax_FD.YLim(2);
    end
    gui_data.FD_sum = gui_data.FD_sum + fd;
    gui_data.FD_dynamic_average = gui_data.FD_sum/gui_data.i;
    
    
    gui_data.txt_Nvolume.String = ['Acquired volumes:  ' num2str(gui_data.i) '/' num2str(gui_data.Nt)];
    gui_data.Nvolume_valid = gui_data.i - gui_data.outlier_counter;
    valid_percentage = round(gui_data.Nvolume_valid/gui_data.i*100, 1);
    gui_data.txt_Nvolume_valid.String = ['Valid volumes:  ' num2str(gui_data.Nvolume_valid) '/' num2str(gui_data.i) ' (' num2str(valid_percentage) '%)'];
    gui_data.txt_fdsum.String = ['Total FD:  ' num2str(gui_data.FD_sum)];
    gui_data.txt_fdave.String = ['Mean FD:  ' num2str(gui_data.FD_dynamic_average)];
    gui_data.txt_tsnr.String = ['tSNR (brain):  ' num2str(gui_data.tSNR(gui_data.i))];
    gui_data.txt_tsnr_gm.String = ['tSNR (GM):  ' num2str(gui_data.tSNR_gm(gui_data.i))];
    gui_data.txt_tsnr_wm.String = ['tSNR (WM):  ' num2str(gui_data.tSNR_wm(gui_data.i))];
    gui_data.txt_tsnr_csf.String = ['tSNR (CSF):  ' num2str(gui_data.tSNR_csf(gui_data.i))];
    
    t7_start = clock;
    
    drawFD(fig);
    drawtSNR(fig);
    drawTHEPLOT(fig);
    checkVolumeSettings(fig);
    drawBrains(fig);
    
    gui_data.T(gui_data.i,7) = etime(clock,t7_start);
    gui_data.T(gui_data.i,8) = etime(clock,t0_start);
    
    pause(0.001);
    
    gui_data.i = gui_data.i+1;
    gui_data_tmp = guidata(fig);
    drawnow; % one way operation to allow gui itself to update (not to allow other parallel operations to finish processing)
    
    % update guidata - TODO
    if strcmp(gui_data_tmp.RT_status, 'stopped')
        gui_data.RT_status = gui_data_tmp.RT_status;
        assignin('base', 'gui_data', gui_data)
        guidata(fig,gui_data);
        break;
    end
    assignin('base', 'gui_data', gui_data)
    guidata(fig,gui_data);
end

gui_data.RT_status = 'completed';
[gui_data.pb_initialize.Enable, gui_data.pb_startRT.Enable, gui_data.pb_stopRT.Enable] = rtControlsDisplay(gui_data.RT_status);
% guidata(fig,gui_data);

end


function stopRT(hObject,eventdata)
fig = ancestor(hObject,'figure');
gui_data = guidata(fig);

gui_data.RT_status = 'stopped';
[gui_data.pb_initialize.Enable, gui_data.pb_startRT.Enable, gui_data.pb_stopRT.Enable] = rtControlsDisplay(gui_data.RT_status);

assignin('base', 'gui_data', gui_data)
guidata(fig,gui_data);
end


function drawFD(fig)
gui_data = guidata(fig);
set(gui_data.plot_FD, 'YData', gui_data.FD);
drawnow;
hold(gui_data.ax_FD,'on');
clear gui_data.line_outliers;
gui_data.line_outliers = line(gui_data.ax_FD, [gui_data.FD_outliers; gui_data.FD_outliers], [gui_data.ax_FD.YLim(2)*ones(1, numel(gui_data.FD_outliers)); zeros(1, numel(gui_data.FD_outliers))],  'Color', 'y', 'LineWidth', 1.5 );
hold(gui_data.ax_FD,'off');
% assignin('base', 'gui_data', gui_data)
% guidata(fig, gui_data);
end

function drawtSNR(fig)
gui_data = guidata(fig);
set(gui_data.plot_tSNR, 'YData', gui_data.tSNR);
drawnow;
% assignin('base', 'gui_data', gui_data)
% guidata(fig, gui_data);
end

function drawTHEPLOT(fig)
gui_data = guidata(fig);
GM_img = gui_data.F_theplot(gui_data.I_GM, :);
WM_img = gui_data.F_theplot(gui_data.I_WM, :);
CSF_img = gui_data.F_theplot(gui_data.I_CSF, :);
all_img = [GM_img; WM_img; CSF_img];
set(gui_data.img_thePlot, 'CData', all_img);
gui_data.ax_thePlot.Title.String = gui_data.ax_thePlot_title;
gui_data.ax_thePlot.YLabel.String = 'voxels';
gui_data.ax_thePlot.XLabel.String = 'Volume #';
drawnow;
% assignin('base', 'gui_data', gui_data)
% guidata(fig, gui_data);
end


function setDim(hObject,eventdata)
% fig = ancestor(hObject,'figure');
% gui_data = guidata(fig);
% gui_data.sld_slice.Max = gui_data.Ndims(gui_data.popup_setDim.Value);
% gui_data.slice_number = floor(gui_data.Ndims(gui_data.popup_setDim.Value)/2);
% gui_data.sld_slice.Value = gui_data.slice_number;
% gui_data.sld_slice.Max = Ndims(gui_data.popup_setDim.Value);
% gui_data.sld_slice.SliderStep = [1/gui_data.Ndims(gui_data.popup_setDim.Value) 1/gui_data.Ndims(gui_data.popup_setDim.Value)];
% gui_data.txt_slice.String = ['Change slice: #' num2str(gui_data.slice_number)];
% guidata(fig, gui_data);
end


function setImg(hObject,eventdata)
% fig = ancestor(hObject,'figure');
% gui_data = guidata(fig);
% gui_data.sld_slice.Max = gui_data.Ndims(gui_data.popup_setDim.Value);
% gui_data.slice_number = floor(gui_data.Ndims(gui_data.popup_setDim.Value)/2);
% gui_data.sld_slice.Value = gui_data.slice_number;
% gui_data.sld_slice.Max = gui_data.Ndims(gui_data.popup_setDim.Value);
% gui_data.sld_slice.SliderStep = [1/gui_data.Ndims(gui_data.popup_setDim.Value) 1/gui_data.Ndims(gui_data.popup_setDim.Value)];
% gui_data.txt_slice.String = ['Change slice: #' num2str(gui_data.slice_number)];
% guidata(fig, gui_data);
end

function changeSlice(hObject,eventdata)
fig = ancestor(hObject,'figure');
gui_data = guidata(fig);
gui_data.slice_number = round(hObject.Value);
gui_data.slice_number = min(gui_data.slice_number, gui_data.Ndims(gui_data.popup_setDim.Value));
gui_data.txt_slice.String = ['Change slice: #' num2str(gui_data.slice_number)];
% assignin('base', 'gui_data', gui_data)
guidata(fig, gui_data);

end


function checkVolumeSettings(fig)
gui_data = guidata(fig);


dimension = gui_data.popup_setDim.Value;

gui_data.sld_slice.Max = gui_data.Ndims(dimension);
gui_data.slice_number = floor(gui_data.Ndims(gui_data.popup_setDim.Value)/2);
gui_data.sld_slice.Value = gui_data.slice_number;
gui_data.sld_slice.Max = gui_data.Ndims(gui_data.popup_setDim.Value);

end

function drawBrains(fig)
gui_data = guidata(fig);

if gui_data.popup_setImg.Value == 1
    if gui_data.popup_setDim.Value == 1
        imagesc(gui_data.ax_volumes, squeeze(gui_data.F_dyn_img(gui_data.slice_number,:,:))); colormap(gui_data.ax_volumes, 'bone'); colorbar(gui_data.ax_volumes);
    elseif gui_data.popup_setDim.Value == 2
        imagesc(gui_data.ax_volumes, squeeze(gui_data.F_dyn_img(:,gui_data.slice_number,:))); colormap(gui_data.ax_volumes, 'bone'); colorbar(gui_data.ax_volumes);
    else
        imagesc(gui_data.ax_volumes, squeeze(gui_data.F_dyn_img(:,:,gui_data.slice_number)));  colormap(gui_data.ax_volumes, 'bone'); colorbar(gui_data.ax_volumes);
    end
else
    if gui_data.popup_setDim.Value == 1
        imagesc(gui_data.ax_volumes, squeeze(gui_data.tSNR_dyn_img(gui_data.slice_number,:,:))); colormap(gui_data.ax_volumes, 'bone'); colorbar(gui_data.ax_volumes);
    elseif gui_data.popup_setDim.Value == 2
        imagesc(gui_data.ax_volumes, squeeze(gui_data.tSNR_dyn_img(:,gui_data.slice_number,:))); colormap(gui_data.ax_volumes, 'bone'); colorbar(gui_data.ax_volumes);
    else
        imagesc(gui_data.ax_volumes, squeeze(gui_data.tSNR_dyn_img(:,:,gui_data.slice_number)));  colormap(gui_data.ax_volumes, 'bone'); colorbar(gui_data.ax_volumes);
    end
end
gui_data.ax_volumes.Title.String = '';
% assignin('base', 'gui_data', gui_data)
% guidata(fig, gui_data);

end




function [pb_initialize, pb_startRT, pb_stopRT] = rtControlsDisplay(RT_status)

% RT_status = initialized, running, stopped, completed.
% [gui_data.pb_initialize.Enable, gui_data.pb_startRT.Enable, gui_data.pb_stopRT.Enable] = rtControlsDisplay(gui_data.RT_status);
% if strcmp(RT_status, 'running')
%     pb_stopRT = 'on';
%     pb_startRT = 'off';
%     pb_initialize = 'off';
% end

switch RT_status
    case 'initialized'
        pb_initialize = 'on';
        pb_startRT = 'on';
        pb_stopRT = 'off';
    case 'running'
        pb_initialize = 'off';
        pb_startRT = 'off';
        pb_stopRT = 'on';
    case 'stopped'
        pb_initialize = 'on';
        pb_startRT = 'on';
        pb_stopRT = 'off';
    case 'completed'
        pb_initialize = 'on';
        pb_startRT = 'on';
        pb_stopRT = 'off';
    otherwise
        
end

end



% Axes







%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% assignin('base', 'src',src)
% assignin('base', 'eventdata',eventdata)

% % Create figure
% figure_handle = figure('Toolbar','none');
% % create structure of handles
% myhandles = guihandles(figure_handle);
% % Add some additional data as a new field called numberOfErrors
% myhandles.numberOfErrors = 0;
% % Save the structure
% guidata(figure_handle,myhandles)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function removeAxesTicks(ax)
set(ax,'xtick',[])
set(ax,'xticklabel',[])
set(ax,'ytick',[])
set(ax,'yticklabel',[])
set(ax,'ztick',[])
set(ax,'zticklabel',[])
end

function removeAxesXTickLabels(ax)
set(ax,'xticklabel',[])
end






