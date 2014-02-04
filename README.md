# FFmpeg-Android
Herein lies scripts and instructions for compiling FFmpeg for Android with RTMP support. Much thanks to [Chris Ballinger](https://github.com/chrisballinger/) and [Liu Feipeng](http://www.roman10.net/how-to-build-ffmpeg-with-ndk-r9/).

## Instructions

### Optional RTMP support dependencies
If you'd like to build FFmpeg with --enable-librtmp, first download and build OpenSSL and librtmp:

#### OpenSSL
1. The GuardianProject have a [great project](https://github.com/guardianproject/openssl-android) that makes building as simple as invoking `ndk-build`.

#### librtmp
2. Clone [RTMPDump](http://rtmpdump.mplayerhq.hu/), and copy `build_librtmp_for_android.sh` into the `./librtmp` subdirectory.

        $ git clone git://git.ffmpeg.org/rtmpdump
        $ cp /path/to/build_librtmp_for_android.sh ./rtmpdump/librtmp
        $ ./rtmpdump/librtmp/build_librtmp_for_android.sh

3. Modify the header variables in `build_librtmp_for_android.sh` as appropriate:

        #build_librtmp_for_android.sh
        NDK=/path/to/your/android-ndk-r9c
 	    SYSROOT=$NDK/platforms/android-19/arch-arm/
	    TOOLCHAIN=$NDK/toolchains/arm-linux-androideabi-4.8/prebuilt/darwin-x86_64
	    OPENSSL_DIR=/path/to/your/openssl-android/
	    ...


### Building FFmpeg

1. Download the [FFmpeg source](http://www.ffmpeg.org/download.html) you desire (This process is tested with 2.1.3)

      
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
		
**If building with RTMP support:** Also modify the following line of `configure`:

        # Replace this:
        enabled librtmp    && require_pkg_config librtmp librtmp/rtmp.h RTMP_Socket
        # With this:
        enabled librtmp    && require librtmp librtmp/rtmp.h RTMP_Socket -L/path/to/rtmpdump/librtmp/android/arm/lib -lrtmp
		
 3. Copy `build_ffmpeg_for_android.sh` or `build_ffmpeg_with_librtmp_for_android.sh` to `ffmpegX.X.X/` and run!
    a. Make sure the script is executable:
    
    		$ sudo chmod +x build_ffmpeg_for_android.sh    
    		
    b. Make any desired changes to `build_ffmpeg_for_android.sh` per your build target.	
    c. Run!
    
    		$ ./build_ffmpeg_for_android.sh	
    		# or to build with debugging symbols:
    		$ ./build_ffmpeg_debug_for_android.sh
    		
    		
The result will be a collection of static libraries and headers at `ffmpegX.X.X/android/`

### Note on Building with Debugging Symbols

We had to pass the `-gdwarf-2` flag to gcc to properly generate debugging symbols for the ffmpeg libraries. A lot was going on, and perhaps instead something yet unexplained happened at a sub-atomic level.  
