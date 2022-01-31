recordingFolder = 'C:\Users\Niv\Desktop\bci-4-als\Team22_Git\Good recordings\Yonatan';
suffixs = {'2', '3'};
concat_save_eeg_trainVec(recordingFolder, suffixs);

function [EEG_data, trainingVec] = concat_save_eeg_trainVec(recordingFolder, suffixs)
    %stores all relevant recording folders
    for suf=1:size(suffixs, 2)
        folders{suf} = [recordingFolder, num2str(suffixs{suf})];
    end
    %stores all relevant recording and trainng vectors mats
    for fold=1:size(folders, 2)
        recordingFiles{fold} = strcat(folders{fold},'\\cleaned_sub.mat');
        trainingvecs{fold} = strcat(folders{fold}, '\\trainingVec.mat');
    end
    %loads first recording and training vector
    con_eeg = load(recordingFiles{1});
    mat_eeg = con_eeg.(subsref(fieldnames(con_eeg),substruct('{}',{1})));
    mat_train = load(trainingvecs{1});
    cat_train = mat_train.(subsref(fieldnames(mat_train),substruct('{}',{1})));
    
    %concats the rest recording and training vectors 
    for mat=2:size(recordingFiles, 2)
       con_eeg = load(recordingFiles{mat});
       mat_2 = con_eeg.(subsref(fieldnames(con_eeg),substruct('{}',{1})));
       mat_eeg = cat(2, mat_eeg, mat_2);

       mat_train = load(trainingvecs{mat});
       train_2 = mat_train.(subsref(fieldnames(mat_train),substruct('{}',{1})));
       cat_train = cat(2, cat_train, train_2);
    end

    EEG_data = {mat_eeg};
    save('EEG_data.mat', 'EEG_data');

    trainingVec = {cat_train};
    save('trainingVec.mat', "trainingVec");
end

