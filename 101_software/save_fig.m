function save_fig(F,PATHOUT, NAME,varargin)
% save_fig: Function to save figure with specific parameters
%     This function helps to save a certain figure.
%     
% INPUT: 
%     F: any figure handle e.g.: gcf)
%     PATHOUT: string to where figure should be saved
%     NAME: Name as string under which figure should be saved

% OUTPUT:
%     No output, as figure is saved in specified location
% 
% Figure format is .png as default, can be changed to any type
% 
% 
% Author: (Julius Welzel & Mareike Daeglau, University of Oldenburg, 2018)

% check inputs
if ~ischar(PATHOUT) | ~ischar(PATHOUT)
    error('Specifiy PATHOUT and NAME as string')
end

% check for name value pairs
% Parse inputs: 
p = inputParser;
defaultFontSize = 12; 
defaultFigSize = [0 0 30 20];
defaultFigType = '.png';
addParameter(p,'fontsize',defaultFontSize,@isnumeric);
addParameter(p,'figsize',defaultFigSize);
addParameter(p,'figtype',defaultFigType);

parse(p,varargin{:});
font_s = p.Results.fontsize;
fig_s = p.Results.figsize;
fig_t = p.Results.figtype;



% set figure options
set(findall(0,'type','axes'),'FontSize',font_s) % set font size of axis
set(F, 'Units','centimeters','Position',fig_s); % set figure size in cm
set(F,'color','white'); % set figure background color in rgb mode
saveas(F,[PATHOUT NAME fig_t]); % save figure 
close;


end

