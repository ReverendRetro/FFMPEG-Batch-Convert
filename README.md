# FFMPEG-Batch-Convert
music_convert.sh -> Converts the input music folder to the output destination retaining directory and file paths and structure

music_convert_update.sh -> converts files that exist on source but not in the output destination

music_files_cleanup.sh -> Checks the source and backup destination, if files exist in the backup destination that do not exist in source, it removes them from the backup destination

# The goal of these scripts
I can set my music library and backup destination in music_convert.sh. Most of my files are lossless, this will convert them over to very high quality ogg files, so they are smaller than the source, meaning easier to backup offsite or onto local storage. I do keep a 1:1 backup of my music directory on an external local drive, but it is near 1TB worth of music. This shaves off a few hundred GB compressing it down. Meaning a remote backup is more feasible. 

I also have in some cases MP3 files I have bought digitally, and as I do collect physical CDs, I replace the MP3 with a FLAC rip of my CDs. While the music_convert_update.sh has a check to remove the old files, it isn't flawless. That is why music_files_cleanup.sh exists. I remove the folder with the MP3 files on source, and add my new FLAC folder, it is backed up to the external drive in a compressed format via a cron job for the script, then the cleanup runs and removes the then orphaned files from the backup.
