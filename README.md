# FFmpeg-Android
Herein lies a script and instructions for compiling FFmpeg for Android. We owe it all to [Liu Feipeng](http://www.roman10.net/how-to-build-ffmpeg-with-ndk-r9/).

## Instructions

1. Download the [FFmpeg source](http://www.ffmpeg.org/download.html) you desire (This process is tested with 2.0.2)
2. Modify `configure` ever so slightly to conform to the Android NDK build system:
      
        # ffmpegX.X.X/configure
        ...
   		# Replace the following lines:
   		
		#SLIBNAME_WITH_MAJOR='$(SLIBNAME).$(LIBMAJOR)'
		#LIB_INSTALL_EXTRA_CMD='$$(RANLIB) "$(LIBDIR)/$(LIBNAME)"'
		#SLIB_INSTALL_NAME='$(SLIBNAME_WITH_VERSION)'
		#SLIB_INSTALL_LINKS='$(SLIBNAME_WITH_MAJOR) $(SLIBNAME)'
		
		# With: 
		
		SLIBNAME_WITH_MAJOR='$(SLIBPREF)$(FULLNAME)-$(LIBMAJOR)$(SLIBSUF)'
		LIB_INSTALL_EXTRA_CMD='$$(RANLIB) "$(LIBDIR)/$(LIBNAME)"'
		SLIB_INSTALL_NAME='$(SLIBNAME_WITH_MAJOR)'
		SLIB_INSTALL_LINKS='$(SLIBNAME)'
		
 3. Copy `build4android.sh` to `ffmpegX.X.X/` and run!
    a. Make sure the script is executable:
    
    		$ sudo chmod +x build4android.sh    
    		
    b. Make any desired changes to `build4android.sh` per your build target.	
    c. Run!
    
    		$ ./build4android.sh	
    		
    		
The result will be a collection of static libraries and headers at `ffmpegX.X.X/android/`