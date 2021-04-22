function fig_out = merge_figures(fig_name, fig_title, figures, varargin)

%% Merge figures function
%
%
% Authors
% - Ariosky Areces Gonzalez
% - Deirel Paz Linares
%
% Inputs
% - fig_name    :Output figure name
% - fig_tile    :Output figure title
% - figures     :Figures list in array or cell format
%   Optional input params
% - width       :Output width figure ('width',value)
% - height      :Output height figure ('height',value)
% - rows        :Rows subplots for the output figure
% - cols        :Columns subplots for the output figure
%
%
%

for i=1:2:length(varargin)
    eval([varargin{i} '=  varargin{(i+1)};'])
end

if(~exist('width','var'))
    width = 875;
end
if(~exist('height','var'))
    height = 400;
end
if(~exist('rows','var'))
    rows = 1;
end
if(~exist('cols','var'))
    cols = length(figures);
end
figures_path = cell(1,length(figures));
tmp_path = fullfile(pwd,'tmp','figures');
if(~isfolder(tmp_path))
   mkdir(tmp_path); 
end
for i=1:length(figures)
    if(iscell(figures))
        fig = figures{i};
    else
        fig = figures(i);
    end
    if(isempty(fig))
        fig_path = [];
    else
        fig_path = fullfile(tmp_path,['fig_',num2str(i),'.fig']);
        savefig(fig,fig_path);
    end
    figures_path{i} = fig_path;
end
fig_out = figure('Name', fig_name, 'NumberTitle', 'off', 'Position', [200,500,width,height]);
axis off;
axis tight;
for i=1:rows
    for j=1:cols
        p = (i-1)*cols+j;
        if(p>length(figures_path))
            break;
        end
        h(p)=subplot(rows,cols,p);
        if(exist('axis_on','var'))
            if(isequal(axis_on{p},'on'));axis on; else;axis off;end
        else
            axis on;
        end
        axis tight;
        if(isempty(figures_path{p}));continue;end
        handle=hgload(figures_path{p});
        title_obj = get(gca,'title');
        clear title;        
        H = findobj(gca, 'Type','Text');
        if(~isempty(H))
            delete(H);
        end        
        title_str = title_obj.String;
        copyobj(allchild(get(handle,'CurrentAxes')),h(p));
        close(handle);
        title(title_str);  
        if(exist('view_orient','var'))
            if(~isempty(view_orient{p}))
                orient = view_orient{p};
                view(orient(1),orient(2));
            end
        end
        
    end
end
if(exist('cmap','var'))
    colormap(cmap);
end
if(isfolder(tmp_path))
   rmdir(tmp_path,'s'); 
end
sgtitle(fig_title);
%% Colspan
% subplot(4,4,[1 6]) % top left
% subplot(4,4,[3 8]) % top right
% subplot(4,4,[9 10]) % bottom left (1)
% subplot(4,4,[13 14]) % bottom left (2)
% subplot(4,4,[11 16]) % bottom right
end

