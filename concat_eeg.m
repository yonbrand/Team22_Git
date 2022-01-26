% recordingFolder_1 = 'C:\Users\Niv\Desktop\bci-4-als\Recordings\Yonatan2'
% recordingFolder_2 = 'C:\Users\Niv\Desktop\bci-4-als\Recordings\Yonatan3'
%  recordingFolder = ' C:\BCI4ALS\Team22\Good recordings\Yonatan';
%  suffix = {'2', '3'};
%  v = concat_xdf(recordingFolder, suffix);

function con_eeg = concat_eeg(recordingFolder, suffixs)
    
    for suf=1:size(suffixs, 2)
        folders{suf} = [recordingFolder, num2str(suffixs{suf})];
    end

    folders{1}

    for fold=1:size(folders, 2)
        recordingFiles{fold} = strcat(folders{fold},'\\EEG.XDF');
    end
   
    for file=1:size(recordingFiles, 2)
        files{file} = pop_loadxdf(recordingFiles{file}, 'streamtype', 'EEG', 'exclude_markerstreams', {});
    end

    
    con_eeg = files{1};
    for eeg=2:size(files, 2)
        events=struct2cell(con_eeg.event);
        latency = events{2, :, end};
%update latency
        
        new_event = struct2cell(files{eeg}.event);
        cell_latency = {new_event{2, :, :}};
        mat_latency = cell2mat(cell_latency);
        cell_latency = num2cell(mat_latency+latency);
        [files{eeg}.event.latency] = cell_latency{:};
        %%
        con_eeg.data = [con_eeg.data, files{eeg}.data];
        con_eeg.xmax = max(con_eeg.xmax, files{eeg}.xmax);
        con_eeg.pnts = con_eeg.pnts+files{eeg}.pnts;
        con_eeg.times = [con_eeg.times, files{eeg}.times+length(con_eeg.times)];
        con_eeg.event = [con_eeg.event, files{eeg}.event];
    end
  
end