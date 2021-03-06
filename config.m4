##*****************************************************************************
## $Id: config.m4 8863 2006-08-10 18:47:55Z da $
##*****************************************************************************
#  AUTHOR:
#    Danny Auble <da@llnl.gov>
#
#  DESCRIPTION:
#    Use to make the php slurm extension
##*****************************************************************************
PHP_ARG_WITH(slurm, whether to use slurm,
[  --with-slurm=SLURM_INSTALL_PATH])
	
if test "$PHP_SLURM" != "no"; then
	SLURMLIB_PATH="/usr/lib64 /usr/lib"
	SLURMINCLUDE_PATH="/usr/include"
	SEARCH_FOR="libslurm.so"
    	
        # --with-libslurm -> check with-path
	
	if test -r $PHP_SLURM/; then # path given as parameter
		SLURM_DIR=$PHP_SLURM
		SLURMLIB_PATH="$SLURM_DIR/lib"
	else # search default path list
		AC_MSG_CHECKING([for libslurm.so in default paths])
		for i in $SLURMLIB_PATH ; do
			if test -r $i/$SEARCH_FOR; then
				SLURM_DIR=$i
				PHP_ADD_LIBPATH($i, SLURM_PHP_SHARED_LIBADD)
    
				AC_MSG_RESULT([found in $i])
				
			fi
		done
	fi
	
	if test -z "$SLURM_DIR"; then
		AC_MSG_RESULT([not found])
		AC_MSG_ERROR([Please reinstall the slurm distribution])
	fi
	
	PHP_ADD_INCLUDE($SLURMINCLUDE_PATH)
	
	LIBNAME=slurm
	LIBSYMBOL=slurm_acct_storage_init
	
	PHP_CHECK_LIBRARY($LIBNAME, $LIBSYMBOL,
		[PHP_ADD_LIBRARY($LIBNAME, , SLURM_PHP_SHARED_LIBADD)
    			AC_DEFINE(HAVE_SLURMLIB,1,[ ])],
		[AC_MSG_ERROR([wrong libslurm version or lib not found])],
		[-L$SLURM_DIR -lslurm])
	
	
	PHP_SUBST(SLURM_PHP_SHARED_LIBADD)
	
	AC_CHECK_HEADERS(stdbool.h)

	AC_DEFINE(HAVE_SLURM_PHP, 1, [Whether you have SLURM])
	#PHP_EXTENSION(slurm_php, $ext_shared)
	PHP_NEW_EXTENSION(slurm_php, slurm_php.c, $ext_shared)
fi
