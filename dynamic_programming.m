%% originally 20160728, modified starting 20170225
clear all
close all

%% load player list
[num,txt,raw] = xlsread('dummy_list_old.xlsx');
pls = raw;

%% remove NaNs
pls = pls(~isnan([pls{:,6}]'),:);


%% convert to table format, name variables
pls = cell2table(pls);

pls.Properties.VariableNames={'Name','Team','Position','Cost','Value1','Value2'}; 
pls.Properties.VariableUnits={'','','','Unit1','Unit2','Unit2'}; %replace with actual units
%.Properties.VariableDescriptions is also a thing


%% define vectors
vi = pls.Value2; %value
wi = pls.Cost; %costs
wi = ceil(wi); 

%%

V = [];
keep = [];
for w = 1:100+1 % change
    V(1,w) = 0;
end

for i = 2:length(vi)+1
    ichanged = i-1;
    for w = 1:100+1  % change
        idx = [];
        if (wi(ichanged)<w)&((vi(ichanged)+V(i-1,w-wi(ichanged)))>V(i-1,w)) %if prev player is worth less AND _________
            K = w;
            for it = (i-1):-1:2
                if keep(it,K) == 1
                    K = K-wi(it-1);
                    idx = [idx it-1];
                end
            end
            %% TOR
            if strcmp(pls{ichanged,3},'TOR')
                idcomp = idx(strcmp(pls(idx,3),'TOR'));
                [Y,I] = max([pls{ichanged,6} [pls{idcomp,6}]]);
                if I == 1
                    keep(i,w)=1;
                    if isempty(idcomp)
                        V(i,w)=vi(ichanged)+V(i-1,w-wi(ichanged));
                    else
                        keep(idcomp+1,w)=0;
                        V(i,w)=vi(ichanged)+V(i-1,w-wi(ichanged))-vi(idcomp);
                    end
                end
                
                %% ABW
            elseif strcmp(pls{ichanged,3},'ABW')
                idcomp = idx(strcmp(pls(idx,3),'ABW'));
                [Y,I] = sort([pls{ichanged,6} [pls{idcomp,6}]],'descend');
                if I(1)>4
                    keep(idcomp+1,w)=0;
                    V(i,w)=vi(ichanged)+V(i-1,w-wi(ichanged))-vi(idcomp(1));
                elseif isempty(idcomp)
                    keep(i,w)=1;
                    V(i,w)=vi(ichanged)+V(i-1,w-wi(ichanged));
                    
                else
                    keep(i,w)=1;
                    V(i,w)=vi(ichanged)+V(i-1,w-wi(ichanged))-vi(idcomp);
                end
                %% MIT
            elseif strcmp(pls{ichanged,3},'MIT')
                idcomp = idx(strcmp(pls(idx,3),'MIT'));
                [Y,I] = max([pls{ichanged,6} [pls{idcomp,6}]]);
                if I == 1
                    keep(i,w)=1;
                    if isempty(idcomp)
                        V(i,w)=vi(ichanged)+V(i-1,w-wi(ichanged));
                    else
                        keep(idcomp+1,w)=0;
                        V(i,w)=vi(ichanged)+V(i-1,w-wi(ichanged))-vi(idcomp);
                    end
                end
                %% STU
            elseif strcmp(pls{ichanged,3},'STU')
                idcomp = idx(strcmp(pls(idx,3),'STU'));
                [Y,I] = max([pls{ichanged,6} [pls{idcomp,6}]]);
                if I == 1
                    keep(i,w)=1;
                    if isempty(idcomp)
                        V(i,w)=vi(ichanged)+V(i-1,w-wi(ichanged));
                    else
                        keep(idcomp+1,w)=0;
                        V(i,w)=vi(ichanged)+V(i-1,w-wi(ichanged))-vi(idcomp);
                    end
                end
            end
            
            
            %                     V(i,w)=V(i-1,w);
            %                     keep(i,w)=0;
            %                 end
            %             else
            %                 keep(i,w)=1;
            %                 V(i,w)=vi(ichanged)+V(i-1,w-wi(ichanged));
            %             end
            
        else
            V(i,w)=V(i-1,w);
            keep(i,w)=0;
        end
        V(i,w)
    end
end
K = 100+1; % change
idx = [];
for i = length(vi):-1:2
    ichanged = i-1;
    if keep(i,K) == 1
        K = K-wi(ichanged);
        idx = [idx ichanged];
    end
end

%%

team = pls(idx,:);
sum(round([team{:,4}]))
sum(round([team{:,6}]))
