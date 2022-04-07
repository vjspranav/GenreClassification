folders = ["pop" "jazz" "country" "rock" "blues"];
frames = [0.5, 1, 3];
for j=1:length(folders)
    cd(folders(j))
    fol = dir("*au");
    for fr_index=1:length(frames)
        frame_length=frames(fr_index);
        genre_spectralcentroid_means=zeros(1,length(fol));
        genre_rolloff_means=zeros(1,length(fol));
        genre_flux_means=zeros(1,length(fol));
        genre_zecr_means=zeros(1,length(fol));

        genre_spectralcentroid_sds=zeros(1,length(fol));
        genre_rolloff_sds=zeros(1,length(fol));
        genre_flux_sds=zeros(1,length(fol));
        genre_zecr_sds=zeros(1,length(fol));

        for n=1:length(fol)
            % Feature arrays
            % cent=zeros(1,27);
            % croll=zeros(1,27);
            % flux=zeros(1,27);
            % zecr=zeros(1,27);
            ind=1;
            f = fol(n).name;
            disp(strcat(folders(j), f," issue\n"));
            for i=0:0.5:(30-frame_length)
                a=miraudio(f, 'Extract', i, i+3);
                cent(ind)=mirstat(mirgetdata(mircentroid(a, 'Frame', 0.025)));
                roll(ind)=mirstat(mirgetdata(mirrolloff(a, 'Frame', 0.025)));
                flux(ind)=mirstat(mirgetdata(mirflux(a, 'Frame', 0.025)));
                zecr(ind)=mirstat(mirgetdata(mirzerocross(a, 'Frame', 0.025)));
                ind=ind+1;

            end
            genre_spectralcentroid_means(n) = mean(cent);
            genre_rolloff_means(n) = mean(roll);
            genre_flux_means(n) = mean(flux);
            genre_zecr_means(n) = mean(zecr);

            genre_spectralcentroid_sds(n) = std(cent,"omitnan");
            genre_rolloff_sds(n) = std(roll,"omitnan");
            genre_flux_sds(n) = std(flux,"omitnan");
            genre_zecr_sds(n) = std(zecr,"omitnan");
        end
        % filenames
        centroid_file=strcat("../genres_output/", folders(j), "_spectral_centroid_mean_frame_", int2str(frame_length * 1000));
        rolloff_file=strcat("../genres_output/", folders(j), "_rolloff_mean_frame_", int2str(frame_length*1000));
        flux_file=strcat("../genres_output/", folders(j), "_flux_mean_frame_", int2str(frame_length*1000));
        zecr_file=strcat("../genres_output/", folders(j), "_zecr_mean_frame_", int2str(frame_length*1000));

        centroid_file_sd=strcat("../genres_output/", folders(j), "_spectral_centroid_sd_frame_", int2str(frame_length*1000));
        rolloff_file_sd=strcat("../genres_output/", folders(j), "_rolloff_sd_frame_", int2str(frame_length*1000));
        flux_file_sd=strcat("../genres_output/", folders(j), "_flux_sd_frame_", int2str(frame_length*1000));
        zecr_file_sd=strcat("../genres_output/", folders(j), "_zecr_sd_frame_", int2str(frame_length*1000));

        % Write to files
        csvwrite(centroid_file,genre_spectralcentroid_means);
        csvwrite(rolloff_file,genre_rolloff_means);
        csvwrite(flux_file,genre_flux_means);
        csvwrite(zecr_file,genre_zecr_means);

        csvwrite(centroid_file_sd,genre_spectralcentroid_sds);
        csvwrite(rolloff_file_sd,genre_rolloff_sds);
        csvwrite(flux_file_sd,genre_flux_sds);
        csvwrite(zecr_file_sd,genre_zecr_sds);
   
    end
    cd ..
end